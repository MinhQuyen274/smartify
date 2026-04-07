import 'package:flutter/foundation.dart';

enum MockAuthStatus { signedOut, signingIn, signedIn }

class MockAuthStore extends ChangeNotifier {
  MockAuthStatus _status = MockAuthStatus.signedOut;

  MockAuthStatus get status => _status;

  void signIn() {
    _status = MockAuthStatus.signedIn;
    notifyListeners();
  }

  void signOut() {
    _status = MockAuthStatus.signedOut;
    notifyListeners();
  }
}
