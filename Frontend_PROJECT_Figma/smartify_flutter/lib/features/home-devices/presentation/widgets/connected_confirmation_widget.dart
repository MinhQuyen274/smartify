import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';

/// Connected confirmation state matching Figma (41_36).
/// Shows success state after device connection.
class ConnectedConfirmationWidget extends StatelessWidget {
  const ConnectedConfirmationWidget({
    super.key,
    required this.deviceName,
    required this.onContinue,
  });

  final String deviceName;
  final VoidCallback onContinue;

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
              // Success icon in circle
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: LightColorTokens.success.withValues(alpha: 0.12),
                ),
                child: Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: LightColorTokens.success,
                    size: 56,
                  ),
                ),
              ),
              const SizedBox(height: LightThemeData.spacingXl),

              // Title
              Text(
                'Connected!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: LightThemeData.spacingM),

              // Message
              Text(
                'Your $deviceName is now connected to your home',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: LightColorTokens.textSecondary,
                ),
              ),
              const SizedBox(height: LightThemeData.spacingXl),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: LightColorTokens.primary,
                    minimumSize: const Size.fromHeight(54),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper function to show connected confirmation dialog
Future<void> showConnectedConfirmation(
  BuildContext context, {
  required String deviceName,
  required VoidCallback onContinue,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ConnectedConfirmationWidget(
      deviceName: deviceName,
      onContinue: onContinue,
    ),
  );
}
