import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/motion/motion_tokens.dart';
import 'package:smartify_flutter/features/prototype_viewer/models/prototype_screen.dart';

class PrototypePngScreen extends StatelessWidget {
  const PrototypePngScreen({
    super.key,
    required this.screen,
    required this.hasPrev,
    required this.hasNext,
    required this.onPrev,
    required this.onNext,
  });

  final PrototypeScreen screen;
  final bool hasPrev;
  final bool hasNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${screen.id} • ${screen.feature}'),
      ),
      body: Stack(
        children: [
          Center(
            child: RepaintBoundary(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final ratio = MediaQuery.of(context).devicePixelRatio;
                  return InteractiveViewer(
                    maxScale: 3,
                    minScale: 1,
                    child: Image.asset(
                      screen.assetPath,
                      fit: BoxFit.contain,
                      cacheWidth: (constraints.maxWidth * ratio).round(),
                      cacheHeight: (constraints.maxHeight * ratio).round(),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Row(
              children: [
                Expanded(
                  child: _NavButton(label: 'Prev', enabled: hasPrev, onTap: onPrev),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NavButton(label: 'Next', enabled: hasNext, onTap: onNext),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  const _NavButton({required this.label, required this.enabled, required this.onTap});

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: widget.enabled ? () => setState(() => _pressed = false) : null,
      onTap: widget.enabled ? widget.onTap : null,
      child: AnimatedScale(
        duration: MotionTokens.tap,
        curve: MotionTokens.standard,
        scale: _pressed ? 0.98 : 1,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.enabled ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
