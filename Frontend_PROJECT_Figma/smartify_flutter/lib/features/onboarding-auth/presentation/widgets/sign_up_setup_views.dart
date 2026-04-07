import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';

class SignUpSetupHeader extends StatelessWidget {
  const SignUpSetupHeader({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.title,
    this.highlight,
    required this.subtitle,
    required this.onBack,
  });

  final int step;
  final int totalSteps;
  final String title;
  final String? highlight;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final progress = step / totalSteps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: progress,
                  backgroundColor: const Color(0xFFE8EBF3),
                  color: LightColorTokens.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '$step / $totalSteps',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 28),
        _HighlightedSetupTitle(
          title: title,
          highlight: highlight,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: LightColorTokens.textSecondary,
          ),
        ),
      ],
    );
  }
}

class SignUpSetupFooter extends StatelessWidget {
  const SignUpSetupFooter({
    super.key,
    required this.primaryLabel,
    required this.onPrimaryTap,
    required this.onSkipTap,
  });

  final String primaryLabel;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSkipTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: onSkipTap,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF1F4FE),
              foregroundColor: LightColorTokens.primary,
              minimumSize: const Size.fromHeight(58),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29),
              ),
            ),
            child: const Text('Skip'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton(
            onPressed: onPrimaryTap,
            style: FilledButton.styleFrom(
              backgroundColor: LightColorTokens.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(58),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29),
              ),
            ),
            child: Text(primaryLabel),
          ),
        ),
      ],
    );
  }
}

class CountryOptionTile extends StatelessWidget {
  const CountryOptionTile({
    super.key,
    required this.flagAsset,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String flagAsset;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? LightColorTokens.primary
                : const Color(0xFFE8EBF3),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                flagAsset,
                width: 48,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_rounded,
                color: LightColorTokens.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

class RoomOptionCard extends StatelessWidget {
  const RoomOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8EBF3)),
        ),
        child: Stack(
          children: [
            if (selected)
              const Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: LightColorTokens.primary,
                  child: Icon(Icons.check, size: 14, color: Colors.white),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 30, color: LightColorTokens.primary),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpSuccessView extends StatelessWidget {
  const SignUpSuccessView({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.close_rounded, size: 26),
          ),
        ),
        const Spacer(),
        const Image(
          image: AssetImage(
            'assets/png/sign_up_success_illustration_exact.png',
          ),
          width: 132,
          height: 132,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 28),
        Text(
          'Well Done!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 16),
        Text(
          'Congratulations! Your home is now a Smartify haven. Start exploring and managing your smart space with ease.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: LightColorTokens.textSecondary,
          ),
        ),
        const Spacer(),
        FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: LightColorTokens.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(58),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29),
            ),
          ),
          child: const Text('Get Started'),
        ),
      ],
    );
  }
}

class _HighlightedSetupTitle extends StatelessWidget {
  const _HighlightedSetupTitle({
    required this.title,
    required this.highlight,
    required this.style,
  });

  final String title;
  final String? highlight;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (highlight == null ||
        highlight!.isEmpty ||
        !title.contains(highlight!)) {
      return Text(title, textAlign: TextAlign.center, style: style);
    }

    final index = title.indexOf(highlight!);
    final before = title.substring(0, index);
    final after = title.substring(index + highlight!.length);

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: before),
          TextSpan(
            text: highlight,
            style: style?.copyWith(color: LightColorTokens.primary),
          ),
          TextSpan(text: after),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
