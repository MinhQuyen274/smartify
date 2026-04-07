import 'package:flutter/material.dart';
import 'package:smartify_flutter/features/smart-scenes/models/smart_scenes_models.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_flow_scaffold.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_segmented_control.dart';
import 'package:smartify_flutter/features/smart-scenes/state/smart_scenes_store.dart';

class SelectSmartSceneScreen extends StatefulWidget {
  const SelectSmartSceneScreen({
    super.key,
    required this.initialTab,
  });

  final SmartSceneSelectionTab initialTab;

  @override
  State<SelectSmartSceneScreen> createState() => _SelectSmartSceneScreenState();
}

class _SelectSmartSceneScreenState extends State<SelectSmartSceneScreen> {
  late SmartSceneSelectionTab _tab = widget.initialTab;
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final automation = SmartScenesStore.automationSceneOptions;
    final tapToRun = SmartScenesStore.tapToRunSceneOptions;
    final options = _tab == SmartSceneSelectionTab.automation ? automation : tapToRun;

    return SmartFlowScaffold(
      title: 'Select Smart Scene',
      actionLabel: 'OK',
      onAction: _selectedId == null
          ? null
          : () {
              final selected = options.firstWhere((item) => item.id == _selectedId);
              Navigator.pop(
                context,
                SceneSummaryItem(
                  id: selected.id,
                  title: selected.name,
                  subtitle:
                      '${_tab == SmartSceneSelectionTab.automation ? 'Automation' : 'Tap-to-Run'}: Enable',
                  icon: selected.icon,
                  color: _tab == SmartSceneSelectionTab.automation
                      ? const Color(0xFFFFA126)
                      : selected.color,
                ),
              );
            },
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
      ],
      body: Column(
        children: [
          SmartSegmentedControl(
            labels: const ['Automation', 'Tap-to-Run'],
            selectedIndex: _tab.index,
            onSelected: (index) {
              setState(() {
                _tab = SmartSceneSelectionTab.values[index];
                _selectedId = null;
              });
            },
          ),
          const SizedBox(height: 18),
          Expanded(
            child: _tab == SmartSceneSelectionTab.automation
                ? ListView.separated(
                    itemCount: automation.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = automation[index];
                      final selected = item.id == _selectedId;
                      return InkWell(
                        onTap: () => setState(() => _selectedId = item.id),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: Theme.of(context).textTheme.titleLarge),
                                    const SizedBox(height: 6),
                                    Text(item.taskLabel, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF8A8D96))),
                                  ],
                                ),
                              ),
                              Icon(
                                selected
                                    ? Icons.check_circle_rounded
                                    : Icons.circle_outlined,
                                color: const Color(0xFF4A68F6),
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.separated(
                    itemCount: tapToRun.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = tapToRun[index];
                      final selected = item.id == _selectedId;
                      return InkWell(
                        onTap: () => setState(() => _selectedId = item.id),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.taskLabel,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                selected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
