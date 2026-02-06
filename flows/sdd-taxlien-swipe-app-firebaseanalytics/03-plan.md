# Implementation Plan: Firebase Analytics

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-02-04  
> Specifications: [02-specifications.md](./02-specifications.md)

## Summary

Интеграция Firebase Analytics и Crashlytics: добавление пакетов, создание FirebaseAnalyticsService, RouteObserver для screen tracking, внедрение событий в провайдеры.

## Task Breakdown

### Phase 1: Foundation

#### Task 1.1: Add Firebase packages
- **Description**: firebase_core, firebase_analytics, firebase_crashlytics
- **Files**: `pubspec.yaml`
- **Dependencies**: None
- **Verification**: flutter pub get
- **Complexity**: Low

#### Task 1.2: Firebase project setup
- **Description**: flutterfire configure или ручная настройка google-services.json, GoogleService-Info.plist
- **Files**: android/app/google-services.json, ios/Runner/GoogleService-Info.plist
- **Dependencies**: Task 1.1
- **Verification**: App builds
- **Complexity**: Medium (manual Firebase Console)

#### Task 1.3: Create FirebaseAnalyticsService
- **Description**: Интерфейс и реализация, обёртка над Firebase SDK
- **Files**:
  - `lib/features/analytics/firebase_analytics_service.dart` — Create
- **Dependencies**: Task 1.1
- **Verification**: Unit test with mock
- **Complexity**: Medium

### Phase 2: Initialization

#### Task 2.1: Initialize Firebase in main.dart
- **Description**: Firebase.initializeApp(), optional guard
- **Files**: `lib/main.dart`
- **Dependencies**: Task 1.2
- **Verification**: App starts, no crash
- **Complexity**: Low

#### Task 2.2: Provide FirebaseAnalyticsService
- **Description**: Добавить в Provider tree
- **Files**: `lib/main.dart`
- **Dependencies**: Task 1.3, 2.1
- **Verification**: Provider.of works
- **Complexity**: Low

### Phase 3: Screen Tracking

#### Task 3.1: Add RouteObserver to GoRouter
- **Description**: RouteObserver, передать в navigatorObservers
- **Files**: `lib/core/navigation/app_router.dart`
- **Dependencies**: Task 2.2
- **Verification**: Observer receives route changes
- **Complexity**: Low

#### Task 3.2: Screen-aware mixin and logScreenView
- **Description**: RouteAware mixin для экранов, didPush → logScreenView
- **Files**: Screens in features/swipe, details, onboarding, etc.
- **Dependencies**: Task 3.1, 2.2
- **Verification**: DebugView shows screen_view
- **Complexity**: Medium

### Phase 4: Event Integration

#### Task 4.1: Swipe events
- **Description**: swipe_action, property_liked, property_passed в SwipeProvider
- **Files**: `lib/features/swipe/providers/swipe_provider.dart`
- **Dependencies**: Task 2.2
- **Verification**: Events in DebugView
- **Complexity**: Low

#### Task 4.2: Filter events
- **Description**: filter_changed, foreclosure_filter_toggled
- **Files**: `lib/features/swipe/providers/filter_provider.dart`
- **Dependencies**: Task 2.2
- **Verification**: Events on filter change
- **Complexity**: Low

#### Task 4.3: Details and FVI events
- **Description**: fvi_viewed, share_initiated
- **Files**: `lib/features/details/`
- **Dependencies**: Task 2.2
- **Verification**: Events on actions
- **Complexity**: Low

#### Task 4.4: Annotation events
- **Description**: annotation_created
- **Files**: `lib/features/annotation/screens/annotation_screen.dart`
- **Dependencies**: Task 2.2
- **Verification**: Event on save
- **Complexity**: Low

#### Task 4.5: Onboarding journey events
- **Description**: onboarding_start, mode_selected, role_selected, etc.
- **Files**: `lib/features/onboarding/`
- **Dependencies**: Task 2.2
- **Verification**: Funnel visible in Firebase
- **Complexity**: Medium

#### Task 4.6: User properties
- **Description**: Set user_mode, total_swipes, total_likes, etc.
- **Files**: SwipeProvider, FilterProvider, UserPreferences
- **Dependencies**: Task 2.2
- **Verification**: User properties in Firebase Console
- **Complexity**: Medium

#### Task 4.7: Offline and sync events
- **Description**: offline_mode_entered, sync_completed
- **Files**: `lib/services/sync_manager.dart`
- **Dependencies**: Task 2.2
- **Verification**: Events when offline/sync
- **Complexity**: Low

#### Task 4.8: Crashlytics integration
- **Description**: setCustomKey before crash, FlutterError.onError
- **Files**: `lib/main.dart`
- **Dependencies**: Task 2.1
- **Verification**: Test crash reported with keys
- **Complexity**: Low

### Phase 5: Testing

#### Task 5.1: Unit tests
- **Description**: Tests для FirebaseAnalyticsService
- **Files**: `test/unit_tests/firebase_analytics_test.dart`
- **Dependencies**: Phase 4
- **Verification**: Tests pass
- **Complexity**: Medium

## Dependency Graph

```
1.1 ─┬─→ 1.2 ─→ 2.1 ─→ 2.2 ─┬─→ 3.1 ─→ 3.2
     │                        ├─→ 4.1
     └─→ 1.3 ────────────────┼─→ 4.2
                             ├─→ 4.3
                             ├─→ 4.4
                             ├─→ 4.5
                             ├─→ 4.6
                             ├─→ 4.7
                             └─→ 4.8

4.x ─→ 5.1
```

## File Change Summary

| File | Action |
|------|--------|
| pubspec.yaml | Modify |
| lib/features/analytics/firebase_analytics_service.dart | Create |
| lib/main.dart | Modify |
| lib/core/navigation/app_router.dart | Modify |
| lib/features/swipe/providers/swipe_provider.dart | Modify |
| lib/features/swipe/providers/filter_provider.dart | Modify |
| lib/features/details/ | Modify |
| lib/features/annotation/ | Modify |
| lib/features/onboarding/ | Modify |
| lib/services/sync_manager.dart | Modify |
| android/app/google-services.json | Create (manual) |
| ios/Runner/GoogleService-Info.plist | Create (manual) |

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Config files in git | Med | High | .gitignore, CI secrets |
| Event volume limits | Low | Low | Debounce, batch |

## Rollback Strategy

1. Remove Firebase init — app continues
2. Stub FirebaseAnalyticsService — no-op implementation

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
