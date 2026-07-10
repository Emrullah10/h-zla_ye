import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';

/// İmza etkileşim: Stitch'teki slide-to-accept / slide-to-deliver.
/// Track + gradyanlı thumb, sürüklerken dolan fill, eşik %85'te onay,
/// bırakınca eşik altındaysa spring ile geri döner.
class SlideToConfirm extends StatefulWidget {
  const SlideToConfirm({
    super.key,
    required this.label,
    required this.confirmedLabel,
    required this.onConfirmed,
    this.icon = Icons.power_settings_new_rounded,
    this.confirmedIcon = Icons.check_rounded,
    this.height = 64,
    this.threshold = 0.85,
    this.trackGradient = AppGradients.primary,
    this.confirmedGradient = AppGradients.cyan,
  });

  final String label;
  final String confirmedLabel;
  final VoidCallback onConfirmed;
  final IconData icon;
  final IconData confirmedIcon;
  final double height;
  final double threshold;
  final Gradient trackGradient;
  final Gradient confirmedGradient;

  @override
  State<SlideToConfirm> createState() => _SlideToConfirmState();
}

class _SlideToConfirmState extends State<SlideToConfirm>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _dragExtent = 0;
  double _maxDrag = 0;
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..addListener(() {
        setState(() => _dragExtent = _controller.value * _maxDrag);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_confirmed || _maxDrag <= 0) return;
    setState(() {
      _dragExtent = (_dragExtent + details.delta.dx).clamp(0, _maxDrag);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_confirmed || _maxDrag <= 0) return;
    final progress = _dragExtent / _maxDrag;
    if (progress >= widget.threshold) {
      setState(() {
        _confirmed = true;
        _dragExtent = _maxDrag;
      });
      HapticFeedback.mediumImpact();
      widget.onConfirmed();
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _confirmed = false;
            _dragExtent = 0;
          });
        }
      });
    } else {
      // Spring geri dönüş — cubic-bezier(0.175,0.885,0.32,1.275) yaklaşık taklidi.
      _controller.value = _dragExtent / _maxDrag;
      _controller
          .animateBack(0, curve: Curves.elasticOut)
          .whenComplete(() => setState(() => _dragExtent = 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final thumbSize = widget.height - 8;
        _maxDrag = constraints.maxWidth - thumbSize - 8;
        final progress = _maxDrag > 0 ? (_dragExtent / _maxDrag).clamp(0.0, 1.0) : 0.0;

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Dolan fill
              AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                width: thumbSize + 8 + (_maxDrag * progress),
                height: widget.height,
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(widget.height / 2),
                ),
              ),
              // Merkez etiket
              Center(
                child: Text(
                  _confirmed
                      ? widget.confirmedLabel.toUpperCase()
                      : (progress > 0.8
                          ? 'BAŞLATILIYOR...'
                          : widget.label.toUpperCase()),
                  style: AppTypography.label.copyWith(
                    color: AppColors.onSurface.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ),
              // Thumb
              Positioned(
                left: 4 + _dragExtent,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _confirmed
                          ? widget.confirmedGradient
                          : widget.trackGradient,
                      boxShadow: _confirmed
                          ? AppShadows.cyanGlow()
                          : AppShadows.brandGlow(),
                    ),
                    child: Icon(
                      _confirmed ? widget.confirmedIcon : widget.icon,
                      color: AppColors.onPrimary,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
