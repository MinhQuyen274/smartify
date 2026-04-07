import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/home-devices/models/home_devices_models.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/device_control_scaffold.dart';
import 'package:smartify_flutter/features/home-devices/state/home_devices_store.dart';

class ControlCameraScreen extends StatelessWidget {
  const ControlCameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<HomeDevicesStore>();
    if (store.allDevices.isEmpty) return const SizedBox.shrink();
    final routeDeviceId = ModalRoute.of(context)?.settings.arguments as String?;
    final device =
        (routeDeviceId != null ? store.deviceById(routeDeviceId) : null) ??
        store.allDevices.firstWhere(
          (d) => d.type == DeviceType.camera,
          orElse: () => store.allDevices.first,
        );

    return DeviceControlScaffold(
      deviceName: device.name,
      roomName: device.room,
      deviceIcon: Icons.videocam_rounded,
      imagePath: device.imagePath,
      isOn: device.isOn,
      onToggle: () => store.toggleDevice(device.id),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Container(
            height: 280,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black12,
            ),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFFDADADA)),
                ),
                const Positioned(
                  left: 12,
                  top: 10,
                  child: Chip(
                    label: Text(
                      'Live',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: Color(0xAA000000),
                    avatar: CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Row(
                    children: const [
                      _VideoBadge(icon: Icons.hd_rounded),
                      SizedBox(width: 8),
                      _VideoBadge(icon: Icons.volume_up_rounded),
                      SizedBox(width: 8),
                      _VideoBadge(icon: Icons.fullscreen_rounded),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Expanded(child: _CameraActionsGrid()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _RoundTransport(icon: Icons.chevron_left_rounded),
              SizedBox(width: 22),
              _RoundTransport(icon: Icons.pause_rounded, active: true),
              SizedBox(width: 22),
              _RoundTransport(icon: Icons.chevron_right_rounded),
            ],
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}

class _VideoBadge extends StatelessWidget {
  const _VideoBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0xAA000000),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}

class _CameraActionsGrid extends StatelessWidget {
  const _CameraActionsGrid();

  @override
  Widget build(BuildContext context) {
    const actions = [
      (Icons.play_circle_outline_rounded, 'Playback'),
      (Icons.camera_alt_outlined, 'Snapshot'),
      (Icons.mic_none_rounded, 'Speak'),
      (Icons.videocam_outlined, 'Record'),
      (Icons.photo_library_outlined, 'Gallery'),
      (Icons.lock_outline_rounded, 'Private Mode'),
      (Icons.nights_stay_outlined, 'Night Mode'),
      (Icons.grid_view_rounded, 'More'),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.88,
      ),
      itemCount: actions.length,
      itemBuilder: (_, i) {
        final item = actions[i];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.$1, size: 28, color: const Color(0xFF4A4A4A)),
            const SizedBox(height: 8),
            Text(
              item.$2,
              style: const TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
            ),
          ],
        );
      },
    );
  }
}

class _RoundTransport extends StatelessWidget {
  const _RoundTransport({required this.icon, this.active = false});

  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 78 : 62,
      height: active ? 78 : 62,
      decoration: BoxDecoration(
        color: active ? LightColorTokens.primary : const Color(0xFFE8E8E8),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: active ? 42 : 36,
        color: active ? Colors.white : const Color(0xFF5C5C5C),
      ),
    );
  }
}
