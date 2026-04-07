import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/motion/motion_tokens.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/reports/models/reports_models.dart';

/// Bar chart for monthly energy statistics matching Figma.
/// Selected bar is vibrant blue with a tooltip; others are light blue.
class StatisticsBarChart extends StatelessWidget {
  const StatisticsBarChart({
    super.key,
    required this.data,
    required this.selectedIndex,
    required this.onBarTap,
  });

  final List<MonthlyUsage> data;
  final int selectedIndex;
  final ValueChanged<int> onBarTap;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final maxHours = data.fold<double>(
      0,
      (prev, e) => math.max(prev, e.onHours),
    );

    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(data.length, (i) {
          final item = data[i];
          final isSelected = i == selectedIndex;
          final barHeight = maxHours > 0 ? (item.onHours / maxHours) * 120 : 0.0;

          return Expanded(
            child: GestureDetector(
              onTap: () => onBarTap(i),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Tooltip on selected bar
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: LightColorTokens.primary,
                        borderRadius: BorderRadius.circular(
                          LightThemeData.radiusS,
                        ),
                      ),
                      child: Text(
                        '${item.onHours.toStringAsFixed(1)} h',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 24),

                  const SizedBox(height: 6),

                  // Bar
                  AnimatedContainer(
                    duration: MotionTokens.cardTransition,
                    curve: MotionTokens.standard,
                    width: 28,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? LightColorTokens.primary
                          : LightColorTokens.primary.withValues(alpha: 0.2),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Label
                  Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? LightColorTokens.textPrimary
                          : const Color(0xFF9CA3AF),
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
