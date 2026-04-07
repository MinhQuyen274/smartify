import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/linked_account_row.dart';

class LinkedAccountsScreen extends StatelessWidget {
  const LinkedAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Linked Accounts',
      child: Consumer<AccountSettingsStore>(
        builder: (context, store, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: store.linkedAccounts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: LinkedAccountRow(
                  account: store.linkedAccounts[index],
                  onTap: () => store.toggleLinkedAccount(index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
