import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// "Kinetic Nocturne" (koyu) ve "Kinetic Daylight" (açık) temaları.
class AppTheme {
  AppTheme._();

  static ThemeData get dark => _base(AppColorScheme.dark, Brightness.dark);
  static ThemeData get light => _base(AppColorScheme.light, Brightness.light);

  static ThemeData _base(AppColorScheme c, Brightness brightness) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: c.scaffold,
      colorScheme: base.colorScheme.copyWith(
        brightness: brightness,
        surface: c.surface,
        primary: AppColors.gradientEnd,
        secondary: c.neonCyan,
        error: c.error,
        onSurface: c.onSurface,
      ),
      textTheme: AppTypography.themedTextTheme(base.textTheme, c),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTypography.title.copyWith(color: c.onSurface),
      ),
      cardTheme: CardThemeData(
        color: c.surfaceContainerHigh.withValues(alpha: 0.6),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gradientEnd,
          foregroundColor: c.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
          borderSide: BorderSide(
            color: AppColors.gradientStart.withValues(alpha: 0.4),
          ),
        ),
      ),
      splashFactory: NoSplash.splashFactory,
      extensions: [c],
    );
  }
}
