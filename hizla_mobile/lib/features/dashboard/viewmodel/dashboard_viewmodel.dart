import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/location/location_provider.dart';
import '../model/courier_shift.dart';
import '../model/daily_summary.dart';
import '../repository/dashboard_repository.dart';

/// Online/offline lokal state + günlük kazanç özeti.
/// Online iken gerçek GPS konumu ~5 sn'de bir backend'e gönderilir.
class DashboardViewModel extends AsyncNotifier<CourierShift> {
  Timer? _tickTimer;
  ProviderSubscription<AsyncValue<DeviceLocation>>? _locationSub;
  DateTime? _lastLocationSentAt;

  @override
  Future<CourierShift> build() async {
    ref.onDispose(() {
      _tickTimer?.cancel();
      _locationSub?.close();
    });
    final summary = await _fetchSummary();
    return CourierShift.initial.copyWith(dailySummaryEarnings: summary.todayEarnings);
  }

  Future<DailySummary> _fetchSummary() async {
    final repository = await ref.watch(dashboardRepositoryProvider.future);
    return repository.fetchDailySummary();
  }

  void toggleOnline() {
    final current = state.valueOrNull ?? CourierShift.initial;
    if (current.isOnline) {
      _tickTimer?.cancel();
      _locationSub?.close();
      _locationSub = null;
      state = AsyncData(current.copyWith(isOnline: false, clearActiveSince: true));
    } else {
      state = AsyncData(current.copyWith(isOnline: true, activeSince: DateTime.now()));
      _tickTimer?.cancel();
      _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        final s = state.valueOrNull;
        if (s != null) {
          // Değişmez veriyi yeniden yaymak yerine sadece rebuild tetikler —
          // activeDuration getter'ı `DateTime.now()` üzerinden her seferinde
          // taze hesaplanır.
          state = AsyncData(s);
        }
      });
      _locationSub?.close();
      _locationSub = ref.listen<AsyncValue<DeviceLocation>>(
        courierLocationProvider,
        (_, next) => _onLocationUpdate(next.valueOrNull),
      );
    }
  }

  void _onLocationUpdate(DeviceLocation? location) {
    if (location == null || !location.isReal) return;
    final now = DateTime.now();
    if (_lastLocationSentAt != null &&
        now.difference(_lastLocationSentAt!) < const Duration(seconds: 5)) {
      return;
    }
    _lastLocationSentAt = now;
    ref.read(dashboardRepositoryProvider.future).then(
          (repository) => repository.sendLocation(location.point.latitude, location.point.longitude),
        );
  }

  Future<void> refreshSummary() async {
    final summary = await _fetchSummary();
    final current = state.valueOrNull ?? CourierShift.initial;
    state = AsyncData(current.copyWith(dailySummaryEarnings: summary.todayEarnings));
  }
}

final dashboardViewModelProvider =
    AsyncNotifierProvider<DashboardViewModel, CourierShift>(DashboardViewModel.new);
