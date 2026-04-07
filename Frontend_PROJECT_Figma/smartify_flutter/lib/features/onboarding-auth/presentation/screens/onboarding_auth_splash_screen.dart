import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';
import 'package:smartify_flutter/features/onboarding-auth/state/onboarding_auth_store.dart';

class OnboardingAuthSplashScreen extends StatefulWidget {
  const OnboardingAuthSplashScreen({super.key});

  @override
  State<OnboardingAuthSplashScreen> createState() =>
      _OnboardingAuthSplashScreenState();
}

class _OnboardingAuthSplashScreenState
    extends State<OnboardingAuthSplashScreen> {
  static const Color _splashBlue = Color(0xFF4A68F6);

  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    context.read<OnboardingAuthStore>().resetWalkthrough();
    _redirectTimer = Timer(const Duration(milliseconds: 1300), () {
      if (!mounted) {
        return;
      }
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.onboardingAuthWalkthrough,
      );
    });
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _splashBlue,
        body: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.08),
              child: AuthMotionSection(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/png/smartify_logo_mark_exact.png',
                      width: 160,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Smartify',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment(0, 0.72),
              child: SizedBox(
                width: 54,
                height: 54,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: Colors.white,
                  backgroundColor: Color(0x4DFFFFFF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
