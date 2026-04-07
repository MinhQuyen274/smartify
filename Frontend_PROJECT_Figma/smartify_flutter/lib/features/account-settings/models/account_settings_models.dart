import 'package:flutter/material.dart';

/// A single row in the Account settings list.
class SettingsMenuItem {
  const SettingsMenuItem({
    required this.title,
    required this.icon,
    this.route,
    this.description,
    this.isDestructive = false,
  });

  final String title;
  final IconData icon;
  final String? route;
  final String? description;
  final bool isDestructive;
}

/// A linked social/auth provider.
class LinkedAccount {
  const LinkedAccount({
    required this.name,
    required this.icon,
    required this.color,
    this.isConnected = false,
  });

  final String name;
  final IconData icon;
  final Color color;
  final bool isConnected;

  LinkedAccount copyWith({bool? isConnected}) {
    return LinkedAccount(
      name: name,
      icon: icon,
      color: color,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

/// A toggleable security setting.
class SecurityToggle {
  const SecurityToggle({
    required this.title,
    this.isEnabled = false,
  });

  final String title;
  final bool isEnabled;

  SecurityToggle copyWith({bool? isEnabled}) {
    return SecurityToggle(
      title: title,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

enum AppThemeOption { systemDefault, light, dark }

extension AppThemeOptionX on AppThemeOption {
  String get label {
    switch (this) {
      case AppThemeOption.systemDefault:
        return 'System Default';
      case AppThemeOption.light:
        return 'Light';
      case AppThemeOption.dark:
        return 'Dark';
    }
  }
}

enum TemperatureUnit { celsius, fahrenheit }

extension TemperatureUnitX on TemperatureUnit {
  String get label {
    switch (this) {
      case TemperatureUnit.celsius:
        return 'Celsius';
      case TemperatureUnit.fahrenheit:
        return 'Fahrenheit';
    }
  }
}

class AppLanguageOption {
  const AppLanguageOption({
    required this.code,
    required this.label,
    required this.flagCode,
  });

  final String code;
  final String label;
  final String flagCode;
}

class SettingsToggleItem {
  const SettingsToggleItem({
    required this.id,
    required this.title,
    this.description,
    this.isEnabled = false,
  });

  final String id;
  final String title;
  final String? description;
  final bool isEnabled;

  SettingsToggleItem copyWith({bool? isEnabled}) {
    return SettingsToggleItem(
      id: id,
      title: title,
      description: description,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
