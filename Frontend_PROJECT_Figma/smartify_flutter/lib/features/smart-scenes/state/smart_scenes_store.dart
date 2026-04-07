import 'package:flutter/material.dart';
import 'package:smartify_flutter/features/home-devices/models/home_devices_models.dart';
import 'package:smartify_flutter/features/home-devices/state/home_devices_store.dart';
import 'package:smartify_flutter/features/smart-scenes/models/smart_scenes_models.dart';

class SmartScenesStore extends ChangeNotifier {
  SmartScenesStore()
      : _automations = _buildInitialAutomations(),
        _tapToRunItems = _buildInitialTapToRuns(),
        _draft = SceneDraft.initial(SceneDraftMode.automation);

  int _dashboardTabIndex = 0;
  int _idCounter = 0;
  String _selectedDeviceCategoryId = deviceCategories.first.id;
  String _selectedRoom = roomFilters[1];
  SceneDraft _draft;
  final List<AutomationItem> _automations;
  final List<TapToRunItem> _tapToRunItems;
  final Map<String, List<SceneSummaryItem>> _savedAutomationConditions = {};
  final Map<String, List<SceneSummaryItem>> _savedAutomationTasks = {};
  final Map<String, List<SceneSummaryItem>> _savedTapToRunConditions = {};
  final Map<String, List<SceneSummaryItem>> _savedTapToRunTasks = {};

  int get dashboardTabIndex => _dashboardTabIndex;
  List<AutomationItem> get automations => List.unmodifiable(_automations);
  List<TapToRunItem> get tapToRunItems => List.unmodifiable(_tapToRunItems);
  SceneDraft get draft => _draft;
  String get selectedDeviceCategoryId => _selectedDeviceCategoryId;
  String get selectedRoom => _selectedRoom;

  List<SmartSceneDevice> get filteredDevices {
    return devices.where((device) {
      final roomMatches =
          _selectedRoom == 'All Rooms' || device.room == _selectedRoom;
      return device.categoryId == _selectedDeviceCategoryId && roomMatches;
    }).toList(growable: false);
  }

  void setDashboardTab(int index) {
    if (_dashboardTabIndex == index) return;
    _dashboardTabIndex = index;
    notifyListeners();
  }

  String toggleAutomation(String id, HomeDevicesStore homeDevicesStore) {
    final index = _automations.indexWhere((item) => item.id == id);
    if (index < 0) return 'Automation not found.';
    final nextState = !_automations[index].isActive;
    _automations[index] = _automations[index].copyWith(isActive: nextState);
    notifyListeners();
    if (nextState) {
      return _applyAutomation(id, homeDevicesStore);
    }
    return _disableAutomation(id, homeDevicesStore);
  }

  void startDraft(SceneDraftMode mode) {
    _draft = SceneDraft.initial(mode);
    _selectedDeviceCategoryId = deviceCategories.first.id;
    _selectedRoom = roomFilters[1];
    notifyListeners();
  }

  void setDraftMode(SceneDraftMode mode) {
    if (_draft.mode == mode) return;
    _draft = SceneDraft.initial(mode).copyWith(tasks: _draft.tasks);
    notifyListeners();
  }

  void setDraftMatchMode(SceneConditionMatchMode mode) {
    if (_draft.matchMode == mode) return;
    _draft = _draft.copyWith(matchMode: mode);
    notifyListeners();
  }

  void addCondition(SceneSummaryItem item) {
    final conditions = List<SceneSummaryItem>.from(_draft.conditions);
    conditions.add(item);
    _draft = _draft.copyWith(conditions: conditions);
    notifyListeners();
  }

  void removeCondition(String id) {
    final conditions =
        _draft.conditions.where((item) => item.id != id).toList(growable: false);
    _draft = _draft.copyWith(conditions: conditions);
    notifyListeners();
  }

  void addTask(SceneSummaryItem item) {
    final tasks = List<SceneSummaryItem>.from(_draft.tasks);
    tasks.add(item);
    _draft = _draft.copyWith(tasks: tasks);
    notifyListeners();
  }

