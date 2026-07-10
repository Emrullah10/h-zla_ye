import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/courier_shift.dart';
import '../model/daily_summary.dart';
import '../repository/dashboard_repository.dart';

/// Online/offline lokal state + günlük kazanç özeti.
/// Backend'de gerçek GPS/shift takibi yok; "Aktif Süre" online'a geçilen
/// andan itibaren lokal olarak sayılır, "Mesafe" simüle edilmez (0.0 km).
class DashboardViewModel extends AsyncNotifier<CourierShift> {
  Timer? _tickTimer;

  @override
  Future<CourierShift> build() async {
    ref.onDispose(() => _tickTimer?.cancel());
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
    }
  }

  Future<void> refreshSummary() async {
    final summary = await _fetchSummary();
    final current = state.valueOrNull ?? CourierShift.initial;
    state = AsyncData(current.copyWith(dailySummaryEarnings: summary.todayEarnings));
  }
}

final dashboardViewModelProvider =
    AsyncNotifierProvider<DashboardViewModel, CourierShift>(DashboardViewModel.new);
