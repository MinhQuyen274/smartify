import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/features/onboarding-auth/state/onboarding_auth_store.dart';

import 'test_support/fake_runtime.dart';
import 'test_support/test_app.dart';

void main() {
  testWidgets('Walkthrough screen renders onboarding actions', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(initialRoute: AppRoutes.onboardingAuthWalkthrough),
    );
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 700),
    );

    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsAtLeastNWidgets(1));
  });

  testWidgets('Sign up form enables submit for valid account input', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(
        initialRoute: AppRoutes.onboardingAuthSignUp,
        authSessionStore: FakeAuthSessionStore(signUpSucceeds: true),
      ),
    );
    await pumpForTransition(tester);

    final signUpFields = find.byType(TextField);
    await tester.enterText(signUpFields.at(0), 'new@smartify.com');
    await tester.enterText(signUpFields.at(1), 'password123');
    await tester.tap(find.byType(Checkbox));
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 200),
    );

    expect(
      find.byKey(const ValueKey<String>('btn-Sign up-false-true')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Sign in form enables submit without small-screen overflow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(
        initialRoute: AppRoutes.onboardingAuthSignIn,
        authSessionStore: FakeAuthSessionStore(signInSucceeds: true),
      ),
    );
    await pumpForTransition(tester);

    final signInFields = find.byType(TextField);
    await tester.enterText(signInFields.at(0), 'user@smartify.com');
    await tester.enterText(signInFields.at(1), 'password123');
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 200),
    );

    expect(
      find.byKey(const ValueKey<String>('btn-Sign in-false-true')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Set Home Location step avoids overflow on phone screens', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(
        initialRoute: AppRoutes.onboardingAuthSignUp,
        authSessionStore: FakeAuthSessionStore(signUpSucceeds: true),
      ),
    );
    await pumpForTransition(tester);

    final signUpFields = find.byType(TextField);
    await tester.enterText(signUpFields.at(0), 'new@smartify.com');
    await tester.enterText(signUpFields.at(1), 'password123');
    await tester.tap(find.byType(Checkbox));
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 200),
    );

    await tester.tap(
      find.byKey(const ValueKey<String>('btn-Sign up-false-true')),
    );
    await pumpForTransition(tester);

    await tester.binding.setSurfaceSize(const Size(390, 844));
    await pumpForTransition(
      tester,
      duration: const Duration(milliseconds: 200),
    );

    await tester.tap(find.text('Continue'));
    await pumpForTransition(tester);
    await tester.tap(find.text('Continue'));
    await pumpForTransition(tester);
    await tester.tap(find.text('Continue'));
    await pumpForTransition(tester);

    expect(find.text('Set Home Location'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Enable Location'));
    await pumpForTransition(tester);

    expect(find.text('Address Details'), findsAtLeastNWidgets(1));
    expect(tester.takeException(), isNull);
  });

  test(
    'OnboardingAuthStore submits auth through the bound session store',
    () async {
      final sessionStore = FakeAuthSessionStore(
        signInSucceeds: true,
        signUpSucceeds: true,
      );
      final store = OnboardingAuthStore()..bindDependencies(sessionStore);

      store.setSignUpEmail('new@smartify.com');
      store.setSignUpPassword('password123');
      store.setSignUpAcceptedTerms(true);
      final signUpOk = await store.submitSignUp();

      store.setSignInEmail('user@smartify.com');
      store.setSignInPassword('password123');
      final signInOk = await store.submitSignIn();

      expect(signUpOk, isTrue);
      expect(signInOk, isTrue);
      expect(sessionStore.isSignedIn, isTrue);
    },
  );
}
