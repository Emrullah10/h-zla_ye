import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hizla_mobile/core/network/xsrf_interceptor.dart';

void main() {
  late CookieJar cookieJar;
  late XsrfInterceptor interceptor;
  const baseUrl = 'http://localhost:4000/api';

  setUp(() {
    cookieJar = CookieJar();
    interceptor = XsrfInterceptor(cookieJar);
  });

  test('GET isteğinde X-XSRF-TOKEN header eklenmez', () async {
    await cookieJar.saveFromResponse(
      Uri.parse(baseUrl),
      [Cookie('XSRF-TOKEN', 'abc123')],
    );

    final options = RequestOptions(path: '/gateway/me', baseUrl: baseUrl, method: 'GET');
    final handler = RequestInterceptorHandler();
    interceptor.onRequest(options, handler);
    await Future<void>.delayed(Duration.zero);

    expect(options.headers.containsKey('X-XSRF-TOKEN'), isFalse);
  });

  test('POST isteğinde XSRF-TOKEN cookie header a taşınır', () async {
    await cookieJar.saveFromResponse(
      Uri.parse(baseUrl),
      [Cookie('XSRF-TOKEN', 'secret-token')],
    );

    final options = RequestOptions(path: '/auth/login', baseUrl: baseUrl, method: 'POST');
    final handler = RequestInterceptorHandler();
    interceptor.onRequest(options, handler);
    await Future<void>.delayed(Duration.zero);

    expect(options.headers['X-XSRF-TOKEN'], 'secret-token');
  });

  test('cookie yoksa header eklenmez', () async {
    final options = RequestOptions(path: '/auth/login', baseUrl: baseUrl, method: 'POST');
    final handler = RequestInterceptorHandler();
    interceptor.onRequest(options, handler);
    await Future<void>.delayed(Duration.zero);

    expect(options.headers.containsKey('X-XSRF-TOKEN'), isFalse);
  });
}
