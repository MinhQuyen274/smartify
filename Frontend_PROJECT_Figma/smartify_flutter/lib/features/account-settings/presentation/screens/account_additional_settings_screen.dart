import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/account-settings/models/account_settings_models.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_settings_toggle_list_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_plain_row.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';

class AccountAdditionalSettingsScreen extends StatelessWidget {
  const AccountAdditionalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Additional Settings',
      backgroundColor: Colors.white,
      child: Consumer<AccountSettingsStore>(
        builder: (context, store, child) {
          return ListView(
            children: [
              SettingsPlainRow(
                title: 'Temperature Units',
                trailingText: store.temperatureUnit.label,
                onTap: () => _showTemperatureSheet(context, store),
              ),
              SettingsPlainRow(
                title: 'Clear Cache',
                trailingText: store.cacheSizeLabel,
                onTap: () => _showClearCacheDialog(context, store),
              ),
              SettingsPlainRow(
                title: 'Experimental Features',
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.accountSettingsToggleList,
                  arguments: const AccountSettingsToggleListArgs(
                    title: 'Experimental Features',
                    type: AccountSettingsToggleListType.experimentalFeatures,
                  ),
                ),
              ),
              SettingsPlainRow(
                title: 'System Permissions',
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.accountSettingsToggleList,
                  arguments: const AccountSettingsToggleListArgs(
                    title: 'System Permissions',
                    type: AccountSettingsToggleListType.systemPermissions,
                  ),
                ),
              ),
              SettingsPlainRow(
                title: 'Legal Information',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.accountLegalInformation),
              ),
              SettingsPlainRow(
                title: 'Check for Updates',
                onTap: () => _showUpdateDialog(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showTemperatureSheet(
    BuildContext context,
    AccountSettingsStore store,
  ) async {
    var pendingUnit = store.temperatureUnit;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Temperature Units',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 18),
                    ...TemperatureUnit.values.map(
                      (unit) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: _SelectionIndicator(
                          isSelected: pendingUnit == unit,
                        ),
                        title: Text(
                          unit.label,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        onTap: () => setState(() => pendingUnit = unit),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: LightColorTokens.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          store.setTemperatureUnit(pendingUnit);
                          Navigator.pop(sheetContext);
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showClearCacheDialog(
    BuildContext context,
    AccountSettingsStore store,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Cache'),
          content: Text(
            store.cacheSizeLabel == '0.0 MB'
                ? 'Cache is already clear.'
                : 'Remove temporary files and free up ${store.cacheSizeLabel}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            if (store.cacheSizeLabel != '0.0 MB')
              TextButton(
                onPressed: () {
                  store.clearCache();
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
          ],
        );
      },
    );
  }

  Future<void> _showUpdateDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('You\'re Up to Date'),
          content: const Text(
            'Smartify is running the latest available version.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? LightColorTokens.primary : const Color(0xFFC9CFDB),
          width: 2,
        ),
      ),
      child: isSelected
          ? Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: LightColorTokens.primary,
                ),
              ),
            )
          : null,
    );
  }
}
