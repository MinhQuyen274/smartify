
import sys

filepath = 'lib/features/reports/presentation/widgets/energy_summary_card.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('''              ],
            ),
          ),
          const SizedBox(height: 3),''', '''              ],
            ),
          ),
          ),
          const SizedBox(height: 3),''')

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(text)

