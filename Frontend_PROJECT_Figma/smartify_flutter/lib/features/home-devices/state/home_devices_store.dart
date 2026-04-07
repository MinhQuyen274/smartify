import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/network/smartify_api_client.dart';
import 'package:smartify_flutter/core/network/smartify_socket_service.dart';
import 'package:smartify_flutter/core/state/auth_session_store.dart';
import 'package:smartify_flutter/features/home-devices/models/home_devices_models.dart';

class HomeDevicesStore extends ChangeNotifier {
  static const String allRoomsLabel = 'All Rooms';
  static const String unassignedRoomLabel = 'Unassigned';

  final WeatherData weather = const WeatherData(
    temperature: 20,
    location: 'Smartify Demo Network',
    condition: 'Device Online',
    aqi: 92,
    humidity: 78.2,
    windSpeed: 2.0,
  );

  SmartifyApiClient? _apiClient;
  SmartifySocketService? _socketService;
  AuthSessionStore? _authSessionStore;
  StreamSubscription<Map<String, dynamic>>? _socketSubscription;

  String _selectedRoom = allRoomsLabel;
  List<SmartDevice> _devices = [];
  bool _loading = false;
  String? _errorMessage;

  double _lampBrightness = 0.85;
  double _lampColorTemp = 0.3;
  double _lampSaturation = 0.64;
  int _lampModeIndex = 0;
  int _acTemperature = 20;
  int _acModeIndex = 0;
  double _speakerVolume = 0.65;
  double _speakerPlaybackPosition = 0.72;
  bool _speakerIsPlaying = true;
  int _addDeviceTab = 0;
  bool _isScanning = false;
  bool _isConnecting = false;
  bool _isConnected = false;
  String? _connectedDeviceName;
  String? _lastClaimedDeviceId;
  String? _manualSetupCode;
  SmartDevice? _pendingDevice;
  int _notifTab = 0;

  String get selectedRoom => _selectedRoom;
  List<SmartDevice> get allDevices => List.unmodifiable(_devices);
  int get totalDeviceCount => _devices.length;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  double get lampBrightness => _lampBrightness;
  double get lampColorTemp => _lampColorTemp;
  double get lampSaturation => _lampSaturation;
  int get lampModeIndex => _lampModeIndex;
  int get acTemperature => _acTemperature;
  int get acModeIndex => _acModeIndex;
  double get speakerVolume => _speakerVolume;
  double get speakerPlaybackPosition => _speakerPlaybackPosition;
  bool get speakerIsPlaying => _speakerIsPlaying;
  int get addDeviceTab => _addDeviceTab;
  bool get isScanning => _isScanning;
  bool get isConnecting => _isConnecting;
  bool get isConnected => _isConnected;
  String? get connectedDeviceName => _connectedDeviceName;
  String? get lastClaimedDeviceId => _lastClaimedDeviceId;
  String? get manualSetupCode => _manualSetupCode;
  SmartDevice? get pendingDevice => _pendingDevice;
  int get notifTab => _notifTab;

