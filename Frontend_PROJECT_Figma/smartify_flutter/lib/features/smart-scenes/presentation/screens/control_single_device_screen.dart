import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/smart-scenes/state/smart_scenes_store.dart';

class ControlSingleDeviceScreen extends StatelessWidget {
  const ControlSingleDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SmartScenesStore>();
    return Scaffold(
      backgroundColor: LightColorTokens.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Expanded(
                    child: Text(
                      'Control Single Device',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 98,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: SmartScenesStore.deviceCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final category = SmartScenesStore.deviceCategories[index];
                    final selected = category.id == store.selectedDeviceCategoryId;
                    return InkWell(
                      onTap: () => store.selectDeviceCategory(category.id),
                      child: Container(
                        width: 130,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: category.backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                          border: selected
                              ? Border.all(color: const Color(0xFF4A68F6), width: 1.4)
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(category.icon, color: category.iconColor),
                            const Spacer(),
                            Text(category.title, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 4),
                            Text(category.countLabel, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF787B85))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: SmartScenesStore.roomFilters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final room = SmartScenesStore.roomFilters[index];
                    final selected = room == store.selectedRoom;
                    return ChoiceChip(
                      label: Text(
                        room == 'All Rooms' ? 'All Rooms (37)' : '$room (${room == 'Living Room' ? 8 : 5})',
                      ),
                      selected: selected,
                      onSelected: (_) => store.selectRoom(room),
                      selectedColor: const Color(0xFF4A68F6),
                      labelStyle: TextStyle(color: selected ? Colors.white : const Color(0xFF2F3238)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                        side: BorderSide(
                          color: selected ? Colors.transparent : const Color(0xFFD7DAE3),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: store.filteredDevices.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final device = store.filteredDevices[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset(device.assetPath, width: 46, height: 46),
                      title: Text(device.name, style: Theme.of(context).textTheme.titleLarge),
                      subtitle: Text(device.room, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF8A8D96))),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoutes.smartScenesTaskSelectFunction,
                          arguments: device,
                        );
                        if (result != null && context.mounted) {
                          Navigator.pop(context, result);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
