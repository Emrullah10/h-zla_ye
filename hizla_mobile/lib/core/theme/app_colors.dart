import 'package:flutter/material.dart';

/// "Kinetic Nocturne" renk paleti — Stitch tasarım sisteminden birebir.
class AppColors {
  AppColors._();

  // Yüzey hiyerarşisi (True Black kademeleri)
  static const Color scaffold = Color(0xFF0E0E0E);
  static const Color surface = Color(0xFF131313);
  static const Color surfaceContainerLow = Color(0xFF1B1B1B);
  static const Color surfaceContainer = Color(0xFF1F1F1F);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color surfaceContainerHighest = Color(0xFF353535);
  static const Color surfaceBright = Color(0xFF393939);

  // Marka & primary gradyan
  static const Color brand = Color(0xFFFF4B2B);
  static const Color gradientStart = Color(0xFFFFB4A5);
  static const Color gradientEnd = Color(0xFFFF5637);
  static const Color primaryFixed = Color(0xFFFFDAD3);
  static const Color onPrimary = Color(0xFF650B00);
  static const Color onPrimaryContainer = Color(0xFF590800);

  // Neon aksan (rota, ETA, online, çarpanlar)
  static const Color neonCyan = Color(0xFF00DAF3);
  static const Color neonCyanContainer = Color(0xFF009FB2);

  // Metin
  static const Color onSurface = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFFE5BDB6);
  static const Color secondary = Color(0xFFC8C6C5);
  static const Color onSecondaryFixedVariant = Color(0xFF474746);

  // Kenarlıklar (yalnızca "ghost border" — %10-15 opacity ile)
  static const Color outline = Color(0xFFAC8881);
  static const Color outlineVariant = Color(0xFF5C403A);

  // Durum
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // Platform rozetleri (sipariş kartı entegrasyonları)
  static const Color yemeksepeti = Color(0xFFEA004B);
  static const Color getir = Color(0xFF5D3EBD);
  static const Color trendyol = Color(0xFFFF6000);

  // Glass yardımcıları
  static Color glassFill({double opacity = 0.06}) =>
      Colors.white.withValues(alpha: opacity);
  static Color glassBorder({double opacity = 0.12}) =>
      Colors.white.withValues(alpha: opacity);
}
