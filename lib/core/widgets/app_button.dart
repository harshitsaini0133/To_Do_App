import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/app_constants.dart';
import 'package:to_do_app/core/theme/app_colors.dart';
import 'package:to_do_app/core/theme/app_typography.dart';
import 'package:to_do_app/core/widgets/app_spacings.dart';

enum ButtonVariant { primary, secondary, ghost }

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.expand = true,
    this.padding,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final ButtonVariant variant;
  final bool expand;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || isLoading;
    final isPrimary = variant == ButtonVariant.primary;
    final background = switch (variant) {
      ButtonVariant.primary => AppColors.primaryGradient,
      ButtonVariant.secondary => const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
        ),
      ButtonVariant.ghost => const LinearGradient(
          colors: [Colors.transparent, Colors.transparent],
        ),
    };
    final textColor = switch (variant) {
      ButtonVariant.primary => Colors.white,
      ButtonVariant.secondary => AppColors.textPrimary,
      ButtonVariant.ghost => AppColors.textPrimary,
    };

    return AnimatedOpacity(
      duration: AppConstants.fastAnimation,
      opacity: disabled ? 0.55 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: background,
          borderRadius: AppSpacing.circular(context, 22),
          border: Border.all(
            color: isPrimary ? Colors.transparent : AppColors.border,
          ),
          boxShadow: disabled || !isPrimary ? null : AppColors.softShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppSpacing.circular(context, 22),
            onTap: disabled ? null : onPressed,
            child: Padding(
              padding: padding ??
                  AppSpacing.symmetric(
                    context: context,
                    horizontal: 20,
                    vertical: 16,
                  ),
              child: Row(
                mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    SizedBox(
                      height: AppSpacing.value(context, 18),
                      width: AppSpacing.value(context, 18),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: textColor,
                      ),
                    )
                  else ...[
                    if (icon != null) ...[
                      IconTheme(
                        data: IconThemeData(color: textColor, size: 18),
                        child: icon!,
                      ),
                      AppSpacing.w(context, 10),
                    ],
                    Text(
                      label,
                      style: AppTypography.textTheme.labelLarge?.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppButton extends GradientButton {
  const AppButton({
    super.key,
    required super.label,
    super.onPressed,
    super.icon,
    super.isLoading,
    super.variant,
    super.expand,
    super.padding,
  });
}
