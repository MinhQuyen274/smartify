# Code Standards (Current Repository Baseline)

Last updated: 2026-03-12

## 1) Architecture and Organization
## 1.1 Folder conventions
- `lib/app/`: app-level bootstrap and router.
- `lib/core/`: global tokens and app-level stores.
- `lib/features/{feature-name}/`: feature-specific presentation/state.
- `lib/shared/widgets/`: reusable widgets across features.
- `test/`: automated tests.

## 1.2 State management
- Use `provider` with `ChangeNotifier` stores.
- Expose immutable accessors (`get`) from stores.
- Call `notifyListeners()` only when state actually changes.

## 1.3 Routing
- Define route strings in `AppRoutes` only.
- Navigate via named routes.
- Keep `/screen/{id}` contract stable for prototype viewer.

## 2) Naming Standards
- Dart classes: PascalCase (`OnboardingAuthStore`).
- Variables/methods: lowerCamelCase (`setSignInEmail`).
- Feature keys: kebab-case string (`onboarding-auth`, `home-devices`, `smart-scenes`).
- File names: snake_case in current codebase (existing convention).

## 3) Error Handling Standards
- Async loaders must use try/catch and expose user-facing error message.
- Example current pattern: `ScreenManifestStore.load()` sets `_errorMessage` and `_isLoaded` consistently.
- UI consumers must render loading and error states before normal content.

## 4) UI and UX Standards (Prototype)
- Light mode only.
- Reuse shared components where possible:
  - `AuthScaffold`
  - `AuthLoadingButton`
  - `SmartifyTextField`
  - `FeatureFlowScreen`
- Keep transitions through existing motion/token system.

## 5) Data and Asset Standards
- PNG prototype assets must be under `assets/png/` and declared in `pubspec.yaml`.
- Screen IDs, labels, and order are derived from file names via `AssetNameParser`.
- Feature classification must be updated carefully to avoid cross-feature mis-grouping.

## 6) Testing Standards (Minimum)
- Keep smoke boot test (`test/widget_test.dart`) passing.
- Keep registry contract test (`test/prototype_screen_registry_test.dart`) passing.
- For route/state changes, prefer adding focused widget tests for affected flow.

## 7) Security and Privacy Baseline
- Current auth flow is mock/local only.
- Do not document or imply secure auth/session guarantees yet.
- No secrets should be hardcoded in source or docs.

## 8) Documentation Sync Rules
When changing onboarding/auth or routing/manifest behavior, update:
- `docs/project-overview-pdr.md`
- `docs/system-architecture.md`
- `docs/codebase-summary.md` (after new repomix snapshot)

## 9) Known Technical Debt
- `MockAuthStore` and `OnboardingAuthStore` responsibilities are partially overlapping by domain (auth), not integrated yet.
- Unknown-route fallback may reduce visibility of route config regressions.

## Unresolved questions
- Should this repo standardize naming to kebab-case filenames in future major refactor, or keep current snake_case Dart files?
- Should onboarding/auth adopt stricter validation rules now, or defer until backend/auth integration phase?
