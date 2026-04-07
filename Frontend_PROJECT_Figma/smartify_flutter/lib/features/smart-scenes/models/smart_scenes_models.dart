import 'package:flutter/material.dart';

class AutomationItem {
  const AutomationItem({
    required this.id,
    required this.name,
    required this.taskCount,
    required this.triggerIcons,
    this.isActive = true,
  });

  final String id;
  final String name;
  final int taskCount;
  final List<SceneStepIcon> triggerIcons;
  final bool isActive;

  AutomationItem copyWith({bool? isActive}) {
    return AutomationItem(
      id: id,
      name: name,
      taskCount: taskCount,
      triggerIcons: triggerIcons,
      isActive: isActive ?? this.isActive,
    );
  }
}

class TapToRunItem {
  const TapToRunItem({
    required this.id,
    required this.name,
    required this.taskCount,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final int taskCount;
  final IconData icon;
  final Color color;
}

class SceneStepIcon {
  const SceneStepIcon({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;
}

class SceneSummaryItem {
  const SceneSummaryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class SceneActionOption {
  const SceneActionOption({
    required this.title,
    required this.icon,
    required this.color,
    this.subtitle,
    this.trailingInfo = false,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final bool trailingInfo;
}

class SmartSceneDeviceCategory {
  const SmartSceneDeviceCategory({
    required this.id,
    required this.title,
    required this.countLabel,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  final String id;
  final String title;
  final String countLabel;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
}

class SmartSceneDevice {
  const SmartSceneDevice({
    required this.id,
    required this.name,
    required this.room,
    required this.categoryId,
    required this.assetPath,
    required this.taskIcon,
    required this.taskColor,
  });

  final String id;
  final String name;
  final String room;
  final String categoryId;
  final String assetPath;
  final IconData taskIcon;
  final Color taskColor;
}

class SelectableSmartScene {
  const SelectableSmartScene({
    required this.id,
    required this.name,
    required this.taskLabel,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final String taskLabel;
  final IconData icon;
  final Color color;
}

class SceneDraft {
  const SceneDraft({
    required this.mode,
    required this.matchMode,
    required this.conditions,
    required this.tasks,
    required this.styleColor,
    required this.styleIcon,
  });

  factory SceneDraft.initial(SceneDraftMode mode) {
    return SceneDraft(
      mode: mode,
      matchMode: SceneConditionMatchMode.any,
      conditions: mode == SceneDraftMode.tapToRun
          ? const [
              SceneSummaryItem(
                id: 'tap-to-run-trigger',
                title: 'Launch Tap-to-Run',
                subtitle: 'One tap to execute commands',
                icon: Icons.touch_app_rounded,
                color: Color(0xFF6C8DFF),
              ),
            ]
          : const [],
      tasks: const [],
      styleColor: const Color(0xFFFFA126),
      styleIcon: Icons.wb_sunny_rounded,
    );
  }

  final SceneDraftMode mode;
  final SceneConditionMatchMode matchMode;
  final List<SceneSummaryItem> conditions;
  final List<SceneSummaryItem> tasks;
  final Color styleColor;
  final IconData styleIcon;

  SceneDraft copyWith({
    SceneDraftMode? mode,
    SceneConditionMatchMode? matchMode,
    List<SceneSummaryItem>? conditions,
    List<SceneSummaryItem>? tasks,
    Color? styleColor,
    IconData? styleIcon,
  }) {
    return SceneDraft(
      mode: mode ?? this.mode,
      matchMode: matchMode ?? this.matchMode,
      conditions: conditions ?? this.conditions,
      tasks: tasks ?? this.tasks,
      styleColor: styleColor ?? this.styleColor,
      styleIcon: styleIcon ?? this.styleIcon,
    );
  }
}

enum SceneDraftMode { automation, tapToRun }

enum SmartSceneSelectionTab { automation, tapToRun }

enum ComparatorMode { lessThan, equalTo, greaterThan }

extension ComparatorModeX on ComparatorMode {
  String get symbol {
    switch (this) {
      case ComparatorMode.lessThan:
        return '<';
      case ComparatorMode.equalTo:
        return '=';
      case ComparatorMode.greaterThan:
        return '>';
    }
  }
}

enum SceneConditionMatchMode { any, all }

extension SceneConditionMatchModeX on SceneConditionMatchMode {
  String get label {
    switch (this) {
      case SceneConditionMatchMode.any:
        return 'When any condition is met';
      case SceneConditionMatchMode.all:
        return 'When all conditions are met';
    }
  }
}
