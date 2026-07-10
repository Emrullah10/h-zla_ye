import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Standart sayfa üst çubuğu — şeffaf, "Hızla Ye" markası veya başlık.
class HizlaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HizlaAppBar({
    super.key,
    this.title,
    this.showBrand = false,
    this.leading,
    this.actions,
  });

  final String? title;
  final bool showBrand;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: showBrand
          ? Text('Hızla Ye', style: AppTypography.brandLogo.copyWith(fontSize: 22))
          : (title != null ? Text(title!, style: AppTypography.title) : null),
      centerTitle: !showBrand,
      actions: actions,
      iconTheme: const IconThemeData(color: AppColors.onSurface),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
