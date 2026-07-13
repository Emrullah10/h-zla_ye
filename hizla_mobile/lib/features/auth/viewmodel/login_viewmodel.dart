import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_viewmodel.dart';

/// Login formunun kendi loading/error state'i — global AuthViewModel'i
/// mutasyon (login çağrısı) için tetikler, formdaki hata mesajını taşır.
class LoginViewModel extends AutoDisposeAsyncNotifier<void> {
  bool _disposed = false;

  @override
  Future<void> build() async {
    ref.onDispose(() => _disposed = true);
  }

  Future<bool> submit({required String phone, required String password}) async {
    state = const AsyncLoading();
    final authViewModel = ref.read(authViewModelProvider.notifier);
    await authViewModel.login(phone: phone, password: password);

    // submit çalışırken ekran kapanıp bu autoDispose notifier yok edilmiş
    // olabilir (örn. kullanıcı hızlıca geri gitti) — bu durumda state'e
    // yazmaya çalışmak "Future already completed" hatası verir.
    if (_disposed) return false;

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
