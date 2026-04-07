import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartify_flutter/app/router/app_router.dart';

import 'test_support/test_app.dart';

void main() {
  testWidgets('Smart dashboard shows automation list by default', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(initialRoute: AppRoutes.smartScenesDashboard),
    );
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 700),
    );

    expect(find.text('My Home'), findsOneWidget);
    expect(find.text('Automation'), findsOneWidget);
    expect(find.text('Tap-to-Run'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Switching to tap-to-run shows action tiles', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(initialRoute: AppRoutes.smartScenesDashboard),
    );
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 700),
    );

    await tester.tap(find.text('Tap-to-Run'));
    await pumpForTransition(tester);

    expect(find.text('Bedtime Prep'), findsOneWidget);
    expect(find.text('Evening Chill'), findsOneWidget);
  });

  testWidgets('Create-scene flow reaches the editor', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(initialRoute: AppRoutes.smartScenesDashboard),
    );
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 700),
    );

    await tester.tap(find.byType(FloatingActionButton));
    await pumpForTransition(tester);

    expect(find.text('Create Scene'), findsOneWidget);
    expect(find.text('Add Task'), findsOneWidget);
  });
}
