import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_panel.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import 'widgets/onboarding_scaffold.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// Stitch onboarding-belge.html birebir uyarlaması (Onboarding Adım 2).
class DocumentUploadScreen extends ConsumerStatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  ConsumerState<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends ConsumerState<DocumentUploadScreen> {
  String? _uploadingDocType;

  static const _documents = [
    (
      docType: 'license',
      icon: Icons.badge_rounded,
      title: 'Sürücü Belgesi',
      subtitle: 'Ehliyetinizin ön ve arka yüzü.',
    ),
    (
      docType: 'id_card',
      icon: Icons.badge_rounded,
      title: 'Kimlik Kartı',
      subtitle: 'Ön ve arka yüzünün net bir fotoğrafı.',
    ),
    (
      docType: 'criminal_record',
      icon: Icons.gavel_rounded,
      title: 'Adli Sicil Kaydı',
      subtitle: 'Son 6 ay içinde alınmış e-Devlet belgesi.',
    ),
  ];

  Future<void> _pickAndUpload(String docType) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    setState(() => _uploadingDocType = docType);
    try {
      await ref
          .read(onboardingViewModelProvider.notifier)
          .uploadDocument(docType: docType, filePath: picked.path);
    } finally {
      if (mounted) setState(() => _uploadingDocType = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(onboardingViewModelProvider).valueOrNull;
    final uploaded = data?.status.documents ?? const <String>[];
    final allUploaded = _documents.every((d) => uploaded.contains(d.docType));

    return OnboardingScaffold(
      title: 'Belgeleri Yükle',
      stepIndex: 2,
      totalSteps: 4,
      bottomAction: Row(
        children: [
          TextButton(
            onPressed: () {},
            child: Text('Daha Sonra', style: AppTypography.bodyMuted),
          ),
          const Spacer(),
          OnboardingContinueButton(
            label: 'Devam Et',
            onPressed: allUploaded ? () {} : null,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lütfen hesabınızı doğrulamak için aşağıdaki belgelerin net fotoğraflarını yükleyin.',
            style: AppTypography.bodyMuted,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final doc in _documents) ...[
            _DocumentCard(
              icon: doc.icon,
              title: doc.title,
              subtitle: doc.subtitle,
              isUploaded: uploaded.contains(doc.docType),
              isUploading: _uploadingDocType == doc.docType,
              onUpload: () => _pickAndUpload(doc.docType),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isUploaded,
    required this.isUploading,
    required this.onUpload,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isUploaded;
  final bool isUploading;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: AppSpacing.radiusChip,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.scaffold,
            ),
            child: Icon(
              isUploaded ? Icons.check_circle_rounded : icon,
              size: 24,
              color: isUploaded ? context.colors.neonCyan : AppColors.gradientStart,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.title.copyWith(fontSize: 16)),
                const SizedBox(height: 2),
                Text(
                  isUploaded ? 'Yüklendi ve onay bekliyor.' : subtitle,
                  style: AppTypography.label.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (!isUploaded)
            SizedBox(
              height: 40,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                    onTap: isUploading ? null : onUpload,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Center(
                        child: isUploading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: context.colors.onPrimary,
                                ),
                              )
                            : Text(
                                'Yükle',
                                style: AppTypography.label.copyWith(
                                  color: context.colors.onPrimary,
                                  fontSize: 12,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
