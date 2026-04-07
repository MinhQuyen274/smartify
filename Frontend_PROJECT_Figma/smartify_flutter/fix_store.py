
import sys

filepath = 'lib/features/account-settings/state/account_settings_store.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    text = f.read()

# Fix the method closure
text = text.replace('''    notifyListeners();
    // Notifications''', '''    notifyListeners();
  }

  // Notifications''')

# Remove the trailing extra braces since we added one above if needed
# Wait, look at the end of the file:
#   void toggleNewTipsAvailable(bool value) {
#     _newTipsAvailableEnabled = value;
#     notifyListeners();
#   }
#
#
#
# }
# This is correct. So just replacing the above closes 	oggleLinkedAccount.

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(text)

