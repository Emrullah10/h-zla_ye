import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_panel.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import 'widgets/onboarding_scaffold.dart';

/// Onboarding Adım 3 — Kişisel Bilgiler (backend karşılığı yok, lokal form).
class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _tcknController = TextEditingController();
  final _addressController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _tcknController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    try {
      await ref.read(onboardingViewModelProvider.notifier).markPersonalInfoDone();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      title: 'Kişisel Bilgiler',
      stepIndex: 3,
      totalSteps: 4,
      bottomAction: OnboardingContinueButton(
        label: 'Continue',
        isLoading: _submitting,
        onPressed: _submitting ? null : _continue,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OnboardingSectionLabel('Personal Info'),
            Text(
              'Kurye profilinizi tamamlamak için lütfen bilgilerinizi girin.',
              style: AppTypography.bodyMuted,
            ),
            const SizedBox(height: AppSpacing.lg),
            _FieldLabel('Ad Soyad'),
            _GlassTextField(
              controller: _fullNameController,
              hintText: 'Adınız ve soyadınız',
              keyboardType: TextInputType.name,
              validator: (v) =>
                  (v == null || v.trim().length < 3) ? 'Geçerli bir ad soyad girin' : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            _FieldLabel('T.C. Kimlik No'),
            _GlassTextField(
              controller: _tcknController,
              hintText: '11 haneli TC kimlik numaranız',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              validator: (v) =>
                  (v == null || v.trim().length != 11) ? '11 haneli TC kimlik no girin' : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            _FieldLabel('Adres'),
            _GlassTextField(
              controller: _addressController,
              hintText: 'İkamet adresiniz',
              keyboardType: TextInputType.streetAddress,
              maxLines: 3,
              validator: (v) =>
                  (v == null || v.trim().length < 10) ? 'Geçerli bir adres girin' : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: AppTypography.label),
    );
  }
}

class _GlassTextField extends StatelessWidget {
  const _GlassTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: AppSpacing.radiusChip,
      padding: EdgeInsets.zero,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        maxLines: maxLines,
        style: AppTypography.body,
        cursorColor: AppColors.gradientStart,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTypography.bodyMuted,
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }
}
