import 'dart:async';

import 'package:smartify_flutter/core/network/app_config.dart';
import 'package:smartify_flutter/core/network/smartify_backend_discovery.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SmartifySocketService {
  SmartifySocketService();

  final StreamController<Map<String, dynamic>> _eventsController =
      StreamController<Map<String, dynamic>>.broadcast();

  io.Socket? _socket;
  final Set<String> _subscribedDeviceIds = <String>{};
  String? _activeToken;
  String? _resolvedSocketUrl;

  Stream<Map<String, dynamic>> get events => _eventsController.stream;

  void connect(String token) {
    if (_activeToken == token && _socket?.connected == true) return;
    disconnect();
    _activeToken = token;
    unawaited(_connectWithFallback(token));
  }

  void subscribeDevice(String deviceId) {
    _subscribedDeviceIds.add(deviceId);
    _socket?.emit('subscribe.device', deviceId);
  }

  void disconnect() {
    _socket?.dispose();
    _socket = null;
    _activeToken = null;
  }

  void dispose() {
    disconnect();
    _eventsController.close();
  }

  void _emit(String type, dynamic payload) {
    _eventsController.add({
      'type': type,
      'payload': payload is Map
          ? Map<String, dynamic>.from(payload)
          : <String, dynamic>{},
    });
  }

  Future<void> _connectWithFallback(String token, [int startIndex = 0]) async {
    final candidates = <String>[
      if (_resolvedSocketUrl != null) _resolvedSocketUrl!,
      ...await SmartifyBackendDiscovery.resolveCandidateUrls(
        AppConfig.socketUrls,
      ),
    ];
    final urls = <String>[];
    for (final url in candidates) {
      if (!urls.contains(url)) {
        urls.add(url);
      }
    }
    if (startIndex >= urls.length) return;

    final socketUrl = urls[startIndex];
    final candidate = io.io(
      socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    var connected = false;
    void tryNext() {
      if (connected || _activeToken != token) return;
      candidate.dispose();
      if (startIndex + 1 < urls.length) {
        unawaited(_connectWithFallback(token, startIndex + 1));
      }
    }

    _socket = candidate;
    candidate
      ..onConnect((_) {
        connected = true;
        _resolvedSocketUrl = socketUrl;
        SmartifyBackendDiscovery.remember(socketUrl);
        for (final deviceId in _subscribedDeviceIds) {
          candidate.emit('subscribe.device', deviceId);
        }
      })
      ..onConnectError((_) => tryNext())
      ..on('device.updated', (data) => _emit('device.updated', data))
      ..on('telemetry.received', (data) => _emit('telemetry.received', data))
      ..on(
        'command.acknowledged',
        (data) => _emit('command.acknowledged', data),
      )
      ..connect();
  }
}
