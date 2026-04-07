import 'package:flutter/foundation.dart';
import 'package:smartify_flutter/core/state/auth_session_store.dart';

class OnboardingAuthStore extends ChangeNotifier {
  AuthSessionStore? _authSessionStore;

  OnboardingAuthStore bindDependencies(AuthSessionStore authSessionStore) {
    _authSessionStore = authSessionStore;
    return this;
  }

  static const int walkthroughCount = 3;
  static const int otpLength = 4;

  int _walkthroughIndex = 0;

  String _signUpEmail = '';
  String _signUpPassword = '';
  String _signUpConfirmPassword = '';
  bool _signUpAcceptedTerms = false;
  bool _signUpLoading = false;
  String? _signUpError;
  bool _signUpSuccess = false;

  String _signInEmail = '';
  String _signInPassword = '';
  bool _rememberMe = false;
  bool _signInLoading = false;
  String? _signInError;

  bool _socialLoading = false;
  String? _socialError;
  String? _socialProviderLabel;

  String _forgotEmail = '';
  bool _forgotLoading = false;
  String? _forgotError;

  String _otpCode = '';
  bool _otpLoading = false;
  String? _otpError;

  String _resetPassword = '';
  String _resetConfirmPassword = '';
  bool _resetLoading = false;
  String? _resetError;

  int get walkthroughIndex => _walkthroughIndex;

  String get signUpEmail => _signUpEmail;
  String get signUpPassword => _signUpPassword;
  String get signUpConfirmPassword => _signUpConfirmPassword;
  bool get signUpAcceptedTerms => _signUpAcceptedTerms;
  bool get signUpLoading => _signUpLoading;
  String? get signUpError => _signUpError;
  bool get signUpSuccess => _signUpSuccess;

  String get signInEmail => _signInEmail;
  String get signInPassword => _signInPassword;
  bool get rememberMe => _rememberMe;
  bool get signInLoading => _signInLoading;
  String? get signInError => _signInError;

  bool get socialLoading => _socialLoading;
  String? get socialError => _socialError;
  String? get socialProviderLabel => _socialProviderLabel;

  String get forgotEmail => _forgotEmail;
  bool get forgotLoading => _forgotLoading;
  String? get forgotError => _forgotError;

  String get otpCode => _otpCode;
  bool get otpLoading => _otpLoading;
  String? get otpError => _otpError;

  String get resetPassword => _resetPassword;
  String get resetConfirmPassword => _resetConfirmPassword;
  bool get resetLoading => _resetLoading;
  String? get resetError => _resetError;

  bool get canGoNextWalkthrough => _walkthroughIndex < walkthroughCount - 1;

  bool get canSubmitSignUp {
    return !_signUpLoading &&
        !_socialLoading &&
        _signUpEmail.isNotEmpty &&
        _signUpPassword.isNotEmpty &&
        _signUpAcceptedTerms;
  }

  bool get canSubmitSignIn {
    return !_signInLoading &&
        !_socialLoading &&
        _signInEmail.isNotEmpty &&
        _signInPassword.isNotEmpty;
  }

  bool get canSubmitForgot => !_forgotLoading && _forgotEmail.isNotEmpty;
  bool get canSubmitOtp => !_otpLoading && _otpCode.length == otpLength;

  bool get canSubmitReset {
    return !_resetLoading &&
        _resetPassword.isNotEmpty &&
        _resetConfirmPassword.isNotEmpty;
  }

  void setWalkthroughIndex(int index) {
    final bounded = index.clamp(0, walkthroughCount - 1);
    if (_walkthroughIndex == bounded) {
      return;
    }
    _walkthroughIndex = bounded;
    notifyListeners();
  }

  void nextWalkthrough() {
    if (_walkthroughIndex >= walkthroughCount - 1) {
      return;
    }
    _walkthroughIndex += 1;
    notifyListeners();
  }

  void skipWalkthrough() {
    if (_walkthroughIndex == walkthroughCount - 1) {
      return;
    }
    _walkthroughIndex = walkthroughCount - 1;
    notifyListeners();
  }

  void resetWalkthrough() {
    if (_walkthroughIndex == 0) {
      return;
    }
    _walkthroughIndex = 0;
    notifyListeners();
  }

  void setSignUpEmail(String value) {
    _signUpEmail = value.trim();
    _signUpError = null;
    notifyListeners();
  }

  void setSignUpPassword(String value) {
    _signUpPassword = value;
    _signUpError = null;
    notifyListeners();
  }

  void setSignUpConfirmPassword(String value) {
    _signUpConfirmPassword = value;
    _signUpError = null;
    notifyListeners();
  }

  void setSignUpAcceptedTerms(bool value) {
    _signUpAcceptedTerms = value;
    _signUpError = null;
    notifyListeners();
  }

