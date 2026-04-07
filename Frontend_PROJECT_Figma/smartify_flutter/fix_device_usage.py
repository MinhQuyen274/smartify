import re

with open('lib/features/reports/presentation/widgets/device_usage_card.dart', 'r', encoding='utf-8') as f:
    text = f.read()

# Add images
text = getattr(re, 'sub')(r"Icon\(item\.icon, size: 28, color: const Color\(0xFF6B7280\)\)", "item.imagePath != null ? Image.asset(item.imagePath!, width: 34, height: 38, fit: BoxFit.contain) : Icon(item.icon, size: 28, color: const Color(0xFF6B7280))", text)
text = getattr(re, 'sub')(r"Icon\(item\.icon, size: 18, color: LightColorTokens\.textSecondary\)", "item.imagePath != null ? Image.asset(item.imagePath!, width: 20, fit: BoxFit.contain) : Icon(item.icon, size: 18, color: LightColorTokens.textSecondary)", text)

# Wrap kWh text with FittedBox
text = getattr(re, 'sub')(r"(Expanded\(\s*child: Column\(\s*crossAxisAlignment: CrossAxisAlignment\.start,\s*children: \[)(\s*RichText\(\s*text: TextSpan\(\s*children: \[(.*\n.*)+?\]\s*\),\s*\)\s*,)", r"\1\n                      FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: \2),", text)

with open('lib/features/reports/presentation/widgets/device_usage_card.dart', 'w', encoding='utf-8') as f:
    f.write(text)
