import 'package:flutter/material.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/features/account-settings/models/account_settings_models.dart';
import 'package:smartify_flutter/features/account-settings/models/home_management_models.dart';

class AccountSettingsStore extends ChangeNotifier {
  // ── Profile ──
  String get userName => 'Andrew Ainsley';
  String get userEmail => 'andrew.ainsley@yourdomain.com';

  // ── General settings menu ──
  List<SettingsMenuItem> get generalMenuItems => [
    SettingsMenuItem(
      title: 'Home Management',
      icon: Icons.home_outlined,
      route: AppRoutes.accountHomeManagement,
    ),
    SettingsMenuItem(
      title: 'Voice Assistants',
      icon: Icons.mic_outlined,
      route: AppRoutes.accountVoiceAssistants,
    ),
    SettingsMenuItem(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      route: AppRoutes.homeDevicesNotifications,
    ),
    SettingsMenuItem(
      title: 'Account & Security',
      icon: Icons.shield_outlined,
      route: AppRoutes.accountSecurity,
    ),
    SettingsMenuItem(
      title: 'Linked Accounts',
      icon: Icons.swap_vert_rounded,
      route: AppRoutes.accountLinkedAccounts,
    ),
    SettingsMenuItem(
      title: 'App Appearance',
      icon: Icons.visibility_outlined,
      route: AppRoutes.accountAppAppearance,
    ),
    SettingsMenuItem(
      title: 'Additional Settings',
      icon: Icons.settings_outlined,
      route: AppRoutes.accountAdditionalSettings,
    ),
  ];

  // ── Support settings menu ──
  static const List<SettingsMenuItem> supportMenuItems = [
    SettingsMenuItem(
      title: 'Data & Analytics',
      icon: Icons.insert_chart_outlined_rounded,
      route: AppRoutes.accountDataAnalytics,
    ),
    SettingsMenuItem(
      title: 'Help & Support',
      icon: Icons.description_outlined,
      route: AppRoutes.accountHelpSupport,
    ),
  ];

  // ── Logout ──
  static const SettingsMenuItem logoutItem = SettingsMenuItem(
    title: 'Logout',
    icon: Icons.logout_rounded,
    isDestructive: true,
  );

  // ── Security toggles ──
  List<SecurityToggle> _securityToggles = const [
    SecurityToggle(title: 'Biometric ID'),
    SecurityToggle(title: 'Face ID'),
    SecurityToggle(title: 'SMS Authenticator'),
    SecurityToggle(title: 'Google Authenticator'),
  ];

  List<SecurityToggle> get securityToggles =>
      List.unmodifiable(_securityToggles);

  void toggleSecurity(int index) {
    if (index < 0 || index >= _securityToggles.length) return;
    _securityToggles = List.of(_securityToggles);
    _securityToggles[index] = _securityToggles[index].copyWith(
      isEnabled: !_securityToggles[index].isEnabled,
    );
    notifyListeners();
  }

  // ── Security nav items ──
  static const List<SettingsMenuItem> securityNavItems = [
    SettingsMenuItem(
      title: 'Change Password',
      icon: Icons.lock_outline_rounded,
    ),
    SettingsMenuItem(
      title: 'Device Management',
      icon: Icons.devices_outlined,
      description: 'Manage your account on the various devices you own.',
    ),
    SettingsMenuItem(
      title: 'Deactivate Account',
      icon: Icons.pause_circle_outline_rounded,
      description:
          'Temporarily deactivate your account. Easily reactivate when you\'re ready.',
    ),
    SettingsMenuItem(
      title: 'Delete Account',
      icon: Icons.delete_outline_rounded,
      description:
          'Permanently remove your account and data. Proceed with caution.',
      isDestructive: true,
    ),
  ];

  // ── Linked accounts ──
  List<LinkedAccount> _linkedAccounts = const [
    LinkedAccount(
      name: 'Google',
      icon: Icons.g_mobiledata_rounded,
      color: Color(0xFFDB4437),
      isConnected: true,
    ),
    LinkedAccount(
      name: 'Apple',
      icon: Icons.apple_rounded,
      color: Color(0xFF000000),
      isConnected: true,
    ),
    LinkedAccount(
      name: 'Facebook',
      icon: Icons.facebook_rounded,
      color: Color(0xFF1877F2),
    ),
    LinkedAccount(
      name: 'Twitter',
      icon: Icons.flutter_dash_rounded,
      color: Color(0xFF1DA1F2),
    ),
  ];

  List<LinkedAccount> get linkedAccounts => List.unmodifiable(_linkedAccounts);

  void toggleLinkedAccount(int index) {
    if (index < 0 || index >= _linkedAccounts.length) return;
    _linkedAccounts = List.of(_linkedAccounts);
    _linkedAccounts[index] = _linkedAccounts[index].copyWith(
      isConnected: !_linkedAccounts[index].isConnected,
    );
    notifyListeners();
  }

  // Notifications
  bool _generalNotificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrateEnabled = false;
  bool _appUpdatesEnabled = true;
  bool _newServiceAvailableEnabled = false;
  bool _newTipsAvailableEnabled = false;

