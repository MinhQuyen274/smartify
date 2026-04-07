import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartify_flutter/app/router/app_router.dart';

import 'test_support/test_app.dart';

void main() {
  testWidgets('Account profile screen renders main sections', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(initialRoute: AppRoutes.accountProfile),
    );
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 700),
    );

    expect(find.text('My Home'), findsOneWidget);
    expect(find.text('Andrew Ainsley'), findsOneWidget);
    expect(find.text('General'), findsOneWidget);
    expect(find.text('Support'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('Account security screen shows toggles and actions', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(initialRoute: AppRoutes.accountSecurity),
    );
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 700),
    );

    expect(find.text('Account & Security'), findsOneWidget);
    expect(find.byType(Switch), findsAtLeastNWidgets(1));
    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Device Management'), findsOneWidget);
  });

  testWidgets('Linked accounts screen renders provider statuses', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(initialRoute: AppRoutes.accountLinkedAccounts),
    );
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 700),
    );

    expect(find.text('Linked Accounts'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Facebook'), findsOneWidget);
  });
}
