import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartify_flutter/app/router/app_router.dart';

import 'test_support/test_app.dart';

void main() {
  testWidgets('App boots to the signed-out splash flow', (tester) async {
    await tester.pumpWidget(buildTestApp(initialRoute: AppRoutes.home));
    await pumpForTransition(tester);

    expect(find.text('Smartify'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
