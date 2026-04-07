# Codebase Summary

Last updated: 2026-03-12
Source snapshot: `D:/Frontend_PROJECT_Figma/smartify_flutter/repomix-output.xml`

## Scope
This summary reflects the current Flutter prototype app in `smartify_flutter`.
The app is a light-mode-only visual flow prototype driven by PNG assets under `assets/png/` and metadata generated at runtime.

## High-Level Structure
- `lib/main.dart`: app bootstrap via `runApp(const SmartifyApp())`.
- `lib/app/app.dart`: `MultiProvider` wiring and `MaterialApp` config.
- `lib/app/router/app_router.dart`: centralized route constants and `onGenerateRoute`.
- `lib/core/`: shared state (`ChangeNotifier` stores), theme tokens, motion tokens/transitions.
- `lib/features/`: feature flows (`onboarding-auth`, `home-devices`, `smart-scenes`, `reports`, `account-settings`) and prototype viewer logic.
- `lib/shared/widgets/`: reusable UI primitives and browsing widgets.
- `test/`: smoke/widget and registry tests.

## Runtime Model
### State and DI
`SmartifyApp` registers these providers:
- `AppFlowStore`
- `MockAuthStore`
- `SelectionStore`
- `OnboardingAuthStore`
- `ScreenManifestStore()..load()`

State management approach: `provider` + `ChangeNotifier`.

### Navigation
`AppRouter.onGenerateRoute` supports:
- Home: `/`
- Reconstructed onboarding/auth screens: `/onboarding-auth/...`
- Home/Devices screens: `/home-devices/...`
- Smart Scenes: `/smart-scenes/...`
- Reports: `/reports/...`
- Account/Settings: `/account-settings/...`
- Dynamic screen viewer routes: `/screen/{id}`

Home/Devices dashboard navigation currently uses bottom-tab `pushReplacementNamed(...)` for Smart/Reports/Account and named push routes for switch-home + notifications.

Unknown routes fall back to a recovery scaffold that links to first manifest route (or home).

### Asset-Driven Screen Registry
- `PrototypeScreenRegistry.loadFromAssets()` reads `AssetManifest.json`.
- Filters only `assets/png/*.png`.
- Sorts by numeric order parsed from file name prefix.
- Builds `PrototypeScreen` with:
  - `id`
  - `order`
  - `assetPath`
  - `route` (`/screen/{id}`)
  - `feature` via `AssetNameParser.resolveFeature(...)`
  - `label`

`ScreenManifestStore` caches mapped `ScreenManifestItem` records and exposes:
- `items`
- `load({force = false})`
- `byRoute(route)`
- `byFeature(feature)`

## Batch 1 Onboarding/Auth Current Implementation
Feature path:
- `lib/features/onboarding-auth/presentation/screens/`
- `lib/features/onboarding-auth/presentation/widgets/`
- `lib/features/onboarding-auth/state/onboarding_auth_store.dart`

Implemented production flow screens:
1. `OnboardingAuthSplashScreen`
2. `OnboardingAuthWalkthroughScreen`
3. `OnboardingAuthWelcomeScreen`
4. `OnboardingAuthSignUpScreen`
5. `OnboardingAuthSignInScreen`
6. `OnboardingAuthForgotPasswordScreen`
7. `OnboardingAuthOtpScreen`
8. `OnboardingAuthResetPasswordScreen`
9. `OnboardingAuthResetSuccessScreen`

Store behavior (`OnboardingAuthStore`) includes local form state, basic validation, loading flags, and mocked async submit delays.
No real backend integration is present.

## Tests Present
- `test/widget_test.dart`: app boot smoke test; checks home title/button.
- `test/prototype_screen_registry_test.dart`: ensures registry loads, IDs unique, asset paths and `/screen/{id}` route contract valid.

## Key Constraints Observed in Code
- Theme mode fixed to light (`ThemeMode.light`).
- Prototype uses local assets and mocked auth; no API/auth tokens/secure storage.
- Feature segmentation depends on filename keyword classification in `AssetNameParser.resolveFeature`.

## Documentation Gaps Identified from Snapshot
- No existing project docs under `docs/` before this update.
- No explicit architecture/PDR/code standards docs scoped to current implementation.
- No dedicated route contract matrix for production-only onboarding/auth route coverage.

## Notes
This summary is intentionally evidence-based and limited to files and behavior verified in repository snapshot and `repomix-output.xml`.

Update note (2026-03-12): Home/Devices parity pass reflected in docs for navigation behavior and route group clarity.
