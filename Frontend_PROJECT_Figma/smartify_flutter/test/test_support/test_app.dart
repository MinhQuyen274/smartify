import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/network/smartify_api_client.dart';
import 'package:smartify_flutter/core/network/smartify_socket_service.dart';
import 'package:smartify_flutter/core/state/app_flow_store.dart';
import 'package:smartify_flutter/core/state/auth_session_store.dart';
import 'package:smartify_flutter/core/state/selection_store.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';
import 'package:smartify_flutter/features/home-devices/state/home_devices_store.dart';
import 'package:smartify_flutter/features/onboarding-auth/state/onboarding_auth_store.dart';
import 'package:smartify_flutter/features/reports/state/reports_store.dart';
import 'package:smartify_flutter/features/screen-mapping/screen_manifest.dart';
import 'package:smartify_flutter/features/smart-scenes/state/smart_scenes_store.dart';

import 'fake_runtime.dart';

Widget buildTestApp({
  String initialRoute = AppRoutes.home,
  AuthSessionStore? authSessionStore,
  SmartifyApiClient? apiClient,
  SmartifySocketService? socketService,
  RouteFactory? onGenerateRoute,
  List<NavigatorObserver> navigatorObservers = const [],
  List<Route<dynamic>> Function(String initialRoute)? onGenerateInitialRoutes,
}) {
  final resolvedApiClient = apiClient ?? FakeSmartifyApiClient();
  final resolvedSocketService = socketService ?? FakeSmartifySocketService();
  final resolvedAuthStore = authSessionStore ?? FakeAuthSessionStore();

  return MultiProvider(
    providers: [
      Provider<SmartifyApiClient>.value(value: resolvedApiClient),
      Provider<SmartifySocketService>.value(value: resolvedSocketService),
      ChangeNotifierProvider(create: (_) => AppFlowStore()),
      ChangeNotifierProvider<AuthSessionStore>.value(value: resolvedAuthStore),
      ChangeNotifierProvider(create: (_) => SelectionStore()),
      ChangeNotifierProxyProvider<AuthSessionStore, OnboardingAuthStore>(
        create: (_) => OnboardingAuthStore(),
        update: (_, session, store) => store!..bindDependencies(session),
      ),
      ChangeNotifierProxyProvider3<
        AuthSessionStore,
        SmartifyApiClient,
        SmartifySocketService,
        HomeDevicesStore
      >(
        create: (_) => HomeDevicesStore(),
        update: (_, session, client, socket, store) =>
            store!..bindDependencies(session, client, socket),
      ),
      ChangeNotifierProvider(create: (_) => SmartScenesStore()),
      ChangeNotifierProxyProvider3<
        AuthSessionStore,
        SmartifyApiClient,
        SmartifySocketService,
        ReportsStore
      >(
        create: (_) => ReportsStore(),
        update: (_, session, client, socket, store) =>
            store!..bindDependencies(session, client, socket),
      ),
      ChangeNotifierProvider(create: (_) => AccountSettingsStore()),
      ChangeNotifierProvider(create: (_) => ScreenManifestStore()),
    ],
    child: MaterialApp(
      theme: LightThemeData.theme,
      onGenerateRoute: onGenerateRoute ?? AppRouter.onGenerateRoute,
      initialRoute: initialRoute,
      navigatorObservers: navigatorObservers,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    ),
  );
}

Future<void> pumpForAppStart(
  WidgetTester tester, {
  Duration duration = const Duration(milliseconds: 1600),
}) async {
  await tester.pump();
  await tester.pump(duration);
}

Future<void> pumpForTransition(
  WidgetTester tester, {
  Duration duration = const Duration(milliseconds: 400),
}) async {
  await tester.pump();
  await tester.pump(duration);
}
