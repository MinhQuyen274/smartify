import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';

class AuthInlineLinkRow extends StatelessWidget {
  const AuthInlineLinkRow({
    super.key,
    required this.prefix,
    required this.linkLabel,
    required this.onTap,
  });

  final String prefix;
  final String linkLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(prefix, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: LightColorTokens.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}
