import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Henüz implemente edilmemiş ekranlar için geçici yer tutucu.
/// Faz ilerledikçe gerçek ekranlarla değiştirilir.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: Text(title, style: AppTypography.title)),
      body: Center(
        child: Text('$title — yakında', style: AppTypography.bodyMuted),
      ),
    );
  }
}
