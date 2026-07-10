import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../../core/widgets/slide_to_confirm.dart';
import '../../../core/widgets/stat_tile.dart';
import '../../dashboard/view/widgets/map_backdrop.dart';
import '../viewmodel/active_order_viewmodel.dart';

/// Stitch aktif-gorev.html birebir uyarlaması (Active Mission).
/// Rota çizimi gerçek değil — CustomPaint ile stilize edilmiş neon rota.
class ActiveMissionScreen extends ConsumerStatefulWidget {
  const ActiveMissionScreen({super.key, this.orderId});

  final String? orderId;

  @override
  ConsumerState<ActiveMissionScreen> createState() => _ActiveMissionScreenState();
}

class _ActiveMissionScreenState extends ConsumerState<ActiveMissionScreen> {
  bool _delivering = false;

  Future<void> _onDelivered() async {
    final order = ref.read(activeOrderViewModelProvider).valueOrNull;
    final orderId = widget.orderId ?? order?.id;
    if (orderId == null || !mounted) return;
    setState(() => _delivering = true);
    if (mounted) {
      context.go(RoutePaths.qrVerify, extra: orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(activeOrderViewModelProvider);
    final order = orderState.valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const MapBackdrop(),
          CustomPaint(painter: _RoutePainter(), size: Size.infinite),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlassPanel(
                        borderRadius: AppSpacing.radiusFull,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.near_me_rounded, color: AppColors.neonCyan, size: 18),
                            const SizedBox(width: AppSpacing.xs),
                            Text('Gazi Blv.', style: AppTypography.title.copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.errorContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.emergency_rounded, color: AppColors.error, size: 18),
                            const SizedBox(width: AppSpacing.xs),
                            Text('YARDIM İSTE',
                                style: AppTypography.label.copyWith(color: AppColors.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.lg,
            child: SafeArea(
              top: false,
              child: GlassPanel(
                borderRadius: AppSpacing.radiusCard,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: AppColors.gradientEnd, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text('ACTIVE MISSION',
                            style: AppTypography.label.copyWith(color: AppColors.neonCyan)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(order?.restaurantName ?? 'Restoran', style: AppTypography.displayLarge),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        style: AppTypography.bodyMuted,
                        children: [
                          const TextSpan(text: 'Sipariş '),
                          TextSpan(
                            text: '#${order?.orderNumber ?? '----'}',
                            style: AppTypography.mono(fontSize: 14, color: AppColors.onSurface),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: StatTile(
                            icon: Icons.route_rounded,
                            label: 'MESAFE',
                            value: '${(order?.distanceKm ?? 0).toStringAsFixed(1)} km',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: StatTile(
                            icon: Icons.schedule_rounded,
                            label: 'TAHMİNİ SÜRE',
                            value: '${order?.etaMinutes ?? 0} dk',
                            valueColor: AppColors.neonCyan,
                            iconColor: AppColors.neonCyan,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SlideToConfirm(
                      label: 'Teslim Et',
                      confirmedLabel: 'Tamamlandı',
                      icon: Icons.double_arrow_rounded,
                      confirmedIcon: Icons.check_rounded,
                      trackGradient: AppGradients.primary,
                      onConfirmed: _delivering ? () {} : _onDelivered,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.8)
      ..cubicTo(
        size.width * 0.5, size.height * 0.6,
        size.width * 0.3, size.height * 0.7,
        size.width * 0.3, size.height * 0.5,
      )
      ..cubicTo(
        size.width * 0.3, size.height * 0.3,
        size.width * 0.6, size.height * 0.4,
        size.width * 0.65, size.height * 0.2,
      );

    final paint = Paint()
      ..color = AppColors.neonCyan.withValues(alpha: 0.85)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(path, paint);

    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.2),
      8,
      Paint()..color = AppColors.gradientEnd,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.8),
      6,
      Paint()
        ..color = AppColors.surface
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
