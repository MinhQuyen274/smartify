import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/motion/motion_tokens.dart';
import 'package:smartify_flutter/shared/widgets/reduced_motion.dart';

class AppPageTransitions {
  const AppPageTransitions._();

  static Route<T> fadeSlide<T>(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: MotionTokens.pageForward,
      reverseTransitionDuration: MotionTokens.pageBackward,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (ReducedMotion.enabled(context)) {
          return FadeTransition(opacity: animation, child: child);
        }
        final fade = CurvedAnimation(parent: animation, curve: MotionTokens.standard);
        final slide = Tween<Offset>(
          begin: const Offset(0.06, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: MotionTokens.decelerate));
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }
}
