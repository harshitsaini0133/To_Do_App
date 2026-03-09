import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:to_do_app/core/theme/app_colors.dart';
import 'package:to_do_app/core/theme/app_typography.dart';

class FrostedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FrostedAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: AppBar(
          title: Text(
            title,
            style: AppTypography.textTheme.titleLarge,
          ),
          leading: leading,
          actions: actions,
          backgroundColor: AppColors.glassFill.withValues(alpha: 0.76),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBar extends FrostedAppBar {
  const CustomAppBar({
    super.key,
    required super.title,
    super.leading,
    super.actions,
  });
}
