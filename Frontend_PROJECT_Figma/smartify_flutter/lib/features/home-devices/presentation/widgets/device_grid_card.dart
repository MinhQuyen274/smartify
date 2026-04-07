import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/motion/motion_tokens.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/home-devices/models/home_devices_models.dart';
import 'package:smartify_flutter/shared/widgets/pressable_scale.dart';

/// 2-column device card matching Figma: icon, name, connectivity tag, toggle.
class DeviceGridCard extends StatelessWidget {
  const DeviceGridCard({
    super.key,
    required this.device,
    required this.onToggle,
    this.onTap,
  });

  final SmartDevice device;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: MotionTokens.cardTransition,
        curve: MotionTokens.standard,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(LightThemeData.radiusM),
          border: Border.all(
            color: device.isOn
                ? LightColorTokens.primary.withValues(alpha: 0.25)
                : const Color(0xFFE6EAF2),
          ),
          boxShadow: device.isOn
              ? const [
                  BoxShadow(
                    blurRadius: 12,
                    offset: Offset(0, 4),
                    color: Color(0x104A7DFF),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (device.imagePath != null)
                  Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: device.isOn
                          ? LightColorTokens.primary.withValues(alpha: 0.1)
                          : const Color(0xFFF1F3F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        device.imagePath!,
                        fit: BoxFit.contain,
                        opacity: device.isOn
                            ? null
                            : const AlwaysStoppedAnimation(0.5),
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            device.icon,
                            size: 22,
                            color: device.isOn
                                ? LightColorTokens.primary
                                : const Color(0xFF9CA3AF),
                          );
                        },
                      ),
                    ),
                  )
                else
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: device.isOn
                          ? LightColorTokens.primary.withValues(alpha: 0.1)
                          : const Color(0xFFF1F3F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      device.icon,
                      size: 22,
                      color: device.isOn
                          ? LightColorTokens.primary
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                SizedBox(
                  height: 28,
                  child: Switch.adaptive(
                    value: device.isOn,
                    onChanged: (_) => onToggle(),
                    activeTrackColor: LightColorTokens.primary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              device.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Icon(
                  device.connectivity == 'Bluetooth'
                      ? Icons.bluetooth_rounded
                      : Icons.wifi_rounded,
                  size: 12,
                  color: const Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 4),
                Text(
                  device.connectivity,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
