import 'package:flutter/material.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_flow_scaffold.dart';

class WeatherConditionMenuScreen extends StatelessWidget {
  const WeatherConditionMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SmartFlowScaffold(
      title: 'When Weather Changes',
      actionLabel: 'Back',
      onAction: () => Navigator.pop(context),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _WeatherMenuRow(
              icon: Icons.thermostat_rounded,
              color: const Color(0xFFFF5A4E),
              title: 'Temperature',
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.smartScenesConditionTemperature,
                );
                if (result != null && context.mounted) {
                  Navigator.pop(context, result);
                }
              },
            ),
            _WeatherMenuRow(
              icon: Icons.water_drop_rounded,
              color: const Color(0xFF2D93E6),
              title: 'Humidity',
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.smartScenesConditionHumidity,
                );
                if (result != null && context.mounted) {
                  Navigator.pop(context, result);
                }
              },
            ),
            _WeatherMenuRow(
              icon: Icons.wb_sunny_rounded,
              color: const Color(0xFFFFA126),
              title: 'Weather',
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.smartScenesConditionWeather,
                );
                if (result != null && context.mounted) {
                  Navigator.pop(context, result);
                }
              },
            ),
            _WeatherMenuRow(
              icon: Icons.light_mode_rounded,
              color: const Color(0xFFFFB238),
              title: 'Sunrise / Sunset',
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.smartScenesConditionSunriseSunset,
                );
                if (result != null && context.mounted) {
                  Navigator.pop(context, result);
                }
              },
            ),
            _WeatherMenuRow(
              icon: Icons.air_rounded,
              color: const Color(0xFF4A68F6),
              title: 'Wind Speed',
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.smartScenesConditionWindSpeed,
                );
                if (result != null && context.mounted) {
                  Navigator.pop(context, result);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherMenuRow extends StatelessWidget {
  const _WeatherMenuRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 18),
            Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
