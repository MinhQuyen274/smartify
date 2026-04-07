import 'package:flutter/material.dart';

/// Energy summary for current or previous month.
class EnergySummary {
  const EnergySummary({
    required this.label,
    required this.onHours,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final double onHours;
  final IconData icon;
  final Color iconColor;
}

/// A single month's energy consumption for the bar chart.
class MonthlyUsage {
  const MonthlyUsage({
    required this.label,
    required this.onHours,
  });

  final String label;
  final double onHours;
}

/// Aggregated usage for a device type (e.g., all Smart Lamps).
class DeviceUsageItem {
  const DeviceUsageItem({
    required this.id,
    required this.name,
    required this.onHours,
    required this.deviceCount,
    required this.icon,
    this.imagePath,
  });

  final String id;
  final String name;
  final double onHours;
  final int deviceCount;
  final IconData icon;
  final String? imagePath;
}

/// Individual device bill entry (one lamp, one CCTV, etc.).
class DeviceBillItem {
  const DeviceBillItem({
    required this.id,
    required this.name,
    required this.room,
    required this.onHours,
    required this.icon,
    this.imagePath,
  });

  final String id;
  final String name;
  final String room;
  final double onHours;
  final IconData icon;
  final String? imagePath;
}

/// Date range option for the statistics dropdown.
class DateRangeOption {
  const DateRangeOption({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}
