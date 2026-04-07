# Smartify Flutter Project Overview & PDR

Last updated: 2026-03-12
Version: 0.1 (Batch 1 Onboarding/Auth baseline)

## 1) Product Overview
Smartify Flutter is a prototype app to reconstruct UI flows from PNG design exports in light mode.
Current priority includes onboarding/auth flow reconstruction and browsing/QA of mapped screens.

## 2) Problem Statement
Team needs a stable, fast way to:
- Review screen flows reconstructed from design assets.
- Navigate by feature slices (`onboarding-auth`, `home-devices`, etc.).
- Validate baseline onboarding/auth UX before real backend/auth integration.

## 3) Functional Requirements (Current Verified Scope)
### FR-1 App bootstrap
- App boots into home route `/`.
- Home screen shows feature entries and launch action.

### FR-2 Feature navigation
- Must route to feature flows via `AppRoutes` constants in `lib/app/router/app_router.dart`.
- Must support dynamic route `/screen/{id}` for PNG viewer.

### FR-3 Screen manifest loading
- Must load from `AssetManifest.json`.
- Must include only `assets/png/*.png`.
- Must map each screen to id/route/feature/label for UI browsing.

### FR-4 Onboarding/Auth reconstructed flow
- Must support production route chain:
  - splash -> walkthrough -> welcome
  - welcome -> sign-up/sign-in
  - forgot-password -> otp -> reset-password -> reset-success
- Must not expose legacy browser/flow routes.

### FR-5 Local state + validation
- `OnboardingAuthStore` must handle local form state and basic validation:
  - email format check
  - min password length check
  - confirm-password match
  - OTP length check
- Submit handlers are mocked async transitions (no backend call).

### FR-6 Error/loading states
- `ScreenManifestStore` must expose loading/error states for consumers.
- `ScreenViewerScreen` and `FeatureFlowScreen` must handle loading/error rendering.

## 4) Non-Functional Requirements
- NFR-1: Keep architecture simple (`provider` + `ChangeNotifier`).
- NFR-2: Keep startup safe even if manifest load fails (error surfaced, no crash expected).
- NFR-3: Keep route naming consistent via `AppRoutes` constants.
- NFR-4: Maintain light-mode-only behavior for current prototype phase.

## 5) Out of Scope (Verified)
- Real auth API integration
- Token/session persistence
- Secure storage
- Production-grade validation/security hardening
- Dark mode implementation

## 6) Acceptance Criteria (Batch 1 docs sync)
- AC-1: Documentation reflects implemented onboarding/auth routes and flow.
- AC-2: Docs explicitly state mock auth nature and no backend integration.
- AC-3: Docs capture asset-driven screen mapping constraints.
- AC-4: Docs define known risks for feature-key and asset classification drift.

## 7) Dependencies & Constraints
- Flutter SDK `^3.9.2` (from `pubspec.yaml`)
- `provider: ^6.1.5`
- Asset source under `assets/png/`

## 8) Risks
1. Feature-key drift (e.g. mismatched `onboarding-auth` key)
2. Over/under-match in `AssetNameParser.resolveFeature`
3. Unknown-route fallback can hide route mapping defects
4. Mock auth expectations may diverge from future real auth behavior

## 9) Success Metrics (Prototype Phase)
- App boot smoke test remains green.
- Registry test remains green after asset/route changes.
- Onboarding/auth reconstructed flow routes remain navigable without crash.

## 10) Change Log (Doc)
- 2026-03-12: Initial PDR created based on implemented Batch 1 onboarding/auth code and route contracts.
- 2026-03-12: Updated requirements to reflect production-only onboarding/auth routes and removal of legacy browser/flow route support.

## Unresolved questions
- Should onboarding/auth get dedicated widget tests for route transitions beyond boot smoke?
- Should unknown-route fallback be tightened for feature routes to avoid masking regressions?
- Should `MockAuthStore` be integrated into onboarding screens or remain separate for now?
