import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_home_management_screen.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';

void main() {
  testWidgets('Home management opens the tapped home detail', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AccountSettingsStore(),
        child: MaterialApp(
          home: const AccountHomeManagementScreen(),
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Home Management'), findsOneWidget);
    expect(find.text('Office'), findsOneWidget);

    await tester.tap(find.text('Office'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('My Home'), findsOneWidget);
    expect(find.text('Office'), findsOneWidget);
    expect(find.text('456 Business Ave, New York, NY 10002'), findsOneWidget);
  });
}
