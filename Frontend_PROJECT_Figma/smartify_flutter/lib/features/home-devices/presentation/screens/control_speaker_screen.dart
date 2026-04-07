import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/home-devices/models/home_devices_models.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/device_control_scaffold.dart';
import 'package:smartify_flutter/features/home-devices/state/home_devices_store.dart';

class ControlSpeakerScreen extends StatelessWidget {
  const ControlSpeakerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<HomeDevicesStore>();
    if (store.allDevices.isEmpty) return const SizedBox.shrink();
    final routeDeviceId = ModalRoute.of(context)?.settings.arguments as String?;
    final device =
        (routeDeviceId != null ? store.deviceById(routeDeviceId) : null) ??
        store.allDevices.firstWhere(
          (d) => d.type == DeviceType.speaker,
          orElse: () => store.allDevices.first,
        );

    return DeviceControlScaffold(
      deviceName: device.name,
      roomName: device.room,
      deviceIcon: Icons.speaker_rounded,
      imagePath: device.imagePath,
      isOn: device.isOn,
      onToggle: () => store.toggleDevice(device.id),
      child: Column(
        children: [
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.music_note_rounded, color: Color(0xFF1DB954)),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Ed Sheeran - Shape of You',
                    style: TextStyle(fontSize: 12, color: Color(0xFF5A5A5A)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 6),
                _VolumeDial(volume: store.speakerVolume, store: store),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _TransportIcon(icon: Icons.skip_previous_rounded),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: store.toggleSpeakerPlayback,
                      child: _TransportIcon(
                        icon: store.speakerIsPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        active: true,
                      ),
                    ),
                    const SizedBox(width: 24),
                    const _TransportIcon(icon: Icons.skip_next_rounded),
                  ],
                ),
                const SizedBox(height: 24),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: LightColorTokens.primary,
                    inactiveTrackColor: const Color(0xFFE3E3E3),
                    thumbColor: Colors.white,
                    overlayColor: Colors.transparent,
                    trackHeight: 8,
                  ),
                  child: Slider(
                    value: store.speakerPlaybackPosition,
                    onChanged: store.setSpeakerPlaybackPosition,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Row(
                    children: [
                      Text(
                        '02:48',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF505050),
                        ),
                      ),
                      Spacer(),
                      Text(
                        '03:53',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF505050),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VolumeDial extends StatelessWidget {
  const _VolumeDial({required this.volume, required this.store});

  final double volume;
  final HomeDevicesStore store;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              final center = const Offset(160, 160);
              final pos = details.localPosition;
              final angle = math.atan2(pos.dy - center.dy, pos.dx - center.dx);
              const start = math.pi * 0.8;
              const sweep = math.pi * 1.4;
              var normalizedAngle = angle - start;
              if (normalizedAngle < -math.pi) normalizedAngle += 2 * math.pi;
              if (normalizedAngle < 0 && normalizedAngle > -math.pi / 2) return;
              if (normalizedAngle < 0) normalizedAngle = 0;
              var currentVolume = normalizedAngle / sweep;
              store.setSpeakerVolume(currentVolume.clamp(0.0, 1.0));
            },
            child: CustomPaint(
              size: const Size(320, 320),
              painter: _VolumeArcPainter(volume: volume),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/stereo.jpg', width: 140),
              const SizedBox(height: 12),
              FittedBox(
                child: Text(
                  '${(volume * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF24262E),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Volume',
                style: TextStyle(fontSize: 13, color: Color(0xFF616161)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VolumeArcPainter extends CustomPainter {
  _VolumeArcPainter({required this.volume});

  final double volume;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width * 0.42;
    const start = math.pi * 0.8;
    const sweep = math.pi * 1.4;

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFE6E6E6);
    final active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
      ..strokeCap = StrokeCap.round
      ..color = LightColorTokens.primary;

    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      start,
      sweep,
      false,
      base,
    );
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      start,
      sweep * volume,
      false,
      active,
    );

    final a = start + sweep * volume;
    final p = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
    canvas.drawCircle(p, 22, Paint()..color = Colors.white);
    canvas.drawCircle(
      p,
      22,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = LightColorTokens.primary,
    );

    final ticks = Paint()
      ..color = const Color(0xFFC6C6C6)
      ..strokeWidth = 2;
    for (var i = 0; i < 28; i++) {
      final ta = start + (sweep / 27) * i;
      final r1 = r - 54;
      final r2 = r - 44;
      canvas.drawLine(
        Offset(c.dx + math.cos(ta) * r1, c.dy + math.sin(ta) * r1),
        Offset(c.dx + math.cos(ta) * r2, c.dy + math.sin(ta) * r2),
        ticks,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VolumeArcPainter oldDelegate) =>
      oldDelegate.volume != volume;
}

class _TransportIcon extends StatelessWidget {
  const _TransportIcon({required this.icon, this.active = false});

  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 74 : 56,
      height: active ? 74 : 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? LightColorTokens.primary : const Color(0xFFE8E8E8),
      ),
      child: Icon(
        icon,
        size: active ? 40 : 32,
        color: active ? Colors.white : LightColorTokens.primary,
      ),
    );
  }
}
