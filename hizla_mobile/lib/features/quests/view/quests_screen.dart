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
import '../model/quest.dart';
import '../viewmodel/quests_viewmodel.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

class _Perk {
  const _Perk({
    required this.icon,
    required this.title,
    required this.description,
    required this.badge,
    required this.badgeColor,
  });

  final IconData icon;
  final String title;
  final String description;
  final String badge;
  final Color badgeColor;
}

const _perks = [
  _Perk(
    icon: Icons.local_gas_station_rounded,
    title: 'Opet Akaryakıt',
    description: 'Tüm yakıt alımlarında anında indirim.',
    badge: '-15%',
    badgeColor: AppColors.brand,
  ),
  _Perk(
    icon: Icons.battery_charging_full_rounded,
    title: 'Teknosa Ekipman',
    description: 'Powerbank ve taşıyıcı aksesuarlar.',
    badge: '1 Al 1 Bedava',
    badgeColor: AppColors.neonCyan,
  ),
  _Perk(
    icon: Icons.lunch_dining_rounded,
    title: 'Burger King',
    description: 'Mola menülerinde kuryelere özel.',
    badge: '-30%',
    badgeColor: AppColors.brand,
  ),
  _Perk(
    icon: Icons.sports_motorsports_rounded,
    title: 'MotoPlus Kasklar',
    description: 'Güvenlik ekipmanlarında fırsat.',
    badge: '₺500 İndirim',
    badgeColor: AppColors.brand,
  ),
];

class QuestsScreen extends ConsumerWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questsAsync = ref.watch(questsViewModelProvider);
    final viewModel = ref.watch(questsViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: context.colors.scaffold,
      body: SafeArea(
        child: AsyncValueView<List<Quest>>(
          value: questsAsync,
          onRetry: viewModel.refresh,
          data: (quests) => RefreshIndicator(
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
                  Text('Avantajlar Dünyası',
                      style: AppTypography.headline.copyWith(fontSize: 26, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Görevleri tamamla, efsane avantajları yakala.', style: AppTypography.bodyMuted),
                  const SizedBox(height: AppSpacing.xl),
                  const _RankCard(),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Günlük Görevler', style: AppTypography.title),
                  const SizedBox(height: AppSpacing.md),
                  for (final quest in quests) ...[
                    _QuestCard(quest: quest),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  Text('Size Özel Fırsatlar', style: AppTypography.title),
                  const SizedBox(height: AppSpacing.md),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.85,
                    children: [for (final perk in _perks) _PerkCard(perk: perk)],
                  ),
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
              context.go(RoutePaths.earnings);
            case 2:
              break;
            case 3:
              context.go(RoutePaths.profile);
          }
        },
        items: const [
          GlassNavItem(icon: Icons.directions_run_rounded, label: 'Drive'),
          GlassNavItem(icon: Icons.payments_rounded, label: 'Earnings'),
          GlassNavItem(icon: Icons.military_tech_rounded, label: 'Quests'),
          GlassNavItem(icon: Icons.person_rounded, label: 'Profile'),
        ],
      ),
    );
  }
}

class _RankCard extends StatelessWidget {
  const _RankCard();

  @override
  Widget build(BuildContext context) {
    const currentPoints = 1750;
    const targetPoints = 2000;
    final progress = currentPoints / targetPoints;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.colors.surfaceContainerHigh, context.colors.surfaceContainer],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: context.colors.glassBorder()),
        boxShadow: AppShadows.deep,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gradientStart.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.workspace_premium_rounded,
                              size: 14, color: AppColors.gradientStart),
                          const SizedBox(width: 4),
                          Text('Güncel Seviye',
                              style: AppTypography.label.copyWith(color: AppColors.gradientStart, fontSize: 11)),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Efsane Kurye',
                        style: AppTypography.headline.copyWith(fontSize: 28, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: AppTypography.bodyMuted,
                        children: [
                          const TextSpan(text: 'Bir sonraki seviye için '),
                          TextSpan(
                            text: '250',
                            style: AppTypography.mono(fontSize: 13, color: AppColors.gradientStart),
                          ),
                          const TextSpan(text: ' puan gerekli'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.brandGlow(),
                ),
                child: const Icon(Icons.military_tech_rounded, color: Colors.white, size: 32),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Puan İlerlemesi', style: AppTypography.label.copyWith(color: context.colors.onSurface)),
              Text('$currentPoints / $targetPoints',
                  style: AppTypography.mono(fontSize: 13, color: AppColors.gradientStart)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: context.colors.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation(AppColors.gradientStart),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestCard extends StatelessWidget {
  const _QuestCard({required this.quest});
  final Quest quest;

  Color _rarityColor(BuildContext context) {
    switch (quest.rarity) {
      case 'rare':
        return context.colors.neonCyan;
      case 'epic':
        return AppColors.brand;
      default:
        return context.colors.onSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: AppSpacing.radiusChip,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _rarityColor(context).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.two_wheeler_rounded, color: _rarityColor(context), size: 20),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(quest.title,
                              style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
                          Text(quest.description, style: AppTypography.labelSmall, maxLines: 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text('${quest.progress}/${quest.targetCount}',
                  style: AppTypography.mono(fontSize: 18, fontWeight: FontWeight.w700, color: _rarityColor(context))),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: LinearProgressIndicator(
              value: quest.progressRatio,
              minHeight: 6,
              backgroundColor: context.colors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(_rarityColor(context)),
            ),
          ),
          if (quest.isCompleted) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.gradientStart,
                  foregroundColor: context.colors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                ),
                child: const Text('Ödülü Al'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PerkCard extends StatelessWidget {
  const _PerkCard({required this.perk});
  final _Perk perk;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        border: Border.all(color: context.colors.glassBorder(opacity: 0.15)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            width: double.infinity,
            color: context.colors.surfaceContainerHigh,
            child: Stack(
              children: [
                Center(
                  child: Icon(perk.icon, size: 32, color: context.colors.onSurfaceVariant),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: perk.badgeColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      perk.badge,
                      style: AppTypography.mono(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  perk.title,
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  perk.description,
                  style: AppTypography.labelSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gradientStart,
                      backgroundColor: context.colors.surfaceContainerHigh,
                      side: BorderSide(color: context.colors.glassBorder()),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                      ),
                    ),
                    child: const Text('Kodu Al', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
