import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_provider.dart';
import '../../../shared/constants/api_endpoints.dart';
import '../model/active_order.dart';

abstract class OrderRepository {
  Future<ActiveOrder?> fetchActiveOrder();
  Future<void> accept(String orderId);
  Future<void> reject(String orderId);
  Future<void> verify({required String orderId, required String qrCode});
  Future<void> rate({required String orderId, required int rating, String? comment});
}

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<ActiveOrder?> fetchActiveOrder() async {
    try {
      final response = await _dio.get(ApiEndpoints.activeOrder);
      return ActiveOrder.fromJsonOrNull(response.data);
    } on DioException catch (e) {
      // Aktif sipariş yoksa backend 404 dönebilir — bunu hata değil "yok" say.
      if (e.response?.statusCode == 404) return null;
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> accept(String orderId) async {
    try {
      await _dio.post(ApiEndpoints.acceptOrder(orderId));
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> reject(String orderId) async {
    try {
      await _dio.post(ApiEndpoints.rejectOrder(orderId));
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> verify({required String orderId, required String qrCode}) async {
    try {
      await _dio.post(
        ApiEndpoints.verifyOrder(orderId),
        data: {'qrCode': qrCode},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> rate({
    required String orderId,
    required int rating,
    String? comment,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.rateOrder(orderId),
        data: {
          'rating': rating,
          'comment': comment,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final orderRepositoryProvider = FutureProvider<OrderRepository>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return OrderRepositoryImpl(dio);
});
