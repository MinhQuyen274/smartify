import 'package:flutter/material.dart';

class SceneBuilderSectionCard extends StatelessWidget {
  const SceneBuilderSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.onAdd,
    this.headerTrailing,
  });

  final String title;
  final Widget child;
  final VoidCallback? onAdd;
  final Widget? headerTrailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineLarge),
              const Spacer(),
              if (headerTrailing != null)
                headerTrailing!
              else if (onAdd != null)
                InkWell(
                  onTap: onAdd,
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A68F6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_rounded, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE8E9EE)),
          child,
        ],
      ),
    );
  }
}
