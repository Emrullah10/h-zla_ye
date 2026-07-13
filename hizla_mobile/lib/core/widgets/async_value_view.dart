import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'gradient_button.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// `AsyncValue&lt;T&gt;` için standart loading/error/data sarmalayıcı.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.gradientStart),
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded, color: context.colors.error, size: 40),
              const SizedBox(height: 12),
              Text(
                'Bir şeyler ters gitti',
                style: AppTypography.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                error.toString(),
                style: AppTypography.bodyMuted,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: 160,
                  child: GradientButton(label: 'Tekrar Dene', onPressed: onRetry),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
