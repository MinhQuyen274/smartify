import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/home-devices/models/home_devices_models.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/device_category_card.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/device_grid_card.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/empty_devices_state_widget.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/room_filter_chips.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/weather_card.dart';
import 'package:smartify_flutter/features/home-devices/state/home_devices_store.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';

class MyHomeDashboardScreen extends StatelessWidget {
  const MyHomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<HomeDevicesStore>();
    final devices = store.filteredDevices;
    final hasAnyDevices = store.allDevices.isNotEmpty;
    final hasFilteredDevices = devices.isNotEmpty;

    return Scaffold(
      backgroundColor: LightColorTokens.background,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'mic',
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.homeDevicesVoiceAssistant,
            ),
            backgroundColor: Colors.white,
            child: const Icon(Icons.mic_rounded, color: Color(0xFF9B59B6)),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => _showHomeAddMenu(context),
            backgroundColor: LightColorTokens.primary,
            child: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 2) {
            Navigator.pushReplacementNamed(context, AppRoutes.reportsDashboard);
          } else if (i == 3) {
            Navigator.pushReplacementNamed(context, AppRoutes.accountProfile);
          } else if (i == 1) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.smartScenesDashboard,
            );
          }
        },
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.homeDevicesSwitchHome,
                        ),
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
                    ),
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.homeDevicesChatbot,
                      ),
                      icon: const Icon(
                        Icons.smart_toy_outlined,
                        color: LightColorTokens.primary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.homeDevicesNotifications,
                      ),
                      icon: Badge(
                        smallSize: 8,
                        child: const Icon(Icons.notifications_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: WeatherCard(data: store.weather),
              ),
            ),
            if (hasAnyDevices)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: AuthMotionSection(
                    delay: const Duration(milliseconds: 80),
                    child: SizedBox(
                      height: 108,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: store.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (_, i) {
                          final category = store.categories[i];
                          return DeviceCategoryCard(
                            category: category,
                            onTap: () => _openFirstDeviceForType(
                              context,
                              store,
                              category.type,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 8, 0),
                child: AuthMotionSection(
                  delay: const Duration(milliseconds: 120),
                  child: Row(
                    children: [
                      Text(
                        'All Devices',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: store.refreshDevices,
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: LightColorTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: AuthMotionSection(
                  delay: const Duration(milliseconds: 150),
                  child: RoomFilterChips(
                    rooms: store.availableRooms,
                    selected: store.selectedRoom,
                    onSelected: store.selectRoom,
                    deviceCounts: {
                      for (final r in store.availableRooms)
                        r: store.deviceCountForRoom(r),
                    },
                  ),
                ),
              ),
            ),
            if (!hasAnyDevices)
              SliverFillRemaining(
                hasScrollBody: false,
                child: store.loading
                    ? const Center(child: CircularProgressIndicator())
                    : EmptyDevicesStateWidget(
                        onAdd: () => Navigator.pushNamed(
                          context,
                          AppRoutes.homeDevicesAddDevice,
                        ),
                      ),
              )
            else if (!hasFilteredDevices)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyFilteredDevicesState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.02,
                  ),
                  itemCount: devices.length,
                  itemBuilder: (_, i) {
                    final device = devices[i];
                    return DeviceGridCard(
                      device: device,
                      onToggle: () => store.toggleDevice(device.id),
                      onTap: () {
                        final route = _controlRouteFor(device);
                        if (route != null) {
                          Navigator.pushNamed(
                            context,
                            route,
                            arguments: device.id,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showHomeAddMenu(BuildContext context) {
    final parentContext = context;
    return showGeneralDialog<void>(
      context: parentContext,
      barrierDismissible: true,
      barrierLabel: 'Add options',
      barrierColor: Colors.black.withValues(alpha: 0.18),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return _HomeAddOptionsOverlay(
          onAddDevice: () {
            Navigator.pop(dialogContext);
            Navigator.pushNamed(parentContext, AppRoutes.homeDevicesAddDevice);
          },
          onScan: () {
            Navigator.pop(dialogContext);
            Navigator.pushNamed(
              parentContext,
              AppRoutes.homeDevicesAddDevice,
              arguments: {'scan': true},
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
            alignment: Alignment.bottomRight,
            child: child,
          ),
        );
      },
    );
  }

  void _openFirstDeviceForType(
    BuildContext context,
    HomeDevicesStore store,
    DeviceType type,
  ) {
    final device = store.firstDeviceByType(type);
    if (device == null) return;
    final route = _controlRouteFor(device);
    if (route == null) return;
    Navigator.pushNamed(context, route, arguments: device.id);
  }

  String? _controlRouteFor(SmartDevice device) {
    if (device.type == DeviceType.light) {
      return AppRoutes.homeDevicesControlLamp;
    }
    if (device.id.startsWith('ac') || device.type == DeviceType.electrical) {
      return AppRoutes.homeDevicesControlAc;
    }
    if (device.type == DeviceType.camera) {
      return AppRoutes.homeDevicesControlCamera;
    }
    if (device.type == DeviceType.speaker) {
      return AppRoutes.homeDevicesControlSpeaker;
    }
    return AppRoutes.homeDevicesDashboard;
  }
}

class _HomeAddOptionsOverlay extends StatelessWidget {
  const _HomeAddOptionsOverlay({
    required this.onAddDevice,
    required this.onScan,
  });

  final VoidCallback onAddDevice;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              right: 24,
              bottom: 114,
              child: _HomeAddOptionsCard(
                onAddDevice: onAddDevice,
                onScan: onScan,
              ),
            ),
            Positioned(
              right: 16,
              bottom: 34,
              child: FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                backgroundColor: LightColorTokens.primary,
                child: const Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAddOptionsCard extends StatelessWidget {
  const _HomeAddOptionsCard({required this.onAddDevice, required this.onScan});

  final VoidCallback onAddDevice;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 154,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A161B33),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HomeAddOptionTile(
                icon: Icons.work_outline_rounded,
                label: 'Add Device',
                onTap: onAddDevice,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _HomeAddOptionTile(
                icon: Icons.qr_code_scanner_rounded,
                label: 'Scan',
                onTap: onScan,
              ),
            ],
          ),
        ),
        Positioned(
          right: 14,
          bottom: -8,
          child: Transform.rotate(
            angle: 0.8,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeAddOptionTile extends StatelessWidget {
  const _HomeAddOptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFF262A35)),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFilteredDevicesState extends StatelessWidget {
  const _EmptyFilteredDevicesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AuthMotionSection(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 56,
              color: LightColorTokens.textSecondary,
            ),
            const SizedBox(height: LightThemeData.spacingL),
            Text(
              'No devices in this room',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: LightThemeData.spacingS),
            Text(
              'Try another room filter.',
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
