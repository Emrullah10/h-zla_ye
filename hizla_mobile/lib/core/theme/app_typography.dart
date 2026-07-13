import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Üç fontlu tipografi sistemi:
/// - Inter: başlık/body (anlatı)
/// - Space Grotesk: label/uppercase (meta veri)
/// - JetBrains Mono: TÜM sayısal değerler (telemetri)
///
/// Renkler tema-bağımlıdır — [forScheme] ile aktif [AppColorScheme]'e göre
/// üretilir. `context.typography` kısayolu bunu otomatik sağlar.
class AppTypography {
  AppTypography._();

  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    color: AppColors.onSurface,
    height: 1.1,
  );

  static TextStyle headline = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.onSurface,
  );

  static TextStyle title = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static TextStyle bodyMuted = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle label = GoogleFonts.spaceGrotesk(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle labelSmall = GoogleFonts.spaceGrotesk(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.onSecondaryFixedVariant,
  );

  /// Kazanç, mesafe, süre, çarpan — HER ZAMAN mono, tabularFigures ile hizalı.
  static TextStyle mono({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.onSurface,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle monoDisplay({Color color = AppColors.gradientStart}) =>
      mono(fontSize: 40, fontWeight: FontWeight.w700, color: color);

  static TextStyle brandLogo = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    fontStyle: FontStyle.italic,
    letterSpacing: -1,
    color: AppColors.brand,
  );

  /// Aktif [AppColorScheme]'e göre renklendirilmiş TextTheme parçaları —
  /// `AppTheme._base` içinde ThemeData.textTheme'e uygulanır.
  static TextTheme themedTextTheme(TextTheme base, AppColorScheme c) {
    return base.copyWith(
      displayLarge: displayLarge.copyWith(color: c.onSurface),
      headlineMedium: headline.copyWith(color: c.onSurface),
      titleMedium: title.copyWith(color: c.onSurface),
      bodyMedium: body.copyWith(color: c.onSurface),
      bodySmall: bodyMuted.copyWith(color: c.onSurfaceVariant),
      labelSmall: labelSmall.copyWith(color: c.onSecondaryFixedVariant),
    );
  }
}
