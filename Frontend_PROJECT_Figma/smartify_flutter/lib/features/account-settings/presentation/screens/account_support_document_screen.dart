import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';

class AccountSupportDocumentArgs {
  const AccountSupportDocumentArgs({
    required this.title,
    required this.introduction,
    required this.sections,
    this.lastUpdated,
  });

  final String title;
  final String introduction;
  final String? lastUpdated;
  final List<AccountSupportDocumentSection> sections;
}

class AccountSupportDocumentSection {
  const AccountSupportDocumentSection({
    required this.heading,
    required this.body,
    this.bullets = const [],
  });

  final String heading;
  final String body;
  final List<String> bullets;
}

class AccountSupportDocumentScreen extends StatelessWidget {
  const AccountSupportDocumentScreen({super.key, required this.args});

  final AccountSupportDocumentArgs args;

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: args.title,
      backgroundColor: Colors.white,
      child: Scrollbar(
        thumbVisibility: true,
        radius: const Radius.circular(999),
        thickness: 4,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (args.lastUpdated != null) ...[
                Text(
                  'Last Updated: ${args.lastUpdated!}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 18),
              ],
              Text(
                args.introduction,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF404758),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              ...args.sections.map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: _DocumentSection(section: section),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentSection extends StatelessWidget {
  const _DocumentSection({required this.section});

  final AccountSupportDocumentSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.heading,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          section.body,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF404758),
            height: 1.7,
          ),
        ),
        if (section.bullets.isNotEmpty) ...[
          const SizedBox(height: 10),
          ...section.bullets.map(
            (bullet) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Icon(
                      Icons.circle,
                      size: 5,
                      color: LightColorTokens.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      bullet,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF404758),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
