import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_panel.dart';
import '../model/active_order.dart';
import '../viewmodel/active_order_viewmodel.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// tasarim-spek-v3.md / mobil-tasarim-plani.md "Incoming Order / Akıllı
/// Sipariş Kartı" — alttan yükselen bottom sheet. Platform rozeti,
/// restoran adı, teslimat adresi, kazanç, mesafe + Kabul Et/Reddet.
class IncomingOrderSheet extends ConsumerStatefulWidget {
  const IncomingOrderSheet({super.key, required this.order});

  final ActiveOrder order;

  @override
  ConsumerState<IncomingOrderSheet> createState() => _IncomingOrderSheetState();
}

class _IncomingOrderSheetState extends ConsumerState<IncomingOrderSheet> {
  bool _submitting = false;

  Future<void> _respond(bool accept) async {
    setState(() => _submitting = true);
    try {
      final notifier = ref.read(activeOrderViewModelProvider.notifier);
      if (accept) {
        await notifier.accept(widget.order.id);
      } else {
        await notifier.reject(widget.order.id);
      }
    } finally {
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
      child: SafeArea(
        top: false,
        child: GlassPanel(
          borderRadius: AppSpacing.radiusCard,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PlatformBadge(platform: order.platform),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.restaurantName, style: AppTypography.headline),
                        const SizedBox(height: 4),
                        Text(
                          order.customerAddress,
                          style: AppTypography.bodyMuted,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₺${order.earnings.toStringAsFixed(2)}',
                        style: AppTypography.mono(
                            fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.brand),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${order.distanceKm.toStringAsFixed(1)} km',
                        style: AppTypography.mono(fontSize: 13, color: context.colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _submitting ? null : () => _respond(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        side: BorderSide(color: context.colors.glassBorder(opacity: 0.2)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusButton)),
                      ),
                      child: Text('Reddet',
                          style: AppTypography.title.copyWith(color: context.colors.onSurfaceVariant)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submitting ? null : () => _respond(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand,
                        foregroundColor: context.colors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusButton)),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2.4),
                            )
                          : const Text('Kabul Et'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  const _PlatformBadge({required this.platform});

  final OrderPlatform platform;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (platform) {
      OrderPlatform.yemeksepeti => (AppColors.yemeksepeti, 'Yemeksepeti'),
      OrderPlatform.getir => (AppColors.getir, 'Getir'),
      OrderPlatform.trendyol => (AppColors.trendyol, 'Trendyol'),
      OrderPlatform.unknown => (context.colors.onSurfaceVariant, 'Sipariş'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.label.copyWith(color: color),
      ),
    );
  }
}
