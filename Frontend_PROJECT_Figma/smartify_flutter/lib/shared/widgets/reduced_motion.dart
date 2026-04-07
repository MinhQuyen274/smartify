import 'package:flutter/material.dart';

class ReducedMotion {
  const ReducedMotion._();

  static bool enabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }
}
