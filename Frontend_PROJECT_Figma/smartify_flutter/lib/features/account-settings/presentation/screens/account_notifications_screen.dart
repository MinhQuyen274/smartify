import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';

class AccountNotificationsScreen extends StatelessWidget {
  const AccountNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Notifications',
      child: Consumer<AccountSettingsStore>(
        builder: (context, store, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              _NotificationItem(
                title: 'General Notification',
                value: store.generalNotificationsEnabled,
                onChanged: (val) => store.toggleGeneralNotifications(val),
              ),
              const Divider(height: 1, color: Color(0xFFF1F3F8)),
              _NotificationItem(
                title: 'Sound',
                value: store.soundEnabled,
                onChanged: (val) => store.toggleSound(val),
              ),
              const Divider(height: 1, color: Color(0xFFF1F3F8)),
              _NotificationItem(
                title: 'Vibrate',
                value: store.vibrateEnabled,
                onChanged: (val) => store.toggleVibrate(val),
              ),
              const Divider(height: 1, color: Color(0xFFF1F3F8)),
              const SizedBox(height: 24),
              Text(
                'System & Services Update',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: LightColorTokens.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              _NotificationItem(
                title: 'App Updates',
                value: store.appUpdatesEnabled,
                onChanged: (val) => store.toggleAppUpdates(val),
              ),
              const Divider(height: 1, color: Color(0xFFF1F3F8)),
              _NotificationItem(
                title: 'New Service Available',
                value: store.newServiceAvailableEnabled,
                onChanged: (val) => store.toggleNewServiceAvailable(val),
              ),
              const Divider(height: 1, color: Color(0xFFF1F3F8)),
              _NotificationItem(
                title: 'New Tips Available',
                value: store.newTipsAvailableEnabled,
                onChanged: (val) => store.toggleNewTipsAvailable(val),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationItem({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: LightColorTokens.primary,
            activeTrackColor: LightColorTokens.primary.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}
