import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import 'widgets/onboarding_scaffold.dart';

/// Stitch onboarding-arac.html birebir uyarlaması (Onboarding Adım 1).
class VehicleSelectScreen extends ConsumerStatefulWidget {
  const VehicleSelectScreen({super.key});

  @override
  ConsumerState<VehicleSelectScreen> createState() => _VehicleSelectScreenState();
}

class _VehicleSelectScreenState extends ConsumerState<VehicleSelectScreen> {
  String _selected = 'motorcycle';
  bool _submitting = false;

  static const _vehicles = [
    (
      value: 'motorcycle',
      icon: Icons.two_wheeler_rounded,
      title: 'Motorcycle',
      subtitle: 'Fastest city delivery',
    ),
    (
      value: 'bicycle',
      icon: Icons.pedal_bike_rounded,
      title: 'Bicycle',
      subtitle: 'Eco-friendly short distance',
    ),
    (
      value: 'car',
      icon: Icons.directions_car_rounded,
      title: 'Car',
      subtitle: 'Large orders & bad weather',
    ),
  ];

  Future<void> _continue() async {
    setState(() => _submitting = true);
    try {
      await ref.read(onboardingViewModelProvider.notifier).selectVehicle(_selected);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      title: 'Onboarding',
      stepIndex: 1,
      totalSteps: 4,
      bottomAction: OnboardingContinueButton(
        label: 'Continue',
        isLoading: _submitting,
        onPressed: _submitting ? null : _continue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingSectionLabel('Vehicle Selection'),
          for (final v in _vehicles)
            SelectableOptionCard(
              icon: v.icon,
              title: v.title,
              subtitle: v.subtitle,
              isSelected: _selected == v.value,
              onTap: () => setState(() => _selected = v.value),
            ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Araç tipini seçtikten sonra gerekli belgeleri yükleyeceksiniz.',
            style: AppTypography.bodyMuted,
          ),
        ],
      ),
    );
  }
}
