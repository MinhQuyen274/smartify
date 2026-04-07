import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/account-settings/models/account_settings_models.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_plain_row.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';

class AccountAppAppearanceScreen extends StatelessWidget {
  const AccountAppAppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'App Appearance',
      backgroundColor: Colors.white,
      child: Consumer<AccountSettingsStore>(
        builder: (context, store, child) {
          return ListView(
            children: [
              SettingsPlainRow(
                title: 'Theme',
                trailingText: store.appTheme.label,
                onTap: () => _showThemeSheet(context, store),
              ),
              SettingsPlainRow(
                title: 'App Language',
                trailingText: store.appLanguage.label,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.accountAppLanguage,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showThemeSheet(
    BuildContext context,
    AccountSettingsStore store,
  ) async {
    var pendingTheme = store.appTheme;

    await showModalBottomSheet<void>(
      context: context,
      barrierColor: const Color(0xB3161B28),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 46,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7EAF0),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Choose Theme',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 22),
                    const Divider(height: 1, color: Color(0xFFE7EAF0)),
                    ...AppThemeOption.values.map(
                      (theme) => InkWell(
                        onTap: () => setState(() => pendingTheme = theme),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              _ThemeRadio(isSelected: pendingTheme == theme),
                              const SizedBox(width: 16),
                              Text(
                                theme.label,
                                style: Theme.of(context).textTheme.headlineMedium
                                    ?.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFE7EAF0)),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: _ThemeSheetButton(
                            label: 'Cancel',
                            backgroundColor: const Color(0xFFECEFFE),
                            textColor: LightColorTokens.primary,
                            onTap: () => Navigator.pop(sheetContext),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _ThemeSheetButton(
                            label: 'OK',
                            backgroundColor: LightColorTokens.primary,
                            textColor: Colors.white,
                            onTap: () {
                              store.setAppTheme(pendingTheme);
                              Navigator.pop(sheetContext);
                            },
                          ),
                        ),
                      ],
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
}

class _ThemeSheetButton extends StatelessWidget {
  const _ThemeSheetButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Ink(
        height: 52,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeRadio extends StatelessWidget {
  const _ThemeRadio({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? LightColorTokens.primary : const Color(0xFFBCC3D1),
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