  void removeTask(String id) {
    final tasks =
        _draft.tasks.where((item) => item.id != id).toList(growable: false);
    _draft = _draft.copyWith(tasks: tasks);
    notifyListeners();
  }

  void setDraftStyleColor(Color color) {
    if (_draft.styleColor == color) return;
    _draft = _draft.copyWith(styleColor: color);
    notifyListeners();
  }

  void setDraftStyleIcon(IconData icon) {
    if (_draft.styleIcon == icon) return;
    _draft = _draft.copyWith(styleIcon: icon);
    notifyListeners();
  }

  void selectDeviceCategory(String categoryId) {
    if (_selectedDeviceCategoryId == categoryId) return;
    _selectedDeviceCategoryId = categoryId;
    notifyListeners();
  }

  void selectRoom(String room) {
    if (_selectedRoom == room) return;
    _selectedRoom = room;
    notifyListeners();
  }

  void saveDraft(String name) {
    final cleanName = name.trim();
    if (cleanName.isEmpty || _draft.tasks.isEmpty || _draft.conditions.isEmpty) {
      return;
    }

    if (_draft.mode == SceneDraftMode.automation) {
      final automationId = _nextId('automation');
      _automations.insert(
        0,
        AutomationItem(
          id: automationId,
          name: cleanName,
          taskCount: _draft.tasks.length,
          triggerIcons: [
            ..._draft.conditions.take(2).map(
                  (item) => SceneStepIcon(icon: item.icon, color: item.color),
                ),
            SceneStepIcon(
              icon: _draft.tasks.first.icon,
              color: _draft.tasks.first.color,
            ),
          ],
        ),
      );
      _savedAutomationConditions[automationId] =
          List<SceneSummaryItem>.from(_draft.conditions);
      _savedAutomationTasks[automationId] =
          List<SceneSummaryItem>.from(_draft.tasks);
      _dashboardTabIndex = 0;
    } else {
      final tapId = _nextId('tap');
      _tapToRunItems.insert(
        0,
        TapToRunItem(
          id: tapId,
          name: cleanName,
          taskCount: _draft.tasks.length,
          icon: _draft.styleIcon,
          color: _draft.styleColor,
        ),
      );
      _savedTapToRunConditions[tapId] =
          List<SceneSummaryItem>.from(_draft.conditions);
      _savedTapToRunTasks[tapId] = List<SceneSummaryItem>.from(_draft.tasks);
      _dashboardTabIndex = 1;
    }

    _draft = SceneDraft.initial(_draft.mode);
    notifyListeners();
  }

  String createId(String prefix) => _nextId(prefix);

  String automationName(String id) {
    return _automations.firstWhere((item) => item.id == id).name;
  }

  String tapToRunName(String id) {
    return _tapToRunItems.firstWhere((item) => item.id == id).name;
  }

  SceneDraft draftForScene(String id, SceneDraftMode mode) {
    if (mode == SceneDraftMode.automation) {
      final savedConditions = _savedAutomationConditions[id];
      final savedTasks = _savedAutomationTasks[id];
      if (savedConditions != null && savedTasks != null) {
        return SceneDraft.initial(SceneDraftMode.automation).copyWith(
          conditions: savedConditions,
          tasks: savedTasks,
        );
      }
      return _builtInAutomationDraft(id);
    }

    final savedConditions = _savedTapToRunConditions[id];
    final savedTasks = _savedTapToRunTasks[id];
    final savedItem = _tapToRunItems.where((item) => item.id == id).firstOrNull;
    if (savedConditions != null && savedTasks != null && savedItem != null) {
      return SceneDraft.initial(SceneDraftMode.tapToRun).copyWith(
        conditions: savedConditions,
        tasks: savedTasks,
        styleColor: savedItem.color,
        styleIcon: savedItem.icon,
      );
    }
    return _builtInTapToRunDraft(id);
  }

  void loadSceneIntoDraft(String id, SceneDraftMode mode) {
    _draft = draftForScene(id, mode);
    notifyListeners();
  }

