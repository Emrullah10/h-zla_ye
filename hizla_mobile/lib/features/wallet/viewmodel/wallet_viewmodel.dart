import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/wallet.dart';
import '../repository/wallet_repository.dart';

class WalletViewModel extends AsyncNotifier<Wallet> {
  @override
  Future<Wallet> build() async {
    return _load();
  }

  Future<Wallet> _load() async {
    final repository = await ref.watch(walletRepositoryProvider.future);
    return repository.fetchWallet();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }
}

final walletViewModelProvider = AsyncNotifierProvider<WalletViewModel, Wallet>(WalletViewModel.new);
