import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Stitch'teki 135° gradyanların Flutter karşılığı.
class AppGradients {
  AppGradients._();

  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.gradientStart, AppColors.gradientEnd],
  );

  static const LinearGradient cyan = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9CF0FF), AppColors.neonCyan],
  );

  /// Scaffold rengi verilen temaya göre üstten/alttan kararma —
  /// `scaffoldFadeFor(context.colors)` ile çağrılmalı.
  static LinearGradient scaffoldFadeFor(AppColorScheme c, {bool topToBottom = true}) =>
      LinearGradient(
        begin: topToBottom ? Alignment.topCenter : Alignment.bottomCenter,
        end: topToBottom ? Alignment.bottomCenter : Alignment.topCenter,
        colors: [
          c.scaffold,
          c.scaffold.withValues(alpha: 0.0),
        ],
      );

  @Deprecated('scaffoldFadeFor(context.colors) kullanın — koyu tema sabitliyor')
  static LinearGradient scaffoldFade({bool topToBottom = true}) =>
      scaffoldFadeFor(AppColorScheme.dark, topToBottom: topToBottom);
}
