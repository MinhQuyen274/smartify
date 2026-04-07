import 'package:flutter/material.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';

class LocationChangeScreen extends StatelessWidget {
  const LocationChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColorTokens.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Expanded(
                    child: Text(
                      'When Location Changes',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _LocationOptionTile(
                      icon: Icons.login_rounded,
                      color: const Color(0xFF57C76C),
                      title: '“Arrive at” a Preset Location',
                      subtitle:
                          'Example: When I come home, turn on all the lights in the house.',
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoutes.smartScenesConditionPresetLocation,
                          arguments: true,
                        );
                        if (result != null && context.mounted) {
                          Navigator.pop(context, result);
                        }
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFE9EBF0)),
                    _LocationOptionTile(
                      icon: Icons.logout_rounded,
                      color: const Color(0xFFFF5A4E),
                      title: '“Leave” a Preset Location',
                      subtitle:
                          'Example: When I leave the house, turn off all devices.',
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoutes.smartScenesConditionPresetLocation,
                          arguments: false,
                        );
                        if (result != null && context.mounted) {
                          Navigator.pop(context, result);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationOptionTile extends StatelessWidget {
  const _LocationOptionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF7E818B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
