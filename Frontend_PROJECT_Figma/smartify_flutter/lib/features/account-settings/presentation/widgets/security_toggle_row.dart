import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/account-settings/models/account_settings_models.dart';

/// Security toggle row — title + Switch.adaptive.
/// Matches Figma Account & Security toggle items.
class SecurityToggleRow extends StatelessWidget {
  const SecurityToggleRow({
    super.key,
    required this.toggle,
    required this.onChanged,
  });

  final SecurityToggle toggle;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(LightThemeData.radiusM),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              toggle.title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          SizedBox(
            height: 28,
            child: Switch.adaptive(
              value: toggle.isEnabled,
              onChanged: (_) => onChanged(),
              activeTrackColor: LightColorTokens.primary,
            ),
          ),
        ],
      ),
    );
  }
}
