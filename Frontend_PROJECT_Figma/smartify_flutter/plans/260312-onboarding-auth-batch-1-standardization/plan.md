---
title: "Batch 1 Onboarding/Auth plan standardization"
description: "Chuẩn hoá phạm vi, thứ tự chỉnh file, rủi ro tích hợp, và verify tối thiểu cho Onboarding/Auth Flutter Batch 1."
status: in_progress
priority: P1
effort: 3h
branch: n/a
tags: [flutter, onboarding-auth, planning, batch-1]
created: 2026-03-12
---

# Plan Overview

## Goal
Chuẩn hoá kế hoạch triển khai Batch 1 Onboarding/Auth theo codebase hiện tại, không thêm scope ngoài MVP prototype, không viết code ở plan này.

## Constraints
- YAGNI/KISS/DRY: chỉ chạm file cần thiết cho flow onboarding/auth.
- Không backend thật, không dark mode, không auth thật.
- Giữ kiến trúc hiện tại: `provider` + `ChangeNotifier` + metadata-driven PNG flow.

## Ordered file change list (implementation order)
1. `D:/Frontend_PROJECT_Figma/smartify_flutter/lib/features/onboarding-auth/presentation/screens/onboarding_auth_flow_screen.dart`
   - Chuẩn hoá entry screen của feature (title/feature key/UX copy).
2. `D:/Frontend_PROJECT_Figma/smartify_flutter/lib/app/router/app_router.dart`
   - Xác nhận route contract `/features/onboarding-auth` ổn định, không xung đột unknown-route fallback.
3. `D:/Frontend_PROJECT_Figma/smartify_flutter/lib/features/home/presentation/screens/home_screen.dart`
   - Chuẩn hoá điểm vào từ Home -> Onboarding/Auth, đồng bộ active feature key.
4. `D:/Frontend_PROJECT_Figma/smartify_flutter/lib/features/prototype_viewer/utils/asset_name_parser.dart`
   - Chuẩn hoá rule phân loại asset về `onboarding-auth` (walkthrough/sign/otp/password/splash/welcome...).
5. `D:/Frontend_PROJECT_Figma/smartify_flutter/lib/features/screen-mapping/screen_manifest.dart`
   - Verify filter `byFeature('onboarding-auth')` và load/error handling cho list màn.
6. `D:/Frontend_PROJECT_Figma/smartify_flutter/lib/shared/widgets/feature_flow_screen.dart`
   - Chuẩn hoá list/grid/search behavior dùng chung cho onboarding/auth browsing.
7. `D:/Frontend_PROJECT_Figma/smartify_flutter/lib/core/state/mock_auth_store.dart`
   - Chuẩn hoá mock auth state transition tối thiểu cho Batch 1 (signedOut/signingIn/signedIn contract).
8. `D:/Frontend_PROJECT_Figma/smartify_flutter/lib/core/state/app_flow_store.dart`
   - Giữ active feature key nhất quán khi điều hướng onboarding/auth.
9. `D:/Frontend_PROJECT_Figma/smartify_flutter/lib/app/app.dart`
   - Kiểm tra provider wiring cho các store dùng trong onboarding/auth flow.
10. `D:/Frontend_PROJECT_Figma/smartify_flutter/test/widget_test.dart`
   - Smoke test boot + entry onboarding/auth.
11. `D:/Frontend_PROJECT_Figma/smartify_flutter/test/prototype_screen_registry_test.dart`
   - Verify registry vẫn map route/asset hợp lệ sau chuẩn hoá feature classification.

## Integration risks with current code
1. Feature-key drift
   - Risk: key không thống nhất (`onboarding-auth` vs biến thể khác) làm lọc màn rỗng.
   - Impact: vào flow nhưng không thấy screen.
2. Asset classification over/under-match
   - Risk: rule `asset_name_parser` bắt nhầm màn khác vào onboarding-auth hoặc bỏ sót màn auth.
   - Impact: thứ tự/nhóm màn sai, điều hướng review sai.
3. Router fallback masking bug
   - Risk: route typo vẫn “chạy” do fallback unknown route, che lỗi mapping.
   - Impact: khó phát hiện regression route.
4. Store contract mismatch
   - Risk: UI giả định trạng thái auth nhưng store chỉ có transition tối giản.
   - Impact: UI state không đồng bộ, test flaky.
5. Shared widget side effects
   - Risk: chỉnh `FeatureFlowScreen` cho onboarding/auth làm ảnh hưởng home-devices/smart-scenes/reports/account-settings.
   - Impact: regression chéo nhiều feature.
6. Asset load timing
   - Risk: `ScreenManifestStore.load()` async + truy cập sớm trong build.
   - Impact: loading/error state xuất hiện sai thời điểm.

## Minimum verify checklist
- [ ] `flutter analyze` pass, không syntax/compile error.
- [ ] `flutter test` pass toàn bộ test hiện có.
- [ ] Boot app vào Home thành công, không crash.
- [ ] Từ Home vào được `Onboarding / Auth` bằng cả button và list entry.
- [ ] Danh sách màn onboarding/auth hiển thị > 0 item khi assets có dữ liệu.
- [ ] Search trong flow onboarding/auth lọc đúng theo id/label.
- [ ] Tap item mở đúng route `/screen/{id}` và render đúng PNG.
- [ ] Prev/Next trong prototype screen không crash ở biên đầu/cuối.
- [ ] Unknown route không được dùng để “che” lỗi route onboarding/auth.
- [ ] Các flow khác (home-devices, smart-scenes, reports, account-settings) vẫn mở được sau thay đổi.

## Out of scope
- Auth API thật, token, secure storage.
- Form validation chi tiết production-level.
- Telemetry/analytics.

## Sync-back status (2026-03-12)

### Implementation progress snapshot
- Done (code hiện diện, theo đúng ordered list):
  - `onboarding_auth_flow_screen.dart`
  - `app_router.dart`
  - `home_screen.dart`
  - `asset_name_parser.dart`
  - `screen_manifest.dart`
  - `feature_flow_screen.dart`
  - `app_flow_store.dart`
  - `app.dart`
  - `test/prototype_screen_registry_test.dart`
- Partial:
  - `mock_auth_store.dart`: có `signedOut`/`signedIn`, enum có `signingIn` nhưng chưa có transition method riêng cho `signingIn`.
- Pending verify runtime/test (chưa chạy lệnh verify trong sync-back này):
  - `test/widget_test.dart` chưa assert riêng entry `Onboarding / Auth`.
  - Checklist `flutter analyze`/`flutter test`/runtime navigation vẫn cần run và chốt.

### Completion estimate
- Tiến độ implement theo scope plan: ~85%
- Tiến độ verify checklist: ~30%

## Unresolved questions
- Có chốt danh sách keyword chuẩn cho phân loại onboarding/auth assets chưa (để tránh bắt nhầm)?
- Batch 1 có yêu cầu state `signingIn` thật (loading UI) hay chỉ signedOut/signedIn là đủ?
- Có cần thêm test riêng cho route contract onboarding/auth ngoài smoke test hiện tại?
