import 'package:flutter/animation.dart';

class MotionTokens {
  const MotionTokens._();

  static const Duration tap = Duration(milliseconds: 110);
  static const Duration micro = Duration(milliseconds: 200);
  static const Duration cardTransition = Duration(milliseconds: 240);
  static const Duration pageForward = Duration(milliseconds: 320);
  static const Duration pageBackward = Duration(milliseconds: 220);
  static const Duration sheetEnter = Duration(milliseconds: 280);
  static const Duration sheetExit = Duration(milliseconds: 180);

  static const Curve standard = Cubic(0.2, 0, 0, 1);
  static const Curve decelerate = Cubic(0.0, 0.0, 0.0, 1.0);
  static const Curve accelerate = Cubic(0.3, 0.0, 1.0, 1.0);
}
