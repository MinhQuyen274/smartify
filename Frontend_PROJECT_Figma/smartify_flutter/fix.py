
import sys

filepath = 'lib/features/reports/presentation/widgets/energy_summary_card.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    text = f.read()

# Let's fix FittedBox manually using regex or just simple find
# The problem is there is a dangling FittedBox with bad syntax or double arguments?

lines = [
    '''          FittedBox(''',
    '''            fit: BoxFit.scaleDown,''',
    '''            alignment: Alignment.centerLeft,''',
    '''            child: RichText(''',
    '''            text: TextSpan(''',
]


