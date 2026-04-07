# System Architecture

Last updated: 2026-03-12

## 1) Architecture Overview
Smartify Flutter is a client-only prototype architecture with:
- Flutter UI layer
- Provider-based state layer (`ChangeNotifier` stores)
- Asset-driven screen registry for prototype flows

No backend services are integrated in current snapshot.

## 2) Main Components
## 2.1 App Composition
- Entry: `lib/main.dart`
- Root app: `lib/app/app.dart`
- Router: `lib/app/router/app_router.dart`

`SmartifyApp` creates providers and attaches `MaterialApp` with `onGenerateRoute`.

## 2.2 State Stores
- `AppFlowStore`: active feature key for navigation context.
- `MockAuthStore`: minimal mock auth status enum transitions.
- `OnboardingAuthStore`: onboarding/auth form + async mock submit logic.
- `ScreenManifestStore`: loaded manifest items + loading/error state.
- `SelectionStore`: additional selection state (registered in app providers).

## 2.3 Feature Modules
- `features/onboarding-auth`: reconstructed onboarding/auth UI and flow logic.
- `features/prototype_viewer`: model/registry/parser/PNG viewer.
- `features/screen-mapping`: manifest store + screen viewer route binding.
- Other feature hubs: `home-devices`, `smart-scenes`, `reports`, `account-settings`.

## 3) Navigation Architecture
### Static routes
Defined in `AppRoutes`, including:
- `/`
- `/onboarding-auth/{screen}` for reconstructed auth steps
- `/home-devices/{screen}`
- `/smart-scenes/{screen}`
- `/reports/{screen}`
- `/account-settings/{screen}`

### Home/Devices navigation behavior (current)
- `MyHomeDashboardScreen` uses `HomeBottomNavBar` with 4 tabs: Home, Smart, Reports, Account.
- Tab switching uses `Navigator.pushReplacementNamed(...)` to route to:
  - Smart -> `AppRoutes.smartScenesDashboard`
  - Reports -> `AppRoutes.reportsDashboard`
  - Account -> `AppRoutes.accountProfile`
- Home title tap navigates to `AppRoutes.homeDevicesSwitchHome`.
- Notification icon navigates to `AppRoutes.homeDevicesNotifications`.

### Dynamic routes
- `/screen/{id}` handled in router default branch.
- Viewer resolves `screenId` from route, then looks up `ScreenManifestStore.items`.

### Unknown route handling
- If route not matched and not `/screen/...`, fallback screen offers navigation to first manifest route (or home).

## 4) Data Flow
1. App starts -> `ScreenManifestStore.load()` executes.
2. Registry reads `AssetManifest.json`.
3. PNG entries mapped to `PrototypeScreen` then `ScreenManifestItem`.
4. Feature screens query `byFeature(featureKey)` for filtered browsing.
5. User navigates to `/screen/{id}` -> `ScreenViewerScreen` renders selected PNG with prev/next.

## 5) Onboarding/Auth Flow Architecture
Current production flow:
- Splash -> Walkthrough -> Welcome
- Welcome branches to Sign Up or Sign In
- Sign In can navigate to Forgot Password -> OTP -> Reset Password -> Reset Success

State owner:
- `OnboardingAuthStore` manages all form fields, errors, loading flags, and simple validations.

## 6) Failure Modes and Current Mitigations
- Manifest load failure -> error text in store and UI retry in `ScreenViewerScreen`.
- Missing screen id -> `Screen not found` scaffold.
- Disabled animations respected in walkthrough page transition duration.

## 7) Constraints
- Light mode enforced.
- Local mock flow only.
- Feature grouping depends on file-name keyword heuristics.

## 8) Architecture Decisions (Current)
- ADR-A1: Use provider + ChangeNotifier for low-complexity prototype state.
- ADR-A2: Use asset manifest as source of truth for screen catalog.
- ADR-A3: Keep only reconstructed onboarding/auth routes in `AppRoutes`; legacy browser/flow routes are removed.

## Unresolved questions
- Should screen-feature classification move from heuristics to explicit metadata file for stability?
- Should unknown-route fallback be retained or replaced with strict 404 screen in next batch?