  List<String> get availableRooms {
    final rooms =
        _devices
            .map((device) => device.room.trim())
            .where((room) => room.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return [allRoomsLabel, ...rooms];
  }

  List<DeviceCategory> get categories => [
    DeviceCategory(
      type: DeviceType.light,
      label: 'Lighting',
      count: _countByType(DeviceType.light),
      unit: 'lights',
      icon: Icons.lightbulb_outline_rounded,
      color: const Color(0xFFF5A524),
    ),
    DeviceCategory(
      type: DeviceType.camera,
      label: 'Cameras',
      count: _countByType(DeviceType.camera),
      unit: 'cameras',
      icon: Icons.videocam_outlined,
      color: const Color(0xFF9B59B6),
    ),
    DeviceCategory(
      type: DeviceType.electrical,
      label: 'Electrical',
      count: _countByType(DeviceType.electrical),
      unit: 'devices',
      icon: Icons.power_outlined,
      color: const Color(0xFFEA5455),
    ),
  ];

  List<SmartDevice> get filteredDevices {
    if (_selectedRoom == allRoomsLabel) return allDevices;
    return _devices.where((device) => device.room == _selectedRoom).toList();
  }

  HomeDevicesStore bindDependencies(
    AuthSessionStore authSessionStore,
    SmartifyApiClient apiClient,
    SmartifySocketService socketService,
  ) {
    final previousToken = _authSessionStore?.session?.accessToken;
    final nextToken = authSessionStore.session?.accessToken;

    _authSessionStore = authSessionStore;
    _apiClient = apiClient;
    _socketService = socketService;

    if (previousToken != nextToken) {
      _socketSubscription?.cancel();
      if (nextToken != null) {
        _socketService?.connect(nextToken);
        _socketSubscription = _socketService?.events.listen(
          (_) => refreshDevices(),
        );
        refreshDevices();
      } else {
        _socketService?.disconnect();
        _devices = [];
        notifyListeners();
      }
    } else if (nextToken != null && _devices.isEmpty && !_loading) {
      refreshDevices();
    }

    return this;
  }

  void selectRoom(String room) {
    if (_selectedRoom == room) return;
    _selectedRoom = room;
    notifyListeners();
  }

  Future<void> refreshDevices() async {
    final token = _authSessionStore?.session?.accessToken;
    if (token == null || _apiClient == null) return;
    _loading = true;
    notifyListeners();
    try {
      final rawDevices = await _apiClient!.getDevices(token);
      _devices = rawDevices.map(_mapDevice).toList();
      if (!availableRooms.contains(_selectedRoom)) {
        _selectedRoom = allRoomsLabel;
      }
      for (final device in _devices) {
        _socketService?.subscribeDevice(device.id);
      }
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  int deviceCountForRoom(String room) {
    if (room == allRoomsLabel) return _devices.length;
    return _devices.where((device) => device.room == room).length;
  }

  Future<void> toggleDevice(String id) async {
    final index = _devices.indexWhere((device) => device.id == id);
    if (index < 0) return;
    final previous = _devices[index];
    final nextState = !previous.isOn;
    _devices = List.of(_devices)..[index] = previous.copyWith(isOn: nextState);
    notifyListeners();

    final token = _authSessionStore?.session?.accessToken;
    if (token == null || _apiClient == null) return;

    try {
      await _apiClient!.sendPowerCommand(
        token,
        deviceId: id,
        relayOn: nextState,
      );
    } catch (error) {
      _devices[index] = previous;
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  void setDevicePower(String id, bool isOn) {
    final index = _devices.indexWhere((device) => device.id == id);
    if (index < 0 || _devices[index].isOn == isOn) return;
    _devices = List.of(_devices)
      ..[index] = _devices[index].copyWith(isOn: isOn);
    notifyListeners();
  }

  void setDevicesWhere(bool Function(SmartDevice device) test, bool isOn) {
    var changed = false;
    final updated = <SmartDevice>[];
    for (final device in _devices) {
      if (test(device) && device.isOn != isOn) {
        updated.add(device.copyWith(isOn: isOn));
        changed = true;
      } else {
        updated.add(device);
      }
    }
    if (!changed) return;
    _devices = updated;
    notifyListeners();
  }

  void setDevicesByType(DeviceType type, bool isOn) {
    setDevicesWhere((device) => device.type == type, isOn);
  }

  void setDevicesByRoom(String room, bool isOn) {
    setDevicesWhere((device) => device.room == room, isOn);
  }

  SmartDevice? deviceById(String id) {
    for (final device in _devices) {
      if (device.id == id) return device;
    }
    return _devices.isNotEmpty ? _devices.first : null;
  }

  SmartDevice? firstDeviceByType(DeviceType type) {
    for (final device in _devices) {
      if (device.type == type) return device;
    }
    return null;
  }

  void setLampBrightness(double value) {
    _lampBrightness = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setLampColorTemp(double value) {
    _lampColorTemp = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setLampSaturation(double value) {
    _lampSaturation = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setLampModeIndex(int index) {
    if (_lampModeIndex == index) return;
    _lampModeIndex = index;
    notifyListeners();
  }

  void setAcTemperature(int temperature) {
    _acTemperature = temperature.clamp(-50, 50);
    notifyListeners();
  }

  void setAcModeIndex(int index) {
    if (_acModeIndex == index) return;
    _acModeIndex = index;
    notifyListeners();
  }

  void setSpeakerVolume(double value) {
    _speakerVolume = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setSpeakerPlaybackPosition(double value) {
    _speakerPlaybackPosition = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void toggleSpeakerPlayback() {
    _speakerIsPlaying = !_speakerIsPlaying;
    notifyListeners();
  }

  void setAddDeviceTab(int index) {
    if (_addDeviceTab == index) return;
    _addDeviceTab = index;
    notifyListeners();
  }

  Future<void> startScan() async {
    _isScanning = true;
    _isConnecting = false;
    _isConnected = false;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    _isScanning = false;
    notifyListeners();
  }

  Future<bool> connectToDevice() async {
    if (_isConnecting) return false;
    _isConnecting = true;
    _isConnected = false;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _isConnecting = false;
    _isConnected = true;
    notifyListeners();
    return true;
  }

  void resetAddDeviceFlow() {
    _addDeviceTab = 0;
    _isScanning = false;
    _isConnecting = false;
    _isConnected = false;
    _connectedDeviceName = null;
    _manualSetupCode = null;
    _pendingDevice = null;
    notifyListeners();
  }

  Future<bool> connectQRDevice(String qrCode, String deviceName) async {
    return _claimProvisioningCode(qrCode, fallbackName: deviceName);
  }

  void setManualSetupCode(String code) {
    _manualSetupCode = code;
    notifyListeners();
  }

  void setPendingDevice(SmartDevice device) {
    _pendingDevice = device;
    _connectedDeviceName = device.name;
    notifyListeners();
  }

  Future<bool> processManualSetupCode(String code) async {
    return _claimProvisioningCode(code, fallbackName: _pendingDevice?.name);
  }

  void completeDeviceSetup() {
    resetAddDeviceFlow();
  }

  void setNotifTab(int index) {
    if (_notifTab == index) return;
    _notifTab = index;
    notifyListeners();
  }

  static const List<NotificationItem> generalNotifs = [
    NotificationItem(
      id: 'n1',
      title: 'Account Security Alert',
      description:
          'We noticed a new login. Review your Smartify credentials if this was not you.',
      time: '09:41 AM',
      icon: Icons.shield_outlined,
      isUnread: true,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Device Synced',
      description: 'Your smart power node is broadcasting live telemetry.',
      time: '08:46 AM',
      icon: Icons.info_outline_rounded,
      isUnread: true,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Password Reset Successful',
      description:
          'Your password has been updated. Contact support if this change was unexpected.',
      time: '20:30 PM',
      icon: Icons.lock_outline_rounded,
      badge: 'OK',
    ),
  ];

  @override
  void dispose() {
    _socketSubscription?.cancel();
    super.dispose();
  }

  Future<bool> _claimProvisioningCode(
    String rawCode, {
    String? fallbackName,
  }) async {
    if (_isConnecting) return false;
    _isConnecting = true;
    _isConnected = false;
    _manualSetupCode = rawCode;
    _errorMessage = null;
    notifyListeners();

    final token = _authSessionStore?.session?.accessToken;
    final provision = _parseProvisioningCode(rawCode);
    if (token == null) {
      _isConnecting = false;
      _errorMessage = 'Sign in before adding a device.';
      notifyListeners();
      return false;
    }
    if (provision == null) {
      _isConnecting = false;
      _errorMessage = 'Use JSON or deviceId|claimCode setup code.';
      notifyListeners();
      return false;
    }
    if (_apiClient == null) {
      _isConnecting = false;
      _errorMessage = 'Smartify API is not ready yet.';
      notifyListeners();
      return false;
    }

    try {
      final response = await _apiClient!.claimDevice(
        token,
        deviceId: provision.deviceId,
        claimCode: provision.claimCode,
        name: fallbackName,
      );
      _lastClaimedDeviceId =
          response['deviceId'] as String? ?? provision.deviceId;
      _connectedDeviceName =
          response['name'] as String? ?? fallbackName ?? provision.deviceId;
      _isConnected = true;
      await refreshDevices();
      return true;
    } catch (error) {
      _errorMessage = _formatClaimError(error);
    } finally {
      _isConnecting = false;
      notifyListeners();
    }
    return false;
  }

  String _formatClaimError(Object error) {
    final message = error.toString();
    if (message.contains('Device already claimed')) {
      return 'This device is already claimed by another account.';
    }
    if (message.contains('Invalid device claim')) {
      return 'This QR code is invalid or expired.';
    }
    if (message.contains('No reachable Smartify API base URL') ||
        message.contains('SocketException') ||
        message.contains('connection error') ||
        message.contains('Connection refused')) {
      return 'Cannot reach Smartify server. Keep your phone on the same Wi-Fi as the laptop.';
    }
    return 'Could not confirm this device. Please try again.';
  }

  int _countByType(DeviceType type) {
    return _devices.where((device) => device.type == type).length;
  }

  SmartDevice _mapDevice(Map<String, dynamic> json) {
    final deviceType = _mapDeviceType(json['type'] as String?);
    return SmartDevice(
      id: json['deviceId'] as String,
      name: json['name'] as String? ?? 'Smart Power Node',
      room: _mapRoom(json['room'] as String?),
      type: deviceType,
      connectivity: 'Wi-Fi',
      icon: _iconForType(deviceType),
      imagePath: _imagePathForType(deviceType),
      isOn: json['relayOn'] as bool? ?? false,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeenAt: DateTime.tryParse(json['lastSeenAt'] as String? ?? ''),
      telemetry: _mapTelemetry(
        json['latestTelemetry'] as Map<String, dynamic>?,
      ),
    );
  }

  PowerTelemetry? _mapTelemetry(Map<String, dynamic>? json) {
    if (json == null) return null;
    return PowerTelemetry(
      relayOn: json['relayOn'] as bool? ?? false,
      recordedAt:
          DateTime.tryParse(
            json['recordedAt'] as String? ?? json['bucket'] as String? ?? '',
          ) ??
          DateTime.now(),
    );
  }

  _ProvisioningCode? _parseProvisioningCode(String rawCode) {
    try {
      final decoded = jsonDecode(rawCode);
      if (decoded is Map<String, dynamic>) {
        return _ProvisioningCode(
          deviceId: decoded['deviceId'] as String,
          claimCode: decoded['claimCode'] as String,
        );
      }
    } catch (_) {}

    final parts = rawCode.trim().split('|');
    if (parts.length == 2) {
      return _ProvisioningCode(deviceId: parts.first, claimCode: parts.last);
    }
    return null;
  }

  DeviceType _mapDeviceType(String? rawType) {
    switch ((rawType ?? '').trim().toLowerCase()) {
      case 'smart-power-node':
      case 'smart-lamp':
      case 'lamp':
      case 'light':
        return DeviceType.light;
      case 'camera':
      case 'smart-camera':
        return DeviceType.camera;
      case 'speaker':
      case 'smart-speaker':
        return DeviceType.speaker;
      default:
        return DeviceType.electrical;
    }
  }

  IconData _iconForType(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return Icons.lightbulb_rounded;
      case DeviceType.camera:
        return Icons.videocam_rounded;
      case DeviceType.speaker:
        return Icons.speaker_rounded;
      case DeviceType.electrical:
        return Icons.power_rounded;
    }
  }

  String _imagePathForType(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return 'assets/bong_den.jpg';
      case DeviceType.camera:
        return 'assets/camera.jpg';
      case DeviceType.speaker:
        return 'assets/stereo.jpg';
      case DeviceType.electrical:
        return 'assets/png/device_ac.png';
    }
  }

  String _mapRoom(String? rawRoom) {
    final room = (rawRoom ?? '').trim();
    if (room.isEmpty) return unassignedRoomLabel;
    return room;
  }
}

class _ProvisioningCode {
  const _ProvisioningCode({required this.deviceId, required this.claimCode});

  final String deviceId;
  final String claimCode;
}
