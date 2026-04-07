import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/features/account-settings/models/home_management_models.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';
import 'package:smartify_flutter/features/account-settings/state/account_settings_store.dart';

class AccountRoomManagementScreen extends StatefulWidget {
  const AccountRoomManagementScreen({super.key});

  @override
  State<AccountRoomManagementScreen> createState() => _AccountRoomManagementScreenState();
}

class _AccountRoomManagementScreenState extends State<AccountRoomManagementScreen> {
  bool _isManageMode = false;

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Room Management',
      child: Consumer<AccountSettingsStore>(
        builder: (context, store, child) {
          final home = store.selectedHome;
          final rooms = home.rooms;
          
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              ...rooms.map((room) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _RoomTile(room: room, isManageMode: _isManageMode),
                );
              }).toList(),
              const SizedBox(height: 16),
              _ActionButton(
                label: 'Add Room',
                borderColor: const Color(0xFF4F46E5),
                textColor: const Color(0xFF4F46E5),
                onTap: () => _showAddRoomDialog(context, store),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddRoomDialog(BuildContext context, AccountSettingsStore store) {
    showDialog(
      context: context,
      builder: (context) => _AddRoomDialog(onSave: (roomName, preset) {
        final newRoom = Room(id: DateTime.now().toString(), name: roomName);
        store.addRoom(newRoom);
        Navigator.pop(context);
      }),
    );
  }
}

class _RoomTile extends StatelessWidget {
  final Room room;
  final bool isManageMode;

  const _RoomTile({required this.room, required this.isManageMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          if (isManageMode) const Icon(Icons.drag_handle_rounded, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          Expanded(child: Text(room.name, style: Theme.of(context).textTheme.titleSmall)),
          const SizedBox(width: 8),
          if (isManageMode) Icon(Icons.delete_rounded, color: const Color(0xFFEF4444), size: 20),
          if (!isManageMode) const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    this.backgroundColor,
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
          color: backgroundColor ?? Colors.transparent,
          border: borderColor != null ? Border.all(color: borderColor!, width: 2) : null,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class _AddRoomDialog extends StatefulWidget {
  final Function(String, String) onSave;

  const _AddRoomDialog({required this.onSave});

  @override
  State<_AddRoomDialog> createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends State<_AddRoomDialog> {
  final _controller = TextEditingController();
  String? _selectedPreset;

  final _presets = ['Study Room', 'Kids\' Room', 'Library', 'Balcony', 'Workshop', 'Rooftop'];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add Room', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Bedroom 2',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: _presets.map((preset) {
                return FilterChip(
                  label: Text(preset),
                  selected: _selectedPreset == preset,
                  onSelected: (selected) => setState(() => _selectedPreset = selected ? preset : null),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _DialogButton(label: 'Cancel', onTap: () => Navigator.pop(context))),
                const SizedBox(width: 12),
                Expanded(
                  child: _DialogButton(
                    label: 'Save',
                    isPrimary: true,
                    onTap: () => widget.onSave(_controller.text, _selectedPreset ?? ''),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _DialogButton({required this.label, this.isPrimary = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF4F46E5) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: isPrimary ? Colors.white : const Color(0xFF4F46E5))),
        ),
      ),
    );
  }
}
