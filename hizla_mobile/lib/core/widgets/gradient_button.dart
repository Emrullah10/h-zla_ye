import 'package:flutter/material.dart';
import '../theme/app_gradients.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// Ana CTA butonu — 135° turuncu gradyan + glow.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.gradient = AppGradients.primary,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Gradient gradient;
  final double height;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || isLoading;
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: disabled ? null : gradient,
          color: disabled ? context.colors.surfaceContainerHighest : null,
          borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
          boxShadow: disabled ? null : AppShadows.brandGlow(),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
            onTap: disabled ? null : onPressed,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: context.colors.onPrimary,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: AppTypography.title.copyWith(
                            color: disabled
                                ? context.colors.onSurfaceVariant
                                : context.colors.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (icon != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Icon(icon,
                              size: 20,
                              color: disabled
                                  ? context.colors.onSurfaceVariant
                                  : context.colors.onPrimary),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