  String executeTapToRun(String id, HomeDevicesStore homeDevicesStore) {
    final item = _tapToRunItems.where((scene) => scene.id == id).firstOrNull;
    if (item == null) return 'Scene not found.';
    return _applyTapToRun(id, item.name, homeDevicesStore);
  }

  String runAutomationNow(String id, HomeDevicesStore homeDevicesStore) {
    return _applyAutomation(id, homeDevicesStore);
  }

  String _nextId(String prefix) {
    _idCounter += 1;
    return '$prefix-$_idCounter';
  }

  SceneDraft _builtInAutomationDraft(String id) {
    switch (id) {
      case 'turn-on-ac':
        return const SceneDraft(
          mode: SceneDraftMode.automation,
          matchMode: SceneConditionMatchMode.any,
          conditions: [
            SceneSummaryItem(
              id: 'temp',
              title: 'Temperature: > 20°C',
              subtitle: 'New York City',
              icon: Icons.thermostat_rounded,
              color: Color(0xFFFF5A4E),
            ),
            SceneSummaryItem(
              id: 'humidity',
              title: 'Humidity: Dry',
              subtitle: 'New York City',
              icon: Icons.water_drop_rounded,
              color: Color(0xFF2D93E6),
            ),
          ],
          tasks: [
            SceneSummaryItem(
              id: 'ac-on',
              title: 'Air Conditioner',
              subtitle: 'Living Room - Function: ON',
              icon: Icons.air_rounded,
              color: Color(0xFF11B5D9),
            ),
          ],
          styleColor: Color(0xFFFFA126),
          styleIcon: Icons.wb_sunny_rounded,
        );
      case 'welcome-home':
        return const SceneDraft(
          mode: SceneDraftMode.automation,
          matchMode: SceneConditionMatchMode.any,
          conditions: [
            SceneSummaryItem(
              id: 'arrive',
              title: 'Arrive at',
              subtitle: '701 7th Ave, New York, 10036, USA',
              icon: Icons.login_rounded,
              color: Color(0xFF57C76C),
            ),
          ],
          tasks: [
            SceneSummaryItem(
              id: 'all-lights',
              title: 'Turn ON All the Lights',
              subtitle: 'Automation: Enable',
              icon: Icons.wb_sunny_rounded,
              color: Color(0xFFFFA126),
            ),
          ],
          styleColor: Color(0xFFFFA126),
          styleIcon: Icons.wb_sunny_rounded,
        );
      case 'bedtime-bliss':
        return const SceneDraft(
          mode: SceneDraftMode.automation,
          matchMode: SceneConditionMatchMode.any,
          conditions: [
            SceneSummaryItem(
              id: 'schedule',
              title: 'Schedule Time: 21:45 PM',
              subtitle: 'Every Day',
              icon: Icons.access_time_filled_rounded,
              color: Color(0xFF4CAF50),
            ),
          ],
          tasks: [
            SceneSummaryItem(
              id: 'delay',
              title: 'Delay the Action',
              subtitle: '15 mins 30 secs',
              icon: Icons.access_time_filled_rounded,
              color: Color(0xFF607D8B),
            ),
            SceneSummaryItem(
              id: 'lights-off',
              title: 'Turn OFF All the Lights',
              subtitle: 'Automation: Enable',
              icon: Icons.wb_sunny_rounded,
              color: Color(0xFFFFA126),
            ),
          ],
          styleColor: Color(0xFFFFA126),
          styleIcon: Icons.wb_sunny_rounded,
        );
      default:
        return const SceneDraft(
          mode: SceneDraftMode.automation,
          matchMode: SceneConditionMatchMode.any,
          conditions: [
            SceneSummaryItem(
              id: 'schedule',
              title: 'Schedule Time: 21:00 PM',
              subtitle: 'Every Day',
              icon: Icons.access_time_filled_rounded,
              color: Color(0xFF4CAF50),
            ),
          ],
          tasks: [
            SceneSummaryItem(
              id: 'lamp-on',
              title: 'Smart Lamp',
              subtitle: 'Living Room - Function: ON',
              icon: Icons.wb_sunny_rounded,
              color: Color(0xFFFF9800),
            ),
          ],
          styleColor: Color(0xFFFFA126),
          styleIcon: Icons.wb_sunny_rounded,
        );
    }
  }

