import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartify_flutter/app/router/app_router.dart';

import 'test_support/test_app.dart';

void main() {
  testWidgets('Welcome route resolves with social auth actions', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(initialRoute: AppRoutes.onboardingAuthWelcome),
    );
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 700),
    );

    expect(find.text('Let\'s Get Started!'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);
    expect(find.text('Continue with Facebook'), findsOneWidget);
  });
}
