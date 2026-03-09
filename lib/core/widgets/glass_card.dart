import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:to_do_app/core/theme/app_colors.dart';
import 'package:to_do_app/core/widgets/app_spacings.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final borderRadius = AppSpacing.circular(context, 32);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding ?? AppSpacing.all(context, 24),
          decoration: BoxDecoration(
            color: AppColors.glassFill.withValues(alpha: 0.72),
            borderRadius: borderRadius,
            border: Border.all(color: AppColors.glassStroke),
            boxShadow: AppColors.softShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}
