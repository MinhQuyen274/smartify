import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';

/// Manual setup code entry form matching Figma (42_37).
/// Allows users to enter device setup code manually.
class ManualSetupCodeFormWidget extends StatefulWidget {
  const ManualSetupCodeFormWidget({
    super.key,
    required this.onSubmit,
    this.onCancel,
  });

  final Function(String code) onSubmit;
  final VoidCallback? onCancel;

  @override
  State<ManualSetupCodeFormWidget> createState() =>
      _ManualSetupCodeFormWidgetState();
}

class _ManualSetupCodeFormWidgetState extends State<ManualSetupCodeFormWidget> {
  late TextEditingController _codeCtrl;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _codeCtrl = TextEditingController();
    _codeCtrl.addListener(_validateCode);
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _validateCode() {
    final code = _codeCtrl.text.trim();
    setState(() {
      _isValid = code.contains('|') || code.startsWith('{');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        Text(
          'Enter Setup Code',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: LightThemeData.spacingM),

        // Helper text
        Text(
          'Paste the QR payload or use format: deviceId|claimCode',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: LightColorTokens.textSecondary,
          ),
        ),
        const SizedBox(height: LightThemeData.spacingXl),

        // Code input field
        TextField(
          controller: _codeCtrl,
          maxLines: 3,
          minLines: 1,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'demo-power-node-01|KAN-POWER-01',
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: LightColorTokens.textSecondary.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: LightColorTokens.surfaceMuted,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(LightThemeData.radiusM),
              borderSide: const BorderSide(color: LightColorTokens.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(LightThemeData.radiusM),
              borderSide: const BorderSide(color: LightColorTokens.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(LightThemeData.radiusM),
              borderSide: const BorderSide(
                color: LightColorTokens.primary,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: LightThemeData.spacingXl),

        // Continue button
        FilledButton(
          onPressed: _isValid
              ? () => widget.onSubmit(_codeCtrl.text.trim().toUpperCase())
              : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
          ),
          child: const Text('Continue'),
        ),
        const SizedBox(height: LightThemeData.spacingM),

        // Cancel button (if provided)
        if (widget.onCancel != null)
          OutlinedButton(
            onPressed: widget.onCancel,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Cancel'),
          ),
      ],
    );
  }
}
