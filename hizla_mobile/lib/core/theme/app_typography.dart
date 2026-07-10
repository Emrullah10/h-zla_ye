import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Üç fontlu tipografi sistemi:
/// - Inter: başlık/body (anlatı)
/// - Space Grotesk: label/uppercase (meta veri)
/// - JetBrains Mono: TÜM sayısal değerler (telemetri)
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
}
