import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_panel.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import 'widgets/onboarding_scaffold.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// Onboarding Adım 4a — Eğitim modülleri (tamamlanınca completeTraining()
/// çağrılır, router otomatik Onay Bekliyor ekranına yönlendirir).
class TrainingScreen extends ConsumerStatefulWidget {
  const TrainingScreen({super.key});

  @override
  ConsumerState<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends ConsumerState<TrainingScreen> {
  final Set<String> _completed = {};
  bool _submitting = false;

  static const _modules = [
    (
      id: 'app_usage',
      icon: Icons.smartphone_rounded,
      title: 'Uygulama Kullanımı',
      subtitle: 'Sipariş kabul, navigasyon ve teslimat akışı.',
    ),
    (
      id: 'traffic_rules',
      icon: Icons.traffic_rounded,
      title: 'Trafik Kuralları',
      subtitle: 'Güvenli sürüş ve trafik kurallarına uyum.',
    ),
    (
      id: 'customer_communication',
      icon: Icons.chat_bubble_rounded,
      title: 'Müşteri İletişimi',
      subtitle: 'Profesyonel ve nazik iletişim ilkeleri.',
    ),
    (
      id: 'safety',
      icon: Icons.health_and_safety_rounded,
      title: 'Güvenlik',
      subtitle: 'Kişisel güvenlik ve acil durum prosedürleri.',
    ),
  ];

  Future<void> _finishTraining() async {
    setState(() => _submitting = true);
    try {
      await ref.read(onboardingViewModelProvider.notifier).completeTraining();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allCompleted = _completed.length == _modules.length;

    return OnboardingScaffold(
      title: 'Eğitim',
      stepIndex: 4,
      totalSteps: 4,
      bottomAction: OnboardingContinueButton(
        label: 'Eğitimi Bitir',
        isLoading: _submitting,
        onPressed: (allCompleted && !_submitting) ? _finishTraining : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingSectionLabel('Training Modules'),
          Text(
            'Kurye olarak çalışmaya başlamadan önce aşağıdaki eğitim modüllerini tamamlayın.',
            style: AppTypography.bodyMuted,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final module in _modules) ...[
            _TrainingModuleCard(
              icon: module.icon,
              title: module.title,
              subtitle: module.subtitle,
              isCompleted: _completed.contains(module.id),
              onTap: () => setState(() {
                if (!_completed.add(module.id)) {
                  _completed.remove(module.id);
                }
              }),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _TrainingModuleCard extends StatelessWidget {
  const _TrainingModuleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassPanel(
        borderRadius: AppSpacing.radiusChip,
        padding: const EdgeInsets.all(AppSpacing.lg),
        borderOpacity: isCompleted ? 0.3 : 0.12,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.gradientStart.withValues(alpha: 0.1)
                    : context.colors.scaffold,
              ),
              child: Icon(
                icon,
                size: 24,
                color: isCompleted ? AppColors.gradientStart : context.colors.secondary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.title.copyWith(fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.label.copyWith(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? AppColors.gradientStart
                      : context.colors.onSurface.withValues(alpha: 0.2),
                  width: 2,
                ),
                color: isCompleted ? AppColors.gradientStart : null,
              ),
              child: isCompleted
                  ? Icon(Icons.check_rounded, size: 16, color: context.colors.onPrimary)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
