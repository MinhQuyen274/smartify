import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_labeled_field.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_loading_button.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_scaffold.dart';
import 'package:smartify_flutter/features/onboarding-auth/state/onboarding_auth_store.dart';

class OnboardingAuthForgotPasswordScreen extends StatefulWidget {
  const OnboardingAuthForgotPasswordScreen({super.key});

  @override
  State<OnboardingAuthForgotPasswordScreen> createState() =>
      _OnboardingAuthForgotPasswordScreenState();
}

class _OnboardingAuthForgotPasswordScreenState
    extends State<OnboardingAuthForgotPasswordScreen> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: context.read<OnboardingAuthStore>().forgotEmail,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              'Forgot Your Password? 🔑',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          const SizedBox(height: 12),
          AuthMotionSection(
            delay: const Duration(milliseconds: 60),
            child: Text(
              'We\'ve got you covered. Enter your registered email to reset your password. We will send an OTP code to your email for the next steps.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 34),
          AuthLabeledField(
            label: 'Your Registered Email',
            hintText: 'andrew.ainsley@yourdomain.com',
            controller: _emailController,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: Color(0xFF7A7F8E),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: store.setForgotEmail,
            errorText: store.forgotError,
            enabled: !store.forgotLoading,
          ),
          const Spacer(),
          AuthLoadingButton(
            label: 'Send OTP Code',
            loading: store.forgotLoading,
            enabled: store.canSubmitForgot,
            onTap: () async {
              final ok = await store.submitForgotPassword();
              if (!context.mounted || !ok) return;
              Navigator.pushNamed(context, AppRoutes.onboardingAuthOtp);
            },
          ),
          const SizedBox(height: LightThemeData.spacingS),
        ],
      ),
    );
  }
}
