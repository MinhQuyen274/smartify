import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/motion/motion_tokens.dart';
import 'package:smartify_flutter/shared/widgets/smartify_primary_button.dart';

class AuthLoadingButton extends StatelessWidget {
  const AuthLoadingButton({
    super.key,
    required this.label,
    required this.loading,
    required this.enabled,
    this.onTap,
  });

  final String label;
  final bool loading;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: MotionTokens.micro,
      switchInCurve: MotionTokens.standard,
      switchOutCurve: MotionTokens.accelerate,
      child: SmartifyPrimaryButton(
        key: ValueKey<String>('btn-$label-$loading-$enabled'),
        label: loading ? 'Please wait...' : label,
        loading: loading,
        enabled: enabled,
        onTap: loading || !enabled ? null : onTap,
      ),
    );
  }
}
