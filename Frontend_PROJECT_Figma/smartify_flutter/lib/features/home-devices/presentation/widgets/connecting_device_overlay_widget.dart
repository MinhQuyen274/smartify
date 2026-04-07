import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';

/// Connecting device state overlay matching Figma (40_35).
/// Shows loading animation while connecting to device.
class ConnectingDeviceOverlayWidget extends StatefulWidget {
  const ConnectingDeviceOverlayWidget({
    super.key,
    required this.deviceName,
    required this.onCancel,
    this.deviceImagePath,
  });

  final String deviceName;
  final VoidCallback onCancel;
  final String? deviceImagePath;

  @override
  State<ConnectingDeviceOverlayWidget> createState() =>
      _ConnectingDeviceOverlayWidgetState();
}

class _ConnectingDeviceOverlayWidgetState
    extends State<ConnectingDeviceOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _pulseAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_pulseCtrl);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
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
                'Connecting...',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: LightThemeData.spacingL),

              // Animated pulse circle with loading indicator
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 148,
                        height: 148,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: LightColorTokens.primary.withValues(
                            alpha: 0.07 * (1 - _pulseAnim.value),
                          ),
                          border: Border.all(
                            color: LightColorTokens.primary.withValues(
                              alpha: 0.2 + (0.18 * (1 - _pulseAnim.value)),
                            ),
                            width: 4,
                          ),
                        ),
                      ),
                      Container(
                        width: 96,
                        height: 96,
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: widget.deviceImagePath == null
                            ? const Icon(
                                Icons.router_rounded,
                                color: LightColorTokens.primary,
                                size: 40,
                              )
                            : Image.asset(
                                widget.deviceImagePath!,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: LightThemeData.spacingXl),

              // Device info
              Text(
                'Connecting to: ${widget.deviceName}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: LightColorTokens.textSecondary,
                ),
              ),
              const SizedBox(height: LightThemeData.spacingXl),

              // Cancel button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper function to show connecting device overlay
Future<void> showConnectingDeviceOverlay(
  BuildContext context, {
  required String deviceName,
  required VoidCallback onCancel,
  String? deviceImagePath,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ConnectingDeviceOverlayWidget(
      deviceName: deviceName,
      onCancel: onCancel,
      deviceImagePath: deviceImagePath,
    ),
  );
}
