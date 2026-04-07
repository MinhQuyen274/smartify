import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';

class OtpCodeField extends StatefulWidget {
  const OtpCodeField({
    super.key,
    required this.length,
    required this.controller,
    required this.onChanged,
    this.errorText,
  });

  final int length;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final code = widget.controller.text.padRight(widget.length);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: Row(
            children: List.generate(widget.length, (index) {
              final value = code[index].trim();
              final active = widget.controller.text.length == index;
              return Expanded(
                child: Container(
                  height: 62,
                  margin: EdgeInsets.only(
                    right: index == widget.length - 1 ? 0 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: active
                          ? LightColorTokens.primary
                          : const Color(0xFFE8EBF3),
                      width: active ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      value.isEmpty ? '' : value,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Offstage(
          offstage: true,
          child: TextField(
            focusNode: _focusNode,
            controller: widget.controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(widget.length),
            ],
            onChanged: widget.onChanged,
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 12),
          Text(
            widget.errorText!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: LightColorTokens.error),
          ),
        ],
      ],
    );
  }
}
