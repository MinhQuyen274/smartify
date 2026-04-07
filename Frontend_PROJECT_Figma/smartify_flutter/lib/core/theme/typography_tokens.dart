import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';

class TypographyTokens {
  const TypographyTokens._();

  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: TextStyle(fontSize: 32, height: 1.2, fontWeight: FontWeight.w700),
      headlineLarge: TextStyle(fontSize: 24, height: 1.25, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(fontSize: 20, height: 1.3, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(fontSize: 18, height: 1.35, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16, height: 1.35, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, height: 1.4, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 12, height: 1.35, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 14, height: 1.2, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontSize: 12, height: 1.2, fontWeight: FontWeight.w500),
    ).apply(
      fontFamily: 'Inter',
      bodyColor: LightColorTokens.textPrimary,
      displayColor: LightColorTokens.textPrimary,
    );
  }
}
