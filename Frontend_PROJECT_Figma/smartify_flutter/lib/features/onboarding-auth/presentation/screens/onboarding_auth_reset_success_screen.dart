import 'package:flutter/material.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';

class OnboardingAuthResetSuccessScreen extends StatelessWidget {
  const OnboardingAuthResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Spacer(),
              const Image(
                image: AssetImage(
                  'assets/png/reset_success_illustration_exact.png',
                ),
                width: 138,
                height: 138,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 28),
              Text(
                'You\'re All Set!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Your password has been successfully changed.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: LightColorTokens.textSecondary,
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.onboardingAuthSignIn,
                    (_) => false,
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: LightColorTokens.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(29),
                  ),
                ),
                child: const Text('Go to Homepage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
