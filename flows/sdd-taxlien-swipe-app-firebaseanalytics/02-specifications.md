# Specifications: Firebase Analytics

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-02-04  
> Requirements: [01-requirements.md](./01-requirements.md)

## Overview

Интеграция Firebase Analytics и Crashlytics для Deal Detective обеспечивает продуктовую аналитику, screen tracking, user properties и crash reporting. События следуют Firebase naming conventions (snake_case, < 40 chars) и не содержат PII.

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| `lib/core/navigation/app_router.dart` | Modify | Route observer для screen tracking |
| `lib/features/analytics/` | Create | FirebaseAnalyticsService |
| `lib/features/swipe/` | Modify | Events: swipe_action, filter_changed |
| `lib/features/details/` | Modify | fvi_viewed, property_liked |
| `lib/features/onboarding/` | Modify | Journey events |
| `lib/features/annotation/` | Modify | annotation_created |
| `lib/main.dart` | Modify | Firebase init |
| `android/app/` | Modify | google-services.json |
| `ios/Runner/` | Modify | GoogleService-Info.plist |

## Architecture

### Component Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         DEAL DETECTIVE APP                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  GoRouter (RouteObserver) ──► screen_view (auto)                         │
│                                                                         │
│  SwipeProvider ────────────► FirebaseAnalyticsService ──► Firebase SDK   │
│  FilterProvider ───────────┤                                            │
│  OnboardingProvider ───────┤                                            │
│  DetailsProvider ──────────┤                                            │
│  AnnotationScreen ─────────┘                                            │
│                                                                         │
│  FirebaseCrashlytics ──────► Custom keys (last_screen, last_action)      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Data Flow

```
User Action / Navigation
    │
    ▼
Provider / RouteObserver
    │
    ▼
FirebaseAnalyticsService.logEvent() / setUserProperty()
    │
    ▼
Firebase Analytics / Crashlytics
```

## Interfaces

### FirebaseAnalyticsService

Implements existing `AnalyticsService` interface from `lib/services/analytics_service.dart`. Alternatively, create a dedicated Firebase wrapper and inject where `AnalyticsService` is used.

```dart
// lib/features/analytics/firebase_analytics_service.dart
// Implements: lib/services/analytics_service.dart AnalyticsService

class FirebaseAnalyticsServiceImpl implements AnalyticsService {
  /// Screen tracking (called by RouteObserver)
  Future<void> logScreenView(String screenName, {Map<String, dynamic>? params});
  
  /// User properties (for segmentation)
  Future<void> setUserProperty(String name, String? value);
  
  /// Journey events
  Future<void> logEvent(String name, {Map<String, dynamic>? params});
  
  /// Custom keys for Crashlytics
  void setCrashlyticsKey(String key, String value);
}
// Note: Existing NoOpAnalyticsService in lib/services/analytics_service.dart
// serves as fallback when Firebase is not configured.
```

### Event Names (from requirements)

Screen: `screen_view` (standard) with `firebase_screen`, `firebase_screen_class`

Custom events (snake_case, < 40 chars):
- `swipe_action` — direction, property_id, foreclosure_prob
- `property_liked` — property_id, fvi_score, price
- `property_passed` — property_id, reason
- `annotation_created` — type, expert_role
- `fvi_viewed` — property_id
- `filter_changed` — filter_name, old_value, new_value
- `foreclosure_filter_toggled` — enabled
- `pdf_export` — property_id, success
- `share_initiated` — property_id, share_type
- `deep_link_opened` — link_type, property_id
- `offline_mode_entered` — cached_properties_count
- `sync_completed` — items_synced, duration_ms

## Data Models

### User Properties

| Property | Type | Set When |
|----------|------|----------|
| user_mode | string | Mode change |
| user_role | string | Role selection |
| total_swipes | int | Swipe count update |
| total_likes | int | Like count update |
| total_annotations | int | Annotation count |
| has_exported_pdf | bool | First PDF export |
| foreclosure_filter_user | bool | Filter toggle |
| subscription_status | string | Future |

### Screen Names

| Route | screen_view name |
|-------|------------------|
| / | home_screen |
| /details/:id | property_details |
| /annotate/:id | annotation_canvas |
| /family | family_board |
| /profile | profile |
| onboarding/* | onboarding_{step} |
| filter | filter_screen |

## Behavior Specifications

### Happy Path

1. App starts → Firebase initialized
2. User navigates → RouteObserver → screen_view
3. User swipes → swipe_action, property_liked/property_passed
4. User changes filter → filter_changed
5. User properties updated on relevant actions

### Edge Cases

| Case | Trigger | Expected Behavior |
|------|---------|-------------------|
| Firebase not configured | Missing google-services.json | No-op, no crash |
| Offline | No network | Events queued, sent when online |
| PII in params | Validation | Sanitize or skip |
| Event name too long | > 40 chars | Truncate or split |

### Error Handling

| Error | Cause | Response |
|-------|-------|----------|
| Firebase init fail | Config invalid | Log, continue without analytics |
| Crashlytics exception | SDK bug | Catch, don't crash |

## Dependencies

### Pubspec
- `firebase_core`: ^3.8.1
- `firebase_analytics`: ^11.3.6
- `firebase_crashlytics`: ^4.1.4

### Requires
- Firebase project
- google-services.json (Android)
- GoogleService-Info.plist (iOS)
- flutterfire configure (or manual)

## Integration Points

### GoRouter RouteObserver

```dart
// In app_router.dart
final routeObserver = RouteObserver<ModalRoute<void>>();

// Wrap navigator with RouteObserver
Observer(
  navigatorObservers: [routeObserver],
  ...
)

// In screens: RouteAware mixin, didPush → logScreenView
```

### Call Sites

| Event | Location |
|-------|----------|
| screen_view | RouteObserver in each Screen |
| swipe_action | SwipeProvider.like/pass |
| property_liked | SwipeProvider.like |
| property_passed | SwipeProvider.pass |
| filter_changed | FilterProvider |
| foreclosure_filter_toggled | FilterProvider |
| annotation_created | AnnotationScreen save |
| fvi_viewed | DetailsScreen FVI tap |
| offline_mode_entered | SyncManager |
| sync_completed | SyncManager |
| deep_link_opened | DeepLinkService |

## Testing Strategy

### Unit Tests
- [ ] FirebaseAnalyticsService — no-op when disabled
- [ ] Event names validation (length, format)
- [ ] User property updates

### Integration Tests
- [ ] Mock Firebase, verify events logged

### Manual Verification
- [ ] Firebase DebugView shows events
- [ ] Crashlytics receives test crash

## Migration / Rollout

- Firebase optional: check if configured before init
- Can ship with stub implementation (no-op) until config ready

## Open Design Questions

- [ ] Debug view during development?
- [ ] BigQuery export for advanced analytics?

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
