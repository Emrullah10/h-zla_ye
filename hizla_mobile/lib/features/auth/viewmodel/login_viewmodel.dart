import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_viewmodel.dart';

/// Login formunun kendi loading/error state'i — global AuthViewModel'i
/// mutasyon (login çağrısı) için tetikler, formdaki hata mesajını taşır.
class LoginViewModel extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit({required String phone, required String password}) async {
    state = const AsyncLoading();
    final authViewModel = ref.read(authViewModelProvider.notifier);
    await authViewModel.login(phone: phone, password: password);
    final result = ref.read(authViewModelProvider);
    if (result.hasError) {
      state = AsyncError(result.error!, result.stackTrace!);
      return false;
    }
    state = const AsyncData(null);
    return true;
  }
}

final loginViewModelProvider =
    AutoDisposeAsyncNotifierProvider<LoginViewModel, void>(LoginViewModel.new);
