import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_panel.dart';

/// Header'daki "BUGÜN ₺1,240.50" glass widget'ı.
class EarningsTicker extends StatelessWidget {
  const EarningsTicker({super.key, required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    final wholePart = amount.floor();
    final centsPart = ((amount - wholePart) * 100).round().toString().padLeft(2, '0');

    return GlassPanel(
      borderRadius: AppSpacing.radiusChip,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('BUGÜN', style: AppTypography.labelSmall),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '₺$wholePart',
                  style: AppTypography.mono(
                      fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.gradientStart),
                ),
                TextSpan(
                  text: '.$centsPart',
                  style: AppTypography.mono(
                      fontSize: 13,
                      color: AppColors.gradientStart.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
