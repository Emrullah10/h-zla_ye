import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

/// Web axios.jsx:14-21 karşılığı: GET/HEAD/OPTIONS dışındaki isteklerde
/// XSRF-TOKEN cookie'sini X-XSRF-TOKEN header'ına taşır.
class XsrfInterceptor extends Interceptor {
  XsrfInterceptor(this._cookieJar);

  final CookieJar _cookieJar;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final method = options.method.toUpperCase();
    if (method != 'GET' && method != 'HEAD' && method != 'OPTIONS') {
      final cookies = await _cookieJar.loadForRequest(options.uri);
      final xsrf = cookies.where((c) => c.name == 'XSRF-TOKEN').firstOrNull;
      if (xsrf != null) {
        options.headers['X-XSRF-TOKEN'] = Uri.decodeComponent(xsrf.value);
      }
    }
    handler.next(options);
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
