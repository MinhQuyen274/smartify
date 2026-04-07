import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';
import 'package:smartify_flutter/features/account-settings/models/home_management_models.dart';
import 'package:smartify_flutter/app/router/app_router.dart';

class AccountMyHomeScreen extends StatelessWidget {
  final String? homeId;
  const AccountMyHomeScreen({super.key, this.homeId});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'My Home',
      child: Consumer<AccountSettingsStore>(
        builder: (context, store, child) {
          final home = store.findHomeById(homeId) ?? store.selectedHome;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              _HomeDetailItem(label: 'Home Name', value: home.name),
              const SizedBox(height: 8),
              _HomeDetailItem(
                label: 'Room Management',
                value: ' Room(s)',
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.accountRoomManagement,
                ),
              ),
              const SizedBox(height: 8),
              _HomeDetailItem(label: 'Device Management', value: ' Device(s)'),
              const SizedBox(height: 8),
              _HomeDetailItem(
                label: 'Location',
                value: home.location ?? '701 7th Ave...',
              ),
              const SizedBox(height: 24),
              _MembersSection(home: home),
              const SizedBox(height: 240),
            ],
          );
        },
      ),
    );
  }
}

class _HomeDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _HomeDetailItem({required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFF9CA3AF),
              ),
          ],
        ),
      ),
    );
  }
}

class _MembersSection extends StatelessWidget {
  final Home home;

  const _MembersSection({required this.home});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Home Members ()',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            FloatingActionButton(
              mini: true,
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.accountAddMember),
              backgroundColor: const Color(0xFF4F46E5),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...home.members.map((member) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _MemberTile(member: member),
          );
        }),
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  final HomeMember member;

  const _MemberTile({required this.member});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.accountHomeMember,
        arguments: member.id,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 20, backgroundColor: const Color(0xFFF1F3F8)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('', style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    member.email,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            Chip(
              label: Text(
                member.roleDisplay,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}
