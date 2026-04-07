import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartify_flutter/core/models/auth_models.dart';
import 'package:smartify_flutter/core/network/smartify_api_client.dart';

enum AuthSessionStatus { initializing, signedOut, signingIn, signedIn }

class AuthSessionStore extends ChangeNotifier {
  AuthSessionStore(
    this._apiClient, [
    FlutterSecureStorage? storage,
    bool restoreOnInit = true,
  ]) : _storage = storage ?? const FlutterSecureStorage() {
    if (restoreOnInit) {
      restoreSession();
    } else {
      _status = AuthSessionStatus.signedOut;
    }
  }

  static const _storageKey = 'smartify-auth-session';

  final SmartifyApiClient _apiClient;
  final FlutterSecureStorage _storage;

  AuthSessionStatus _status = AuthSessionStatus.initializing;
  AuthSession? _session;
  String? _errorMessage;

  AuthSessionStatus get status => _status;
  AuthSession? get session => _session;
  String? get errorMessage => _errorMessage;
  bool get isSignedIn =>
      _status == AuthSessionStatus.signedIn && _session != null;

  Future<void> restoreSession() async {
    String? raw;
    try {
      raw = await _storage
          .read(key: _storageKey)
          .timeout(const Duration(milliseconds: 500));
    } catch (_) {
      raw = null;
    }

    if (raw == null || raw.isEmpty) {
      _status = AuthSessionStatus.signedOut;
      notifyListeners();
      return;
    }

    _session = AuthSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    _status = AuthSessionStatus.signedIn;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    return _saveSession(
      () => _apiClient.signIn(email: email, password: password),
    );
  }

  Future<bool> signUp(String email, String password) async {
    return _saveSession(
      () => _apiClient.signUp(email: email, password: password),
    );
  }

  Future<void> signOut() async {
    _session = null;
    _status = AuthSessionStatus.signedOut;
    _errorMessage = null;
    try {
      await _storage
          .delete(key: _storageKey)
          .timeout(const Duration(milliseconds: 500));
    } catch (_) {}
    notifyListeners();
  }

  Future<bool> _saveSession(Future<AuthSession> Function() action) async {
    _status = AuthSessionStatus.signingIn;
    _errorMessage = null;
    notifyListeners();
    try {
      _session = await action();
      try {
        await _storage
            .write(key: _storageKey, value: jsonEncode(_session!.toJson()))
            .timeout(const Duration(milliseconds: 500));
      } catch (_) {}
      _status = AuthSessionStatus.signedIn;
      notifyListeners();
      return true;
    } catch (error) {
      _status = AuthSessionStatus.signedOut;
      _errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }
}
