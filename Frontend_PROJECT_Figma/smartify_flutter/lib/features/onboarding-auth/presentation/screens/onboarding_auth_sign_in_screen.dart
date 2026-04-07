import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_labeled_field.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_loading_button.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_scaffold.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/welcome_social_button.dart';
import 'package:smartify_flutter/features/onboarding-auth/state/onboarding_auth_store.dart';

class OnboardingAuthSignInScreen extends StatefulWidget {
  const OnboardingAuthSignInScreen({super.key});

  @override
  State<OnboardingAuthSignInScreen> createState() =>
      _OnboardingAuthSignInScreenState();
}

class _OnboardingAuthSignInScreenState
    extends State<OnboardingAuthSignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  var _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final store = context.read<OnboardingAuthStore>();
    _emailController = TextEditingController(text: store.signInEmail);
    _passwordController = TextEditingController(text: store.signInPassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<OnboardingAuthStore>();

    return AuthScaffold(
      onBack: () => Navigator.pop(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthMotionSection(
              child: Text(
                'Welcome Back! 👋',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            const SizedBox(height: 8),
            AuthMotionSection(
              delay: const Duration(milliseconds: 60),
              child: Text(
                'Your Smart Home, Your Rules.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 30),
            AuthLabeledField(
              label: 'Email',
              hintText: 'Email',
              controller: _emailController,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: Color(0xFF7A7F8E),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: store.setSignInEmail,
              errorText: store.signInError,
              enabled: !store.signInLoading && !store.socialLoading,
            ),
            const SizedBox(height: LightThemeData.spacingL),
            AuthLabeledField(
              label: 'Password',
              hintText: 'Password',
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
              textInputAction: TextInputAction.done,
              onChanged: store.setSignInPassword,
              enabled: !store.signInLoading && !store.socialLoading,
            ),
            const SizedBox(height: 14),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: store.rememberMe,
                      onChanged: store.signInLoading || store.socialLoading
                          ? null
                          : (value) => store.setRememberMe(value ?? false),
                    ),
                    Text(
                      'Remember me',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: store.signInLoading || store.socialLoading
                      ? null
                      : () => Navigator.pushNamed(
                          context,
                          AppRoutes.onboardingAuthForgotPassword,
                        ),
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(child: Divider(color: LightColorTokens.border)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: LightColorTokens.textSecondary,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: LightColorTokens.border)),
              ],
            ),
            const SizedBox(height: 18),
            WelcomeSocialButton(
              provider: 'Google',
              loading:
                  store.socialLoading && store.socialProviderLabel == 'Google',
              onTap: () async {
                final ok = await store.submitSocialAuth('Google');
                if (!context.mounted || ok) return;
              },
            ),
            const SizedBox(height: 12),
            WelcomeSocialButton(
              provider: 'Apple',
              loading:
                  store.socialLoading && store.socialProviderLabel == 'Apple',
              onTap: () async {
                final ok = await store.submitSocialAuth('Apple');
                if (!context.mounted || ok) return;
              },
            ),
            const SizedBox(height: 12),
            WelcomeSocialButton(
              provider: 'Facebook',
              loading:
                  store.socialLoading &&
                  store.socialProviderLabel == 'Facebook',
              onTap: () async {
                final ok = await store.submitSocialAuth('Facebook');
                if (!context.mounted || ok) return;
              },
            ),
            const SizedBox(height: 24),
            AuthLoadingButton(
              label: 'Sign in',
              loading: store.signInLoading,
              enabled: store.canSubmitSignIn,
              onTap: () async {
                final ok = await store.submitSignIn();
                if (!context.mounted || !ok) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
