import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/app_constants.dart';

class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({
    required Widget page,
    super.settings,
  }) : super(
          transitionDuration: AppConstants.mediumAnimation,
          reverseTransitionDuration: AppConstants.fastAnimation,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            final offsetTween = Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            );
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
              child: SlideTransition(
                position: animation.drive(offsetTween),
                child: child,
              ),
            );
          },
        );
}
