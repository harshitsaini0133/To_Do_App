import 'package:flutter/material.dart';
import 'package:to_do_app/core/config/app_config.dart';
import 'package:to_do_app/core/theme/app_colors.dart';
import 'package:to_do_app/core/theme/app_typography.dart';
import 'package:to_do_app/core/widgets/glass_card.dart';
import 'package:to_do_app/core/widgets/app_spacings.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkOverlayGradient),
        child: Stack(
          children: [
            const _AuthDecor(),
            SafeArea(
              child: SingleChildScrollView(
                padding: AppSpacing.pagePadding(context),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.sizeOf(context).height - 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacing.h(context, 12),
                      _LogoLockup(title: title, subtitle: subtitle),
                      AppSpacing.h(context, 28),
                      if (!AppConfig.isFirebaseConfigured) ...[
                        _ConfigBanner(keys: AppConfig.missingConfiguration),
                        AppSpacing.h(context, 18),
                      ],
                      GlassCard(child: child),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoLockup extends StatelessWidget {
  const _LogoLockup({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: AppSpacing.value(context, 68),
          width: AppSpacing.value(context, 68),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: AppSpacing.circular(context, 24),
            boxShadow: AppColors.softShadow,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 34,
          ),
        ),
        AppSpacing.h(context, 24),
        Text(
          title,
          style: AppTypography.textTheme.displayMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        AppSpacing.h(context, 12),
        Text(
          subtitle,
          style: AppTypography.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.78),
          ),
        ),
      ],
    );
  }
}

class _ConfigBanner extends StatelessWidget {
  const _ConfigBanner({required this.keys});

  final List<String> keys;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all(context, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: AppSpacing.circular(context, 24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          const Icon(Icons.settings_suggest_rounded, color: Colors.white),
          AppSpacing.w(context, 12),
          Expanded(
            child: Text(
              'Add ${keys.join(' and ')} via --dart-define before using Firebase.',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthDecor extends StatelessWidget {
  const _AuthDecor();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -70,
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
