import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_scaffold.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/otp_code_field.dart';
import 'package:smartify_flutter/features/onboarding-auth/state/onboarding_auth_store.dart';

class OnboardingAuthOtpScreen extends StatefulWidget {
  const OnboardingAuthOtpScreen({super.key});

  @override
  State<OnboardingAuthOtpScreen> createState() =>
      _OnboardingAuthOtpScreenState();
}

class _OnboardingAuthOtpScreenState extends State<OnboardingAuthOtpScreen> {
  late final TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController(
      text: context.read<OnboardingAuthStore>().otpCode,
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<OnboardingAuthStore>();

    return AuthScaffold(
      onBack: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthMotionSection(
            child: Text(
              'Enter OTP Code 🔐',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          const SizedBox(height: 12),
          AuthMotionSection(
            delay: const Duration(milliseconds: 60),
            child: Text(
              'Please check your email inbox for a message from Smartify. Enter the one-time verification code below.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 28),
          OtpCodeField(
            length: OnboardingAuthStore.otpLength,
            controller: _otpController,
            errorText: store.otpError,
            onChanged: store.setOtpCode,
          ),
          const SizedBox(height: 22),
          Text(
            'You can resend the code in 56 seconds',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: LightColorTokens.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: store.otpLoading ? null : () => store.setOtpCode(''),
            child: const Text('Resend code'),
          ),
          const Spacer(),
          FilledButton(
            onPressed: store.canSubmitOtp
                ? () async {
                    final ok = await store.submitOtp();
                    if (!context.mounted || !ok) return;
                    Navigator.pushNamed(
                      context,
                      AppRoutes.onboardingAuthResetPassword,
                    );
                  }
                : null,
            style: FilledButton.styleFrom(
              backgroundColor: LightColorTokens.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text('Continue'),
          ),
          const SizedBox(height: LightThemeData.spacingS),
        ],
      ),
    );
  }
}
