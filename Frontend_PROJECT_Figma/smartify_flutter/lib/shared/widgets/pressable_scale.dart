import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/motion/motion_tokens.dart';
import 'package:smartify_flutter/shared/widgets/reduced_motion.dart';

class PressableScale extends StatefulWidget {
  const PressableScale({super.key, required this.onTap, required this.child});

  final VoidCallback? onTap;
  final Widget child;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final reduce = ReducedMotion.enabled(context);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed && !reduce ? 0.98 : 1,
        duration: reduce ? const Duration(milliseconds: 80) : MotionTokens.tap,
        curve: MotionTokens.standard,
        child: widget.child,
      ),
    );
  }
}