  bool get generalNotificationsEnabled => _generalNotificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get vibrateEnabled => _vibrateEnabled;
  bool get appUpdatesEnabled => _appUpdatesEnabled;
  bool get newServiceAvailableEnabled => _newServiceAvailableEnabled;
  bool get newTipsAvailableEnabled => _newTipsAvailableEnabled;

  void toggleGeneralNotifications(bool value) {
    _generalNotificationsEnabled = value;
    notifyListeners();
  }

  void toggleSound(bool value) {
    _soundEnabled = value;
    notifyListeners();
  }

  void toggleVibrate(bool value) {
    _vibrateEnabled = value;
    notifyListeners();
  }

  void toggleAppUpdates(bool value) {
    _appUpdatesEnabled = value;
    notifyListeners();
  }

  void toggleNewServiceAvailable(bool value) {
    _newServiceAvailableEnabled = value;
    notifyListeners();
  }

  void toggleNewTipsAvailable(bool value) {
    _newTipsAvailableEnabled = value;
    notifyListeners();
  }

  static const List<AppLanguageOption> appLanguages = [
    AppLanguageOption(code: 'en-us', label: 'English (US)', flagCode: 'us'),
    AppLanguageOption(code: 'en-uk', label: 'English (UK)', flagCode: 'uk'),
    AppLanguageOption(code: 'zh-cn', label: 'Mandarin', flagCode: 'cn'),
    AppLanguageOption(code: 'es-es', label: 'Spanish', flagCode: 'es'),
    AppLanguageOption(code: 'hi-in', label: 'Hindi', flagCode: 'in'),
    AppLanguageOption(code: 'fr-fr', label: 'French', flagCode: 'fr'),
    AppLanguageOption(code: 'ar-ae', label: 'Arabic', flagCode: 'ae'),
    AppLanguageOption(code: 'ru-ru', label: 'Russian', flagCode: 'ru'),
    AppLanguageOption(code: 'ja-jp', label: 'Japanese', flagCode: 'jp'),
  ];

  AppThemeOption _appTheme = AppThemeOption.light;
  AppLanguageOption _appLanguage = appLanguages.first;
  TemperatureUnit _temperatureUnit = TemperatureUnit.celsius;
  double _cacheSizeInMb = 15.6;

  List<SettingsToggleItem> _dataUsagePreferences = const [
    SettingsToggleItem(
      id: 'product-analytics',
      title: 'Product Analytics',
      description: 'Share anonymous usage patterns to improve Smartify.',
      isEnabled: true,
    ),
    SettingsToggleItem(
      id: 'crash-reports',
      title: 'Crash Reports',
      description: 'Automatically send diagnostics when something goes wrong.',
      isEnabled: true,
    ),
    SettingsToggleItem(
      id: 'feature-insights',
      title: 'Feature Insights',
      description: 'Help us understand which automations you use most.',
      isEnabled: false,
    ),
  ];

  List<SettingsToggleItem> _adPreferences = const [
    SettingsToggleItem(
      id: 'personalized-ads',
      title: 'Personalized Ads',
      description: 'Tailor ads based on your preferences and behavior.',
      isEnabled: true,
    ),
    SettingsToggleItem(
      id: 'partner-measurement',
      title: 'Partner Measurement',
      description: 'Allow partners to measure campaign performance.',
      isEnabled: false,
    ),
  ];

  List<SettingsToggleItem> _experimentalFeatures = const [
    SettingsToggleItem(
      id: 'labs-dashboard',
      title: 'Labs Dashboard',
      description: 'Preview unfinished home dashboards and widgets.',
      isEnabled: false,
    ),
    SettingsToggleItem(
      id: 'voice-shortcuts',
      title: 'Voice Shortcuts',
      description: 'Try early voice routines before public release.',
      isEnabled: true,
    ),
    SettingsToggleItem(
      id: 'device-insights',
      title: 'Device Insights',
      description: 'Enable richer diagnostics for supported devices.',
      isEnabled: false,
    ),
  ];

  List<SettingsToggleItem> _systemPermissions = const [
    SettingsToggleItem(
      id: 'location',
      title: 'Location Access',
      description: 'Needed for home presence and nearby device setup.',
      isEnabled: true,
    ),
    SettingsToggleItem(
      id: 'microphone',
      title: 'Microphone',
      description: 'Required for voice assistants and intercom features.',
      isEnabled: true,
    ),
    SettingsToggleItem(
      id: 'bluetooth',
      title: 'Bluetooth',
      description: 'Used during device discovery and onboarding.',
      isEnabled: true,
    ),
    SettingsToggleItem(
      id: 'notifications',
      title: 'Notifications',
      description: 'Allow activity alerts and critical home warnings.',
      isEnabled: true,
    ),
  ];