  SceneDraft _builtInTapToRunDraft(String id) {
    final item = _tapToRunItems.firstWhere((scene) => scene.id == id);
    final tasks = switch (id) {
      'bedtime-prep' => const [
          SceneSummaryItem(
            id: 'lights-off',
            title: 'Turn OFF All the Lights',
            subtitle: 'Automation: Enable',
            icon: Icons.wb_sunny_rounded,
            color: Color(0xFFFFA126),
          ),
          SceneSummaryItem(
            id: 'speaker-off',
            title: 'Stereo Speaker',
            subtitle: 'Living Room - Function: OFF',
            icon: Icons.speaker_rounded,
            color: Color(0xFF00BCD4),
          ),
        ],
      'home-office' => const [
          SceneSummaryItem(
            id: 'ac-on',
            title: 'Air Conditioner',
            subtitle: 'Living Room - Function: ON',
            icon: Icons.air_rounded,
            color: Color(0xFF11B5D9),
          ),
          SceneSummaryItem(
            id: 'router-on',
            title: 'Router',
            subtitle: 'Living Room - Function: ON',
            icon: Icons.router_rounded,
            color: Color(0xFF607D8B),
          ),
        ],
      _ => const [
          SceneSummaryItem(
            id: 'lights-on',
            title: 'Turn ON All the Lights',
            subtitle: 'Automation: Enable',
            icon: Icons.wb_sunny_rounded,
            color: Color(0xFFFFA126),
          ),
        ],
    };

    return SceneDraft.initial(SceneDraftMode.tapToRun).copyWith(
      tasks: tasks,
      styleColor: item.color,
      styleIcon: item.icon,
    );
  }

  String _applyAutomation(String id, HomeDevicesStore homeDevicesStore) {
    switch (id) {
      case 'turn-on-ac':
        homeDevicesStore.setDevicesWhere(
          (device) => device.id.startsWith('ac'),
          true,
        );
        return 'Air Conditioner turned ON.';
      case 'welcome-home':
        homeDevicesStore.setDevicesByRoom('Living Room', true);
        return 'Living room devices turned ON.';
      case 'bedtime-bliss':
        homeDevicesStore.setDevicesWhere(
          (device) => device.type == DeviceType.light || device.type == DeviceType.speaker,
          false,
        );
        return 'Bedtime devices turned OFF.';
      case 'all-lights':
        homeDevicesStore.setDevicesByType(DeviceType.light, true);
        return 'All lights turned ON.';
      default:
        final storedTasks = _savedAutomationTasks[id];
        if (storedTasks != null) {
          return _applyStoredTasks(
            storedTasks,
            homeDevicesStore,
            fallbackMessage: 'Automation applied.',
          );
        }
        return 'Automation enabled.';
    }
  }

  String _disableAutomation(String id, HomeDevicesStore homeDevicesStore) {
    switch (id) {
      case 'turn-on-ac':
        homeDevicesStore.setDevicesWhere(
          (device) => device.id.startsWith('ac'),
          false,
        );
        return 'Air Conditioner turned OFF.';
      case 'welcome-home':
        homeDevicesStore.setDevicesByRoom('Living Room', false);
        return 'Living room devices turned OFF.';
      case 'bedtime-bliss':
        homeDevicesStore.setDevicesWhere(
          (device) => device.type == DeviceType.light || device.type == DeviceType.speaker,
          true,
        );
        return 'Bedtime devices restored.';
      case 'all-lights':
        homeDevicesStore.setDevicesByType(DeviceType.light, false);
        return 'All lights turned OFF.';
      default:
        return 'Automation disabled.';
    }
  }

