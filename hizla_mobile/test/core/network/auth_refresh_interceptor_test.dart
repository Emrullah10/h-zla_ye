import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hizla_mobile/core/network/auth_refresh_interceptor.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

/// `ErrorInterceptorHandler.future` `@protected` olduğu için testte handler'ın
/// tamamlanma sonucunu okuyabilmek adına aynı sınıftan türetiyoruz.
class _TestableErrorHandler extends ErrorInterceptorHandler {
  Future<void> get completedSilently => future.then((_) {}).catchError((_) {});
}

void main() {
  late MockDio dio;
  late MockDio refreshDio;
  late bool refreshFailedCalled;
  late AuthRefreshInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/fallback'));
  });

  setUp(() {
    dio = MockDio();
    refreshDio = MockDio();
    refreshFailedCalled = false;
    interceptor = AuthRefreshInterceptor(
      dio: dio,
      refreshDio: refreshDio,
      onRefreshFailed: () => refreshFailedCalled = true,
    );
  });

  DioException build401(String path, {bool retry = false}) {
    final options = RequestOptions(path: path, extra: {'_retry': retry});
    return DioException(
      requestOptions: options,
      response: Response(requestOptions: options, statusCode: 401),
    );
  }

  /// ErrorInterceptorHandler.next(err) çağrıldığında handler'ın kendi
  /// future'ı tamamlanır (Dio'nun normal davranışı — üretimde Dio bunu
  /// bekleyip zinciri sonlandırır). `completedSilently` bu future'ı
  /// tüketerek "unhandled" uyarısını önler.
  Future<void> runOnError(DioException err) async {
    final handler = _TestableErrorHandler();
    // completedSilently zincirini handler.next/resolve çağrılmadan ÖNCE
    // kurmalıyız — yoksa completeError senkron olarak dinleyicisiz kalır.
    final silent = handler.completedSilently;
    await interceptor.onError(err, handler);
    await silent;
  }

  test('/gateway/refresh kendi 401 hatasında retry denemez', () async {
    final err = build401('/gateway/refresh');
    await runOnError(err);
    verifyNever(() => refreshDio.post(any()));
  });

  test('/auth/login 401 hatasında retry denemez', () async {
    final err = build401('/auth/login');
    await runOnError(err);
    verifyNever(() => refreshDio.post(any()));
  });

  test('zaten retry edilmiş istekte tekrar refresh denemez', () async {
    final err = build401('/courier/order/active', retry: true);
    await runOnError(err);
    verifyNever(() => refreshDio.post(any()));
  });

  test('401 alan normal istek başarılı refresh sonrası tekrar denenir', () async {
    final err = build401('/courier/order/active');
    when(() => refreshDio.post('/gateway/refresh')).thenAnswer(
      (_) async => Response(requestOptions: err.requestOptions, statusCode: 200),
    );
    when(() => dio.fetch<dynamic>(any())).thenAnswer(
      (_) async => Response(requestOptions: err.requestOptions, statusCode: 200),
    );

    await runOnError(err);

    verify(() => refreshDio.post('/gateway/refresh')).called(1);
    verify(() => dio.fetch<dynamic>(any())).called(1);
    expect(err.requestOptions.extra['_retry'], isTrue);
  });

  test('refresh başarısız olursa onRefreshFailed çağrılır', () async {
    final err = build401('/courier/order/active');
    when(() => refreshDio.post('/gateway/refresh'))
        .thenThrow(DioException(requestOptions: err.requestOptions));

    await runOnError(err);

    expect(refreshFailedCalled, isTrue);
  });
}
