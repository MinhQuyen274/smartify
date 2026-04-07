import 'package:flutter/material.dart';

class SceneSummaryTile extends StatelessWidget {
  const SceneSummaryTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onRemove,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onRemove;
  final Widget? trailing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF7D7F89),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (onRemove != null)
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded, color: Color(0xFFFF5A4E)),
            ),
        ],
      ),
    );
  }
}