  String _applyTapToRun(
    String id,
    String name,
    HomeDevicesStore homeDevicesStore,
  ) {
    switch (id) {
      case 'bedtime-prep':
        homeDevicesStore.setDevicesByType(DeviceType.light, false);
        homeDevicesStore.setDevicesWhere(
          (device) => device.type == DeviceType.speaker || device.id.startsWith('ac'),
          false,
        );
        return 'Bedtime Prep ran: lights, AC and speaker turned OFF.';
      case 'evening-chill':
        homeDevicesStore.setDevicesWhere(
          (device) => device.name == 'Smart Lamp' || device.name == 'Stereo Speaker',
          true,
        );
        return 'Evening Chill ran in Living Room.';
      case 'boost-productivity':
        homeDevicesStore.setDevicesWhere(
          (device) => device.id.startsWith('ac'),
          true,
        );
        homeDevicesStore.setDevicesWhere(
          (device) => device.type == DeviceType.speaker,
          false,
        );
        return 'Boost Productivity ran.';
      case 'get-energized':
        homeDevicesStore.setDevicesByType(DeviceType.light, true);
        homeDevicesStore.setDevicesWhere(
          (device) => device.type == DeviceType.speaker,
          true,
        );
        return 'Get Energized turned lights and speaker ON.';
      case 'home-office':
        homeDevicesStore.setDevicesWhere(
          (device) =>
              device.id.startsWith('ac') ||
              device.id.startsWith('router'),
          true,
        );
        homeDevicesStore.setDevicesWhere(
          (device) => device.type == DeviceType.speaker,
          false,
        );
        return 'Home Office scene applied.';
      case 'reading-corner':
        homeDevicesStore.setDevicesWhere(
          (device) => device.name.contains('Lamp'),
          true,
        );
        homeDevicesStore.setDevicesWhere(
          (device) => device.type == DeviceType.speaker,
          false,
        );
        return 'Reading Corner scene applied.';
      case 'outdoor-party':
        homeDevicesStore.setDevicesByType(DeviceType.light, true);
        homeDevicesStore.setDevicesWhere(
          (device) => device.type == DeviceType.speaker,
          true,
        );
        return 'Outdoor Party scene applied.';
      default:
        final storedTasks = _savedTapToRunTasks[id];
        if (storedTasks != null) {
          return _applyStoredTasks(
            storedTasks,
            homeDevicesStore,
            fallbackMessage: 'Ran "$name".',
          );
        }
        return 'Ran "$name".';
    }
  }

  String _applyStoredTasks(
    List<SceneSummaryItem> tasks,
    HomeDevicesStore homeDevicesStore, {
    required String fallbackMessage,
    Set<String>? visitedSceneNames,
  }) {
    final visited = visitedSceneNames ?? <String>{};
    var changed = false;

    for (final task in tasks) {
      final subtitle = task.subtitle.toUpperCase();
      if (subtitle.contains('FUNCTION: ON') || subtitle.contains('FUNCTION: OFF')) {
        final turnOn = subtitle.contains('FUNCTION: ON');
        changed = _applyDeviceTaskByName(task.title, turnOn, homeDevicesStore) || changed;
        continue;
      }

      if (task.subtitle.startsWith('Automation:') || task.subtitle.startsWith('Tap-to-Run:')) {
        if (visited.contains(task.title)) continue;
        visited.add(task.title);
        final result = _runSceneByName(task.title, homeDevicesStore, visited);
        changed = result != null || changed;
      }
    }

    return changed ? 'Scene executed successfully.' : fallbackMessage;
  }

  bool _applyDeviceTaskByName(
    String deviceName,
    bool turnOn,
    HomeDevicesStore homeDevicesStore,
  ) {
    final before = homeDevicesStore.allDevices
        .where((device) => device.name == deviceName)
        .toList(growable: false);
    if (before.isEmpty) return false;
    homeDevicesStore.setDevicesWhere((device) => device.name == deviceName, turnOn);
    return true;
  }

  String? _runSceneByName(
    String sceneName,
    HomeDevicesStore homeDevicesStore,
    Set<String> visitedSceneNames,
  ) {
    for (final item in _tapToRunItems) {
      if (item.name == sceneName) {
        return _applyTapToRun(item.id, item.name, homeDevicesStore);
      }
    }
    for (final item in _automations) {
      if (item.name == sceneName) {
        final storedTasks = _savedAutomationTasks[item.id];
        if (storedTasks != null) {
          return _applyStoredTasks(
            storedTasks,
            homeDevicesStore,
            fallbackMessage: 'Automation applied.',
            visitedSceneNames: visitedSceneNames,
          );
        }
        return _applyAutomation(item.id, homeDevicesStore);
      }
    }
    return null;
  }

