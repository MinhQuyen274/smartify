import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColorTokens.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, size: 32),
              ),
            ),
            const SizedBox(height: 46),
            const Text(
              'We are listening...',
              style: TextStyle(fontSize: 17, color: Color(0xFF555555)),
            ),
            const SizedBox(height: 6),
            const Text(
              'What do you want to do?',
              style: TextStyle(fontSize: 20, color: Color(0xFF3C3C3C)),
            ),
            const SizedBox(height: 34),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                '"Turn on all the lights in the entire room"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF24262E),
                  height: 1.45,
                ),
              ),
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: _animCtrl,
              builder: (context, _) {
                return SizedBox(
                  width: double.infinity,
                  height: 190,
                  child: CustomPaint(painter: _VoiceWavePainter(time: _animCtrl.value * 2 * math.pi)),
                );
              },
            ),
            const SizedBox(height: 52),
            AnimatedBuilder(
              animation: _animCtrl,
              builder: (context, child) {
                final scale = 1.0 + 0.05 * math.sin(_animCtrl.value * 2 * math.pi * 2);
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFF63D6FF),
                      Color(0xFF1F6EFF),
                      Color(0xFF1E1E85),
                    ],
                    stops: [0.06, 0.55, 1],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF289CFF).withValues(alpha: 0.35),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.multitrack_audio_rounded, color: Colors.white, size: 68),
              ),
            ),
            const SizedBox(height: 74),
          ],
        ),
      ),
    );
  }
}

class _VoiceWavePainter extends CustomPainter {
  _VoiceWavePainter({required this.time});
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height * 0.56;
    final amplitudes = [28.0, 52.0, 78.0, 44.0, 26.0];
    final colors = [
      const Color(0xFF7B3BFF),
      const Color(0xFF34A6FF),
      const Color(0xFF3F62FF),
      const Color(0xFF7BC043),
      const Color(0xFFFFB129),
    ];

    for (var i = 0; i < amplitudes.length; i++) {
      final paint = Paint()
        ..color = colors[i].withValues(alpha: 0.95)
        ..style = PaintingStyle.fill;
      final path = Path();
      final frequency = 2 + i * 0.8;
      // Pulse animation
      final baseAmp = amplitudes[i];
      final amp = baseAmp + math.sin(time * (1.0 + i * 0.2)) * (baseAmp * 0.3);
      final phase = time * (1.5 + i * 0.3);

      path.moveTo(0, centerY);
      for (double x = 0; x <= size.width; x += 2) {
        final angle = (x / size.width) * math.pi * frequency + phase;
        final envelope = 0.4 + 0.6 * math.sin((x / size.width) * math.pi);
        final y = centerY + math.sin(angle) * amp * envelope;
        path.lineTo(x, y);
      }
      path.lineTo(size.width, centerY);
      path.close();
      canvas.drawPath(path, paint);
    }

    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF8E8EFF), Color(0xFF66D1FF), Color(0xFF8E8EFF)],
      ).createShader(Rect.fromLTWH(0, centerY - 2, size.width, 4))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), linePaint);
  }

  @override
  bool shouldRepaint(covariant _VoiceWavePainter oldDelegate) => oldDelegate.time != time;
}
