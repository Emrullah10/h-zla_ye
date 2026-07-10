import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/cookie_jar_provider.dart';
import '../../../core/storage/secure_storage_provider.dart';
import '../model/auth_session.dart';
import '../model/driver_profile.dart';
import '../repository/auth_repository.dart';
import 'auth_state.dart';

const _driverStorageKey = 'hizla_driver_profile';

/// Uygulama genelindeki tek oturum kaynağı. Splash'te /me denenir;
/// onboarding.status'a göre Onboarding/Active state'i belirlenir.
/// go_router bu provider'ı dinleyerek redirect kararı verir.
class AuthViewModel extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final repository = await ref.watch(authRepositoryProvider.future);
    try {
      final session = await repository.fetchMe();
      final driver = await _loadPersistedDriver();
      return _stateFor(session, driver);
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        return const AuthUnauthenticated();
      }
      rethrow;
    }
  }

  Future<void> login({required String phone, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(authRepositoryProvider.future);
      final session = await repository.login(phone: phone, password: password);
      if (session.driver != null) {
        await _persistDriver(session.driver!);
      }
      final driver = session.driver ?? await _loadPersistedDriver();
      return _stateFor(session, driver);
    });
  }

  Future<void> refreshOnboardingStatus(String? newStatus) async {
    final current = state.valueOrNull;
    if (current is AuthOnboarding) {
      final updated = current.session.copyWith(onboardingStatus: newStatus);
      final driver = await _loadPersistedDriver();
      state = AsyncData(_stateFor(updated, driver));
    }
  }

  Future<void> logout() async {
    final repository = await ref.read(authRepositoryProvider.future);
    try {
      await repository.logout();
    } catch (_) {
      // Sunucu tarafı hata olsa da lokal oturumu temizlemeye devam et.
    }
    final cookieJar = await ref.read(cookieJarProvider.future);
    await cookieJar.deleteAll();
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: _driverStorageKey);
    state = const AsyncData(AuthUnauthenticated());
  }

  AuthState _stateFor(AuthSession session, DriverProfile? driver) {
    if (session.isApproved) {
      return AuthActive(session, driver);
    }
    return AuthOnboarding(session);
  }

  Future<void> _persistDriver(DriverProfile driver) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: _driverStorageKey, value: jsonEncode(driver.toJson()));
  }

  Future<DriverProfile?> _loadPersistedDriver() async {
    final storage = ref.read(secureStorageProvider);
    final raw = await storage.read(key: _driverStorageKey);
    if (raw == null) return null;
    return DriverProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}

final authViewModelProvider =
    AsyncNotifierProvider<AuthViewModel, AuthState>(AuthViewModel.new);
