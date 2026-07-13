import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage_provider.dart';

const _themeModeKey = 'theme_mode';

/// Kullanıcının tema tercihi — varsayılan [ThemeMode.system]. Değer
/// `flutter_secure_storage`'da kalıcı tutulur.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _restore();
    return ThemeMode.system;
  }

  Future<void> _restore() async {
    final storage = ref.read(secureStorageProvider);
    final saved = await storage.read(key: _themeModeKey);
    if (saved == null) return;
    state = ThemeMode.values.firstWhere(
      (m) => m.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: _themeModeKey, value: mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
