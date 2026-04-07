import 'package:flutter/material.dart';

class SettingsFlagIcon extends StatelessWidget {
  const SettingsFlagIcon({
    super.key,
    required this.flagCode,
    this.width = 60,
    this.height = 40,
  });

  final String flagCode;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _FlagPainter(flagCode),
    );
  }
}

class _FlagPainter extends CustomPainter {
  const _FlagPainter(this.flagCode);

  final String flagCode;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final clip = RRect.fromRectAndRadius(rect, const Radius.circular(4));
    canvas.clipRRect(clip);

    switch (flagCode) {
      case 'us':
        _paintUnitedStates(canvas, size);
        break;
      case 'uk':
        _paintUnitedKingdom(canvas, size);
        break;
      case 'cn':
        _paintChina(canvas, size);
        break;
      case 'es':
        _paintSpain(canvas, size);
        break;
      case 'in':
        _paintIndia(canvas, size);
        break;
      case 'fr':
        _paintFrance(canvas, size);
        break;
      case 'ae':
        _paintUnitedArabEmirates(canvas, size);
        break;
      case 'ru':
        _paintRussia(canvas, size);
        break;
      case 'jp':
        _paintJapan(canvas, size);
        break;
      default:
        _paintSolid(canvas, size, const Color(0xFFE5E7EB));
    }
  }

  void _paintUnitedStates(Canvas canvas, Size size) {
    final stripeHeight = size.height / 7;
    for (var i = 0; i < 7; i++) {
      _paintSolid(
        canvas,
        Size(size.width, stripeHeight),
        i.isEven ? const Color(0xFFFF3B30) : Colors.white,
        offset: Offset(0, stripeHeight * i),
      );
    }
    _paintSolid(
      canvas,
      Size(size.width * 0.42, size.height * 0.54),
      const Color(0xFF2557A7),
    );
    final star = Paint()..color = Colors.white;
    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 4; col++) {
        canvas.drawCircle(
          Offset(8 + col * 6.5, 6 + row * 6.5),
          1.3,
          star,
        );
      }
    }
  }

  void _paintUnitedKingdom(Canvas canvas, Size size) {
    _paintSolid(canvas, size, const Color(0xFF1D4FA3));
    final white = Paint()
      ..color = Colors.white
      ..strokeWidth = size.height * 0.22;
    final red = Paint()
      ..color = const Color(0xFFE53935)
      ..strokeWidth = size.height * 0.1;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), white);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), white);
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), red);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), red);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.4, 0, size.width * 0.2, size.height),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.38, size.width, size.height * 0.24),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.44, 0, size.width * 0.12, size.height),
      Paint()..color = const Color(0xFFE53935),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.42, size.width, size.height * 0.16),
      Paint()..color = const Color(0xFFE53935),
    );
  }

  void _paintChina(Canvas canvas, Size size) {
    _paintSolid(canvas, size, const Color(0xFFFF3B30));
    final yellow = Paint()..color = const Color(0xFFFFD54F);
    canvas.drawCircle(Offset(size.width * 0.24, size.height * 0.24), 5, yellow);
    for (final offset in [
      Offset(size.width * 0.42, size.height * 0.13),
      Offset(size.width * 0.48, size.height * 0.26),
      Offset(size.width * 0.48, size.height * 0.4),
      Offset(size.width * 0.42, size.height * 0.52),
    ]) {
      canvas.drawCircle(offset, 2.1, yellow);
    }
  }

  void _paintSpain(Canvas canvas, Size size) {
    _paintSolid(canvas, size, const Color(0xFFE53935));
    _paintSolid(
      canvas,
      Size(size.width, size.height * 0.5),
      const Color(0xFFFFD54F),
      offset: Offset(0, size.height * 0.25),
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.16, size.height * 0.34, 10, 11),
      Paint()..color = const Color(0xFFB71C1C),
    );
  }

  void _paintIndia(Canvas canvas, Size size) {
    _paintSolid(canvas, Size(size.width, size.height / 3), const Color(0xFFFF6F3D));
    _paintSolid(
      canvas,
      Size(size.width, size.height / 3),
      Colors.white,
      offset: Offset(0, size.height / 3),
    );
    _paintSolid(
      canvas,
      Size(size.width, size.height / 3),
      const Color(0xFF1E9E5A),
      offset: Offset(0, size.height * 2 / 3),
    );
    final wheel = Paint()
      ..color = const Color(0xFF2952A3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 5.3, wheel);
    canvas.drawCircle(center, 1.3, Paint()..color = const Color(0xFF2952A3));
  }

  void _paintFrance(Canvas canvas, Size size) {
    _paintSolid(canvas, Size(size.width / 3, size.height), const Color(0xFF1F4FBF));
    _paintSolid(
      canvas,
      Size(size.width / 3, size.height),
      Colors.white,
      offset: Offset(size.width / 3, 0),
    );
    _paintSolid(
      canvas,
      Size(size.width / 3, size.height),
      const Color(0xFFE53935),
      offset: Offset(size.width * 2 / 3, 0),
    );
  }

  void _paintUnitedArabEmirates(Canvas canvas, Size size) {
    _paintSolid(canvas, Size(size.width * 0.25, size.height), const Color(0xFFE53935));
    _paintSolid(
      canvas,
      Size(size.width * 0.75, size.height / 3),
      const Color(0xFF1FA15B),
      offset: Offset(size.width * 0.25, 0),
    );
    _paintSolid(
      canvas,
      Size(size.width * 0.75, size.height / 3),
      Colors.white,
      offset: Offset(size.width * 0.25, size.height / 3),
    );
    _paintSolid(
      canvas,
      Size(size.width * 0.75, size.height / 3),
      Colors.black,
      offset: Offset(size.width * 0.25, size.height * 2 / 3),
    );
  }

  void _paintRussia(Canvas canvas, Size size) {
    _paintSolid(canvas, Size(size.width, size.height / 3), Colors.white);
    _paintSolid(
      canvas,
      Size(size.width, size.height / 3),
      const Color(0xFF2557A7),
      offset: Offset(0, size.height / 3),
    );
    _paintSolid(
      canvas,
      Size(size.width, size.height / 3),
      const Color(0xFFE53935),
      offset: Offset(0, size.height * 2 / 3),
    );
  }

  void _paintJapan(Canvas canvas, Size size) {
    _paintSolid(canvas, size, Colors.white);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.height * 0.24,
      Paint()..color = const Color(0xFFFF3B30),
    );
  }

  void _paintSolid(
    Canvas canvas,
    Size size,
    Color color, {
    Offset offset = Offset.zero,
  }) {
    canvas.drawRect(
      Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _FlagPainter oldDelegate) {
    return oldDelegate.flagCode != flagCode;
  }
}
