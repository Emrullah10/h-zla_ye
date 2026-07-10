import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../viewmodel/active_order_viewmodel.dart';

/// Stitch emoji-rating.html birebir uyarlaması (Restoran Puanlama).
/// great=5, okay=3, bad=1 mapping — rate-restaurant.use-case.js sadece
/// 1-5 arası rating validasyonu yapıyor, backend'de sabit bir eşleme yok.
class EmojiRatingScreen extends ConsumerStatefulWidget {
  const EmojiRatingScreen({super.key, this.orderId});

  final String? orderId;

  @override
  ConsumerState<EmojiRatingScreen> createState() => _EmojiRatingScreenState();
}

class _EmojiRatingScreenState extends ConsumerState<EmojiRatingScreen> {
  bool _submitting = false;

  String? get _orderId =>
      widget.orderId ?? ref.read(activeOrderViewModelProvider).valueOrNull?.id;

  Future<void> _rate(int rating) async {
    final orderId = _orderId;
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      if (orderId != null) {
        await ref.read(activeOrderViewModelProvider.notifier).rate(
              orderId: orderId,
              rating: rating,
            );
      }
    } finally {
      if (mounted) context.go(RoutePaths.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(activeOrderViewModelProvider).valueOrNull;
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text('TESLİMAT TAMAMLANDI',
                      style: AppTypography.label.copyWith(color: AppColors.neonCyan)),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Restoran deneyimi nasıldı?',
                  style: AppTypography.headline,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text.rich(
                  TextSpan(
                    style: AppTypography.bodyMuted,
                    children: [
                      const TextSpan(text: 'Alım deneyiminizi puanlayın: '),
                      TextSpan(
                        text: order?.restaurantName ?? '',
                        style: AppTypography.bodyMuted.copyWith(
                            color: AppColors.gradientStart, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                _EmojiOption(
                  emoji: '😃',
                  title: 'Great',
                  subtitle: 'Hızlı ve Güler Yüzlü',
                  onTap: _submitting ? null : () => _rate(5),
                ),
                const SizedBox(height: AppSpacing.lg),
                _EmojiOption(
                  emoji: '😐',
                  title: 'Okay',
                  subtitle: 'Ortalama Deneyim',
                  onTap: _submitting ? null : () => _rate(3),
                ),
                const SizedBox(height: AppSpacing.lg),
                _EmojiOption(
                  emoji: '😡',
                  title: 'Bad',
                  subtitle: 'Yavaş ve İlgisiz',
                  titleColor: AppColors.error,
                  onTap: _submitting ? null : () => _rate(1),
                ),
                const SizedBox(height: AppSpacing.xl),
                TextButton(
                  onPressed: _submitting ? null : () => context.go(RoutePaths.dashboard),
                  child: Text(
                    'Skip for now',
                    style: AppTypography.bodyMuted
                        .copyWith(decoration: TextDecoration.underline),
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

class _EmojiOption extends StatelessWidget {
  const _EmojiOption({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleColor = AppColors.onSurface,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final Color titleColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
            border: Border.all(color: AppColors.glassBorder(opacity: 0.1)),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTypography.title.copyWith(color: titleColor)),
                  Text(subtitle, style: AppTypography.bodyMuted),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
