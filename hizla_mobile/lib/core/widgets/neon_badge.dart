import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// Küçük glow'lu rozet/chip — "x1.5", "Peak", "Yeni" gibi.
class NeonBadge extends StatelessWidget {
  const NeonBadge({
    super.key,
    required this.label,
    this.icon,
    this.color,
  });

  final String label;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? context.colors.neonCyan;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: resolvedColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: resolvedColor.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(color: resolvedColor.withValues(alpha: 0.25), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: resolvedColor),
            const SizedBox(width: 4),
          ],
          Text(label, style: AppTypography.mono(fontSize: 11, color: resolvedColor)),
        ],
      ),
    );
  }
}
