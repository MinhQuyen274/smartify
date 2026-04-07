import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/smart-scenes/models/smart_scenes_models.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/scene_builder_section_card.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/scene_summary_tile.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/sheet_option_row.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_primary_action_button.dart';
import 'package:smartify_flutter/features/smart-scenes/state/smart_scenes_store.dart';

class CreateSceneScreen extends StatelessWidget {
  const CreateSceneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SmartScenesStore>();
    final draft = store.draft;
    final canSave = draft.conditions.isNotEmpty && draft.tasks.isNotEmpty;

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
                      'Create Scene',
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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Column(
                  children: [
                    SceneBuilderSectionCard(
                      title: 'If',
                      onAdd: () => _showConditionSheet(context),
                      child: Column(
                        children: [
                          if (draft.mode == SceneDraftMode.automation)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () => _showConditionMatchSheet(context),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 14, bottom: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          draft.matchMode.label,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            color: const Color(0xFF7E818B),
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.keyboard_arrow_down_rounded),
                                    ],
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
                              onRemove: () => store.removeCondition(draft.conditions[index].id),
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
                      onAdd: () => _showTaskSheet(context),
                      child: draft.tasks.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 22, bottom: 8),
                              child: OutlinedButton(
                                onPressed: () => _showTaskSheet(context),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 46),
                                  side: const BorderSide(color: Color(0xFFD7DAE3)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: Text(
                                  'Add Task',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                for (int index = 0; index < draft.tasks.length; index++) ...[
                                  SceneSummaryTile(
                                    title: draft.tasks[index].title,
                                    subtitle: draft.tasks[index].subtitle,
                                    icon: draft.tasks[index].icon,
                                    color: draft.tasks[index].color,
                                    onRemove: () => store.removeTask(draft.tasks[index].id),
                                  ),
                                  if (index != draft.tasks.length - 1)
                                    const Divider(height: 1, color: Color(0xFFE9EBF0)),
                                ],
                              ],
                            ),
                    ),
                    if (draft.mode == SceneDraftMode.tapToRun) ...[
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () => _showStyleSheet(context),
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
                              const SizedBox(width: 10),
                              const Icon(Icons.chevron_right_rounded),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SmartPrimaryActionButton(
              label: 'Save',
              onTap: () {
                if (!canSave) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add at least one condition and one task before saving.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                _showSceneNameSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showConditionMatchSheet(BuildContext context) async {
    final store = context.read<SmartScenesStore>();
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('When any condition is met'),
              trailing: store.draft.matchMode == SceneConditionMatchMode.any
                  ? const Icon(Icons.check_rounded, color: LightColorTokens.primary)
                  : null,
              onTap: () {
                store.setDraftMatchMode(SceneConditionMatchMode.any);
                Navigator.pop(sheetContext);
              },
            ),
            ListTile(
              title: const Text('When all conditions are met'),
              trailing: store.draft.matchMode == SceneConditionMatchMode.all
                  ? const Icon(Icons.check_rounded, color: LightColorTokens.primary)
                  : null,
              onTap: () {
                store.setDraftMatchMode(SceneConditionMatchMode.all);
                Navigator.pop(sheetContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showConditionSheet(BuildContext context) async {
    final store = context.read<SmartScenesStore>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 56, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E6EB), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text('Add Condition', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 20),
              const Divider(height: 1, color: Color(0xFFE9EBF0)),
              for (final option in SmartScenesStore.addConditionOptions) ...[
                SheetOptionRow(
                  icon: option.icon,
                  color: option.color,
                  title: option.title,
                  trailingInfo: option.trailingInfo,
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    if (option.title == 'Tap-to-Run') {
                      store.startDraft(SceneDraftMode.tapToRun);
                      return;
                    }
                    final result = await _pushConditionRoute(context, option.title);
                    if (result is SceneSummaryItem && context.mounted) {
                      store.addCondition(result);
                    }
                  },
                ),
                const Divider(height: 1, color: Color(0xFFE9EBF0)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<Object?> _pushConditionRoute(BuildContext context, String title) {
    switch (title) {
      case 'When Weather Changes':
        return Navigator.pushNamed(context, AppRoutes.smartScenesWeatherMenu);
      case 'When Location Changes':
        return Navigator.pushNamed(context, AppRoutes.smartScenesConditionLocationChange);
      case 'Schedule Time':
        return Navigator.pushNamed(context, AppRoutes.smartScenesConditionScheduleTime);
      case 'When Device Status Changes':
        return Future<Object?>.value(
          SceneSummaryItem(
            id: 'device-status',
            title: 'Device Status Changed',
            subtitle: 'Living Room',
            icon: Icons.business_center_rounded,
            color: const Color(0xFF2196F3),
          ),
        );
      case 'Change Arm Mode':
        return Future<Object?>.value(
          SceneSummaryItem(
            id: 'arm-mode-condition',
            title: 'Arm Mode: Away',
            subtitle: 'Home Security',
            icon: Icons.shield_rounded,
            color: const Color(0xFF9C27B0),
          ),
        );
      case 'When Alarm Triggered':
        return Future<Object?>.value(
          SceneSummaryItem(
            id: 'alarm-triggered',
            title: 'Alarm Triggered',
            subtitle: 'Home Security',
            icon: Icons.alarm_rounded,
            color: const Color(0xFFFF5543),
          ),
        );
      default:
        return Future<Object?>.value(null);
    }
  }

  Future<void> _showTaskSheet(BuildContext context) async {
    final store = context.read<SmartScenesStore>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 56, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E6EB), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text('Add Task', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 20),
              const Divider(height: 1, color: Color(0xFFE9EBF0)),
              for (final option in SmartScenesStore.addTaskOptions) ...[
                SheetOptionRow(
                  icon: option.icon,
                  color: option.color,
                  title: option.title,
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final result = await _pushTaskRoute(context, option.title, store.draft.mode);
                    if (result is SceneSummaryItem && context.mounted) {
                      store.addTask(result);
                    }
                  },
                ),
                const Divider(height: 1, color: Color(0xFFE9EBF0)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<Object?> _pushTaskRoute(
    BuildContext context,
    String title,
    SceneDraftMode mode,
  ) {
    switch (title) {
      case 'Control Single Device':
        return Navigator.pushNamed(context, AppRoutes.smartScenesTaskControlSingleDevice);
      case 'Select Smart Scene':
        return Navigator.pushNamed(
          context,
          AppRoutes.smartScenesTaskSelectSmartScene,
          arguments: mode == SceneDraftMode.automation
              ? SmartSceneSelectionTab.automation
              : SmartSceneSelectionTab.tapToRun,
        );
      case 'Delay the Action':
        return Navigator.pushNamed(context, AppRoutes.smartScenesTaskDelayAction);
      case 'Change Arm Mode':
        return Future<Object?>.value(
          SceneSummaryItem(
            id: 'arm-mode-task',
            title: 'Change Arm Mode',
            subtitle: 'Set Home Security to Away',
            icon: Icons.shield_rounded,
            color: const Color(0xFF9C27B0),
          ),
        );
      case 'Send Notification':
        return Future<Object?>.value(
          SceneSummaryItem(
            id: 'send-notification',
            title: 'Send Notification',
            subtitle: 'Push notification to your phone',
            icon: Icons.notifications_rounded,
            color: const Color(0xFFFF5543),
          ),
        );
      default:
        return Future<Object?>.value(null);
    }
  }

  Future<void> _showStyleSheet(BuildContext context) async {
    final store = context.read<SmartScenesStore>();
    int selectedTab = 0;
    Color tempColor = store.draft.styleColor;
    IconData tempIcon = store.draft.styleIcon;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 56, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E6EB), borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 20),
                    Text('Style', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: Color(0xFFE9EBF0)),
                    const SizedBox(height: 20),
                    Container(
                      height: 42,
                      decoration: BoxDecoration(color: const Color(0xFFF5F5F8), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          _StyleTab(label: 'Color', selected: selectedTab == 0, onTap: () => setSheetState(() => selectedTab = 0)),
                          _StyleTab(label: 'Icon', selected: selectedTab == 1, onTap: () => setSheetState(() => selectedTab = 1)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    if (selectedTab == 0)
                      Wrap(
                        spacing: 18,
                        runSpacing: 18,
                        children: [
                          for (final color in SmartScenesStore.styleColors)
                            InkWell(
                              onTap: () => setSheetState(() => tempColor = color),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                                child: tempColor == color
                                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 28)
                                    : null,
                              ),
                            ),
                        ],
                      )
                    else
                      Wrap(
                        spacing: 18,
                        runSpacing: 18,
                        children: [
                          for (final icon in SmartScenesStore.styleIcons)
                            InkWell(
                              onTap: () => setSheetState(() => tempIcon = icon),
                              child: Container(
                                width: 42,
                                height: 42,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: tempIcon == icon
                                      ? const Color(0xFFF5F5F8)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  icon,
                                  color: tempIcon == icon
                                      ? tempColor
                                      : const Color(0xFF61656F),
                                  size: 28,
                                ),
                              ),
                            ),
                        ],
                      ),
                    const SizedBox(height: 22),
                    const Divider(height: 1, color: Color(0xFFE9EBF0)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              store.setDraftStyleColor(tempColor);
                              store.setDraftStyleIcon(tempIcon);
                              Navigator.pop(sheetContext);
                            },
                            child: const Text('OK'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> _showSceneNameSheet(BuildContext context) async {
    final store = context.read<SmartScenesStore>();
    final rootNavigator = Navigator.of(context);
    final suggestion = store.draft.mode == SceneDraftMode.automation
        ? 'Enter automation name'
        : 'Enter tap-to-run name';
    final controller = TextEditingController();

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 56, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E6EB), borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 20),
                Text('Scene Name', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 20),
                const Divider(height: 1, color: Color(0xFFE9EBF0)),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  autofocus: false,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: suggestion,
                  ),
                  onSubmitted: (value) {
                    final trimmed = value.trim();
                    if (trimmed.isEmpty) {
                      return;
                    }
                    FocusScope.of(sheetContext).unfocus();
                    store.saveDraft(trimmed);
                    Navigator.pop(sheetContext);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) {
                        rootNavigator.pop(trimmed);
                      }
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          final value = controller.text.trim();
                          if (value.isEmpty) {
                            return;
                          }
                          FocusScope.of(sheetContext).unfocus();
                          store.saveDraft(value);
                          Navigator.pop(sheetContext);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (context.mounted) {
                              rootNavigator.pop(value);
                            }
                          });
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StyleTab extends StatelessWidget {
  const _StyleTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? LightColorTokens.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: selected ? Colors.white : const Color(0xFF2F3137),
            ),
          ),
        ),
      ),
    );
  }
}
