import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_labeled_field.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_loading_button.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_scaffold.dart';
import 'package:smartify_flutter/features/onboarding-auth/state/onboarding_auth_store.dart';

class OnboardingAuthResetPasswordScreen extends StatefulWidget {
  const OnboardingAuthResetPasswordScreen({super.key});

  @override
  State<OnboardingAuthResetPasswordScreen> createState() =>
      _OnboardingAuthResetPasswordScreenState();
}

class _OnboardingAuthResetPasswordScreenState
    extends State<OnboardingAuthResetPasswordScreen> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmController;
  var _obscurePassword = true;
  var _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    final store = context.read<OnboardingAuthStore>();
    _passwordController = TextEditingController(text: store.resetPassword);
    _confirmController = TextEditingController(
      text: store.resetConfirmPassword,
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
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
              'Secure Your Account 🔒',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          const SizedBox(height: 12),
          AuthMotionSection(
            delay: const Duration(milliseconds: 60),
            child: Text(
              'Almost there! Create a new password for your Smartify account to keep it secure. Remember to choose a strong and unique password.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 28),
          AuthLabeledField(
            label: 'New Password',
            hintText: 'New Password',
            controller: _passwordController,
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFF7A7F8E),
            ),
            suffixIcon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF7A7F8E),
            ),
            onSuffixTap: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            obscureText: _obscurePassword,
            onChanged: store.setResetPassword,
            errorText: store.resetError,
            enabled: !store.resetLoading,
          ),
          const SizedBox(height: LightThemeData.spacingL),
          AuthLabeledField(
            label: 'Confirm New Password',
            hintText: 'Confirm New Password',
            controller: _confirmController,
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFF7A7F8E),
            ),
            suffixIcon: Icon(
              _obscureConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF7A7F8E),
            ),
            onSuffixTap: () =>
                setState(() => _obscureConfirm = !_obscureConfirm),
            obscureText: _obscureConfirm,
            onChanged: store.setResetConfirmPassword,
            enabled: !store.resetLoading,
          ),
          const Spacer(),
          AuthLoadingButton(
            label: 'Save New Password',
            loading: store.resetLoading,
            enabled: store.canSubmitReset,
            onTap: () async {
              final ok = await store.submitResetPassword();
              if (!context.mounted || !ok) return;
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.onboardingAuthResetSuccess,
              );
            },
          ),
          const SizedBox(height: LightThemeData.spacingS),
        ],
      ),
    );
  }
}
