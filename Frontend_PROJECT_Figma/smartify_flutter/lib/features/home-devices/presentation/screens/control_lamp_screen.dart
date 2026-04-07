import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/home-devices/models/home_devices_models.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/device_control_scaffold.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/mode_tab_bar.dart';
import 'package:smartify_flutter/features/home-devices/state/home_devices_store.dart';

class ControlLampScreen extends StatelessWidget {
  const ControlLampScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<HomeDevicesStore>();
    final routeDeviceId = ModalRoute.of(context)?.settings.arguments as String?;
    final device =
        (routeDeviceId != null ? store.deviceById(routeDeviceId) : null) ??
        store.allDevices.firstWhere(
          (candidate) => candidate.type == DeviceType.light,
          orElse: () => store.allDevices.isNotEmpty
              ? store.allDevices.first
              : const SmartDevice(
                  id: '',
                  name: '',
                  room: '',
                  type: DeviceType.light,
                  connectivity: 'Wi-Fi',
                  icon: Icons.lightbulb_rounded,
                ),
        );
    if (device.id.isEmpty) return const SizedBox.shrink();

    return DeviceControlScaffold(
      deviceName: device.name,
      roomName: device.room,
      deviceIcon: Icons.lightbulb_outline_rounded,
      imagePath: device.imagePath,
      isOn: device.isOn,
      onToggle: () => store.toggleDevice(device.id),
      child: Column(
        children: [
          ModeTabBar(
            labels: const ['White', 'Color', 'Scene'],
            selectedIndex: store.lampModeIndex,
            onSelected: store.setLampModeIndex,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: store.lampModeIndex == 1
                ? _LampColorModeView(store: store)
                : _LampWhiteModeView(store: store),
          ),
          _SliderRow(
            icon: Icons.wb_sunny_outlined,
            value: store.lampBrightness,
            percentLabel: '${(store.lampBrightness * 100).round()}%',
            onChanged: store.setLampBrightness,
          ),
          if (store.lampModeIndex == 1) ...[
            const SizedBox(height: 18),
            _SliderRow(
              icon: Icons.circle_outlined,
              value: store.lampSaturation,
              percentLabel: '${(store.lampSaturation * 100).round()}%',
              onChanged: store.setLampSaturation,
            ),
          ],
          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE7EAF4),
                foregroundColor: LightColorTokens.primary,
              ),
              child: const Text(
                'Schedule Automatic ON/OFF',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

class _LampWhiteModeView extends StatelessWidget {
  const _LampWhiteModeView({required this.store});

  final HomeDevicesStore store;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 330,
        height: 330,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                final center = Offset(165, 165);
                final pos = details.localPosition;
                final angle = math.atan2(
                  pos.dy - center.dy,
                  pos.dx - center.dx,
                );
                const start = math.pi * 0.82;
                const sweep = math.pi * 1.36;
                var normalizedAngle = angle - start;
                while (normalizedAngle < 0) normalizedAngle += 2 * math.pi;
                var currentSelection = normalizedAngle / sweep;
                currentSelection = currentSelection.clamp(0.0, 1.0);
                store.setLampColorTemp(currentSelection);
              },
              child: CustomPaint(
                size: const Size(330, 330),
                painter: _LampWhiteArcPainter(position: store.lampColorTemp),
              ),
            ),
            Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFDADADA)),
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/bong_den.jpg', width: 74),
            ),
          ],
        ),
      ),
    );
  }
}

class _LampColorModeView extends StatelessWidget {
  const _LampColorModeView({required this.store});

  final HomeDevicesStore store;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 330,
        height: 330,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                final center = Offset(165, 165);
                final pos = details.localPosition;
                final angle = math.atan2(
                  pos.dy - center.dy,
                  pos.dx - center.dx,
                );
                var normalizedAngle = angle + math.pi / 2;
                if (normalizedAngle < 0) normalizedAngle += 2 * math.pi;
                var currentSelection = normalizedAngle / (2 * math.pi);
                currentSelection = currentSelection.clamp(0.0, 1.0);
                store.setLampColorTemp(currentSelection);
              },
              child: CustomPaint(
                size: const Size(330, 330),
                painter: _ColorWheelPainter(selector: store.lampColorTemp),
              ),
            ),
            Container(
              width: 172,
              height: 172,
              decoration: const BoxDecoration(
                color: LightColorTokens.background,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/bong_den.jpg', width: 74),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.icon,
    required this.value,
    required this.percentLabel,
    required this.onChanged,
  });

  final IconData icon;
  final double value;
  final String percentLabel;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 30, color: const Color(0xFF555555)),
        const SizedBox(width: 10),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 9,
              activeTrackColor: LightColorTokens.primary,
              inactiveTrackColor: const Color(0xFFE5E5E5),
              thumbColor: Colors.white,
              overlayColor: Colors.transparent,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13),
            ),
            child: Slider(value: value, onChanged: onChanged),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 56,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              percentLabel,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3A3A),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class _LampWhiteArcPainter extends CustomPainter {
  _LampWhiteArcPainter({required this.position});

  final double position;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.42;
    const start = math.pi * 0.82;
    const sweep = math.pi * 1.36;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 48
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        startAngle: start,
        endAngle: start + sweep,
        colors: [Color(0xFFF6DA93), Color(0xFFEDEDEB), Color(0xFFC9CEEF)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      paint,
    );

    final angle = start + sweep * position;
    final p = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
    canvas.drawCircle(p, 24, Paint()..color = Colors.white);
    canvas.drawCircle(
      p,
      24,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = const Color(0xFFF6E7BB),
    );
  }

  @override
  bool shouldRepaint(covariant _LampWhiteArcPainter oldDelegate) =>
      oldDelegate.position != position;
}

class _ColorWheelPainter extends CustomPainter {
  _ColorWheelPainter({required this.selector});

  final double selector;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.42;
    final ringRect = Rect.fromCircle(center: center, radius: radius);
    final wheelPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 58
      ..shader = SweepGradient(
        colors: List<Color>.generate(
          13,
          (i) => HSVColor.fromAHSV(1, i * 30, 1, 1).toColor(),
        ),
      ).createShader(ringRect);
    canvas.drawCircle(center, radius, wheelPaint);

    final angle = -math.pi / 2 + selector * math.pi * 2;
    final p = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
    canvas.drawCircle(p, 26, Paint()..color = Colors.white);
    canvas.drawCircle(
      p,
      26,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = const Color(0xFF1840EF),
    );

    final tickPaint = Paint()
      ..color = const Color(0xFFBDBDBD)
      ..strokeWidth = 2;
    for (var i = 0; i < 36; i++) {
      final a = (math.pi * 2 / 36) * i;
      final r1 = radius + 36;
      final r2 = radius + 42;
      canvas.drawLine(
        Offset(center.dx + math.cos(a) * r1, center.dy + math.sin(a) * r1),
        Offset(center.dx + math.cos(a) * r2, center.dy + math.sin(a) * r2),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ColorWheelPainter oldDelegate) =>
      oldDelegate.selector != selector;
}
