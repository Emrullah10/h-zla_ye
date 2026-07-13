import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// Onboarding adımlarının ortak iskeleti: geri/yardım header, ilerleme
/// çubuğu, "Step X of 4" etiketi. Stitch onboarding-arac.html / onboarding-belge.html.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.title,
    required this.stepIndex, // 1..4
    required this.totalSteps,
    required this.child,
    this.onBack,
    this.bottomAction,
  });

  final String title;
  final int stepIndex;
  final int totalSteps;
  final Widget child;
  final VoidCallback? onBack;
  final Widget? bottomAction;

  @override
  Widget build(BuildContext context) {
    final progress = stepIndex / totalSteps;
    return Scaffold(
      backgroundColor: context.colors.scaffold,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: onBack ?? () => Navigator.maybePop(context),
                    icon: Icon(Icons.arrow_back_rounded,
                        color: context.colors.onSurface),
                  ),
                  Text('Hızla Ye', style: AppTypography.brandLogo.copyWith(fontSize: 18)),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.help_outline_rounded,
                        color: context.colors.onSurface),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: AppTypography.headline),
                  Text(
                    'Step $stepIndex of $totalSteps',
                    style: AppTypography.mono(
                        fontSize: 13, color: context.colors.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: context.colors.surfaceContainerHigh,
                  valueColor: const AlwaysStoppedAnimation(AppColors.gradientEnd),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: AppSpacing.xl),
                  child: child,
                ),
              ),
              if (bottomAction != null) ...[
                Container(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: context.colors.outlineVariant.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: bottomAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingSectionLabel extends StatelessWidget {
  const OnboardingSectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(text.toUpperCase(), style: AppTypography.label),
    );
  }
}

/// Tercih/seçim kartı — radio-benzeri, seçiliyken glow+border.
class SelectableOptionCard extends StatelessWidget {
  const SelectableOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.lg),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.surfaceContainerHighest
              : context.colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
          border: Border.all(
            color: isSelected
                ? AppColors.gradientStart.withValues(alpha: 0.5)
                : context.colors.outlineVariant.withValues(alpha: 0.15),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.brand.withValues(alpha: 0.15),
                    blurRadius: 15,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.gradientStart.withValues(alpha: 0.1)
                    : context.colors.scaffold,
              ),
              child: Icon(icon,
                  size: 26,
                  color: isSelected ? AppColors.gradientStart : context.colors.secondary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.title.copyWith(fontSize: 16)),
                  Text(subtitle, style: AppTypography.label.copyWith(fontSize: 12)),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.gradientStart
                      : context.colors.onSurface.withValues(alpha: 0.2),
                  width: 2,
                ),
                color: isSelected ? AppColors.gradientStart : null,
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded,
                      size: 14, color: context.colors.onPrimary)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContinueButton extends StatelessWidget {
  const OnboardingContinueButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: disabled ? null : AppGradients.primary,
          color: disabled ? context.colors.surfaceContainerHighest : null,
          borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
            onTap: disabled ? null : onPressed,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.4, color: context.colors.onPrimary),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(label,
                            style: AppTypography.title.copyWith(
                              color: disabled
                                  ? context.colors.onSurfaceVariant
                                  : context.colors.onPrimary,
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(width: AppSpacing.sm),
                        Icon(Icons.arrow_forward_rounded,
                            size: 20,
                            color: disabled
                                ? context.colors.onSurfaceVariant
                                : context.colors.onPrimary),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
