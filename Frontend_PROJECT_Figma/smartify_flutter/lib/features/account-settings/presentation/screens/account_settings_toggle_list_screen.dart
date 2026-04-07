import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/account-settings/models/account_settings_models.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';

enum AccountSettingsToggleListType {
  dataUsage,
  adPreferences,
  experimentalFeatures,
  systemPermissions,
}

class AccountSettingsToggleListArgs {
  const AccountSettingsToggleListArgs({
    required this.title,
    required this.type,
  });

  final String title;
  final AccountSettingsToggleListType type;
}

class AccountSettingsToggleListScreen extends StatelessWidget {
  const AccountSettingsToggleListScreen({super.key, required this.args});

  final AccountSettingsToggleListArgs args;

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: args.title,
      backgroundColor: const Color(0xFFF7F8FA),
      child: Consumer<AccountSettingsStore>(
        builder: (context, store, child) {
          final items = _resolveItems(store);
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          if (item.description != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              item.description!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: LightColorTokens.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Switch(
                      value: item.isEnabled,
                      onChanged: (_) => _toggle(store, item.id),
                      activeThumbColor: LightColorTokens.primary,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemCount: items.length,
          );
        },
      ),
    );
  }

  List<SettingsToggleItem> _resolveItems(AccountSettingsStore store) {
    switch (args.type) {
      case AccountSettingsToggleListType.dataUsage:
        return store.dataUsagePreferences;
      case AccountSettingsToggleListType.adPreferences:
        return store.adPreferences;
      case AccountSettingsToggleListType.experimentalFeatures:
        return store.experimentalFeatures;
      case AccountSettingsToggleListType.systemPermissions:
        return store.systemPermissions;
    }
  }

  void _toggle(AccountSettingsStore store, String id) {
    switch (args.type) {
      case AccountSettingsToggleListType.dataUsage:
        store.toggleDataUsagePreference(id);
        break;
      case AccountSettingsToggleListType.adPreferences:
        store.toggleAdPreference(id);
        break;
      case AccountSettingsToggleListType.experimentalFeatures:
        store.toggleExperimentalFeature(id);
        break;
      case AccountSettingsToggleListType.systemPermissions:
        store.toggleSystemPermission(id);
        break;
    }
  }
}