  void setSignInEmail(String value) {
    _signInEmail = value.trim();
    _signInError = null;
    notifyListeners();
  }

  void setSignInPassword(String value) {
    _signInPassword = value;
    _signInError = null;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  void setForgotEmail(String value) {
    _forgotEmail = value.trim();
    _forgotError = null;
    notifyListeners();
  }

  void setOtpCode(String value) {
    _otpCode = value.trim();
    _otpError = null;
    notifyListeners();
  }

  void setResetPassword(String value) {
    _resetPassword = value;
    _resetError = null;
    notifyListeners();
  }

  void setResetConfirmPassword(String value) {
    _resetConfirmPassword = value;
    _resetError = null;
    notifyListeners();
  }

  Future<bool> submitSignUp() async {
    if (_signUpLoading || _socialLoading) {
      return false;
    }
    final emailError = validateEmail(_signUpEmail);
    if (emailError != null) {
      _signUpError = emailError;
      notifyListeners();
      return false;
    }
    final passwordError = validatePassword(_signUpPassword);
    if (passwordError != null) {
      _signUpError = passwordError;
      notifyListeners();
      return false;
    }
    if (!_signUpAcceptedTerms) {
      _signUpError = 'You need to accept Terms & Conditions.';
      notifyListeners();
      return false;
    }
    final confirmPassword = _signUpConfirmPassword.isEmpty
        ? _signUpPassword
        : _signUpConfirmPassword;
    if (_signUpPassword != confirmPassword) {
      _signUpError = 'Confirm password does not match.';
      notifyListeners();
      return false;
    }

    _signUpLoading = true;
    _signUpError = null;
    notifyListeners();

    final ok =
        await _authSessionStore?.signUp(_signUpEmail, _signUpPassword) ?? false;
    _signUpLoading = false;
    _signUpSuccess = ok;
    _signUpError = ok ? null : _authSessionStore?.errorMessage ?? 'Sign up failed.';
    notifyListeners();
    return ok;
  }

  Future<bool> submitSignIn() async {
    if (_signInLoading || _socialLoading) {
      return false;
    }
    final emailError = validateEmail(_signInEmail);
    if (emailError != null) {
      _signInError = emailError;
      notifyListeners();
      return false;
    }
    final passwordError = validatePassword(_signInPassword);
    if (passwordError != null) {
      _signInError = passwordError;
      notifyListeners();
      return false;
    }

    _signInLoading = true;
    _signInError = null;
    notifyListeners();

    final ok =
        await _authSessionStore?.signIn(_signInEmail, _signInPassword) ?? false;
    _signInLoading = false;
    _signInError = ok ? null : _authSessionStore?.errorMessage ?? 'Sign in failed.';
    notifyListeners();
    return ok;
  }

  Future<bool> submitSocialAuth(String providerLabel) async {
    if (_socialLoading || _signInLoading || _signUpLoading) {
      return false;
    }
    if (providerLabel.trim().isEmpty) {
      _socialError = 'Social provider is required.';
      notifyListeners();
      return false;
    }

    _socialLoading = true;
    _socialError = null;
    _socialProviderLabel = providerLabel;
    notifyListeners();

    _socialLoading = false;
    _socialError = 'Social sign-in is not part of the MVP demo.';
    notifyListeners();
    return false;
  }

  void clearSocialState() {
    _socialLoading = false;
    _socialError = null;
    _socialProviderLabel = null;
    notifyListeners();
  }

  Future<bool> submitForgotPassword() async {
    if (_forgotLoading) {
      return false;
    }
    final emailError = validateEmail(_forgotEmail);
    if (emailError != null) {
      _forgotError = emailError;
      notifyListeners();
      return false;
    }

    _forgotLoading = true;
    _forgotError = null;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 700));

    _forgotLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> submitOtp() async {
    if (_otpLoading) {
      return false;
    }
    if (_otpCode.length != otpLength) {
      _otpError = 'OTP must be $otpLength digits.';
      notifyListeners();
      return false;
    }

    _otpLoading = true;
    _otpError = null;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 700));

    _otpLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> submitResetPassword() async {
    if (_resetLoading) {
      return false;
    }
    final passwordError = validatePassword(_resetPassword);
    if (passwordError != null) {
      _resetError = passwordError;
      notifyListeners();
      return false;
    }
    if (_resetPassword != _resetConfirmPassword) {
      _resetError = 'Confirm password does not match.';
      notifyListeners();
      return false;
    }

    _resetLoading = true;
    _resetError = null;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 850));

    _resetLoading = false;
    notifyListeners();
    return true;
  }

  void clearSignUpState() {
    _signUpError = null;
    _signUpLoading = false;
    _signUpSuccess = false;
    notifyListeners();
  }

  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required.';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format.';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }
}
