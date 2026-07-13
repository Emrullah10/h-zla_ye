import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// go_router redirect kararı AuthViewModel yüklenene kadar bu ekran gösterilir.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.scaffold,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hızla Ye', style: AppTypography.brandLogo),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: AppColors.gradientStart),
          ],
        ),
      ),
    );
  }
}
