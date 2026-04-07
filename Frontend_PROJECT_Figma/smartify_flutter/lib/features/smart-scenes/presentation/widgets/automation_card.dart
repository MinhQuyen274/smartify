import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/smart-scenes/models/smart_scenes_models.dart';

class AutomationCard extends StatelessWidget {
  const AutomationCard({
    super.key,
    required this.item,
    required this.onToggle,
    this.onTap,
  });

  final AutomationItem item;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(LightThemeData.radiusM),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 12, 14),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(LightThemeData.radiusM),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: textTheme.titleLarge),
                          const SizedBox(height: 6),
                          Text(
                            '${item.taskCount} task${item.taskCount == 1 ? '' : 's'}',
                            style: textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF8A8D96),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF2E3137),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 3,
                        children: [
                          for (int index = 0; index < item.triggerIcons.length; index++)
                            ...[
                              Icon(
                                item.triggerIcons[index].icon,
                                size: 24,
                                color: item.triggerIcons[index].color,
                              ),
                              if (index != item.triggerIcons.length - 1)
                                const Icon(
                                  Icons.arrow_right_alt_rounded,
                                  color: Color(0xFF666A73),
                                  size: 24,
                                ),
                            ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _AutomationToggle(
                  value: item.isActive,
                  onTap: onToggle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AutomationToggle extends StatelessWidget {
  const _AutomationToggle({
    required this.value,
    required this.onTap,
  });

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 52,
          height: 32,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value
                ? LightColorTokens.primary
                : const Color(0xFFD7DAE3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
