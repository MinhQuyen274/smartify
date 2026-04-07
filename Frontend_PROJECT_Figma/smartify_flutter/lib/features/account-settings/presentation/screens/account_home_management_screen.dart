import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';
import 'package:smartify_flutter/features/account-settings/models/home_management_models.dart';
import 'package:smartify_flutter/app/router/app_router.dart';

class AccountHomeManagementScreen extends StatelessWidget {
  const AccountHomeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Home Management',
      child: Consumer<AccountSettingsStore>(
        builder: (context, store, child) {
          final homes = store.homes;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              ...homes.map((home) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _HomeCard(
                    home: home,
                    onTap: () {
                      store.selectHomeById(home.id);
                      Navigator.pushNamed(
                        context,
                        AppRoutes.accountMyHome,
                        arguments: home.id,
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 12),
              _ActionButton(
                label: 'Create a Home',
                backgroundColor: const Color(0xFF4F46E5),
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _ActionButton(
                label: 'Join a Home',
                backgroundColor: Colors.white,
                borderColor: const Color(0xFF4F46E5),
                textColor: const Color(0xFF4F46E5),
                onTap: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final Home home;
  final VoidCallback onTap;

  const _HomeCard({required this.home, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        home.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      if (home.location != null && home.location!.isNotEmpty)
                        Text(
                          home.location!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: const Color(0xFF9CA3AF)),
                        ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatBadge(label: 'Rooms', value: home.roomCount.toString()),
                _StatBadge(
                  label: 'Devices',
                  value: home.deviceCount.toString(),
                ),
                _StatBadge(
                  label: 'Members',
                  value: home.memberCount.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;

  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: const Color(0xFF9CA3AF)),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color? borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.backgroundColor,
    this.borderColor,
    this.textColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 2)
              : null,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
