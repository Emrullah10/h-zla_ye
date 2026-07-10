import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/active_order.dart';
import '../repository/order_repository.dart';

/// Aktif sipariş durumunu tutan ve 8sn'de bir polling yapan ViewModel.
/// Kurye online iken bekleyen (incoming) veya kabul edilmiş (active mission)
/// bir sipariş var mı diye periyodik kontrol eder.
class ActiveOrderViewModel extends AsyncNotifier<ActiveOrder?> {
  Timer? _pollTimer;

  @override
  Future<ActiveOrder?> build() async {
    ref.onDispose(() => _pollTimer?.cancel());
    _startPolling();
    return _fetch();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 8), (_) async {
      final order = await _fetch();
      state = AsyncData(order);
    });
  }

  Future<ActiveOrder?> _fetch() async {
    final repository = await ref.watch(orderRepositoryProvider.future);
    return repository.fetchActiveOrder();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> accept(String orderId) async {
    final repository = await ref.read(orderRepositoryProvider.future);
    await repository.accept(orderId);
    await refresh();
  }

  Future<void> reject(String orderId) async {
    final repository = await ref.read(orderRepositoryProvider.future);
    await repository.reject(orderId);
    await refresh();
  }

  Future<void> verify({required String orderId, required String qrCode}) async {
    final repository = await ref.read(orderRepositoryProvider.future);
    await repository.verify(orderId: orderId, qrCode: qrCode);
    await refresh();
  }

  Future<void> rate({
    required String orderId,
    required int rating,
    String? comment,
  }) async {
    final repository = await ref.read(orderRepositoryProvider.future);
    await repository.rate(orderId: orderId, rating: rating, comment: comment);
    await refresh();
  }
}

final activeOrderViewModelProvider =
    AsyncNotifierProvider<ActiveOrderViewModel, ActiveOrder?>(
        ActiveOrderViewModel.new);
