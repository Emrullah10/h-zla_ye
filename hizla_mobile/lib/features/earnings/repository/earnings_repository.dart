import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_provider.dart';
import '../../../shared/constants/api_endpoints.dart';
import '../model/earnings.dart';

abstract class EarningsRepository {
  Future<Earnings> fetchEarnings(EarningsPeriod period);
}

class EarningsRepositoryImpl implements EarningsRepository {
  EarningsRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<Earnings> fetchEarnings(EarningsPeriod period) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.earnings,
        queryParameters: {'period': period.apiValue},
      );
      return Earnings.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final earningsRepositoryProvider = FutureProvider<EarningsRepository>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return EarningsRepositoryImpl(dio);
});
