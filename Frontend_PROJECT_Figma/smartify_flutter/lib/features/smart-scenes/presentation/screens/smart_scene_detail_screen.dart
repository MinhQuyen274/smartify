import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/home-devices/state/home_devices_store.dart';
import 'package:smartify_flutter/features/smart-scenes/models/smart_scenes_models.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/scene_builder_section_card.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/scene_summary_tile.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_primary_action_button.dart';
import 'package:smartify_flutter/features/smart-scenes/state/smart_scenes_store.dart';

class SmartSceneDetailArgs {
  const SmartSceneDetailArgs({
    required this.sceneId,
    required this.mode,
  });

  final String sceneId;
  final SceneDraftMode mode;
}

class SmartSceneDetailScreen extends StatelessWidget {
  const SmartSceneDetailScreen({super.key, required this.args});

  final SmartSceneDetailArgs args;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SmartScenesStore>();
    final draft = store.draftForScene(args.sceneId, args.mode);
    final name = args.mode == SceneDraftMode.automation
        ? store.automationName(args.sceneId)
        : store.tapToRunName(args.sceneId);

    return Scaffold(
      backgroundColor: LightColorTokens.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Expanded(
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
                child: Column(
                  children: [
                    SceneBuilderSectionCard(
                      title: 'If',
                      child: Column(
                        children: [
                          if (args.mode == SceneDraftMode.automation)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 14, bottom: 10),
                                child: Text(
                                  draft.matchMode.label,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFF7E818B),
                                  ),
                                ),
                              ),
                            ),
                          for (int index = 0; index < draft.conditions.length; index++) ...[
                            SceneSummaryTile(
                              title: draft.conditions[index].title,
                              subtitle: draft.conditions[index].subtitle,
                              icon: draft.conditions[index].icon,
                              color: draft.conditions[index].color,
                            ),
                            if (index != draft.conditions.length - 1)
                              const Divider(height: 1, color: Color(0xFFE9EBF0)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SceneBuilderSectionCard(
                      title: 'Then',
                      child: Column(
                        children: [
                          for (int index = 0; index < draft.tasks.length; index++) ...[
                            SceneSummaryTile(
                              title: draft.tasks[index].title,
                              subtitle: draft.tasks[index].subtitle,
                              icon: draft.tasks[index].icon,
                              color: draft.tasks[index].color,
                            ),
                            if (index != draft.tasks.length - 1)
                              const Divider(height: 1, color: Color(0xFFE9EBF0)),
                          ],
                        ],
                      ),
                    ),
                    if (args.mode == SceneDraftMode.tapToRun) ...[
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Text('Style', style: Theme.of(context).textTheme.titleLarge),
                            const Spacer(),
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: draft.styleColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(draft.styleIcon, color: Colors.white, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: SmartPrimaryActionButton(
                    label: 'Edit Scene',
                    onTap: () async {
                      store.loadSceneIntoDraft(args.sceneId, args.mode);
                      final result = await Navigator.pushNamed(
                        context,
                        AppRoutes.smartScenesCreate,
                      );
                      if (result is String && context.mounted) {
                        Navigator.pop(context, result);
                      }
                    },
                    margin: const EdgeInsets.fromLTRB(24, 12, 8, 20),
                  ),
                ),
                Expanded(
                  child: SmartPrimaryActionButton(
                    label: 'Run Now',
                    onTap: () {
                      final homeStore = context.read<HomeDevicesStore>();
                      final message = args.mode == SceneDraftMode.automation
                          ? store.runAutomationNow(args.sceneId, homeStore)
                          : store.executeTapToRun(args.sceneId, homeStore);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    margin: const EdgeInsets.fromLTRB(8, 12, 24, 20),
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
