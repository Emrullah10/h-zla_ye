import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/model/driver_profile.dart';
import '../../auth/viewmodel/auth_state.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

/// AuthActive state'inden DriverProfile'ı okuyan basit bir türetilmiş provider.
/// Backend'de ayrı bir /profile endpoint'i yok — driver bilgisi login/AuthActive
/// state'inden geliyor.
final profileDriverProvider = Provider<DriverProfile?>((ref) {
  final authState = ref.watch(authViewModelProvider);
  final session = authState.valueOrNull;
  if (session is AuthActive) return session.driver;
  return null;
});

/// Çıkış işlemini tetikleyen ince yardımcı — router zaten authViewModelProvider
/// state'ini dinleyip logout sonrası login ekranına yönlendiriyor.
final profileLogoutProvider = Provider<Future<void> Function()>((ref) {
  return () => ref.read(authViewModelProvider.notifier).logout();
});
