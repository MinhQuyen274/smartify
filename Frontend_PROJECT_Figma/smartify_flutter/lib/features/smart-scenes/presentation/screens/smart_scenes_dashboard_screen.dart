import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:smartify_flutter/features/home-devices/state/home_devices_store.dart';
import 'package:smartify_flutter/features/smart-scenes/models/smart_scenes_models.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/smart_scene_detail_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/automation_card.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_segmented_control.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/tap_to_run_tile.dart';
import 'package:smartify_flutter/features/smart-scenes/state/smart_scenes_store.dart';

class SmartScenesDashboardScreen extends StatelessWidget {
  const SmartScenesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SmartScenesStore>();
    final showingAutomation = store.dashboardTabIndex == 0;

    return Scaffold(
      backgroundColor: LightColorTokens.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final mode = showingAutomation
              ? SceneDraftMode.automation
              : SceneDraftMode.tapToRun;
          context.read<SmartScenesStore>().startDraft(mode);
          final result = await Navigator.pushNamed(
            context,
            AppRoutes.smartScenesCreate,
          );
          if (result is String && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Saved "$result"'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        backgroundColor: LightColorTokens.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 34),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.homeDevicesDashboard);
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, AppRoutes.reportsDashboard);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, AppRoutes.accountProfile);
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('My Home', style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down_rounded),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Scene history is not available yet.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.note_alt_outlined, size: 24),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Alternate Smart view is not available yet.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.grid_view_rounded, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SmartSegmentedControl(
                labels: const ['Automation', 'Tap-to-Run'],
                selectedIndex: store.dashboardTabIndex,
                onSelected: store.setDashboardTab,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: showingAutomation
                      ? _AutomationList(items: store.automations)
                      : _TapToRunList(items: store.tapToRunItems),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AutomationList extends StatelessWidget {
  const _AutomationList({required this.items});

  final List<AutomationItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const ValueKey('automation-list'),
      padding: const EdgeInsets.only(bottom: 100),
      itemBuilder: (context, index) {
        final item = items[index];
        return AutomationCard(
          item: item,
          onTap: () async {
            final result = await Navigator.pushNamed(
              context,
              AppRoutes.smartScenesDetail,
              arguments: SmartSceneDetailArgs(
                sceneId: item.id,
                mode: SceneDraftMode.automation,
              ),
            );
            if (result is String && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Saved "$result"'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          onToggle: () {
            final message = context.read<SmartScenesStore>().toggleAutomation(
                  item.id,
                  context.read<HomeDevicesStore>(),
                );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemCount: items.length,
    );
  }
}

class _TapToRunList extends StatelessWidget {
  const _TapToRunList({required this.items});

  final List<TapToRunItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const ValueKey('tap-to-run-list'),
      padding: const EdgeInsets.only(bottom: 100),
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return TapToRunTile(
          item: item,
          onTap: () async {
            final result = await Navigator.pushNamed(
              context,
              AppRoutes.smartScenesDetail,
              arguments: SmartSceneDetailArgs(
                sceneId: item.id,
                mode: SceneDraftMode.tapToRun,
              ),
            );
            if (result is String && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Saved "$result"'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          onRun: () {
            final message = context.read<SmartScenesStore>().executeTapToRun(
                  item.id,
                  context.read<HomeDevicesStore>(),
                );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }
}
