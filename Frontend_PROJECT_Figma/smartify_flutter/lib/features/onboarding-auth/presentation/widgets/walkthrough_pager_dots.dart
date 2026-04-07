import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/motion/motion_tokens.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';

class WalkthroughPagerDots extends StatelessWidget {
  const WalkthroughPagerDots({
    super.key,
    required this.count,
    required this.index,
  });

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (dotIndex) {
          final active = dotIndex == index;
          return AnimatedContainer(
            duration: MotionTokens.micro,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: active ? 24 : 8,
            decoration: BoxDecoration(
              color: active ? LightColorTokens.primary : LightColorTokens.border,
              borderRadius: BorderRadius.circular(99),
            ),
          );
        },
      ),
    );
  }
}
