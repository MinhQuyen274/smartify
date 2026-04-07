import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/state/auth_session_store.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/profile_header.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_menu_row.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';

/// Account profile screen — profile header + General/Support settings lists.
/// Matches Figma "Account / Settings" screen (screen 107).
class AccountProfileScreen extends StatelessWidget {
  const AccountProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AccountSettingsStore>();

    return Scaffold(
      backgroundColor: LightColorTokens.background,
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: 3,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.homeDevicesDashboard);
          } else if (i == 1) {
            Navigator.pushReplacementNamed(context, AppRoutes.smartScenesDashboard);
          } else if (i == 2) {
            Navigator.pushReplacementNamed(context, AppRoutes.reportsDashboard);
          }
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'My Home',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.grid_view_rounded,
                      color: LightColorTokens.textSecondary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: LightColorTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // ── Profile header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: AuthMotionSection(
                child: ProfileHeader(
                  name: store.userName,
                  email: store.userEmail,
                ),
              ),
            ),

            // ── General section ──
            _SectionHeader(title: 'General', delay: 60),
            ...store.generalMenuItems.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                child: AuthMotionSection(
                  delay: Duration(milliseconds: 100 + 30 * i),
                  child: SettingsMenuRow(
                    item: item,
                    onTap: () {
                      if (item.route != null) {
                        Navigator.pushNamed(context, item.route!);
                      }
                    },
                  ),
                ),
              );
            }),

            // ── Support section ──
            _SectionHeader(title: 'Support', delay: 300),
            ...AccountSettingsStore.supportMenuItems
                .asMap()
                .entries
                .map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                child: AuthMotionSection(
                  delay: Duration(milliseconds: 340 + 30 * i),
                  child: SettingsMenuRow(
                    item: item,
                    onTap: () {
                      if (item.route != null) {
                        Navigator.pushNamed(context, item.route!);
                      }
                    },
                  ),
                ),
              );
            }),

            // ── Logout ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: AuthMotionSection(
                delay: const Duration(milliseconds: 400),
                child: SettingsMenuRow(
                  item: AccountSettingsStore.logoutItem,
                  onTap: () {
                    context.read<AuthSessionStore>().signOut().then((_) {
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (_) => false,
                      );
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.delay,
  });

  final String title;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: AuthMotionSection(
        delay: Duration(milliseconds: delay),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF9CA3AF),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
