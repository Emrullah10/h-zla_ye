import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/gradient_button.dart';
import '../viewmodel/active_order_viewmodel.dart';

/// Stitch qr-verify.html birebir uyarlaması (QR Doğrulama).
/// mobile_scanner ile gerçek kamera taraması; okunan kod verifyOrder'a
/// gönderilir, başarılıysa emoji rating ekranına yönlendirilir.
class QrVerifyScreen extends ConsumerStatefulWidget {
  const QrVerifyScreen({super.key, this.orderId});

  final String? orderId;

  @override
  ConsumerState<QrVerifyScreen> createState() => _QrVerifyScreenState();
}

class _QrVerifyScreenState extends ConsumerState<QrVerifyScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _processing = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? get _orderId =>
      widget.orderId ?? ref.read(activeOrderViewModelProvider).valueOrNull?.id;

  Future<void> _verify(String qrCode) async {
    final orderId = _orderId;
    if (orderId == null || _processing) return;
    setState(() {
      _processing = true;
      _error = null;
    });
    try {
      await ref.read(activeOrderViewModelProvider.notifier).verify(
            orderId: orderId,
            qrCode: qrCode,
          );
      if (!mounted) return;
      context.go(RoutePaths.emojiRating, extra: orderId);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _enterCodeManually() async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Text('Kodu Gir', style: AppTypography.title),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: AppTypography.mono(),
          decoration: const InputDecoration(hintText: 'QR kod değeri'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Onayla'),
          ),
        ],
      ),
    );
    if (code != null && code.isNotEmpty) {
      await _verify(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final barcode = capture.barcodes.firstOrNull;
              final value = barcode?.rawValue;
              if (value != null) _verify(value);
            },
          ),
          Container(color: Colors.black.withValues(alpha: 0.25)),
          const _ScannerFrame(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.close_rounded, color: AppColors.onSurface),
                      ),
                      const Spacer(),
                      Text('Hızla Ye',
                          style: AppTypography.brandLogo.copyWith(fontSize: 20)),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.xl,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _WatermarkBar(orderId: _orderId),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                      border: Border.all(color: AppColors.glassBorder(opacity: 0.15)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Teslimatı Doğrula', style: AppTypography.title),
                        const SizedBox(height: 4),
                        Text(
                          'QR kodu çerçeve içine hizalayarak teslimatı onaylayın.',
                          style: AppTypography.bodyMuted,
                          textAlign: TextAlign.center,
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(_error!,
                              style: AppTypography.bodyMuted.copyWith(color: AppColors.error)),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _processing ? null : _enterCodeManually,
                                icon: const Icon(Icons.keyboard_rounded),
                                label: const Text('Enter Code'),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: AppSpacing.md),
                                  foregroundColor: AppColors.onSurface,
                                  side: BorderSide(color: AppColors.glassBorder(opacity: 0.2)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(AppSpacing.radiusButton)),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: GradientButton(
                                label: 'Capture Proof',
                                icon: Icons.photo_camera_rounded,
                                gradient: AppGradients.primary,
                                onPressed: _processing ? null : () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_processing)
            const Center(child: CircularProgressIndicator(color: AppColors.gradientStart)),
        ],
      ),
    );
  }
}

class _ScannerFrame extends StatelessWidget {
  const _ScannerFrame();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gradientStart.withValues(alpha: 0.7), width: 3),
            borderRadius: BorderRadius.circular(AppSpacing.lg),
          ),
        ),
      ),
    );
  }
}

class _WatermarkBar extends StatelessWidget {
  const _WatermarkBar({this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final time = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        border: Border.all(color: AppColors.glassBorder(opacity: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded, color: AppColors.neonCyan, size: 16),
              const SizedBox(width: 4),
              Text('Beşiktaş', style: AppTypography.label.copyWith(fontSize: 12)),
            ],
          ),
          Text(time, style: AppTypography.mono(fontSize: 13)),
        ],
      ),
    );
  }
}
