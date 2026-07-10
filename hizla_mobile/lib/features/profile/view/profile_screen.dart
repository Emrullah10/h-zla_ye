import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../../core/widgets/hizla_app_bar.dart';
import '../viewmodel/profile_viewmodel.dart';

/// Profil ekranı — quests.html'deki rank kartı stilinden esinlenir.
/// Backend'de ayrı bir profile endpoint'i yok — DriverProfile AuthActive
/// state'inden okunur.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(profileDriverProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const HizlaAppBar(title: 'Profil'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _ProfileHeaderCard(name: driver?.name, phone: driver?.phone),
          const SizedBox(height: AppSpacing.lg),
          _VehicleCard(vehicleType: driver?.vehicleType),
          const SizedBox(height: AppSpacing.lg),
          const _StatsRow(),
          const SizedBox(height: AppSpacing.xl),
          Text('Ayarlar', style: AppTypography.label),
          const SizedBox(height: AppSpacing.sm),
          const _SettingsList(),
          const SizedBox(height: AppSpacing.xl),
          const _LogoutButton(),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.name, required this.phone});

  final String? name;
  final String? phone;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              gradient: AppGradients.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded, color: AppColors.onPrimary, size: 32),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (name == null || name!.isEmpty) ? 'Kurye' : name!,
                  style: AppTypography.headline.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 2),
                Text(
                  (phone == null || phone!.isEmpty) ? '—' : phone!,
                  style: AppTypography.mono(fontSize: 13, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _vehicleLabels = {
  'bicycle': 'Bisiklet',
  'motorcycle': 'Motosiklet',
  'car': 'Araba',
};

const _vehicleIcons = {
  'bicycle': Icons.pedal_bike_rounded,
  'motorcycle': Icons.two_wheeler_rounded,
  'car': Icons.directions_car_filled_rounded,
};

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.vehicleType});

  final String? vehicleType;

  @override
  Widget build(BuildContext context) {
    final label = _vehicleLabels[vehicleType] ?? 'Belirtilmemiş';
    final icon = _vehicleIcons[vehicleType] ?? Icons.two_wheeler_rounded;

    return GlassPanel(
      borderRadius: AppSpacing.radiusChip,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: AppColors.neonCyan, size: 22),
          const SizedBox(width: AppSpacing.md),
          Text('Araç Tipi', style: AppTypography.label),
          const Spacer(),
          Text(label, style: AppTypography.title.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _StatItem(icon: Icons.star_rounded, label: 'Puan', value: '4.9', color: AppColors.gradientStart)),
        SizedBox(width: AppSpacing.sm),
        Expanded(child: _StatItem(icon: Icons.local_shipping_rounded, label: 'Teslimat', value: '312', color: AppColors.neonCyan)),
        SizedBox(width: AppSpacing.sm),
        Expanded(child: _StatItem(icon: Icons.military_tech_rounded, label: 'Seviye', value: 'Efsane', color: AppColors.gradientStart)),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: AppSpacing.radiusChip,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.md),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: AppTypography.mono(fontSize: 15, color: AppColors.onSurface)),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.labelSmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  const _SettingsList();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: EdgeInsets.zero,
      child: Column(
        children: const [
          _SettingsTile(icon: Icons.notifications_none_rounded, label: 'Bildirimler'),
          Divider(height: 1, color: AppColors.outlineVariant, indent: 56),
          _SettingsTile(icon: Icons.language_rounded, label: 'Dil'),
          Divider(height: 1, color: AppColors.outlineVariant, indent: 56),
          _SettingsTile(icon: Icons.help_outline_rounded, label: 'Yardım'),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.onSurfaceVariant),
      title: Text(label, style: AppTypography.body),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
    );
  }
}

class _LogoutButton extends ConsumerWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => ref.read(profileLogoutProvider)(),
        icon: const Icon(Icons.logout_rounded, color: AppColors.error),
        label: Text('Çıkış Yap',
            style: AppTypography.title.copyWith(color: AppColors.error, fontSize: 15)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          side: BorderSide(color: AppColors.error.withValues(alpha: 0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
          ),
        ),
      ),
    );
  }
}
