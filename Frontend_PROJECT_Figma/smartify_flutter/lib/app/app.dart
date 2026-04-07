import 'package:flutter/material.dart';
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

class SmartifyApp extends StatelessWidget {
  const SmartifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => SmartifyApiClient()),
        Provider(create: (_) => SmartifySocketService()),
        ChangeNotifierProvider(create: (_) => AppFlowStore()),
        ChangeNotifierProvider(
          create: (context) => AuthSessionStore(context.read<SmartifyApiClient>()),
        ),
        ChangeNotifierProvider(create: (_) => SelectionStore()),
        ChangeNotifierProxyProvider<AuthSessionStore, OnboardingAuthStore>(
          create: (_) => OnboardingAuthStore(),
          update: (_, session, store) => store!..bindDependencies(session),
        ),
        ChangeNotifierProxyProvider3<
            AuthSessionStore,
            SmartifyApiClient,
            SmartifySocketService,
            HomeDevicesStore>(
          create: (_) => HomeDevicesStore(),
          update: (_, session, apiClient, socketService, store) =>
              store!..bindDependencies(session, apiClient, socketService),
        ),
        ChangeNotifierProvider(create: (_) => SmartScenesStore()),
        ChangeNotifierProxyProvider3<
            AuthSessionStore,
            SmartifyApiClient,
            SmartifySocketService,
            ReportsStore>(
          create: (_) => ReportsStore(),
          update: (_, session, apiClient, socketService, store) =>
              store!..bindDependencies(session, apiClient, socketService),
        ),
        ChangeNotifierProvider(create: (_) => AccountSettingsStore()),
        ChangeNotifierProvider(create: (_) => ScreenManifestStore()..load()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smartify',
        themeMode: ThemeMode.light,
        theme: LightThemeData.theme,
        darkTheme: LightThemeData.theme,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRoutes.home,
      ),
    );
  }
}
