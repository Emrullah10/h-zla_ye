import 'dart:async';
import 'package:dio/dio.dart';

/// Web axios.jsx:31-62 karşılığı: 401'de tek uçuşluk refresh + bekleyen
/// isteklerin kuyruklanması. `/gateway/refresh`, `/auth/login`, `/gateway/me`
/// endpoint'lerinin kendi 401'lerinde retry denenmez (sonsuz döngü önlenir).
class AuthRefreshInterceptor extends Interceptor {
  AuthRefreshInterceptor({
    required this.dio,
    required this.refreshDio,
    required this.onRefreshFailed,
  });

  /// Ana istekleri tekrar denemek için kullanılan Dio (interceptor zincirli).
  final Dio dio;

  /// Sadece /gateway/refresh çağrısı için ayrı, interceptor'suz Dio —
  /// aksi halde bu istek de kendi 401'ini tetikleyip döngüye girebilir.
  final Dio refreshDio;

  /// Refresh başarısız olursa çağrılır (örn. oturumu kapat).
  final void Function() onRefreshFailed;

  bool _isRefreshing = false;
  final List<Completer<void>> _pendingQueue = [];

  static const _noRetryPatterns = [
    '/gateway/refresh',
    '/auth/login',
    '/gateway/me',
  ];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final original = err.requestOptions;

    if (response?.statusCode != 401 || original.extra['_retry'] == true) {
      return handler.next(err);
    }

    if (_noRetryPatterns.any((p) => original.path.contains(p))) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      final completer = Completer<void>();
      _pendingQueue.add(completer);
      try {
        await completer.future;
        original.extra['_retry'] = true;
        final response = await dio.fetch(original);
        return handler.resolve(response);
      } catch (_) {
        return handler.next(err);
      }
    }

    original.extra['_retry'] = true;
    _isRefreshing = true;
    try {
      await refreshDio.post('/gateway/refresh');
      _drainQueue(null);
      final response = await dio.fetch(original);
      handler.resolve(response);
    } catch (refreshError) {
      _drainQueue(refreshError);
      onRefreshFailed();
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  void _drainQueue(Object? error) {
    for (final completer in _pendingQueue) {
      if (error == null) {
        completer.complete();
      } else {
        completer.completeError(error);
      }
    }
    _pendingQueue.clear();
  }
}
