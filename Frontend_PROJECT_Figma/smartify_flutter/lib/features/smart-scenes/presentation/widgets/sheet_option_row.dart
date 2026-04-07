import 'package:flutter/material.dart';

class SheetOptionRow extends StatelessWidget {
  const SheetOptionRow({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailingInfo = false,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool trailingInfo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF7E818B),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailingInfo)
              const Icon(Icons.info_outline_rounded, color: Color(0xFF71747E))
            else
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF2F3238),
              ),
          ],
        ),
      ),
    );
  }
}
