import 'package:flutter/material.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/walkthrough_pager_dots.dart';

class WalkthroughPanel extends StatelessWidget {
  const WalkthroughPanel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.index,
    required this.count,
    required this.onSkip,
    required this.onPrimaryTap,
  });

  final String title;
  final String subtitle;
  final int index;
  final int count;
  final VoidCallback onSkip;
  final VoidCallback onPrimaryTap;

  @override
  Widget build(BuildContext context) {
    final isLast = index == count - 1;
    return ClipPath(
      clipper: const _WalkthroughSheetClipper(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(24, 44, 24, 24),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 22,
                height: 1.25,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.7,
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 18),
            WalkthroughPagerDots(count: count, index: index),
            const SizedBox(height: 18),
            if (isLast)
              _WalkthroughButton(
                label: 'Get Started',
                backgroundColor: const Color(0xFF4A68F6),
                foregroundColor: Colors.white,
                onTap: onPrimaryTap,
              )
            else
              Row(
                children: [
                  Expanded(
                    child: _WalkthroughButton(
                      label: 'Skip',
                      backgroundColor: const Color(0xFFF1F4FE),
                      foregroundColor: const Color(0xFF4A68F6),
                      onTap: onSkip,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _WalkthroughButton(
                      label: 'Next',
                      backgroundColor: const Color(0xFF4A68F6),
                      foregroundColor: Colors.white,
                      onTap: onPrimaryTap,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _WalkthroughButton extends StatelessWidget {
  const _WalkthroughButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _WalkthroughSheetClipper extends CustomClipper<Path> {
  const _WalkthroughSheetClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 52)
      ..quadraticBezierTo(size.width * 0.5, 0, size.width, 52)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
