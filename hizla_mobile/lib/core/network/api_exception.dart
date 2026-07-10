import 'package:dio/dio.dart';

/// DioException'ı uygulama içi domain hatasına indirger.
class ApiException implements Exception {
  ApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  factory ApiException.fromDioException(DioException e) {
    final data = e.response?.data;
    String? serverMessage;
    if (data is Map && data['message'] is String) {
      serverMessage = data['message'] as String;
    } else if (data is Map && data['error'] is String) {
      serverMessage = data['error'] as String;
    }
    return ApiException(
      message: serverMessage ?? _fallbackMessage(e),
      statusCode: e.response?.statusCode,
    );
  }

  static String _fallbackMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Bağlantı zaman aşımına uğradı';
      case DioExceptionType.connectionError:
        return 'İnternet bağlantısı yok';
      default:
        return e.response?.statusCode == 401
            ? 'Oturum süresi doldu'
            : 'Bir şeyler ters gitti';
    }
  }

  @override
  String toString() => message;
}
