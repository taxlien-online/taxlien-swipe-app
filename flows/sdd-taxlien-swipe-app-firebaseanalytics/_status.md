# Status: sdd-taxlien-swipe-app-firebaseanalytics

## Current Phase

REQUIREMENTS | SPECIFICATIONS | PLAN | **IMPLEMENTATION**

## Phase Status

DRAFTING | REVIEW | APPROVED | **IN PROGRESS**

## Last Updated

2026-02-04 by Claude

## Blockers

- None

## Progress

- [x] Requirements drafted
- [x] Analytics abstraction: AnalyticsService + NoOpAnalyticsService
- [x] Onboarding events: onboarding_start, mode_selected, onboarding_skipped, onboarding_complete
- [x] Firebase SDK: firebase_core, firebase_analytics, firebase_crashlytics in pubspec
- [x] FirebaseAnalyticsServiceImpl + optional init in main (no crash without config)
- [x] Screen view observer via GoRouter (AnalyticsRouteObserver, createRouter(observers))
- [x] Swipe events: swipe_action, property_liked, property_passed (SwipeProvider)
- [x] Filter events: filter_changed, foreclosure_filter_toggled (FilterProvider)
- [x] Sync/offline: offline_mode_entered, sync_completed (SyncManager)
- [x] Crashlytics: FlutterError.onError, setCrashlyticsKey(last_screen)
- [ ] Firebase config files (manual: google-services.json, GoogleService-Info.plist)
- [ ] Deferred: details/FVI, annotation events, user properties, unit tests

## Context Notes

- App runs without Firebase when config files absent (NoOpAnalyticsService).
- Router created in main with AppRouter.createRouter(observers: [AnalyticsRouteObserver(analytics)]).
- Implementation log: [04-implementation-log.md](./04-implementation-log.md).

## References

- `sdd-taxlien-swipe-app` - Main app architecture
- `sdd-taxlien-swipe-app-facebookappevents` - Companion marketing analytics flow

## Next Actions

1. Add google-services.json / GoogleService-Info.plist for real Firebase (or use flutterfire configure)
2. Optionally add fvi_viewed, share_initiated, annotation_created, user properties
3. Add unit tests for FirebaseAnalyticsService
