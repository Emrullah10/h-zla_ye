import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// Stitch `.glass-panel`: rgba(42,42,42,0.6) + backdrop-blur(20-24px).
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.borderRadius = AppSpacing.radiusCard,
    this.blurSigma = 20,
    this.fillOpacity = 0.6,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.borderOpacity = 0.12,
  });

  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final double fillOpacity;
  final EdgeInsets padding;
  final double borderOpacity;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHigh.withValues(alpha: fillOpacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: borderOpacity),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
