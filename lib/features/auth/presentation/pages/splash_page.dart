import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/app_constants.dart';
import 'package:to_do_app/core/theme/app_colors.dart';
import 'package:to_do_app/core/theme/app_typography.dart';
import 'package:to_do_app/core/widgets/app_spacings.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.slowAnimation,
    )..repeat(reverse: true);
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.94, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkOverlayGradient),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: AppSpacing.value(context, 112),
                    width: AppSpacing.value(context, 112),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: AppSpacing.circular(context, 34),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 56,
                    ),
                  ),
                  AppSpacing.h(context, 28),
                  Text(
                    'To Do App',
                    style: AppTypography.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  AppSpacing.h(context, 12),
                  Text(
                    'Plan clean. Move fast.',
                    style: AppTypography.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.76),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
