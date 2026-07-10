import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/earnings.dart';
import '../repository/earnings_repository.dart';

class EarningsViewModel extends AsyncNotifier<Earnings> {
  EarningsPeriod _period = EarningsPeriod.weekly;
  EarningsPeriod get period => _period;

  @override
  Future<Earnings> build() async {
    return _load();
  }

  Future<Earnings> _load() async {
    final repository = await ref.watch(earningsRepositoryProvider.future);
    return repository.fetchEarnings(_period);
  }

  Future<void> setPeriod(EarningsPeriod period) async {
    if (_period == period) return;
    _period = period;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }
}

final earningsViewModelProvider =
    AsyncNotifierProvider<EarningsViewModel, Earnings>(EarningsViewModel.new);
