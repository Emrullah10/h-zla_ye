import 'package:flutter/material.dart';

/// "Kinetic Nocturne" / "Kinetic Daylight" renk paleti — Stitch tasarım
/// sisteminden birebir. Tema-bağımlı renkler [AppColorScheme] üzerinden
/// (bkz. `context.colors`), marka/gradyan gibi temadan bağımsız sabitler
/// burada `static const` kalır.
class AppColors {
  AppColors._();

  // Marka & primary gradyan — her iki temada da AYNI (marka kimliği sabit).
  static const Color brand = Color(0xFFFF4B2B);
  static const Color gradientStart = Color(0xFFFFB4A5);
  static const Color gradientEnd = Color(0xFFFF5637);
  static const Color primaryFixed = Color(0xFFFFDAD3);

  // Platform rozetleri (sipariş kartı entegrasyonları) — her iki temada aynı.
  static const Color yemeksepeti = Color(0xFFEA004B);
  static const Color getir = Color(0xFF5D3EBD);
  static const Color trendyol = Color(0xFFFF6000);

  // --- Aşağıdakiler geriye dönük uyumluluk için korunur (koyu tema
  // değerleri). Yeni kod `context.colors.x` kullanmalı. ---
  static const Color scaffold = Color(0xFF0E0E0E);
  static const Color surface = Color(0xFF131313);
  static const Color surfaceContainerLow = Color(0xFF1B1B1B);
  static const Color surfaceContainer = Color(0xFF1F1F1F);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color surfaceContainerHighest = Color(0xFF353535);
  static const Color surfaceBright = Color(0xFF393939);
  static const Color onPrimary = Color(0xFF650B00);
  static const Color onPrimaryContainer = Color(0xFF590800);
  static const Color neonCyan = Color(0xFF00DAF3);
  static const Color neonCyanContainer = Color(0xFF009FB2);
  static const Color onSurface = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFFE5BDB6);
  static const Color secondary = Color(0xFFC8C6C5);
  static const Color onSecondaryFixedVariant = Color(0xFF474746);
  static const Color outline = Color(0xFFAC8881);
  static const Color outlineVariant = Color(0xFF5C403A);
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  static Color glassFill({double opacity = 0.06}) =>
      Colors.white.withValues(alpha: opacity);
  static Color glassBorder({double opacity = 0.12}) =>
      Colors.white.withValues(alpha: opacity);
}

