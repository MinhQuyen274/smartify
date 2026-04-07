import re

with open('lib/features/reports/presentation/screens/reports_dashboard_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = re.sub(
    r\"Text\(\s*'My Home',\s*style:\s*Theme\.of\(context\)\.textTheme\.headlineLarge,\s*\)\",
    r\"Flexible(child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text('My Home', style: Theme.of(context).textTheme.headlineLarge)))\",
    text
)

text = re.sub(
    r\"Text\(\s*'Statistics',\s*style:\s*Theme\.of\(context\)\.textTheme\.titleMedium,\s*\)\",
    r\"Flexible(child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text('Statistics', style: Theme.of(context).textTheme.titleMedium)))\",
    text
)

with open('lib/features/reports/presentation/screens/reports_dashboard_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)
