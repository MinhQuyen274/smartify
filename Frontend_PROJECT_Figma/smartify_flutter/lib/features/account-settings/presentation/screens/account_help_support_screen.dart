import 'package:flutter/material.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_support_document_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_plain_row.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';

class AccountHelpSupportScreen extends StatelessWidget {
  const AccountHelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Help & Support',
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          SettingsPlainRow(
            title: 'FAQ',
            onTap: () => Navigator.pushNamed(context, AppRoutes.accountFaq),
          ),
          SettingsPlainRow(
            title: 'Contact Support',
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.accountContactSupport),
          ),
          SettingsPlainRow(
            title: 'Privacy Policy',
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.accountPrivacyPolicy),
          ),
          SettingsPlainRow(
            title: 'Terms of Service',
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.accountTermsOfService),
          ),
          SettingsPlainRow(
            title: 'Partner',
            onTap: () => _openDocument(
              context,
              'Partner',
              'Explore Smartify partner integrations and service programs.',
            ),
          ),
          SettingsPlainRow(
            title: 'Job Vacancy',
            onTap: () => _openDocument(
              context,
              'Job Vacancy',
              'See open roles and what it is like to build with the Smartify team.',
            ),
          ),
          SettingsPlainRow(
            title: 'Accessibility',
            onTap: () => _openDocument(
              context,
              'Accessibility',
              'Learn about our accessibility commitments and compatibility support.',
            ),
          ),
          SettingsPlainRow(
            title: 'Feedback',
            onTap: () => _openDocument(
              context,
              'Feedback',
              'Share product feedback, feature requests, and improvement ideas.',
            ),
          ),
          SettingsPlainRow(
            title: 'About us',
            onTap: () => _openDocument(
              context,
              'About us',
              'Smartify builds simple, reliable tools for modern connected homes.',
            ),
          ),
          SettingsPlainRow(
            title: 'Rate us',
            onTap: () => _openDocument(
              context,
              'Rate us',
              'Tell us how Smartify is working for your home and devices.',
            ),
          ),
          SettingsPlainRow(
            title: 'Visit Our Website',
            onTap: () => _openDocument(
              context,
              'Visit Our Website',
              'Browse product updates, support resources, and latest announcements.',
            ),
          ),
          SettingsPlainRow(
            title: 'Follow us on Social Media',
            onTap: () => _openDocument(
              context,
              'Follow us on Social Media',
              'Keep up with new launches, tutorials, and community stories.',
            ),
          ),
        ],
      ),
    );
  }

  void _openDocument(BuildContext context, String title, String intro) {
    Navigator.pushNamed(
      context,
      AppRoutes.accountSupportDocument,
      arguments: AccountSupportDocumentArgs(
        title: title,
        introduction: intro,
        sections: const [
          AccountSupportDocumentSection(
            heading: 'Overview',
            body:
                'This section is included in the prototype so the support flow remains complete end-to-end while preserving the final information architecture.',
          ),
        ],
      ),
    );
  }
}
