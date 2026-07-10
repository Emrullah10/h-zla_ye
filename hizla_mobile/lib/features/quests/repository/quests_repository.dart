import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_provider.dart';
import '../../../shared/constants/api_endpoints.dart';
import '../model/quest.dart';

abstract class QuestsRepository {
  Future<List<Quest>> fetchQuests();
}

class QuestsRepositoryImpl implements QuestsRepository {
  QuestsRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<Quest>> fetchQuests() async {
    try {
      final response = await _dio.get(ApiEndpoints.quests);
      return QuestsResponse.fromJson(response.data as Map<String, dynamic>).quests;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final questsRepositoryProvider = FutureProvider<QuestsRepository>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return QuestsRepositoryImpl(dio);
});