  AppThemeOption get appTheme => _appTheme;
  AppLanguageOption get appLanguage => _appLanguage;
  TemperatureUnit get temperatureUnit => _temperatureUnit;
  String get cacheSizeLabel => '${_cacheSizeInMb.toStringAsFixed(1)} MB';
  List<SettingsToggleItem> get dataUsagePreferences =>
      List.unmodifiable(_dataUsagePreferences);
  List<SettingsToggleItem> get adPreferences =>
      List.unmodifiable(_adPreferences);
  List<SettingsToggleItem> get experimentalFeatures =>
      List.unmodifiable(_experimentalFeatures);
  List<SettingsToggleItem> get systemPermissions =>
      List.unmodifiable(_systemPermissions);

  void setAppTheme(AppThemeOption theme) {
    if (_appTheme == theme) {
      return;
    }
    _appTheme = theme;
    notifyListeners();
  }

  void setAppLanguage(AppLanguageOption language) {
    if (_appLanguage.code == language.code) {
      return;
    }
    _appLanguage = language;
    notifyListeners();
  }

  void setTemperatureUnit(TemperatureUnit unit) {
    if (_temperatureUnit == unit) {
      return;
    }
    _temperatureUnit = unit;
    notifyListeners();
  }

  void clearCache() {
    if (_cacheSizeInMb == 0) {
      return;
    }
    _cacheSizeInMb = 0;
    notifyListeners();
  }

  void toggleDataUsagePreference(String id) {
    _dataUsagePreferences = _togglePreference(_dataUsagePreferences, id);
  }

  void toggleAdPreference(String id) {
    _adPreferences = _togglePreference(_adPreferences, id);
  }

  void toggleExperimentalFeature(String id) {
    _experimentalFeatures = _togglePreference(_experimentalFeatures, id);
  }

  void toggleSystemPermission(String id) {
    _systemPermissions = _togglePreference(_systemPermissions, id);
  }

  List<SettingsToggleItem> _togglePreference(
    List<SettingsToggleItem> items,
    String id,
  ) {
    final index = items.indexWhere((item) => item.id == id);
    if (index == -1) {
      return items;
    }

    final updatedItems = List<SettingsToggleItem>.of(items);
    final current = updatedItems[index];
    updatedItems[index] = current.copyWith(isEnabled: !current.isEnabled);
    notifyListeners();
    return updatedItems;
  }

  // Home Management
  final List<Home> _homes = _buildInitialHomes();
  int _selectedHomeIndex = 0;

  static List<Home> _buildInitialHomes() {
    return [
      Home(
        id: '1',
        name: 'My Home',
        location: '123 Main St, New York, NY 10001',
        rooms: [
          Room(id: '1', name: 'Living Room', devices: 5),
          Room(id: '2', name: 'Bedroom', devices: 3),
          Room(id: '3', name: 'Kitchen', devices: 4),
        ],
        members: [],
      ),
      Home(
        id: '2',
        name: 'Office',
        location: '456 Business Ave, New York, NY 10002',
        rooms: [Room(id: '4', name: 'Meeting Room', devices: 6)],
        members: [],
      ),
    ];
  }

  List<Home> get homes => List.unmodifiable(_homes);
  Home get selectedHome {
    if (_homes.isEmpty) {
      return _createEmptyHome();
    }

    final safeIndex = _selectedHomeIndex.clamp(0, _homes.length - 1);
    return _homes[safeIndex];
  }

  int get selectedHomeIndex => _selectedHomeIndex;

  void setSelectedHomeIndex(int index) {
    if (index >= 0 && index < _homes.length) {
      _selectedHomeIndex = index;
      notifyListeners();
    }
  }

  Home? findHomeById(String? homeId) {
    if (homeId == null || homeId.isEmpty) {
      return null;
    }

    for (final home in _homes) {
      if (home.id == homeId) {
        return home;
      }
    }
    return null;
  }

  void selectHomeById(String? homeId) {
    if (homeId == null || homeId.isEmpty) {
      return;
    }

    final index = _homes.indexWhere((home) => home.id == homeId);
    if (index == -1 || index == _selectedHomeIndex) {
      return;
    }

    _selectedHomeIndex = index;
    notifyListeners();
  }

  Home _createEmptyHome() {
    return Home(id: "", name: "No Home", location: "", rooms: [], members: []);
  }

  void addRoom(Room room) {
    final home = selectedHome;
    final updatedHome = home.copyWith(rooms: [...home.rooms, room]);
    _homes[_selectedHomeIndex] = updatedHome;
    notifyListeners();
  }

  void removeRoom(String roomId) {
    final home = selectedHome;
    final updatedHome = home.copyWith(
      rooms: home.rooms.where((r) => r.id != roomId).toList(),
    );
    _homes[_selectedHomeIndex] = updatedHome;
    notifyListeners();
  }

  void addHomeMember(HomeMember member) {
    final home = selectedHome;
    final updatedHome = home.copyWith(members: [...home.members, member]);
    _homes[_selectedHomeIndex] = updatedHome;
    notifyListeners();
  }

  void removeHomeMember(String memberId) {
    final home = selectedHome;
    final updatedHome = home.copyWith(
      members: home.members.where((m) => m.id != memberId).toList(),
    );
    _homes[_selectedHomeIndex] = updatedHome;
    notifyListeners();
  }
}
