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
      'relayOn': true,
      'isOnline': true,
      'lastSeenAt': '2026-04-01T08:00:00.000Z',
      'latestTelemetry': {
        'voltage': 220.5,
        'current': 0.42,
        'activePower': 91.8,
        'energyKwh': 1.7,
        'frequency': 50.0,
        'powerFactor': 0.96,
        'relayOn': true,
        'recordedAt': '2026-04-01T08:00:00.000Z',
      },
    },
  ];
  final history = {
    'demo-power-node-01': [
      {
        'bucket': '2026-03-30T08:00:00.000Z',
        'activePower': 45.0,
        'energyKwh': 1.2,
      },
      {
        'bucket': '2026-03-31T08:00:00.000Z',
        'activePower': 52.0,
        'energyKwh': 1.5,
      },
      {
        'bucket': '2026-04-01T08:00:00.000Z',
        'activePower': 60.0,
        'energyKwh': 1.8,
      },
    ],
  };
  final summary = {
    'deviceCount': 1,
    'totalEnergyKwh': 1.8,
    'devices': [
      {
        'deviceId': 'demo-power-node-01',
        'name': 'Smart Power Node',
        'consumedEnergyKwh': 1.8,
      },
    ],
  };

  testWidgets('Reports dashboard renders real summary sections', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(
        initialRoute: AppRoutes.reportsDashboard,
        authSessionStore: FakeAuthSessionStore(seededSession: seededSession),
        apiClient: FakeSmartifyApiClient(
          devices: devices,
          historyByDeviceId: history,
          reportSummary: summary,
        ),
      ),
    );
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 700),
    );

    expect(find.text('My Home'), findsOneWidget);
    expect(find.text('This range'), findsOneWidget);
    expect(find.text('Statistics'), findsOneWidget);
    expect(find.text('Devices'), findsAtLeastNWidgets(1));
    expect(find.text('Smart Power Node'), findsOneWidget);
  });

  testWidgets('Device detail report shows bill cards for seeded device', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(
        initialRoute: AppRoutes.reportsDeviceDetail,
        authSessionStore: FakeAuthSessionStore(seededSession: seededSession),
        apiClient: FakeSmartifyApiClient(
          devices: devices,
          historyByDeviceId: history,
          reportSummary: summary,
        ),
        onGenerateInitialRoutes: (_) => [
          AppRouter.onGenerateRoute(
            const RouteSettings(
              name: AppRoutes.reportsDeviceDetail,
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

    expect(find.text('Smart Power Node (1)'), findsOneWidget);
    expect(find.text('Living Room'), findsOneWidget);
  });
}
