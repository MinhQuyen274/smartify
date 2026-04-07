import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';
import 'package:smartify_flutter/shared/widgets/pressable_scale.dart';

/// Switch Home screen matching Figma — list of homes with active indicator.
class SwitchHomeScreen extends StatelessWidget {
  const SwitchHomeScreen({super.key});

  static const List<_HomeOption> _homes = [
    _HomeOption(name: 'My Home', subtitle: 'New York City, USA', isActive: true),
    _HomeOption(name: 'Beach House', subtitle: 'Miami, FL', isActive: false),
    _HomeOption(name: 'Office', subtitle: 'Manhattan, NY', isActive: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColorTokens.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(LightThemeData.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const Spacer(),
                  Text(
                    'Switch Home',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 20),
              ...List.generate(_homes.length, (i) {
                final home = _homes[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AuthMotionSection(
                    delay: Duration(milliseconds: 60 * i),
                    child: PressableScale(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            LightThemeData.radiusM,
                          ),
                          border: Border.all(
                            color: home.isActive
                                ? LightColorTokens.primary
                                : const Color(0xFFE6EAF2),
                            width: home.isActive ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: LightColorTokens.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.home_rounded,
                                color: LightColorTokens.primary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    home.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                  Text(
                                    home.subtitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color:
                                              LightColorTokens.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            if (home.isActive)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: LightColorTokens.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeOption {
  const _HomeOption({
    required this.name,
    required this.subtitle,
    required this.isActive,
  });

  final String name;
  final String subtitle;
  final bool isActive;
}
