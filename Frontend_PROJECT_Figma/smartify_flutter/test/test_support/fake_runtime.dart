import 'dart:async';

import 'package:smartify_flutter/core/models/auth_models.dart';
import 'package:smartify_flutter/core/network/smartify_api_client.dart';
import 'package:smartify_flutter/core/network/smartify_socket_service.dart';
import 'package:smartify_flutter/core/state/auth_session_store.dart';

class FakeAuthSessionStore extends AuthSessionStore {
  FakeAuthSessionStore({
    this.signInSucceeds = true,
    this.signUpSucceeds = true,
    AuthSession? seededSession,
  }) : _sessionValue = seededSession,
       _statusValue = seededSession == null
           ? AuthSessionStatus.signedOut
           : AuthSessionStatus.signedIn,
       super(SmartifyApiClient(), null, false);

  final bool signInSucceeds;
  final bool signUpSucceeds;

  AuthSessionStatus _statusValue;
  AuthSession? _sessionValue;
  String? _errorValue;

  @override
  AuthSessionStatus get status => _statusValue;

  @override
  AuthSession? get session => _sessionValue;

  @override
  String? get errorMessage => _errorValue;

  @override
  bool get isSignedIn =>
      _statusValue == AuthSessionStatus.signedIn && _sessionValue != null;

  @override
  Future<bool> signIn(String email, String password) async {
    _statusValue = AuthSessionStatus.signingIn;
    _errorValue = null;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 1));

    if (!signInSucceeds) {
      _statusValue = AuthSessionStatus.signedOut;
      _errorValue = 'Sign in failed.';
      notifyListeners();
      return false;
    }

    _sessionValue = demoSession(email);
    _statusValue = AuthSessionStatus.signedIn;
    notifyListeners();
    return true;
  }

  @override
  Future<bool> signUp(String email, String password) async {
    _statusValue = AuthSessionStatus.signingIn;
    _errorValue = null;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 1));

    if (!signUpSucceeds) {
      _statusValue = AuthSessionStatus.signedOut;
      _errorValue = 'Sign up failed.';
      notifyListeners();
      return false;
    }

    _sessionValue = demoSession(email);
    _statusValue = AuthSessionStatus.signedIn;
    notifyListeners();
    return true;
  }

  @override
  Future<void> signOut() async {
    _sessionValue = null;
    _statusValue = AuthSessionStatus.signedOut;
    _errorValue = null;
    notifyListeners();
  }

  static AuthSession demoSession(String email) {
    return AuthSession(
      accessToken: 'test-token',
      user: AuthUser(
        id: 'user-1',
        email: email,
        createdAt: DateTime(2026, 4, 1),
      ),
    );
  }
}

class FakeSmartifyApiClient extends SmartifyApiClient {
  FakeSmartifyApiClient({
    this.devices = const [],
    this.historyByDeviceId = const {},
    this.reportSummary,
    this.signInSucceeds = true,
    this.signUpSucceeds = true,
  });

  final List<Map<String, dynamic>> devices;
  final Map<String, List<Map<String, dynamic>>> historyByDeviceId;
  final Map<String, dynamic>? reportSummary;
  final bool signInSucceeds;
  final bool signUpSucceeds;

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    if (!signInSucceeds) {
      throw Exception('Sign in failed.');
    }
    return FakeAuthSessionStore.demoSession(email);
  }

  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
  }) async {
    if (!signUpSucceeds) {
      throw Exception('Sign up failed.');
    }
    return FakeAuthSessionStore.demoSession(email);
  }

  @override
  Future<List<Map<String, dynamic>>> getDevices(String token) async {
    return List<Map<String, dynamic>>.from(devices);
  }

  @override
  Future<Map<String, dynamic>> getDevice(String token, String deviceId) async {
    return Map<String, dynamic>.from(
      devices.firstWhere((device) => device['deviceId'] == deviceId),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getDeviceHistory(
    String token,
    String deviceId,
  ) async {
    return List<Map<String, dynamic>>.from(
      historyByDeviceId[deviceId] ?? const [],
    );
  }

  @override
  Future<Map<String, dynamic>> claimDevice(
    String token, {
    required String deviceId,
    required String claimCode,
    String? name,
  }) async {
    return {
      'deviceId': deviceId,
      'name': name ?? 'Smart Power Node',
      'claimCode': claimCode,
    };
  }

  @override
  Future<Map<String, dynamic>> sendPowerCommand(
    String token, {
    required String deviceId,
    required bool relayOn,
  }) async {
    return {'requestId': 'req-1', 'deviceId': deviceId, 'relayOn': relayOn};
  }

  @override
  Future<Map<String, dynamic>> getReportSummary(String token) async {
    return Map<String, dynamic>.from(
      reportSummary ??
          {
            'deviceCount': devices.length,
            'totalEnergyKwh': 0,
            'devices': const <Map<String, dynamic>>[],
          },
    );
  }
}

class FakeSmartifySocketService extends SmartifySocketService {
  final StreamController<Map<String, dynamic>> _controller =
      StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> get events => _controller.stream;

  @override
  void connect(String token) {}

  @override
  void subscribeDevice(String deviceId) {}

  @override
  void disconnect() {}

  @override
  void dispose() {
    _controller.close();
  }

  void emit(String type, Map<String, dynamic> payload) {
    _controller.add({'type': type, 'payload': payload});
  }
}
