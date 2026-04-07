import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/home-devices/models/home_devices_models.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/device_control_scaffold.dart';
import 'package:smartify_flutter/features/home-devices/state/home_devices_store.dart';

class ControlAcScreen extends StatelessWidget {
  const ControlAcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<HomeDevicesStore>();
    final routeDeviceId = ModalRoute.of(context)?.settings.arguments as String?;
    final device =
        (routeDeviceId != null ? store.deviceById(routeDeviceId) : null) ??
        store.allDevices.firstWhere(
          (candidate) => candidate.type == DeviceType.electrical,
          orElse: () => store.allDevices.isNotEmpty
              ? store.allDevices.first
              : const SmartDevice(
                  id: '',
                  name: '',
                  room: '',
                  type: DeviceType.electrical,
                  connectivity: 'Wi-Fi',
                  icon: Icons.power_rounded,
                ),
        );
    if (device.id.isEmpty) return const SizedBox.shrink();
    final mode = store.acModeIndex;

    return DeviceControlScaffold(
      deviceName: device.name,
      roomName: device.room,
      deviceIcon: Icons.power_rounded,
      imagePath: device.imagePath,
      isOn: device.isOn,
      onToggle: () => store.toggleDevice(device.id),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: const [
                    Icon(Icons.location_on_outlined, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'New York City',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF3F3F3F),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right_rounded, size: 24),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFD9D9D9)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _ModeButton(
                      label: '<',
                      selected: mode == 0,
                      onTap: () => store.setAcModeIndex(0),
                    ),
                    const SizedBox(width: 6),
                    _ModeButton(
                      label: '=',
                      selected: mode == 1,
                      onTap: () => store.setAcModeIndex(1),
                    ),
                    const SizedBox(width: 6),
                    _ModeButton(
                      label: '>',
                      selected: mode == 2,
                      onTap: () => store.setAcModeIndex(2),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${store.acTemperature}°C',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF24262E),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 10,
                    activeTrackColor: LightColorTokens.primary,
                    inactiveTrackColor: const Color(0xFFE3E3E3),
                    thumbColor: Colors.white,
                    overlayColor: Colors.transparent,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                    ),
                  ),
                  child: Slider(
                    min: -50,
                    max: 50,
                    value: store.acTemperature.toDouble().clamp(-50, 50),
                    onChanged: (v) =>
                        store.setAcTemperature(v.round().clamp(-50, 50)),
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Text(
                      '-50°C',
                      style: TextStyle(fontSize: 13, color: Color(0xFF5E5E5E)),
                    ),
                    Spacer(),
                    Text(
                      '50°C',
                      style: TextStyle(fontSize: 13, color: Color(0xFF5E5E5E)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: LightColorTokens.primary,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: selected
                ? LightColorTokens.primary
                : const Color(0xFFEAEAEA),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : const Color(0xFF2E2E2E),
            ),
          ),
        ),
      ),
    );
  }
}
