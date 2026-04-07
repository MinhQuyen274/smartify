import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/motion/motion_tokens.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';

/// Segmented tab control matching Figma mode selectors
/// (White/Color/Scene for Lamp, Cooling/Heating/Purifying for AC).
class ModeTabBar extends StatelessWidget {
  const ModeTabBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF1F3F8),
        borderRadius: BorderRadius.circular(LightThemeData.radiusS),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isActive = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: AnimatedContainer(
                duration: MotionTokens.micro,
                curve: MotionTokens.standard,
                margin: const EdgeInsets.all(3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive ? (activeColor ?? LightColorTokens.primary) : Colors.transparent,
                  borderRadius: BorderRadius.circular(LightThemeData.radiusS - 2),
                ),
                child: Text(
                  labels[i],
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isActive ? Colors.white : (inactiveColor ?? LightColorTokens.textSecondary),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
