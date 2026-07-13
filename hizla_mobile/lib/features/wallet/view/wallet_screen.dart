import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
import '../model/wallet.dart';
import '../viewmodel/wallet_viewmodel.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletViewModelProvider);
    final viewModel = ref.watch(walletViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: context.colors.scaffold,
      appBar: const HizlaAppBar(title: 'Cüzdan'),
      body: SafeArea(
        child: AsyncValueView<Wallet>(
          value: walletAsync,
          onRetry: viewModel.refresh,
          data: (wallet) => RefreshIndicator(
            color: AppColors.gradientStart,
            backgroundColor: context.colors.surfaceContainerHigh,
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
                  _ReceiptCard(wallet: wallet),
                  const SizedBox(height: AppSpacing.lg),
                  const _PayoutCountdown(),
                  const SizedBox(height: AppSpacing.lg),
                  _TransactionsGrid(wallet: wallet),
                  const SizedBox(height: AppSpacing.screenBottomNavGap),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: 0,
        onTap: (i) {
          switch (i) {
            case 0:
              break;
            case 1:
              context.go(RoutePaths.dashboard);
            case 2:
              context.go(RoutePaths.slots);
            case 3:
              context.go(RoutePaths.support);
          }
        },
        items: const [
          GlassNavItem(icon: Icons.account_balance_wallet_rounded, label: 'Wallet'),
          GlassNavItem(icon: Icons.home_rounded, label: 'Home'),
          GlassNavItem(icon: Icons.qr_code_2_rounded, label: 'Scan'),
          GlassNavItem(icon: Icons.forum_rounded, label: 'Chat'),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.wallet});
  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    // Net Pay makbuzu: backend yalnızca balance/pending döndürür — sistem
    // kesintisi/vergi kalemleri gösterim amaçlı sabit oranlarla türetilir.
    final totalEarnings = wallet.balance + wallet.pending;
    final systemFee = totalEarnings * 0.05;
    final tax = totalEarnings * 0.04375;
    final netPay = wallet.balance;
    final now = DateTime.now();
    final periodStart = now.subtract(const Duration(days: 6));
    final dateFmt = DateFormat('MMM d', 'en_US');

    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CURRENT BALANCE',
                      style: AppTypography.label.copyWith(color: context.colors.neonCyan)),
                  const SizedBox(height: 4),
                  ShaderMask(
                    shaderCallback: (bounds) => AppGradients.primary.createShader(bounds),
                    child: Text(
                      '₺${netPay.toStringAsFixed(2)}',
                      style: AppTypography.mono(fontSize: 34, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Period', style: AppTypography.label.copyWith(fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(
                    '${dateFmt.format(periodStart)} - ${dateFmt.format(now)}',
                    style: AppTypography.mono(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Divider(color: context.colors.outlineVariant.withValues(alpha: 0.3)),
          const SizedBox(height: AppSpacing.md),
          _BreakdownRow(label: 'Total Earnings', value: totalEarnings, isDeduction: false),
          _BreakdownRow(label: 'System Fee (5%)', value: -systemFee, isDeduction: true),
          _BreakdownRow(label: 'Tax Deduction', value: -tax, isDeduction: true),
          const SizedBox(height: AppSpacing.sm),
          Divider(color: context.colors.outlineVariant.withValues(alpha: 0.3)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Net Pay', style: AppTypography.title.copyWith(fontWeight: FontWeight.w700)),
              Text(
                '₺${netPay.toStringAsFixed(2)}',
                style: AppTypography.mono(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: context.colors.neonCyan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.label, required this.value, required this.isDeduction});
  final String label;
  final double value;
  final bool isDeduction;

  @override
  Widget build(BuildContext context) {
    final sign = value < 0 ? '-' : '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMuted),
          Text(
            '$sign₺${value.abs().toStringAsFixed(2)}',
            style: AppTypography.mono(
              fontSize: 16,
              color: isDeduction ? context.colors.error : context.colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayoutCountdown extends StatefulWidget {
  const _PayoutCountdown();

  @override
  State<_PayoutCountdown> createState() => _PayoutCountdownState();
}

class _PayoutCountdownState extends State<_PayoutCountdown> {
  late Timer _timer;
  Duration _remaining = const Duration(hours: 24, minutes: 15);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining -= const Duration(seconds: 1);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: context.colors.glassBorder()),
        boxShadow: AppShadows.cyanGlow(blur: 15, opacity: 0.15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: context.colors.neonCyan.withValues(alpha: 0.1),
                child: Icon(Icons.schedule_rounded, color: context.colors.neonCyan),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NEXT PAYOUT IN', style: AppTypography.label.copyWith(fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(_fmt(_remaining),
                      style: AppTypography.mono(fontSize: 24, fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionsGrid extends StatelessWidget {
  const _TransactionsGrid({required this.wallet});
  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final lastTx = wallet.transactions.isNotEmpty ? wallet.transactions.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Son İşlemler', style: AppTypography.label),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: GlassPanel(
                borderRadius: AppSpacing.radiusChip,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last Transfer', style: AppTypography.label.copyWith(fontSize: 10)),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lastTx?.description ?? 'İşlem yok',
                                style: AppTypography.body.copyWith(fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text('Garanti BBVA', style: AppTypography.labelSmall),
                            ],
                          ),
                        ),
                        Text(
                          '₺${(lastTx?.amount ?? 0).abs().toStringAsFixed(2)}',
                          style: AppTypography.mono(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: GlassPanel(
                borderRadius: AppSpacing.radiusChip,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_balance_rounded,
                        size: 32, color: context.colors.onSurfaceVariant),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Banka Hesaplarını Yönet',
                      textAlign: TextAlign.center,
                      style: AppTypography.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (wallet.transactions.length > 1) ...[
          const SizedBox(height: AppSpacing.md),
          GlassPanel(
            borderRadius: AppSpacing.radiusChip,
            child: Column(
              children: [
                for (final tx in wallet.transactions.skip(1).take(5))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            tx.description,
                            style: AppTypography.body,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${tx.amount >= 0 ? '+' : ''}₺${tx.amount.toStringAsFixed(2)}',
                          style: AppTypography.mono(
                            fontSize: 13,
                            color: tx.amount >= 0 ? AppColors.gradientStart : context.colors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
