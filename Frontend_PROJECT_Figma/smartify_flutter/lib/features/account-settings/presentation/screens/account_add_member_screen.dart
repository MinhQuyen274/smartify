import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';
import 'package:smartify_flutter/features/account-settings/models/home_management_models.dart';

class AccountAddMemberScreen extends StatefulWidget {
  const AccountAddMemberScreen({super.key});

  @override
  State<AccountAddMemberScreen> createState() => _AccountAddMemberScreenState();
}

class _AccountAddMemberScreenState extends State<AccountAddMemberScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  HomeMemberRole _selectedRole = HomeMemberRole.member;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Add Member',
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF4F46E5),
            unselectedLabelColor: const Color(0xFF9CA3AF),
            indicatorColor: const Color(0xFF4F46E5),
            tabs: const [
              Tab(text: 'Invite via Email'),
              Tab(text: 'Invite via QR Code'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _EmailInviteTab(
                  emailController: _emailController,
                  selectedRole: _selectedRole,
                  onRoleChanged: (role) => setState(() => _selectedRole = role),
                ),
                _QRCodeTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

class _EmailInviteTab extends StatelessWidget {
  final TextEditingController emailController;
  final HomeMemberRole selectedRole;
  final Function(HomeMemberRole) onRoleChanged;

  const _EmailInviteTab({
    required this.emailController,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.mail_outline),
                hintText: 'sarah.wilona@yourdomain.com',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Role', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                ..._buildRoleOptions(context),
              ],
            ),
            const SizedBox(height: 24),
            _SendButton(onSend: () => _sendInvite(context)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRoleOptions(BuildContext context) {
    return [
      _RoleOption(
        title: 'Admin',
        description: 'Manage devices & rooms, manage members, & manage smart scenes',
        isSelected: selectedRole == HomeMemberRole.admin,
        onTap: () => onRoleChanged(HomeMemberRole.admin),
      ),
      const SizedBox(height: 12),
      _RoleOption(
        title: 'Member',
        description: 'Use devices, use smart scenes',
        isSelected: selectedRole == HomeMemberRole.member,
        onTap: () => onRoleChanged(HomeMemberRole.member),
      ),
    ];
  }

  void _sendInvite(BuildContext context) {
    if (emailController.text.isEmpty) return;
    final store = Provider.of<AccountSettingsStore>(context, listen: false);
    final newMember = HomeMember(
      id: DateTime.now().toString(),
      name: emailController.text.split('@').first,
      email: emailController.text,
      avatarUrl: '',
      role: selectedRole,
    );
    store.addHomeMember(newMember);
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
              Text('An invitation has been sent to\n""', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleOption({
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
          border: Border.all(color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Radio<bool>(value: true, groupValue: isSelected, onChanged: (_) => onTap()),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF9CA3AF))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final VoidCallback onSend;

  const _SendButton({required this.onSend});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSend,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4F46E5),
        minimumSize: const Size.fromHeight(50),
      ),
      child: const Text('Send Invite', style: TextStyle(color: Colors.white)),
    );
  }
}

class _QRCodeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Icon(Icons.qr_code_2_rounded, size: 100)),
          ),
          const SizedBox(height: 16),
          Text('F6Z9K4X7', style: Theme.of(context).textTheme.titleSmall),
          Text('Invitation Code', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF9CA3AF))),
        ],
      ),
    );
  }
}
