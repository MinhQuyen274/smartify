import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';

/// Scaffold for device control screens (Smart Lamp, AC, etc.)
/// matching Figma: back arrow, title "Control Device", more menu, toggle row.
class DeviceControlScaffold extends StatelessWidget {
  const DeviceControlScaffold({
    super.key,
    required this.deviceName,
    required this.roomName,
    required this.deviceIcon,
    this.imagePath,
    required this.isOn,
    required this.onToggle,
    required this.child,
    this.onBack,
  });

  final String deviceName;
  final String roomName;
  final IconData deviceIcon;
  final String? imagePath;
  final bool isOn;
  final VoidCallback onToggle;
  final Widget child;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColorTokens.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LightThemeData.spacingS,
                vertical: LightThemeData.spacingXs,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const Spacer(),
                  Text(
                    'Control Device',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert_rounded),
                  ),
                ],
              ),
            ),
            // Device info + toggle
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LightThemeData.spacingL,
              ),
              child: Row(
                children: [
                  imagePath != null
                      ? Image.asset(imagePath!, width: 44, fit: BoxFit.contain)
                      : Icon(deviceIcon, size: 24, color: LightColorTokens.textSecondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deviceName,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          roomName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: LightColorTokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: isOn,
                    onChanged: (_) => onToggle(),
                    activeTrackColor: LightColorTokens.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: LightThemeData.spacingL,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
