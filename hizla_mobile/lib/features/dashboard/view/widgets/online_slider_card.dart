import 'package:flutter/material.dart';
import '../../../../core/widgets/slide_to_confirm.dart';

/// Alttaki "MÜSAİT OL" / "ÇEVRİMİÇİ" kaydırma kontrolü — mevcut
/// [SlideToConfirm] widget'ı sarmalanarak kullanılır, yeniden yazılmaz.
class OnlineSliderCard extends StatelessWidget {
  const OnlineSliderCard({super.key, required this.onConfirmed});

  final VoidCallback onConfirmed;

  @override
  Widget build(BuildContext context) {
    return SlideToConfirm(
      label: 'Slayt İle Müsait Ol',
      confirmedLabel: 'Çevrimiçi',
      onConfirmed: onConfirmed,
    );
  }
}
