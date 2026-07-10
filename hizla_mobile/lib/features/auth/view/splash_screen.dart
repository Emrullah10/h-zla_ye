import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// go_router redirect kararı AuthViewModel yüklenene kadar bu ekran gösterilir.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
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
