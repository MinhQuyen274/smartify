import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/shared/widgets/pressable_scale.dart';

class SmartifyPrimaryButton extends StatelessWidget {
  const SmartifyPrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.enabled = true,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final isInteractive = enabled && !loading && onTap != null;
    return Opacity(
      opacity: isInteractive ? 1 : 0.6,
      child: PressableScale(
        onTap: isInteractive ? onTap : null,
        child: Container(
          width: double.infinity,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isInteractive
                ? LightColorTokens.primary
                : LightColorTokens.primaryPressed,
            borderRadius: BorderRadius.circular(LightThemeData.radiusM),
            boxShadow: const [
              BoxShadow(
                blurRadius: 16,
                offset: Offset(0, 8),
                color: LightColorTokens.shadow,
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: loading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    label,
                    key: ValueKey<String>(label),
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}
