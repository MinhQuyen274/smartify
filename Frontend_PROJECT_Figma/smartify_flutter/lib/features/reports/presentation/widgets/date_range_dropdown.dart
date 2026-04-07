import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/motion/motion_tokens.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/reports/models/reports_models.dart';

/// Dropdown button for date range selection matching Figma.
/// Opens a popup menu with time range options.
class DateRangeDropdown extends StatelessWidget {
  const DateRangeDropdown({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  final List<DateRangeOption> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final currentLabel = options
        .firstWhere(
          (o) => o.value == selectedValue,
          orElse: () => options.first,
        )
        .label;

    return PopupMenuButton<String>(
      onSelected: onSelected,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LightThemeData.radiusM),
      ),
      color: Colors.white,
      elevation: 8,
      itemBuilder: (_) => options.map((opt) {
        final isSelected = opt.value == selectedValue;
        return PopupMenuItem<String>(
          value: opt.value,
          child: AnimatedDefaultTextStyle(
            duration: MotionTokens.micro,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: isSelected
                  ? LightColorTokens.primary
                  : LightColorTokens.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Text(opt.label),
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F8),
          borderRadius: BorderRadius.circular(LightThemeData.radiusS),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: LightColorTokens.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }
}
