import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartify_flutter/app/router/app_router.dart';

import 'test_support/fake_runtime.dart';
import 'test_support/test_app.dart';

void main() {
  final seededSession = FakeAuthSessionStore.demoSession('user@smartify.com');
  final devices = [
    {
      'deviceId': 'demo-power-node-01',
      'name': 'Smart Power Node',
      'type': 'smart-power-node',
      'relayOn': true,
      'isOnline': true,
      'lastSeenAt': '2026-04-01T08:00:00.000Z',
      'latestTelemetry': {
        'relayOn': true,
        'recordedAt': '2026-04-01T08:00:00.000Z',
      },
    },
  ];

  testWidgets('Home dashboard shows device status on unit card', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(
        initialRoute: AppRoutes.homeDevicesDashboard,
        authSessionStore: FakeAuthSessionStore(seededSession: seededSession),
        apiClient: FakeSmartifyApiClient(devices: devices),
      ),
    );
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 700),
    );

    expect(find.text('Smart Power Node'), findsOneWidget);
    expect(find.text('Living Room'), findsNothing);
    expect(find.text('Bedroom'), findsNothing);
    expect(find.text('Unassigned (1)'), findsOneWidget);
  });

  testWidgets('Control lamp screen shows device header', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(
        initialRoute: AppRoutes.homeDevicesControlLamp,
        authSessionStore: FakeAuthSessionStore(seededSession: seededSession),
        apiClient: FakeSmartifyApiClient(devices: devices),
        onGenerateInitialRoutes: (_) => [
          AppRouter.onGenerateRoute(
            const RouteSettings(
              name: AppRoutes.homeDevicesControlLamp,
              arguments: 'demo-power-node-01',
            ),
          ),
        ],
      ),
    );
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 700),
    );

    expect(find.text('Smart Power Node'), findsOneWidget);
    expect(find.text('Unassigned'), findsOneWidget);
  });
}
