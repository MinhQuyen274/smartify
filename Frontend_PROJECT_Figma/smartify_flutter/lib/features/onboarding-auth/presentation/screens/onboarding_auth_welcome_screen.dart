import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/welcome_auth_actions.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/welcome_social_button.dart';
import 'package:smartify_flutter/features/onboarding-auth/state/onboarding_auth_store.dart';

class OnboardingAuthWelcomeScreen extends StatefulWidget {
  const OnboardingAuthWelcomeScreen({super.key});

  @override
  State<OnboardingAuthWelcomeScreen> createState() =>
      _OnboardingAuthWelcomeScreenState();
}

class _OnboardingAuthWelcomeScreenState
    extends State<OnboardingAuthWelcomeScreen> {
  static const List<String> _providers = [
    'Google',
    'Apple',
    'Facebook',
    'X',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<OnboardingAuthStore>().clearSocialState();
      }
    });
  }

  Future<void> _handleSocialTap(String provider) async {
    final store = context.read<OnboardingAuthStore>();
    if (!mounted) return;
    await store.submitSocialAuth(provider);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<OnboardingAuthStore>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final topSpacing = constraints.maxHeight > 760 ? 52.0 : 28.0;
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: topSpacing),
                      const AuthMotionSection(
                        child: Center(
                          child: Image(
                            // Fixed: Using the correct mark to match design exactly
                            image: AssetImage(
                              'assets/png/smartify_logo_mark_exact.png',
                            ),
                            width: 134,
                            height: 48,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      AuthMotionSection(
                        delay: const Duration(milliseconds: 40),
                        child: Text(
                          'Let\'s Get Started!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.8,
                              ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AuthMotionSection(
                        delay: const Duration(milliseconds: 80),
                        child: Text(
                          'Let\'s dive in into your account',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: LightColorTokens.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 34),
                      for (var i = 0; i < _providers.length; i++) ...[
                        AuthMotionSection(
                          delay: Duration(milliseconds: 120 + (i * 35)),
                          child: WelcomeSocialButton(
                            provider: _providers[i],
                            loading:
                                store.socialLoading &&
                                store.socialProviderLabel == _providers[i],
                            onTap: () => _handleSocialTap(_providers[i]),
                          ),
                        ),
                        if (i != _providers.length - 1)
                          const SizedBox(height: 14),
                      ],
                      if (store.socialError != null) ...[
                        const SizedBox(height: 14),
                        Text(
                          store.socialError!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: LightColorTokens.error),
                        ),
                      ],
                      const SizedBox(height: 36),
                      WelcomeAuthActions(
                        busy: store.socialLoading,
                        onSignUp: () => Navigator.pushNamed(
                          context,
                          AppRoutes.onboardingAuthSignUp,
                        ),
                        onSignIn: () => Navigator.pushNamed(
                          context,
                          AppRoutes.onboardingAuthSignIn,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
