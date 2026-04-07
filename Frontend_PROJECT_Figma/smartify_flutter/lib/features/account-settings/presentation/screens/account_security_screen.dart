import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/security_toggle_row.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_menu_row.dart';

class AccountSecurityScreen extends StatelessWidget {
  const AccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Account & Security',
      child: Consumer<AccountSettingsStore>(
        builder: (context, store, child) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              ...store.securityToggles.asMap().entries.map((toggle) {
                return Column(
                  children: [
                    SecurityToggleRow(
                      toggle: toggle.value,
                      onChanged: () => store.toggleSecurity(toggle.key),
                    ),
                    if (toggle.key < store.securityToggles.length - 1)
                      const Divider(height: 1),
                  ],
                );
              }),
              const SizedBox(height: 32),
              ...AccountSettingsStore.securityNavItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SettingsMenuRow(item: item),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
