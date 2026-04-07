import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/account-settings/models/account_settings_models.dart';
import 'package:smartify_flutter/shared/widgets/pressable_scale.dart';

/// Settings menu row — icon + title + optional description + chevron.
/// Red styling for destructive items (Logout, Delete Account).
class SettingsMenuRow extends StatelessWidget {
  const SettingsMenuRow({
    super.key,
    required this.item,
    this.onTap,
  });

  final SettingsMenuItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = item.isDestructive
        ? LightColorTokens.error
        : LightColorTokens.textPrimary;
    final iconBg = item.isDestructive
        ? LightColorTokens.error.withValues(alpha: 0.08)
        : const Color(0xFFF1F3F8);

    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(LightThemeData.radiusM),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 20, color: color),
            ),
            const SizedBox(width: 14),
            // Title + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: color,
                    ),
                  ),
                  if (item.description != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      item.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: item.isDestructive
                            ? LightColorTokens.error.withValues(alpha: 0.7)
                            : const Color(0xFF9CA3AF),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Chevron
            Icon(
              Icons.chevron_right_rounded,
              color: item.isDestructive
                  ? LightColorTokens.error.withValues(alpha: 0.5)
                  : const Color(0xFFBBC1CC),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
