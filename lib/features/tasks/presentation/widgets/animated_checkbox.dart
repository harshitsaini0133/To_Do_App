import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/app_constants.dart';
import 'package:to_do_app/core/theme/app_colors.dart';
import 'package:to_do_app/core/widgets/app_spacings.dart';

class AnimatedCheckbox extends StatelessWidget {
  const AnimatedCheckbox({
    super.key,
    required this.value,
    required this.onTap,
  });

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.86, end: value ? 1 : 0.92),
        duration: AppConstants.fastAnimation,
        curve: Curves.elasticOut,
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: AnimatedContainer(
          duration: AppConstants.fastAnimation,
          height: AppSpacing.value(context, 28),
          width: AppSpacing.value(context, 28),
          decoration: BoxDecoration(
            gradient: value ? AppColors.primaryGradient : null,
            color: value ? null : Colors.white,
            borderRadius: AppSpacing.circular(context, 10),
            border: Border.all(
              color: value ? Colors.transparent : AppColors.border,
              width: 1.4,
            ),
            boxShadow: value ? AppColors.softShadow : null,
          ),
          child: Icon(
            Icons.check_rounded,
            size: 18,
            color: value ? Colors.white : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
