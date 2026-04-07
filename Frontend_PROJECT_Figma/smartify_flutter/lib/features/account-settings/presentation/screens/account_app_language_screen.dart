import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_flag_icon.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_surface_card.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';

class AccountAppLanguageScreen extends StatelessWidget {
  const AccountAppLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'App Language',
      backgroundColor: const Color(0xFFF7F8FA),
      child: Consumer<AccountSettingsStore>(
        builder: (context, store, child) {
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            itemBuilder: (context, index) {
              final language = AccountSettingsStore.appLanguages[index];
              final isSelected = language.code == store.appLanguage.code;
              return SettingsSurfaceCard(
                title: language.label,
                leading: SettingsFlagIcon(flagCode: language.flagCode),
                isSelected: isSelected,
                onTap: () => store.setAppLanguage(language),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: LightColorTokens.primary,
                        size: 26,
                      )
                    : null,
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: AccountSettingsStore.appLanguages.length,
          );
        },
      ),
    );
  }
}
