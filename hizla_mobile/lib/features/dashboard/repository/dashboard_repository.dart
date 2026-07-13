import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_provider.dart';
import '../../../shared/constants/api_endpoints.dart';
import '../model/daily_summary.dart';

/// Dashboard'ın ihtiyacı olan minimal veri — earnings feature'ının detaylı
/// analitiğiyle ÇAKIŞMAZ, sadece header'daki "Bugün ₺X" widget'ı için.
abstract class DashboardRepository {
  Future<DailySummary> fetchDailySummary();
  Future<void> sendLocation(double lat, double lng);
}

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<DailySummary> fetchDailySummary() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.earnings,
        queryParameters: {'period': 'weekly'},
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) return DailySummary.zero;
      return DailySummary.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return DailySummary.zero;
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> sendLocation(double lat, double lng) async {
    try {
      await _dio.post(
        ApiEndpoints.courierLocation,
        data: {'lat': lat, 'lng': lng},
      );
    } on DioException catch (_) {
      // Konum gönderimi arka plan işi — sessizce yut, dashboard'u bozmasın.
    }
  }
}

final dashboardRepositoryProvider = FutureProvider<DashboardRepository>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return DashboardRepositoryImpl(dio);
});
