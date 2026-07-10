import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_provider.dart';
import '../../../shared/constants/api_endpoints.dart';
import '../model/wallet.dart';

abstract class WalletRepository {
  Future<Wallet> fetchWallet();
}

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<Wallet> fetchWallet() async {
    try {
      final response = await _dio.get(ApiEndpoints.wallet);
      return Wallet.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final walletRepositoryProvider = FutureProvider<WalletRepository>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return WalletRepositoryImpl(dio);
});
