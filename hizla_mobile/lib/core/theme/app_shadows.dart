import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Neon glow ve derin gölge tanımları.
///
/// `cyanGlow`/`brandGlow` marka renklerini kullanır (temadan bağımsız);
/// yalnızca cyan'ın tam tonu tema-bağımlı olduğundan opsiyonel [scheme]
/// parametresiyle geçirilebilir.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> cyanGlow({
    double blur = 24,
    double opacity = 0.4,
    AppColorScheme? scheme,
  }) =>
      [
        BoxShadow(
          color: (scheme?.neonCyan ?? AppColors.neonCyan).withValues(alpha: opacity),
          blurRadius: blur,
          spreadRadius: 2,
        ),
      ];

  static List<BoxShadow> brandGlow({double blur = 24, double opacity = 0.3}) => [
        BoxShadow(
          color: AppColors.brand.withValues(alpha: opacity),
          blurRadius: blur,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> deep = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.8),
      blurRadius: 50,
      offset: const Offset(0, 20),
    ),
  ];

  static List<BoxShadow> navShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.5),
      blurRadius: 30,
      offset: const Offset(0, -8),
    ),
  ];
}
