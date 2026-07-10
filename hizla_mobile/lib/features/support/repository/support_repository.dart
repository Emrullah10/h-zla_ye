import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_provider.dart';
import '../../../shared/constants/api_endpoints.dart';
import '../model/support_ticket.dart';

/// POST /courier/support — create-support-ticket.use-case.js ile birebir.
abstract class SupportRepository {
  Future<void> createTicket(SupportTicket ticket);
}

class SupportRepositoryImpl implements SupportRepository {
  SupportRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> createTicket(SupportTicket ticket) async {
    try {
      await _dio.post(ApiEndpoints.support, data: ticket.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final supportRepositoryProvider = FutureProvider<SupportRepository>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return SupportRepositoryImpl(dio);
});