/// Tema-bağımlı renk şeması — `Theme.of(context).extension<AppColorScheme>()`
/// üzerinden erişilir (kısayol: `context.colors`, bkz. theme_context.dart).
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.scaffold,
    required this.surface,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.surfaceBright,
    required this.onPrimary,
    required this.onPrimaryContainer,
    required this.neonCyan,
    required this.neonCyanContainer,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.secondary,
    required this.onSecondaryFixedVariant,
    required this.outline,
    required this.outlineVariant,
    required this.error,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.glassFillOpacity,
    required this.glassBorderOpacity,
    required this.glassBase,
  });

  final Color scaffold;
  final Color surface;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color surfaceBright;
  final Color onPrimary;
  final Color onPrimaryContainer;
  final Color neonCyan;
  final Color neonCyanContainer;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color secondary;
  final Color onSecondaryFixedVariant;
  final Color outline;
  final Color outlineVariant;
  final Color error;
  final Color errorContainer;
  final Color onErrorContainer;

  /// Glass efektlerinin taban rengi — koyuda beyaz, açıkta siyah üzerine
  /// düşük opaklık uygulanır (bkz. [glassFill]/[glassBorder]).
  final Color glassBase;
  final double glassFillOpacity;
  final double glassBorderOpacity;

  Color glassFill({double? opacity}) =>
      glassBase.withValues(alpha: opacity ?? glassFillOpacity);
  Color glassBorder({double? opacity}) =>
      glassBase.withValues(alpha: opacity ?? glassBorderOpacity);

  static const dark = AppColorScheme(
    scaffold: Color(0xFF0E0E0E),
    surface: Color(0xFF131313),
    surfaceContainerLow: Color(0xFF1B1B1B),
    surfaceContainer: Color(0xFF1F1F1F),
    surfaceContainerHigh: Color(0xFF2A2A2A),
    surfaceContainerHighest: Color(0xFF353535),
    surfaceBright: Color(0xFF393939),
    onPrimary: Color(0xFF650B00),
    onPrimaryContainer: Color(0xFF590800),
    neonCyan: Color(0xFF00DAF3),
    neonCyanContainer: Color(0xFF009FB2),
    onSurface: Color(0xFFE2E2E2),
    onSurfaceVariant: Color(0xFFE5BDB6),
    secondary: Color(0xFFC8C6C5),
    onSecondaryFixedVariant: Color(0xFF474746),
    outline: Color(0xFFAC8881),
    outlineVariant: Color(0xFF5C403A),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    glassBase: Colors.white,
    glassFillOpacity: 0.06,
    glassBorderOpacity: 0.12,
  );

  static const light = AppColorScheme(
    scaffold: Color(0xFFFAF7F5),
    surface: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF4F0ED),
    surfaceContainer: Color(0xFFEFEAE6),
    surfaceContainerHigh: Color(0xFFE8E2DD),
    surfaceContainerHighest: Color(0xFFDFD8D2),
    surfaceBright: Color(0xFFFFFFFF),
    onPrimary: Color(0xFFFFFFFF),
    onPrimaryContainer: Color(0xFF590800),
    neonCyan: Color(0xFF0093A6),
    neonCyanContainer: Color(0xFFC9F3FA),
    onSurface: Color(0xFF1D1B1A),
    onSurfaceVariant: Color(0xFF6E5A54),
    secondary: Color(0xFF4A4847),
    onSecondaryFixedVariant: Color(0xFFDFD8D2),
    outline: Color(0xFF8C6F68),
    outlineVariant: Color(0xFFE4D3CD),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
    glassBase: Colors.black,
    glassFillOpacity: 0.04,
    glassBorderOpacity: 0.08,
  );

  @override
  AppColorScheme copyWith({
    Color? scaffold,
    Color? surface,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? surfaceBright,
    Color? onPrimary,
    Color? onPrimaryContainer,
    Color? neonCyan,
    Color? neonCyanContainer,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? secondary,
    Color? onSecondaryFixedVariant,
    Color? outline,
    Color? outlineVariant,
    Color? error,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? glassBase,
    double? glassFillOpacity,
    double? glassBorderOpacity,
  }) {
    return AppColorScheme(
      scaffold: scaffold ?? this.scaffold,
      surface: surface ?? this.surface,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      onPrimary: onPrimary ?? this.onPrimary,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      neonCyan: neonCyan ?? this.neonCyan,
      neonCyanContainer: neonCyanContainer ?? this.neonCyanContainer,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      secondary: secondary ?? this.secondary,
      onSecondaryFixedVariant:
          onSecondaryFixedVariant ?? this.onSecondaryFixedVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      glassBase: glassBase ?? this.glassBase,
      glassFillOpacity: glassFillOpacity ?? this.glassFillOpacity,
      glassBorderOpacity: glassBorderOpacity ?? this.glassBorderOpacity,
    );
  }

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceContainerLow:
          Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainer:
          Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh:
          Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceContainerHighest: Color.lerp(
          surfaceContainerHighest, other.surfaceContainerHighest, t)!,
      surfaceBright: Color.lerp(surfaceBright, other.surfaceBright, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onPrimaryContainer:
          Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t)!,
      neonCyan: Color.lerp(neonCyan, other.neonCyan, t)!,
      neonCyanContainer:
          Color.lerp(neonCyanContainer, other.neonCyanContainer, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant:
          Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondaryFixedVariant: Color.lerp(
          onSecondaryFixedVariant, other.onSecondaryFixedVariant, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      onErrorContainer:
          Color.lerp(onErrorContainer, other.onErrorContainer, t)!,
      glassBase: Color.lerp(glassBase, other.glassBase, t)!,
      glassFillOpacity: t < 0.5 ? glassFillOpacity : other.glassFillOpacity,
      glassBorderOpacity:
          t < 0.5 ? glassBorderOpacity : other.glassBorderOpacity,
    );
  }
}
