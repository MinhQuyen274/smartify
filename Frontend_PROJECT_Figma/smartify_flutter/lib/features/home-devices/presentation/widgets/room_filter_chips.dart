import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/motion/motion_tokens.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';

/// Horizontally scrollable room filter chips matching Figma.
/// Active chip: solid blue fill + white text. Inactive: outline.
class RoomFilterChips extends StatelessWidget {
  const RoomFilterChips({
    super.key,
    required this.rooms,
    required this.selected,
    required this.onSelected,
    this.deviceCounts,
  });

  final List<String> rooms;
  final String selected;
  final ValueChanged<String> onSelected;
  final Map<String, int>? deviceCounts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: rooms.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final room = rooms[index];
          final isActive = room == selected;
          final count = deviceCounts?[room];
          final label = count != null ? '$room ($count)' : room;

          return GestureDetector(
            onTap: () => onSelected(room),
            child: AnimatedContainer(
              duration: MotionTokens.micro,
              curve: MotionTokens.standard,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive ? LightColorTokens.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(LightThemeData.radiusS),
                border: Border.all(
                  color: isActive
                      ? LightColorTokens.primary
                      : const Color(0xFFD1D5DB),
                ),
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isActive ? Colors.white : const Color(0xFF6B7280),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
