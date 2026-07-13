import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_panel.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// Onboarding Adım 4b — Başvuru inceleme ekranı. Backend onayı 15 saniyede
/// bir Timer.periodic ile poll edilir; router redirect'i onay geldiğinde
/// otomatik olarak dashboard'a yönlendirir.
class PendingApprovalScreen extends ConsumerStatefulWidget {
  const PendingApprovalScreen({super.key});

  @override
  ConsumerState<PendingApprovalScreen> createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends ConsumerState<PendingApprovalScreen>
    with SingleTickerProviderStateMixin {
  Timer? _pollTimer;
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      ref.read(onboardingViewModelProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.scaffold,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Hızla Ye', style: AppTypography.brandLogo.copyWith(fontSize: 22)),
                const SizedBox(height: AppSpacing.xxl),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.primary,
                  ),
                  child: RotationTransition(
                    turns: _rotationController,
                    child: Icon(
                      Icons.hourglass_top_rounded,
                      size: 56,
                      color: context.colors.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Başvurunuz İnceleniyor',
                  style: AppTypography.headline,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Belgeleriniz ve bilgileriniz ekibimiz tarafından değerlendiriliyor. '
                  'Onaylandığında otomatik olarak yönlendirileceksiniz.',
                  style: AppTypography.bodyMuted,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                GlassPanel(
                  borderRadius: AppSpacing.radiusChip,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sync_rounded, size: 16, color: context.colors.neonCyan),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Durum her 15 saniyede bir kontrol ediliyor',
                        style: AppTypography.label.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
