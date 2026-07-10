import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import 'auth_refresh_interceptor.dart';
import 'cookie_jar_provider.dart';
import 'xsrf_interceptor.dart';

/// Refresh çağrısı için ayrı, interceptor-zinciri-olmayan Dio (döngü önler).
final _refreshDioProvider = FutureProvider<Dio>((ref) async {
  final cookieJar = await ref.watch(cookieJarProvider.future);
  final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
  dio.interceptors.add(CookieManager(cookieJar));
  return dio;
});

/// Uygulamanın tüm servis çağrılarında kullandığı ana Dio instance'ı.
/// Cookie yönetimi + XSRF header + 401-refresh-retry zinciri kurulu gelir.
final dioProvider = FutureProvider<Dio>((ref) async {
  final cookieJar = await ref.watch(cookieJarProvider.future);
  final refreshDio = await ref.watch(_refreshDioProvider.future);

  final dio = Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  dio.interceptors.add(CookieManager(cookieJar));
  dio.interceptors.add(XsrfInterceptor(cookieJar));
  dio.interceptors.add(AuthRefreshInterceptor(
    dio: dio,
    refreshDio: refreshDio,
    onRefreshFailed: () {
      // authViewModel dinleyicileri /gateway/me çağrısının kendi 401'inden
      // Unauthenticated durumuna geçer; burada ek bir side-effect gerekmiyor.
    },
  ));

  return dio;
});
