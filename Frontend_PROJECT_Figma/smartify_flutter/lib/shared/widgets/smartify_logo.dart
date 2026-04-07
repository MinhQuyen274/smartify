import 'dart:math' as math;

import 'package:flutter/material.dart';

class SmartifyLogoMark extends StatelessWidget {
  const SmartifyLogoMark({
    super.key,
    this.size = 88,
    this.shellColor = const Color(0xFF4A7DFF),
    this.signalColor = Colors.white,
    this.shadowColor = const Color(0x1F111827),
    this.showShadow = true,
  });

  final double size;
  final Color shellColor;
  final Color signalColor;
  final Color shadowColor;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _SmartifyLogoPainter(
          shellColor: shellColor,
          signalColor: signalColor,
          shadowColor: shadowColor,
          showShadow: showShadow,
        ),
      ),
    );
  }
}

class _SmartifyLogoPainter extends CustomPainter {
  const _SmartifyLogoPainter({
    required this.shellColor,
    required this.signalColor,
    required this.shadowColor,
    required this.showShadow,
  });

  final Color shellColor;
  final Color signalColor;
  final Color shadowColor;
  final bool showShadow;

  @override
  void paint(Canvas canvas, Size size) {
    final shellPath = Path()
      ..moveTo(size.width * 0.50, size.height * 0.08)
      ..quadraticBezierTo(
        size.width * 0.80,
        size.height * 0.20,
        size.width * 0.80,
        size.height * 0.45,
      )
      ..lineTo(size.width * 0.76, size.height * 0.66)
      ..quadraticBezierTo(
        size.width * 0.70,
        size.height * 0.88,
        size.width * 0.50,
        size.height * 0.90,
      )
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.88,
        size.width * 0.24,
        size.height * 0.66,
      )
      ..lineTo(size.width * 0.20, size.height * 0.45)
      ..quadraticBezierTo(
        size.width * 0.20,
        size.height * 0.20,
        size.width * 0.50,
        size.height * 0.08,
      )
      ..close();

    if (showShadow) {
      canvas.drawShadow(shellPath, shadowColor, size.width * 0.06, true);
    }

    canvas.drawPath(shellPath, Paint()..color = shellColor);

    final strokePaint = Paint()
      ..color = signalColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width * 0.5, size.height * 0.60);
    final startAngle = math.pi * 1.12;
    const sweepAngle = math.pi * 0.76;

    for (final factor in [0.54, 0.37, 0.22]) {
      final rect = Rect.fromCenter(
        center: center,
        width: size.width * factor,
        height: size.width * factor * 0.9,
      );
      canvas.drawArc(rect, startAngle, sweepAngle, false, strokePaint);
    }

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.67),
      size.width * 0.035,
      Paint()..color = signalColor,
    );
  }

  @override
  bool shouldRepaint(covariant _SmartifyLogoPainter oldDelegate) {
    return shellColor != oldDelegate.shellColor ||
        signalColor != oldDelegate.signalColor ||
        shadowColor != oldDelegate.shadowColor ||
        showShadow != oldDelegate.showShadow;
  }
}
