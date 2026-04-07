import 'package:flutter_test/flutter_test.dart';
import 'package:smartify_flutter/features/onboarding-auth/state/onboarding_auth_store.dart';

void main() {
  test(
    'Forgot-password, OTP, and reset helpers validate the happy path',
    () async {
      final store = OnboardingAuthStore();

      store.setForgotEmail('user@smartify.com');
      final forgotOk = await store.submitForgotPassword();

      store.setOtpCode('1234');
      final otpOk = await store.submitOtp();

      store.setResetPassword('password123');
      store.setResetConfirmPassword('password123');
      final resetOk = await store.submitResetPassword();

      expect(forgotOk, isTrue);
      expect(otpOk, isTrue);
      expect(resetOk, isTrue);
    },
  );
}
