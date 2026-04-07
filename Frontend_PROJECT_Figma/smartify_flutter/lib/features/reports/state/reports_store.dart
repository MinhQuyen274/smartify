import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/network/smartify_api_client.dart';
import 'package:smartify_flutter/core/network/smartify_socket_service.dart';
import 'package:smartify_flutter/core/state/auth_session_store.dart';
import 'package:smartify_flutter/features/reports/models/reports_models.dart';

class ReportsStore extends ChangeNotifier {
  static const List<DateRangeOption> dateRangeOptions = [
    DateRangeOption(label: 'Today', value: 'today'),
    DateRangeOption(label: 'This Week', value: 'this_week'),
    DateRangeOption(label: 'Last month', value: 'last_month'),
    DateRangeOption(label: 'Last 3 months', value: 'last_3_months'),
    DateRangeOption(label: 'Last 6 months', value: 'last_6_months'),
    DateRangeOption(label: 'This year', value: 'this_year'),
    DateRangeOption(label: 'Last year', value: 'last_year'),
    DateRangeOption(label: 'All time', value: 'all_time'),
    DateRangeOption(label: 'Custom range..', value: 'custom'),
  ];

  SmartifyApiClient? _apiClient;
  AuthSessionStore? _authSessionStore;
  StreamSubscription<Map<String, dynamic>>? _socketSubscription;

  String _selectedRange = 'last_6_months';
  int _selectedBarIndex = 0;
  DateTime _customDate = DateTime(2024, 12, 1);
  bool _loading = false;
  String? _errorMessage;
  List<EnergySummary> _summaries = const [];
  List<MonthlyUsage> _monthlyUsage = const [];
  List<DeviceUsageItem> _deviceUsageItems = const [];
  final Map<String, List<DeviceBillItem>> _deviceBills = <String, List<DeviceBillItem>>{};

  String get selectedRange => _selectedRange;
  int get selectedBarIndex => _selectedBarIndex;
  DateTime get customDate => _customDate;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  List<EnergySummary> get summaries => _summaries;
  List<MonthlyUsage> get monthlyUsage => _monthlyUsage;
  List<DeviceUsageItem> get deviceUsageItems => _deviceUsageItems;

  ReportsStore bindDependencies(
    AuthSessionStore authSessionStore,
    SmartifyApiClient apiClient,
    SmartifySocketService socketService,
  ) {
    final previousToken = _authSessionStore?.session?.accessToken;
    final nextToken = authSessionStore.session?.accessToken;
    _authSessionStore = authSessionStore;
    _apiClient = apiClient;

    if (previousToken != nextToken) {
      _socketSubscription?.cancel();
      if (nextToken != null) {
        _socketSubscription = socketService.events.listen((_) => refresh());
        refresh();
      } else {
        _summaries = const [];
        _monthlyUsage = const [];
        _deviceUsageItems = const [];
        _deviceBills.clear();
        notifyListeners();
      }
    } else if (nextToken != null && _deviceUsageItems.isEmpty && !_loading) {
      refresh();
    }

    return this;
  }

  String get selectedRangeLabel {
    for (final option in dateRangeOptions) {
      if (option.value == _selectedRange) return option.label;
    }
    return 'Last 6 months';
  }

  void setDateRange(String value) {
    if (_selectedRange == value) return;
    _selectedRange = value;
    refresh();
  }

  void selectBar(int index) {
    if (_selectedBarIndex == index) return;
    _selectedBarIndex = index;
    notifyListeners();
  }

  void setCustomDate(DateTime date) {
    _customDate = date;
    notifyListeners();
  }

  Future<void> refresh() async {
    final token = _authSessionStore?.session?.accessToken;
    if (token == null || _apiClient == null) return;
    _loading = true;
    notifyListeners();
    try {
      final devices = await _apiClient!.getDevices(token);
      final summary = await _apiClient!.getReportSummary(token);
      _deviceUsageItems = _buildDeviceUsage(summary);
      _summaries = _buildSummaries(summary);
      _deviceBills
        ..clear()
        ..addAll(await _buildDeviceBills(token, devices));
      _monthlyUsage = await _buildMonthlyUsage(token, devices);
      _selectedBarIndex = _monthlyUsage.isEmpty ? 0 : _monthlyUsage.length - 1;
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  List<DeviceBillItem> billsForDevice(String deviceId) {
    return _deviceBills[deviceId] ?? const [];
  }

  DeviceUsageItem? deviceUsageById(String id) {
    for (final item in _deviceUsageItems) {
      if (item.id == id) return item;
    }
    return null;
  }

  List<EnergySummary> _buildSummaries(Map<String, dynamic> summary) {
    final totalOnHours = (summary['totalOnHours'] as num?)?.toDouble() ?? 0;
    return [
      EnergySummary(
        label: 'Total Active',
        onHours: totalOnHours,
        icon: Icons.timer_rounded,
        iconColor: const Color(0xFFF5A524),
      ),
      EnergySummary(
        label: 'Devices',
        onHours: (summary['deviceCount'] as num?)?.toDouble() ?? 0,
        icon: Icons.power_rounded,
        iconColor: const Color(0xFF4A7DFF),
      ),
    ];
  }

  List<DeviceUsageItem> _buildDeviceUsage(Map<String, dynamic> summary) {
    final devices = List<Map<String, dynamic>>.from(summary['devices'] as List? ?? const []);
    return devices
        .map(
          (device) => DeviceUsageItem(
            id: device['deviceId'] as String,
            name: device['name'] as String? ?? 'Smart Power Node',
            onHours: (device['onHours'] as num?)?.toDouble() ?? 0,
            deviceCount: 1,
            icon: Icons.power_outlined,
            imagePath: 'assets/bong_den.jpg',
          ),
        )
        .toList();
  }

  Future<Map<String, List<DeviceBillItem>>> _buildDeviceBills(
    String token,
    List<Map<String, dynamic>> devices,
  ) async {
    final result = <String, List<DeviceBillItem>>{};
    for (final device in devices) {
      // Simplified: Just use the total onHours for now as the 'bill'
      final summary = await _apiClient!.getReportSummary(token);
      final deviceData = (summary['devices'] as List).firstWhere((d) => d['deviceId'] == device['deviceId'], orElse: () => null);
      final onHours = (deviceData?['onHours'] as num?)?.toDouble() ?? 0;
      
      result[device['deviceId'] as String] = [
        DeviceBillItem(
          id: device['deviceId'] as String,
          name: device['name'] as String? ?? 'Smart Power Node',
          room: 'Living Room',
          onHours: onHours,
          icon: Icons.power_rounded,
          imagePath: 'assets/bong_den.jpg',
        ),
      ];
    }
    return result;
  }

  Future<List<MonthlyUsage>> _buildMonthlyUsage(
    String token,
    List<Map<String, dynamic>> devices,
  ) async {
    // For now, return an empty list or dummy data as calculating daily breakdown 
    // for ON-time is a complex SQL operation.
    return const [];
  }
}
