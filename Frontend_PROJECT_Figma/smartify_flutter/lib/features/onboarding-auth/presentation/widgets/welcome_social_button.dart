import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';

class WelcomeSocialButton extends StatelessWidget {
  const WelcomeSocialButton({
    super.key,
    required this.provider,
    required this.loading,
    required this.onTap,
  });

  final String provider;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconAsset = switch (provider) {
      'Google' => 'assets/png/social_google_exact.png',
      'Apple' => 'assets/png/social_apple_exact.png',
      'Facebook' => 'assets/png/social_facebook_exact.png',
      'X' => 'assets/png/social_twitter_exact.png',
      _ => 'assets/png/social_twitter_exact.png',
    };

    return SizedBox(
      height: 58,
      child: OutlinedButton(
        onPressed: loading ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: LightColorTokens.textPrimary,
          side: const BorderSide(color: Color(0xFFE7EBF5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Image.asset(iconAsset, width: 24, height: 24),
              ),
            ),
            Text( // Centered perfectly in the button
              'Continue with $provider',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
