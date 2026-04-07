import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/shared/widgets/pressable_scale.dart';

class SettingsPlainRow extends StatelessWidget {
  const SettingsPlainRow({
    super.key,
    required this.title,
    this.subtitle,
    this.trailingText,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    this.showChevron = true,
  });

  final String title;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: subtitle == null
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: LightColorTokens.textSecondary,
                        height: 1.55,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailingText != null) ...[
              const SizedBox(width: 16),
              Text(
                trailingText!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (showChevron) ...[
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right_rounded,
                color: LightColorTokens.textPrimary,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