  static const List<String> roomFilters = [
    'All Rooms',
    'Living Room',
    'Bedroom',
    'Kitchen',
    'Office',
  ];

  static const List<SceneActionOption> addConditionOptions = [
    SceneActionOption(
      title: 'Tap-to-Run',
      icon: Icons.touch_app_rounded,
      color: Color(0xFF8AA1FF),
      trailingInfo: true,
    ),
    SceneActionOption(
      title: 'When Weather Changes',
      icon: Icons.wb_sunny_rounded,
      color: Color(0xFFFF9B23),
    ),
    SceneActionOption(
      title: 'When Location Changes',
      icon: Icons.location_on_rounded,
      color: Color(0xFFFF6433),
    ),
    SceneActionOption(
      title: 'Schedule Time',
      icon: Icons.access_time_filled_rounded,
      color: Color(0xFF4CAF50),
    ),
    SceneActionOption(
      title: 'When Device Status Changes',
      icon: Icons.business_center_rounded,
      color: Color(0xFF2196F3),
    ),
    SceneActionOption(
      title: 'Change Arm Mode',
      icon: Icons.shield_rounded,
      color: Color(0xFF9C27B0),
    ),
    SceneActionOption(
      title: 'When Alarm Triggered',
      icon: Icons.alarm_rounded,
      color: Color(0xFFFF5543),
    ),
  ];

  static const List<SceneActionOption> addTaskOptions = [
    SceneActionOption(
      title: 'Control Single Device',
      icon: Icons.business_center_rounded,
      color: Color(0xFF2196F3),
    ),
    SceneActionOption(
      title: 'Select Smart Scene',
      icon: Icons.task_alt_rounded,
      color: Color(0xFF4CAF50),
    ),
    SceneActionOption(
      title: 'Change Arm Mode',
      icon: Icons.shield_rounded,
      color: Color(0xFF9C27B0),
    ),
    SceneActionOption(
      title: 'Send Notification',
      icon: Icons.notifications_rounded,
      color: Color(0xFFFF5543),
    ),
    SceneActionOption(
      title: 'Delay the Action',
      icon: Icons.access_time_filled_rounded,
      color: Color(0xFF607D8B),
    ),
  ];

  static const List<SmartSceneDeviceCategory> deviceCategories = [
    SmartSceneDeviceCategory(
      id: 'lighting',
      title: 'Lightning',
      countLabel: '12 lights',
      icon: Icons.lightbulb_outline_rounded,
      iconColor: Color(0xFFFF9800),
      backgroundColor: Color(0xFFFFF8E8),
    ),
    SmartSceneDeviceCategory(
      id: 'cameras',
      title: 'Cameras',
      countLabel: '8 cameras',
      icon: Icons.videocam_outlined,
      iconColor: Color(0xFF9C27B0),
      backgroundColor: Color(0xFFF6F1FF),
    ),
    SmartSceneDeviceCategory(
      id: 'electrical',
      title: 'Electrical',
      countLabel: '6 devices',
      icon: Icons.power_outlined,
      iconColor: Color(0xFFFF6433),
      backgroundColor: Color(0xFFFFF1ED),
    ),
  ];

