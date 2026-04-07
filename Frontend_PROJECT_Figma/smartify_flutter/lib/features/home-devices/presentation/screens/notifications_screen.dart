import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/home-devices/models/home_devices_models.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/mode_tab_bar.dart';
import 'package:smartify_flutter/features/home-devices/state/home_devices_store.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';

/// Notification screen matching Figma — General / Smart Home tabs,
/// grouped by Today/Yesterday, unread dot, chevron.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<HomeDevicesStore>();

    return Scaffold(
      backgroundColor: LightColorTokens.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LightThemeData.spacingS,
                vertical: LightThemeData.spacingXs,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const Spacer(),
                  Text(
                    'Notification',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
            ),
            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LightThemeData.spacingL,
              ),
              child: ModeTabBar(
                labels: const ['General', 'Smart Home'],
                selectedIndex: store.notifTab,
                onSelected: store.setNotifTab,
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: store.notifTab == 0
                  ? _GeneralNotifList()
                  : _SmartHomeNotifList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneralNotifList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifs = HomeDevicesStore.generalNotifs;
    final todayItems = notifs.sublist(0, 2);
    final yesterdayItems = notifs.sublist(2);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: LightThemeData.spacingL),
      children: [
        _DateHeader(label: 'Today'),
        ...todayItems.map((n) => _NotifTile(item: n)),
        const SizedBox(height: 12),
        _DateHeader(label: 'Yesterday'),
        ...yesterdayItems.map((n) => _NotifTile(item: n)),
      ],
    );
  }
}

class _SmartHomeNotifList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AuthMotionSection(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: LightColorTokens.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              'No smart home notifications',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: LightColorTokens.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: LightColorTokens.textSecondary,
            ),
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return AuthMotionSection(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(LightThemeData.radiusM),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, size: 20, color: LightColorTokens.textPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: Theme.of(context).textTheme.labelLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.badge != null)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: item.badge == 'NEW'
                                ? LightColorTokens.primary
                                : const Color(0xFF1FBF75),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: LightColorTokens.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.time,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFADB5BD),
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                if (item.isUnread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: LightColorTokens.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                const SizedBox(height: 10),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: LightColorTokens.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
