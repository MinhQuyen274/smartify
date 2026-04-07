import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/core/state/auth_session_store.dart';
import 'package:smartify_flutter/features/home-devices/presentation/screens/my_home_dashboard_screen.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/screens/onboarding_auth_splash_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authStore = context.watch<AuthSessionStore>();

    if (authStore.status == AuthSessionStatus.initializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authStore.status == AuthSessionStatus.signedIn) {
      return const MyHomeDashboardScreen();
    }

    return const OnboardingAuthSplashScreen();
  }
}
