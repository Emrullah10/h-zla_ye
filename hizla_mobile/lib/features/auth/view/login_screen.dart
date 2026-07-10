import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../../core/widgets/gradient_button.dart';
import '../viewmodel/login_viewmodel.dart';

/// Stitch login.html ("Pilot Entrance") birebir uyarlaması.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _errorText = null);
    final success = await ref.read(loginViewModelProvider.notifier).submit(
          phone: _phoneController.text.trim(),
          password: _pinController.text,
        );
    if (!success && mounted) {
      final error = ref.read(loginViewModelProvider).error;
      setState(() => _errorText = error?.toString() ?? 'Giriş başarısız');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);
    final isLoading = loginState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.1,
            colors: [
              AppColors.brand.withValues(alpha: 0.15),
              AppColors.scaffold.withValues(alpha: 0),
            ],
            stops: const [0, 0.6],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.xxl,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Marka
                    Text(
                      'Hızla Ye',
                      style: AppTypography.brandLogo.copyWith(fontSize: 48),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PILOT ENTRANCE',
                      style: AppTypography.label.copyWith(
                        color: AppColors.secondary,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Glass form kartı
                    GlassPanel(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        children: [
                          _LabeledField(
                            label: 'Telemetry ID (Phone)',
                            controller: _phoneController,
                            icon: Icons.phone_iphone_rounded,
                            keyboardType: TextInputType.phone,
                            monoFontSize: 17,
                            hint: '+90 5XX XXX XX XX',
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _LabeledField(
                            label: 'Access Code',
                            controller: _pinController,
                            icon: Icons.lock_rounded,
                            obscureText: true,
                            monoFontSize: 24,
                            letterSpacing: 10,
                            hint: '••••',
                            trailingLabel: 'Forgot?',
                          ),
                          if (_errorText != null) ...[
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              _errorText!,
                              style: AppTypography.bodyMuted
                                  .copyWith(color: AppColors.error),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          const SizedBox(height: AppSpacing.xl),
                          GradientButton(
                            label: 'Giriş Yap',
                            icon: Icons.arrow_forward_rounded,
                            isLoading: isLoading,
                            onPressed: isLoading ? null : _submit,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // İkincil aksiyonlar
                    _SecondaryButton(
                      icon: Icons.two_wheeler_rounded,
                      label: 'Sürücü Ol',
                      onTap: () {},
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _SecondaryButton(
                      icon: Icons.help_outline_rounded,
                      label: 'Yardım',
                      transparent: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.monoFontSize = 16,
    this.letterSpacing,
    this.hint,
    this.trailingLabel,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final double monoFontSize;
  final double? letterSpacing;
  final String? hint;
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.label),
            if (trailingLabel != null)
              Text(
                trailingLabel!.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(color: AppColors.neonCyan),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
          ),
          child: Row(
            children: [
              const SizedBox(width: AppSpacing.lg),
              Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  style: AppTypography.mono(
                    fontSize: monoFontSize,
                    color: AppColors.onSurface,
                  ).copyWith(letterSpacing: letterSpacing),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: AppTypography.mono(
                      fontSize: monoFontSize,
                      color: AppColors.surfaceContainerHighest,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.transparent = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool transparent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: transparent ? Colors.transparent : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: transparent
                ? null
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.15),
                    ),
                  ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 18,
                    color: transparent ? AppColors.secondary : AppColors.onSurface),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label,
                  style: AppTypography.title.copyWith(
                    fontSize: 14,
                    color: transparent ? AppColors.secondary : AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
