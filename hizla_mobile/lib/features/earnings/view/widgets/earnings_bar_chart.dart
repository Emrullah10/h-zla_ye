import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_typography.dart';
import '../../model/earnings.dart';

/// Stitch "Daily Performance" jumping bar chart — fl_chart BarChart ile.
/// En yüksek değere sahip bar gradyan renkli + tooltip, diğerleri surfaceVariant.
class EarningsBarChart extends StatelessWidget {
  const EarningsBarChart({super.key, required this.earnings});

  final Earnings earnings;

  @override
  Widget build(BuildContext context) {
    final bars = earnings.bars;
    if (bars.isEmpty) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Text('Veri yok', style: AppTypography.bodyMuted),
        ),
      );
    }

    final maxAmount = earnings.maxBarAmount <= 0 ? 1.0 : earnings.maxBarAmount;
    var highlightIndex = 0;
    for (var i = 0; i < bars.length; i++) {
      if (bars[i].amount > bars[highlightIndex].amount) highlightIndex = i;
    }

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: maxAmount * 1.2,
          alignment: BarChartAlignment.spaceAround,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= bars.length) return const SizedBox.shrink();
                  final isHighlight = index == highlightIndex;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      bars[index].label,
                      style: AppTypography.labelSmall.copyWith(
                        color: isHighlight
                            ? AppColors.gradientStart
                            : AppColors.onSecondaryFixedVariant,
                        fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w700,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => AppColors.gradientStart,
              getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
                '₺${bars[groupIndex].amount.toStringAsFixed(0)}',
                AppTypography.mono(fontSize: 11, color: AppColors.onPrimary),
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < bars.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: bars[i].amount,
                    width: 18,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                    gradient: i == highlightIndex ? AppGradients.primary : null,
                    color: i == highlightIndex ? null : AppColors.surfaceContainerHighest,
                  ),
                ],
              ),
          ],
        ),
        duration: const Duration(milliseconds: 600),
      ),
    );
  }
}
