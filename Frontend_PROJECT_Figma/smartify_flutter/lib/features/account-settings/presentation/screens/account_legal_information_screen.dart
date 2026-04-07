import 'package:flutter/material.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_plain_row.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';

class AccountLegalInformationScreen extends StatelessWidget {
  const AccountLegalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Legal Information',
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          SettingsPlainRow(
            title: 'Privacy Policy',
            onTap: () => Navigator.pushNamed(context, AppRoutes.accountPrivacyPolicy),
          ),
          SettingsPlainRow(
            title: 'Terms of Service',
            onTap: () => Navigator.pushNamed(context, AppRoutes.accountTermsOfService),
          ),
        ],
      ),
    );
  }
}
