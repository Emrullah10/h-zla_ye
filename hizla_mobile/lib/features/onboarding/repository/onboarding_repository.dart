import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_provider.dart';
import '../../../shared/constants/api_endpoints.dart';
import '../model/onboarding_status.dart';

abstract class OnboardingRepository {
  Future<OnboardingStatus> fetchStatus();
  Future<void> selectVehicle(String vehicleType);
  Future<void> uploadDocument({required String docType, required String filePath});
  Future<void> completeTraining();
}

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<OnboardingStatus> fetchStatus() async {
    try {
      final response = await _dio.get(ApiEndpoints.onboardingStatus);
      return OnboardingStatus.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> selectVehicle(String vehicleType) async {
    try {
      await _dio.post(
        ApiEndpoints.onboardingVehicle,
        data: {'vehicleType': vehicleType},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> uploadDocument({
    required String docType,
    required String filePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'docType': docType,
        'file': await MultipartFile.fromFile(filePath),
      });
      await _dio.post(ApiEndpoints.onboardingDocument, data: formData);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> completeTraining() async {
    try {
      await _dio.post(ApiEndpoints.onboardingTrainingComplete);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final onboardingRepositoryProvider = FutureProvider<OnboardingRepository>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return OnboardingRepositoryImpl(dio);
});
