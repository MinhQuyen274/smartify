import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';

class WelcomeAuthActions extends StatelessWidget {
  const WelcomeAuthActions({
    super.key,
    required this.busy,
    required this.onSignUp,
    required this.onSignIn,
  });

  final bool busy;
  final VoidCallback onSignUp;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 58,
          child: FilledButton(
            onPressed: busy ? null : onSignUp,
            style: FilledButton.styleFrom(
              backgroundColor: LightColorTokens.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29),
              ),
            ),
            child: Text(
              'Sign up',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: LightThemeData.spacingL),
        SizedBox(
          height: 58,
          child: FilledButton(
            onPressed: busy ? null : onSignIn,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF1F4FE),
              foregroundColor: LightColorTokens.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29),
              ),
            ),
            child: Text(
              'Sign in',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: LightColorTokens.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 6,
          children: [
            const _LegalText(label: 'Privacy Policy'),
            Text(
              '|',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: LightColorTokens.textSecondary,
              ),
            ),
            const _LegalText(label: 'Terms of Service'),
          ],
        ),
      ],
    );
  }
}

class _LegalText extends StatelessWidget {
  const _LegalText({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: LightColorTokens.textSecondary),
    );
  }
}
