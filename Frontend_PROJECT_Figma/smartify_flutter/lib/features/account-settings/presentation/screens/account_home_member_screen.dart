import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';
import 'package:smartify_flutter/features/account-settings/models/home_management_models.dart';

class AccountHomeMemberScreen extends StatelessWidget {
  final String? memberId;
  const AccountHomeMemberScreen({super.key, this.memberId});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Home Member',
      child: Consumer<AccountSettingsStore>(
        builder: (context, store, child) {
          final home = store.selectedHome;
          final member = home.members.firstWhere((m) => m.id == memberId, orElse: () => home.members.first);
          
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFFE9D5FF),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Text(member.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(member.email, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF9CA3AF))),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _RoleItem(
                label: 'Role',
                value: member.roleDisplay,
                onTap: () {},
              ),
              const SizedBox(height: 24),
              _RemoveButton(
                onTap: () => _showRemoveDialog(context, member, store),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, HomeMember member, AccountSettingsStore store) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Remove Member', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFFEF4444))),
              const SizedBox(height: 16),
              Text('Are you sure you want to remove\n"" ?', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Color(0xFF4F46E5)))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        store.removeHomeMember(member.id);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        _showSuccessDialog(context, member.name);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F46E5)),
                      child: const Text('Yes, Remove', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String memberName) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(28)),
                child: const Icon(Icons.check, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 16),
              Text('\"\" has been removed!', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F46E5)),
                child: const Text('Done', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _RoleItem({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleSmall),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RemoveButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEF4444), width: 2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text('Remove Member', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFFEF4444), fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
