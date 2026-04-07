import 'package:flutter/material.dart';

/// Represents a single smart device in the home.
class SmartDevice {
  const SmartDevice({
    required this.id,
    required this.name,
    required this.room,
    required this.type,
    required this.connectivity,
    required this.icon,
    this.imagePath,
    this.isOn = false,
    this.isOnline = false,
    this.lastSeenAt,
    this.telemetry,
  });

  final String id;
  final String name;
  final String room;
  final DeviceType type;
  final String connectivity;
  final IconData icon;
  final String? imagePath;
  final bool isOn;
  final bool isOnline;
  final DateTime? lastSeenAt;
  final PowerTelemetry? telemetry;

  SmartDevice copyWith({
    bool? isOn,
    bool? isOnline,
    String? imagePath,
    DateTime? lastSeenAt,
    PowerTelemetry? telemetry,
  }) {
    return SmartDevice(
      id: id,
      name: name,
      room: room,
      type: type,
      connectivity: connectivity,
      icon: icon,
      imagePath: imagePath ?? this.imagePath,
      isOn: isOn ?? this.isOn,
      isOnline: isOnline ?? this.isOnline,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      telemetry: telemetry ?? this.telemetry,
    );
  }
}

enum DeviceType { light, camera, electrical, speaker }

class PowerTelemetry {
  const PowerTelemetry({
    required this.relayOn,
    required this.recordedAt,
  });

  final bool relayOn;
  final DateTime recordedAt;
}

/// Represents a device category summary card.
class DeviceCategory {
  const DeviceCategory({
    required this.type,
    required this.label,
    required this.count,
    required this.unit,
    required this.icon,
    required this.color,
  });

  final DeviceType type;
  final String label;
  final int count;
  final String unit;
  final IconData icon;
  final Color color;
}

/// Represents a notification entry.
class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    this.isUnread = false,
    this.badge,
  });

  final String id;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final bool isUnread;
  final String? badge;
}

/// Static mock weather data matching Figma.
class WeatherData {
  const WeatherData({
    required this.temperature,
    required this.location,
    required this.condition,
    required this.aqi,
    required this.humidity,
    required this.windSpeed,
  });

  final int temperature;
  final String location;
  final String condition;
  final int aqi;
  final double humidity;
  final double windSpeed;
}
