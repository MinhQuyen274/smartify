import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';

/// Dedicated empty devices state component matching Figma (28_23).
/// Displays centered icon + title + subtitle + add device button.
class EmptyDevicesStateWidget extends StatelessWidget {
  const EmptyDevicesStateWidget({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AuthMotionSection(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: LightThemeData.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon: 64px, light gray color
              Icon(
                Icons.content_paste_off_rounded,
                size: 64,
                color: LightColorTokens.border,
              ),
              const SizedBox(height: LightThemeData.spacingXl),
              
              // Title: "No Devices"
              Text(
                'No Devices',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: LightThemeData.spacingS),
              
              // Subtitle
              Text(
                'You haven\'t added a device yet.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: LightColorTokens.textSecondary,
                ),
              ),
              const SizedBox(height: LightThemeData.spacingXl),
              
              // Add Device Button: width full, height ~54px
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Device'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  backgroundColor: LightColorTokens.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
