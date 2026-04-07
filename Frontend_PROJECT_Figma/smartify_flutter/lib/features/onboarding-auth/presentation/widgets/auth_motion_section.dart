import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/motion/motion_tokens.dart';
import 'package:smartify_flutter/shared/widgets/reduced_motion.dart';

class AuthMotionSection extends StatefulWidget {
  const AuthMotionSection({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  State<AuthMotionSection> createState() => _AuthMotionSectionState();
}

class _AuthMotionSectionState extends State<AuthMotionSection> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduce = ReducedMotion.enabled(context);
    final duration = reduce ? const Duration(milliseconds: 80) : MotionTokens.cardTransition;
    return AnimatedOpacity(
      duration: duration,
      opacity: _visible ? 1 : 0,
      curve: MotionTokens.standard,
      child: AnimatedSlide(
        duration: duration,
        offset: _visible || reduce ? Offset.zero : const Offset(0, 0.04),
        curve: MotionTokens.decelerate,
        child: widget.child,
      ),
    );
  }
}
