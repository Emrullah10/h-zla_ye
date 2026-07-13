import 'package:flutter/material.dart';
import 'app_colors.dart';

/// `context.colors.x` kısayolu — aktif temanın [AppColorScheme]'ine erişir.
extension ThemeContextX on BuildContext {
  AppColorScheme get colors => Theme.of(this).extension<AppColorScheme>()!;
}
