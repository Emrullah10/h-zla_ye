import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'glass_panel.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// Küçük glass istatistik kartı — "Aktif Süre 00:00:00" gibi.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.iconColor = AppColors.gradientStart,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: AppSpacing.radiusChip,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: AppTypography.labelSmall),
              Text(value,
                  style: AppTypography.mono(
                      fontSize: 14, color: valueColor ?? context.colors.onSurface)),
            ],
          ),
        ],
      ),
    );
  }
}
