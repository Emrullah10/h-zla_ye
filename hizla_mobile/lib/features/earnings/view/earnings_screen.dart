import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/glass_bottom_nav.dart';
import '../../../core/widgets/glass_panel.dart';
import '../model/earnings.dart';
import '../viewmodel/earnings_viewmodel.dart';
import 'widgets/earnings_bar_chart.dart';

class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earningsAsync = ref.watch(earningsViewModelProvider);
    final viewModel = ref.watch(earningsViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: AsyncValueView<Earnings>(
          value: earningsAsync,
          onRetry: viewModel.refresh,
          data: (earnings) => RefreshIndicator(
            color: AppColors.gradientStart,
            backgroundColor: AppColors.surfaceContainerHigh,
            onRefresh: viewModel.refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(),
                  const SizedBox(height: AppSpacing.xl),
                  _BalanceHeader(earnings: earnings),
                  const SizedBox(height: AppSpacing.xl),
                  _PeriodSelector(viewModel: viewModel),
                  const SizedBox(height: AppSpacing.lg),
                  _WidgetsRow(earnings: earnings),
                  const SizedBox(height: AppSpacing.lg),
                  _PerformanceMetrics(earnings: earnings),
                  const SizedBox(height: AppSpacing.lg),
                  _DailyPerformanceCard(earnings: earnings),
                  const SizedBox(height: AppSpacing.screenBottomNavGap),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: 2,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go(RoutePaths.dashboard);
            case 1:
              context.go(RoutePaths.slots);
            case 2:
              break;
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

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.surfaceContainerHigh,
          child: const Icon(Icons.person_rounded, color: AppColors.onSurfaceVariant),
        ),
        Text('Hızla Ye', style: AppTypography.brandLogo.copyWith(fontSize: 20)),
        const Icon(Icons.qr_code_scanner_rounded, color: AppColors.gradientStart),
      ],
    );
  }
}

class _BalanceHeader extends StatelessWidget {
  const _BalanceHeader({required this.earnings});
  final Earnings earnings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'MEVCUT BAKİYE',
          style: AppTypography.label,
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 2),
              child: Text('₺', style: AppTypography.mono(fontSize: 20, color: AppColors.onSurface)),
            ),
            ShaderMask(
              shaderCallback: (bounds) => AppGradients.primary.createShader(bounds),
              child: Text(
                earnings.total.toStringAsFixed(2),
                style: AppTypography.monoDisplay(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(color: AppColors.glassBorder()),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.trending_up_rounded, color: AppColors.neonCyan, size: 14),
              const SizedBox(width: 4),
              Text(
                '+12.4% geçen haftaya göre',
                style: AppTypography.mono(fontSize: 11, color: AppColors.neonCyan),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.viewModel});
  final EarningsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final period in EarningsPeriod.values) ...[
          _PeriodChip(
            period: period,
            selected: viewModel.period == period,
            onTap: () => viewModel.setPeriod(period),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({required this.period, required this.selected, required this.onTap});
  final EarningsPeriod period;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          gradient: selected ? AppGradients.primary : null,
          color: selected ? null : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          period.label,
          style: AppTypography.body.copyWith(
            color: selected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _WidgetsRow extends StatelessWidget {
  const _WidgetsRow({required this.earnings});
  final Earnings earnings;

  @override
  Widget build(BuildContext context) {
    final today = earnings.bars.isNotEmpty ? earnings.bars.last.amount : 0.0;
    final weeklyGoal = 6500.0;
    final progress = (earnings.total / weeklyGoal).clamp(0.0, 1.0);

    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _StatWidgetCard(
            icon: Icons.account_balance_wallet_rounded,
            iconColor: AppColors.gradientStart,
            label: 'Bugünkü Kazanç',
            value: '₺${today.toStringAsFixed(0)}',
          ),
          const SizedBox(width: AppSpacing.md),
          _StatWidgetCard(
            icon: Icons.volunteer_activism_rounded,
            iconColor: AppColors.neonCyan,
            label: 'Bahşişler',
            value: '₺${earnings.avgOrderFee.toStringAsFixed(0)}',
          ),
          const SizedBox(width: AppSpacing.md),
          _WeeklyGoalCard(progress: progress, total: earnings.total, goal: weeklyGoal),
        ],
      ),
    );
  }
}

class _StatWidgetCard extends StatelessWidget {
  const _StatWidgetCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176,
      child: GlassPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(label, style: AppTypography.label.copyWith(fontSize: 11)),
            const SizedBox(height: 4),
            Text(value, style: AppTypography.mono(fontSize: 24, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _WeeklyGoalCard extends StatelessWidget {
  const _WeeklyGoalCard({required this.progress, required this.total, required this.goal});
  final double progress;
  final double total;
  final double goal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 208,
      child: GlassPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
                  ),
                  child: const Icon(Icons.flag_rounded, color: AppColors.onSurface, size: 20),
                ),
                Text('${(progress * 100).toStringAsFixed(0)}%',
                    style: AppTypography.mono(fontSize: 11, color: AppColors.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('Haftalık Hedef', style: AppTypography.label.copyWith(fontSize: 11)),
            const SizedBox(height: 4),
            Text(
              '₺${(total / 1000).toStringAsFixed(1)}k / ₺${(goal / 1000).toStringAsFixed(1)}k',
              style: AppTypography.mono(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.scaffold,
                valueColor: const AlwaysStoppedAnimation(AppColors.gradientStart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerformanceMetrics extends StatelessWidget {
  const _PerformanceMetrics({required this.earnings});
  final Earnings earnings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.star_rounded,
            iconColor: AppColors.gradientStart,
            value: '4.98',
            label: 'RATING',
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _MetricCard(
            icon: Icons.task_alt_rounded,
            iconColor: AppColors.neonCyan,
            value: '98%',
            label: 'ACCEPTANCE',
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.scaffold,
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: AppTypography.mono(fontSize: 20, fontWeight: FontWeight.w700)),
              Text(label, style: AppTypography.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyPerformanceCard extends StatelessWidget {
  const _DailyPerformanceCard({required this.earnings});
  final Earnings earnings;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daily Performance', style: AppTypography.title),
              const Icon(Icons.more_horiz_rounded, color: AppColors.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          EarningsBarChart(earnings: earnings),
        ],
      ),
    );
  }
}