  static const List<SmartSceneDevice> devices = [
    SmartSceneDevice(id: 'lamp', name: 'Smart Lamp', room: 'Living Room', categoryId: 'lighting', assetPath: 'assets/bong_den.jpg', taskIcon: Icons.wb_sunny_rounded, taskColor: Color(0xFFFF9800)),
    SmartSceneDevice(id: 'cctv-1', name: 'Smart V1 CCTV', room: 'Living Room', categoryId: 'cameras', assetPath: 'assets/camera.jpg', taskIcon: Icons.videocam_outlined, taskColor: Color(0xFF9C27B0)),
    SmartSceneDevice(id: 'speaker', name: 'Stereo Speaker', room: 'Living Room', categoryId: 'electrical', assetPath: 'assets/stereo.jpg', taskIcon: Icons.speaker_rounded, taskColor: Color(0xFF00BCD4)),
    SmartSceneDevice(id: 'router', name: 'Router', room: 'Living Room', categoryId: 'electrical', assetPath: 'assets/png/device_ac.png', taskIcon: Icons.router_rounded, taskColor: Color(0xFF607D8B)),
    SmartSceneDevice(id: 'ac', name: 'Air Conditioner', room: 'Living Room', categoryId: 'electrical', assetPath: 'assets/png/device_ac.png', taskIcon: Icons.air_rounded, taskColor: Color(0xFF11B5D9)),
    SmartSceneDevice(id: 'webcam', name: 'Smart Webcam', room: 'Living Room', categoryId: 'cameras', assetPath: 'assets/camera.jpg', taskIcon: Icons.videocam_rounded, taskColor: Color(0xFF7E57C2)),
  ];

  static const List<SelectableSmartScene> automationSceneOptions = [
    SelectableSmartScene(id: 'auto-lights', name: 'Turn ON All the Lights', taskLabel: 'Start', icon: Icons.wb_sunny_rounded, color: Colors.white),
    SelectableSmartScene(id: 'office', name: 'Go to Office', taskLabel: 'Stop', icon: Icons.business_center_rounded, color: Colors.white),
    SelectableSmartScene(id: 'energy', name: 'Energy Saver Mode', taskLabel: 'Stop', icon: Icons.eco_rounded, color: Colors.white),
    SelectableSmartScene(id: 'work', name: 'Work Mode Activate', taskLabel: 'Stop', icon: Icons.laptop_mac_rounded, color: Colors.white),
    SelectableSmartScene(id: 'movie', name: 'Movie Night Magic', taskLabel: 'Stop', icon: Icons.movie_rounded, color: Colors.white),
    SelectableSmartScene(id: 'guests', name: 'Guests Arriving', taskLabel: 'Stop', icon: Icons.people_alt_rounded, color: Colors.white),
  ];

  static const List<SelectableSmartScene> tapToRunSceneOptions = [
    SelectableSmartScene(id: 'bedtime', name: 'Bedtime Prep', taskLabel: 'Stop', icon: Icons.dark_mode_rounded, color: Color(0xFF2D9BF0)),
    SelectableSmartScene(id: 'evening', name: 'Evening Chill', taskLabel: 'Stop', icon: Icons.bedtime_rounded, color: Color(0xFF95C851)),
    SelectableSmartScene(id: 'boost', name: 'Boost Productivity', taskLabel: 'Stop', icon: Icons.insights_rounded, color: Color(0xFFA12AB1)),
    SelectableSmartScene(id: 'energy', name: 'Get Energized', taskLabel: 'Stop', icon: Icons.local_fire_department_rounded, color: Color(0xFFFF4338)),
    SelectableSmartScene(id: 'office', name: 'Home Office', taskLabel: 'Stop', icon: Icons.home_rounded, color: Color(0xFF18B9CF)),
    SelectableSmartScene(id: 'reading', name: 'Reading Corner', taskLabel: 'Stop', icon: Icons.menu_book_rounded, color: Color(0xFF8C6657)),
  ];

