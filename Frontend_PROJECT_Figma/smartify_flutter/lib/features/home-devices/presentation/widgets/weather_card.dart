import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/home-devices/models/home_devices_models.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';

/// Weather card matching Figma "My Home" design —
/// blue gradient, sun+cloud illustration, AQI/humidity/wind.
class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.data});

  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    return AuthMotionSection(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A7DFF), Color(0xFF7B6CF6)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(LightThemeData.radiusL),
          boxShadow: const [
            BoxShadow(
              blurRadius: 20,
              offset: Offset(0, 8),
              color: Color(0x304A7DFF),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data.temperature}°C',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.location,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.condition,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _WeatherStat(
                        icon: Icons.eco_outlined,
                        label: 'AQI ${data.aqi}',
                      ),
                      const SizedBox(width: 14),
                      _WeatherStat(
                        icon: Icons.water_drop_outlined,
                        label: '${data.humidity}%',
                      ),
                      const SizedBox(width: 14),
                      _WeatherStat(
                        icon: Icons.air_rounded,
                        label: '${data.windSpeed} m/s',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Sun + cloud illustration
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.wb_sunny_rounded,
                      size: 50,
                      color: Colors.orange.shade300,
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    left: 0,
                    child: Icon(
                      Icons.cloud_rounded,
                      size: 56,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  const _WeatherStat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
