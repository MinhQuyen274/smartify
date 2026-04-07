import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/account-settings/models/account_settings_models.dart';

/// Linked account row — brand icon + name + Connected/Connect status.
/// Matches Figma Linked Accounts screen.
class LinkedAccountRow extends StatelessWidget {
  const LinkedAccountRow({
    super.key,
    required this.account,
    this.onTap,
  });

  final LinkedAccount account;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(LightThemeData.radiusM),
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              offset: Offset(0, 2),
              color: Color(0x08000000),
            ),
          ],
        ),
        child: Row(
          children: [
            // Brand icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: account.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                account.icon,
                size: 22,
                color: account.color,
              ),
            ),
            const SizedBox(width: 14),
            // Name
            Expanded(
              child: Text(
                account.name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            // Status
            Text(
              account.isConnected ? 'Connected' : 'Connect',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: account.isConnected
                    ? const Color(0xFF9CA3AF)
                    : LightColorTokens.primary,
                fontWeight: account.isConnected
                    ? FontWeight.w400
                    : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