  static const List<Color> styleColors = [
    Color(0xFF4A68F6),
    Color(0xFFFF4338),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF673AB7),
    Color(0xFF3F51B5),
    Color(0xFF2D93E6),
    Color(0xFF18A7E0),
    Color(0xFF1CB7CF),
    Color(0xFF0E9E9B),
    Color(0xFF4CAF50),
    Color(0xFF92C853),
    Color(0xFFCDDF3D),
    Color(0xFFFCE34C),
    Color(0xFFFDBD33),
    Color(0xFFFFA126),
    Color(0xFFFF5C2A),
    Color(0xFF8D6354),
    Color(0xFF718D9E),
  ];

  static const List<IconData> styleIcons = [
    Icons.touch_app_rounded,
    Icons.wb_sunny_rounded,
    Icons.nights_stay_rounded,
    Icons.access_time_filled_rounded,
    Icons.hourglass_bottom_rounded,
    Icons.water_drop_rounded,
    Icons.air_rounded,
    Icons.thermostat_rounded,
    Icons.sell_rounded,
    Icons.login_rounded,
    Icons.logout_rounded,
    Icons.dark_mode_rounded,
    Icons.local_fire_department_rounded,
    Icons.menu_book_rounded,
    Icons.celebration_rounded,
    Icons.location_on_rounded,
    Icons.schedule_rounded,
    Icons.business_center_rounded,
    Icons.verified_user_rounded,
    Icons.notifications_rounded,
    Icons.eco_rounded,
    Icons.attach_money_rounded,
    Icons.play_circle_fill_rounded,
    Icons.settings_rounded,
    Icons.shopping_cart_rounded,
    Icons.checkroom_rounded,
    Icons.sports_esports_rounded,
    Icons.videocam_rounded,
    Icons.email_rounded,
    Icons.favorite_rounded,
  ];
}

List<AutomationItem> _buildInitialAutomations() {
  return const [
    AutomationItem(id: 'turn-on-ac', name: 'Turn on the AC', taskCount: 1, triggerIcons: [SceneStepIcon(icon: Icons.thermostat_rounded, color: Color(0xFFFF5A4E)), SceneStepIcon(icon: Icons.water_drop_rounded, color: Color(0xFF2D93E6)), SceneStepIcon(icon: Icons.air_rounded, color: Color(0xFF11B5D9))]),
    AutomationItem(id: 'welcome-home', name: 'Welcome Home Automation', taskCount: 1, triggerIcons: [SceneStepIcon(icon: Icons.login_rounded, color: Color(0xFF57C76C)), SceneStepIcon(icon: Icons.wb_sunny_rounded, color: Color(0xFFFFA126))]),
    AutomationItem(id: 'bedtime-bliss', name: 'Bedtime Bliss Automation', taskCount: 2, triggerIcons: [SceneStepIcon(icon: Icons.access_time_filled_rounded, color: Color(0xFF4CAF50)), SceneStepIcon(icon: Icons.schedule_rounded, color: Color(0xFF607D8B)), SceneStepIcon(icon: Icons.wb_sunny_rounded, color: Color(0xFFFFA126))]),
    AutomationItem(id: 'all-lights', name: 'Turn ON All the Lights', taskCount: 1, triggerIcons: [SceneStepIcon(icon: Icons.access_time_filled_rounded, color: Color(0xFF4CAF50)), SceneStepIcon(icon: Icons.wb_sunny_rounded, color: Color(0xFFFFA126))]),
  ];
}

List<TapToRunItem> _buildInitialTapToRuns() {
  return const [
    TapToRunItem(id: 'bedtime-prep', name: 'Bedtime Prep', taskCount: 2, icon: Icons.dark_mode_rounded, color: Color(0xFF2D9BF0)),
    TapToRunItem(id: 'evening-chill', name: 'Evening Chill', taskCount: 4, icon: Icons.bedtime_rounded, color: Color(0xFF95C851)),
    TapToRunItem(id: 'boost-productivity', name: 'Boost Productivity', taskCount: 1, icon: Icons.insights_rounded, color: Color(0xFFA12AB1)),
    TapToRunItem(id: 'get-energized', name: 'Get Energized', taskCount: 3, icon: Icons.local_fire_department_rounded, color: Color(0xFFFF4338)),
    TapToRunItem(id: 'home-office', name: 'Home Office', taskCount: 2, icon: Icons.home_rounded, color: Color(0xFF18B9CF)),
    TapToRunItem(id: 'reading-corner', name: 'Reading Corner', taskCount: 4, icon: Icons.menu_book_rounded, color: Color(0xFF8C6657)),
    TapToRunItem(id: 'outdoor-party', name: 'Outdoor Party', taskCount: 3, icon: Icons.celebration_rounded, color: Color(0xFF718D9E)),
  ];
}
