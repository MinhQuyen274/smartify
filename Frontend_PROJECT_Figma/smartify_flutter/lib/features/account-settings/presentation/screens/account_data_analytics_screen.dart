import 'package:flutter/material.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_settings_toggle_list_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_plain_row.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';

class AccountDataAnalyticsScreen extends StatelessWidget {
  const AccountDataAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Data & Analytics',
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          SettingsPlainRow(
            title: 'Data Usage',
            subtitle:
                'Control how your data is used for analytics.\nCustomize your preferences.',
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.accountSettingsToggleList,
              arguments: const AccountSettingsToggleListArgs(
                title: 'Data Usage',
                type: AccountSettingsToggleListType.dataUsage,
              ),
            ),
          ),
          SettingsPlainRow(
            title: 'Ad Preferences',
            subtitle:
                'Manage ad personalization settings. Tailor\nyour ad experience.',
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.accountSettingsToggleList,
              arguments: const AccountSettingsToggleListArgs(
                title: 'Ad Preferences',
                type: AccountSettingsToggleListType.adPreferences,
              ),
            ),
          ),
          SettingsPlainRow(
            title: 'Download My Data',
            subtitle:
                'Request a copy of your data. Your information,\nyour control.',
            onTap: () => _showDownloadDialog(context),
          ),
        ],
      ),
    );
  }

  Future<void> _showDownloadDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Download Requested'),
          content: const Text(
            'We\'ll prepare your Smartify data export and notify you when it is ready.',
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
