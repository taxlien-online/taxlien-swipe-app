# Implementation Log: Firebase Analytics

> Started: 2026-02-04
> Plan: [03-plan.md](./03-plan.md)

## Progress Tracker

| Task | Status | Notes |
|------|--------|-------|
| 1.1 Add Firebase packages | ✅ Done | firebase_core, firebase_analytics, firebase_crashlytics in pubspec.yaml |
| 1.2 Firebase project setup | ⏳ Manual | google-services.json, GoogleService-Info.plist (developer) |
| 1.3 Create FirebaseAnalyticsService | ✅ Done | lib/features/analytics/firebase_analytics_service.dart |
| 2.1 Initialize Firebase in main | ✅ Done | try/catch, no crash if config missing |
| 2.2 Provide FirebaseAnalyticsService | ✅ Done | Firebase when configured, NoOp otherwise |
| 3.1 Add RouteObserver to GoRouter | ✅ Done | createRouter(observers), AnalyticsRouteObserver |
| 3.2 Screen tracking | ✅ Done | Observer logs screen_view + Crashlytics last_screen |
| 4.1 Swipe events | ✅ Done | swipe_action, property_liked, property_passed in SwipeProvider |
| 4.2 Filter events | ✅ Done | filter_changed, foreclosure_filter_toggled in FilterProvider |
| 4.3 Details / FVI events | ⏳ Deferred | fvi_viewed, share_initiated |
| 4.4 Annotation events | ⏳ Deferred | annotation_created |
| 4.5 Onboarding events | ✅ Done | Already in welcome/mode/ready screens |
| 4.6 User properties | ⏳ Deferred | user_mode, total_swipes, etc. |
| 4.7 Offline/sync events | ✅ Done | offline_mode_entered, sync_completed in SyncManager |
| 4.8 Crashlytics | ✅ Done | FlutterError.onError → recordFlutterFatalError; setCrashlyticsKey(last_screen) |
| 5.1 Unit tests | ⏳ Deferred | FirebaseAnalyticsService tests |

## Session 2026-02-04

- **Packages**: firebase_core, firebase_analytics, firebase_crashlytics added (firebase_core/auth already present for OAuth).
- **FirebaseAnalyticsServiceImpl**: Implements AnalyticsService; logScreenView, logEvent, setUserProperty; setCrashlyticsKey; param sanitization (length, types).
- **main.dart**: Firebase.initializeApp() in try/catch; analytics = Firebase.apps.isEmpty ? NoOpAnalyticsService : FirebaseAnalyticsServiceImpl; router = AppRouter.createRouter(observers: [AnalyticsRouteObserver(analytics)]); SyncManager(analytics: analytics); FlutterError.onError → Crashlytics when Firebase configured.
- **AppRouter**: Refactored to createRouter(observers); static _router set by createRouter; MyApp(router: router).
- **AnalyticsRouteObserver**: NavigatorObserver; didPush → logScreenView(mapped name), setCrashlyticsKey(last_screen) for Firebase impl; route name → screen_view map (home → home_screen, details → property_details, etc.).
- **SwipeProvider**: Optional AnalyticsService; handleLike/handlePass log swipe_action, property_liked/property_passed with property_id, foreclosure_prob, fvi_score, tax_amount where available.
- **FilterProvider**: Optional AnalyticsService; setFilter logs filter_changed; logForeclosureFilterToggled(enabled).
- **SyncManager**: Optional AnalyticsService; offline_mode_entered (cached_properties_count) when connectivity none; sync_completed (duration_ms) after syncQueuedActions.

## Manual Steps (1.2)

- Create/use Firebase project in Firebase Console.
- Add Android app → download `google-services.json` → `android/app/google-services.json`.
- Add iOS app → download `GoogleService-Info.plist` → `ios/Runner/GoogleService-Info.plist`.
- Or run `flutterfire configure` when available.

## Completion Checklist

- [x] Firebase packages and FirebaseAnalyticsService
- [x] Optional init and provider wiring
- [x] Screen tracking via GoRouter observer
- [x] Swipe and filter events
- [x] Sync/offline and Crashlytics
- [ ] Firebase config files (manual)
- [ ] Details/annotation events and user properties (deferred)
- [ ] Unit tests (deferred)
