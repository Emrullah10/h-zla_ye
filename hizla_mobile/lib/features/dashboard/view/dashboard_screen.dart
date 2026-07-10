import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/glass_bottom_nav.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../../core/widgets/stat_tile.dart';
import '../../orders/model/active_order.dart';
import '../../orders/viewmodel/active_order_viewmodel.dart';
import '../../orders/view/incoming_order_sheet.dart';
import '../model/courier_shift.dart';
import '../viewmodel/dashboard_viewmodel.dart';
import 'widgets/earnings_ticker.dart';
import 'widgets/map_backdrop.dart';
import 'widgets/online_slider_card.dart';

/// Stitch pilot-dashboard.html birebir uyarlaması ("Ana Komuta Merkezi").
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String? _shownIncomingOrderId;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<ActiveOrder?>>(activeOrderViewModelProvider,
        (previous, next) {
      final order = next.valueOrNull;
      if (order == null) return;
      if (order.isPending && order.id != _shownIncomingOrderId) {
        _shownIncomingOrderId = order.id;
        _showIncomingOrderSheet(order);
      }
      if (order.isAccepted) {
        context.go(RoutePaths.activeMission, extra: order.id);
      }
    });

    final shiftState = ref.watch(dashboardViewModelProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.scaffold,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const MapBackdrop(),
          SafeArea(
            child: AsyncValueView<CourierShift>(
              value: shiftState,
              data: (shift) => Column(
                children: [
                  _Header(dailyEarnings: shift.dailySummaryEarnings),
                  const Spacer(),
                  const _LocationPill(),
                  const SizedBox(height: AppSpacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: StatTile(
                                icon: Icons.bolt_rounded,
                                label: 'AKTİF SÜRE',
                                value: _formatDuration(shift.activeDuration),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            const Expanded(
                              child: StatTile(
                                icon: Icons.pedal_bike_rounded,
                                label: 'MESAFE',
                                value: '0.0 km',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        OnlineSliderCard(
                          onConfirmed: () =>
                              ref.read(dashboardViewModelProvider.notifier).toggleOnline(),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: 0,
        items: const [
          GlassNavItem(icon: Icons.speed_rounded, label: 'DASHBOARD'),
          GlassNavItem(icon: Icons.calendar_month_rounded, label: 'SLOTS'),
          GlassNavItem(icon: Icons.payments_rounded, label: 'EARNINGS'),
          GlassNavItem(icon: Icons.account_circle_rounded, label: 'PROFILE'),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              context.go(RoutePaths.slots);
            case 2:
              context.go(RoutePaths.earnings);
            case 3:
              context.go(RoutePaths.profile);
          }
        },
      ),
    );
  }

  void _showIncomingOrderSheet(ActiveOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => IncomingOrderSheet(order: order),
    ).whenComplete(() => _shownIncomingOrderId = null);
  }

  static String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.dailyEarnings});

  final double dailyEarnings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    child: Icon(Icons.person_rounded, color: AppColors.onSurfaceVariant, size: 28),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.neonCyan,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.scaffold, width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.neonCyan.withValues(alpha: 0.5), blurRadius: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Efsane Kurye', style: AppTypography.title),
                  Text('LEVEL 42 PILOT',
                      style: AppTypography.label.copyWith(color: AppColors.neonCyan)),
                ],
              ),
            ],
          ),
          EarningsTicker(amount: dailyEarnings),
        ],
      ),
    );
  }
}

class _LocationPill extends StatelessWidget {
  const _LocationPill();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: AppSpacing.radiusFull,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.my_location_rounded, color: AppColors.neonCyan, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text('Beşiktaş Merkez', style: AppTypography.mono(fontSize: 14)),
        ],
      ),
    );
  }
}
