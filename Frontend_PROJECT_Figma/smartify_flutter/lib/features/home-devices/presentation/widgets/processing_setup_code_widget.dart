import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';

/// Processing setup code loading state matching Figma (43_38).
/// Shows while processing device setup code.
class ProcessingSetupCodeWidget extends StatefulWidget {
  const ProcessingSetupCodeWidget({super.key});

  @override
  State<ProcessingSetupCodeWidget> createState() =>
      _ProcessingSetupCodeWidgetState();
}

class _ProcessingSetupCodeWidgetState extends State<ProcessingSetupCodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinCtrl;

  @override
  void initState() {
    super.initState();
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back button
      child: Dialog(
        elevation: 16,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LightThemeData.radiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(LightThemeData.spacingXl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Processing Setup Code...',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: LightThemeData.spacingL),

              // Animated spinner
              RotationTransition(
                turns: _spinCtrl,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: LightColorTokens.primary.withValues(alpha: 0.2),
                      width: 4,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: LightColorTokens.primary,
                        width: 4,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: LightThemeData.spacingXl),

              // Subtitle
              Text(
                'Setting up your device...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: LightColorTokens.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper function to show processing setup code dialog
Future<void> showProcessingSetupCode(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const ProcessingSetupCodeWidget(),
  );
}
