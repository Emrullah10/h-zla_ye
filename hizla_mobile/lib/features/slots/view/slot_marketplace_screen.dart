import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/glass_bottom_nav.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../../core/widgets/hizla_app_bar.dart';
import '../../../core/widgets/neon_badge.dart';
import '../model/slot.dart';
import '../viewmodel/slot_viewmodel.dart';

class SlotMarketplaceScreen extends ConsumerWidget {
  const SlotMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slotsAsync = ref.watch(slotViewModelProvider);
    final viewModel = ref.watch(slotViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const HizlaAppBar(title: 'Slot Marketplace'),
      body: SafeArea(
        child: AsyncValueView<List<Slot>>(
          value: slotsAsync,
          onRetry: () => ref.invalidate(slotViewModelProvider),
          data: (slots) => RefreshIndicator(
            color: AppColors.gradientStart,
            backgroundColor: AppColors.surfaceContainerHigh,
            onRefresh: () async => ref.invalidate(slotViewModelProvider),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vardiyalarını planla, kazancını maksimize et.',
                      style: AppTypography.bodyMuted),
                  const SizedBox(height: AppSpacing.lg),
                  _DateSelector(viewModel: viewModel),
                  const SizedBox(height: AppSpacing.lg),
                  const _HeatmapBar(),
                  const SizedBox(height: AppSpacing.lg),
                  for (final slot in slots) ...[
                    _SlotCard(slot: slot, viewModel: viewModel),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  const SizedBox(height: AppSpacing.screenBottomNavGap),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: 1,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go(RoutePaths.dashboard);
            case 1:
              break;
            case 2:
              context.go(RoutePaths.earnings);
            case 3:
              context.go(RoutePaths.profile);
          }
        },
        items: const [
          GlassNavItem(icon: Icons.speed_rounded, label: 'Dashboard'),
          GlassNavItem(icon: Icons.calendar_month_rounded, label: 'Slots'),
          GlassNavItem(icon: Icons.payments_rounded, label: 'Earnings'),
          GlassNavItem(icon: Icons.account_circle_rounded, label: 'Profile'),
        ],
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({required this.viewModel});
  final SlotViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = List.generate(7, (i) => today.add(Duration(days: i)));
    const weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const monthLabels = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final day = days[index];
          final isToday = index == 0;
          final label = isToday ? 'Today' : weekdayLabels[(day.weekday - 1) % 7];
          return GestureDetector(
            onTap: () => viewModel.selectDate(day),
            child: Container(
              width: 72,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: isToday
                    ? AppColors.surfaceContainerHigh
                    : AppColors.surfaceContainerHigh.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
                border: Border.all(
                  color: isToday
                      ? AppColors.neonCyan.withValues(alpha: 0.5)
                      : Colors.transparent,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppTypography.labelSmall.copyWith(
                      color: isToday ? AppColors.neonCyan : AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${day.day}',
                      style: AppTypography.mono(fontSize: 18, fontWeight: FontWeight.w700)),
                  Text(monthLabels[day.month - 1], style: AppTypography.labelSmall),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeatmapBar extends StatelessWidget {
  const _HeatmapBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        border: Border.all(color: AppColors.glassBorder(opacity: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.gradientStart,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.brandGlow(blur: 8, opacity: 0.5),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('Yoğun Talep Bölgesi', style: AppTypography.labelSmall),
            ],
          ),
          Text('Çarpan Aktif', style: AppTypography.mono(fontSize: 11, color: AppColors.gradientStart)),
        ],
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({required this.slot, required this.viewModel});
  final Slot slot;
  final SlotViewModel viewModel;

  bool get _isElevated => slot.demand != SlotDemand.normal && slot.ownership == SlotOwnership.available;

  @override
  Widget build(BuildContext context) {
    if (slot.ownership == SlotOwnership.mine) {
      return _buildMySlot(context);
    }
    if (_isElevated) {
      return _buildElevatedSlot(context);
    }
    return _buildRegularSlot(context);
  }

  Widget _buildMySlot(BuildContext context) {
    return Stack(
      children: [
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded, color: AppColors.neonCyan, size: 16),
                          const SizedBox(width: 6),
                          Text(slot.timeRange,
                              style: AppTypography.mono(fontSize: 16, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(slot.region, style: AppTypography.bodyMuted),
                    ],
                  ),
                  const NeonBadge(label: 'My Slot', color: AppColors.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EST. BASE', style: AppTypography.labelSmall),
                      Text('₺${slot.estimatedBase.toStringAsFixed(0)}',
                          style: AppTypography.mono(fontSize: 14)),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () => viewModel.releaseSlot(slot.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      backgroundColor: AppColors.surfaceContainerHighest,
                      side: BorderSide(color: AppColors.glassBorder()),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                      ),
                    ),
                    child: const Text('Slot Bırak'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(width: 4, color: AppColors.neonCyan),
        ),
      ],
    );
  }

  Widget _buildElevatedSlot(BuildContext context) {
    final isPeak = slot.demand == SlotDemand.peak;
    final accent = isPeak ? AppColors.neonCyan : AppColors.gradientStart;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        boxShadow: [
          BoxShadow(color: accent.withValues(alpha: 0.35), blurRadius: 16, spreadRadius: 1),
        ],
      ),
      child: GlassPanel(
        fillOpacity: 0.4,
        borderOpacity: 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded, color: AppColors.onSurfaceVariant, size: 16),
                        const SizedBox(width: 6),
                        Text(slot.timeRange,
                            style: AppTypography.mono(fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(slot.region, style: AppTypography.bodyMuted),
                  ],
                ),
                NeonBadge(
                  label: 'x${slot.multiplier?.toStringAsFixed(1) ?? '1.0'}',
                  icon: isPeak ? Icons.bolt_rounded : Icons.local_fire_department_rounded,
                  color: accent,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('EST. DEMAND', style: AppTypography.labelSmall),
                    Text(
                      isPeak ? 'Peak' : 'High',
                      style: AppTypography.mono(fontSize: 14, fontWeight: FontWeight.w700, color: accent),
                    ),
                  ],
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                    boxShadow: AppShadows.brandGlow(blur: 12, opacity: 0.3),
                  ),
                  child: TextButton(
                    onPressed: () => viewModel.claimSlot(slot.id),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                    ),
                    child: Text('Slot Al', style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegularSlot(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, color: AppColors.onSurfaceVariant, size: 16),
                      const SizedBox(width: 6),
                      Text(slot.timeRange,
                          style: AppTypography.mono(fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(slot.region, style: AppTypography.bodyMuted),
                ],
              ),
              Text('Available', style: AppTypography.labelSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EST. DEMAND', style: AppTypography.labelSmall),
                  Text('Normal', style: AppTypography.mono(fontSize: 14)),
                ],
              ),
              OutlinedButton(
                onPressed: () => viewModel.claimSlot(slot.id),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.gradientStart,
                  backgroundColor: AppColors.surfaceContainerHigh,
                  side: BorderSide(color: AppColors.gradientStart.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                  ),
                ),
                child: const Text('Slot Al'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
