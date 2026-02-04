# Requirements: Firebase Analytics

**Version:** 1.0
**Status:** DRAFT
**Last Updated:** 2026-02-03

---

## Problem Statement

Deal Detective нуждается в продуктовой аналитике для:
1. **User Behavior** - понимание как пользователи используют приложение
2. **Funnel Analysis** - выявление bottlenecks в user journey
3. **Feature Adoption** - измерение использования новых фич
4. **Crash Correlation** - связь crashes с user actions

---

## User Stories

### US-1: Screen Tracking

**As a** продуктовый менеджер
**I want** видеть какие экраны посещают пользователи
**So that** я понимаю user flow

**Screens to Track:**
| Screen | Name | Parameters |
|--------|------|------------|
| Home (Swipe) | `home_screen` | mode (beginner/expert) |
| Property Details | `property_details` | property_id |
| Annotation Canvas | `annotation_canvas` | property_id |
| Family Board | `family_board` | - |
| Onboarding | `onboarding_{step}` | step_number |
| Settings | `settings` | - |
| Filter | `filter_screen` | - |
| Profile | `profile` | - |

**Acceptance Criteria:**
- [ ] Все экраны логируются автоматически через GoRouter observer
- [ ] Screen time tracked для каждого экрана
- [ ] Parameters передаются корректно

---

### US-2: User Journey Events

**As a** продуктовый аналитик
**I want** понимать полный user journey
**So that** могу оптимизировать конверсию

**Journey Events:**
```
Onboarding Funnel:
onboarding_start → mode_selected → role_selected (expert) → geography_selected →
tutorial_step_1 → tutorial_step_2 → [tutorial_step_3] → onboarding_complete

Discovery Funnel:
search_started → filter_applied → card_viewed → card_swiped →
details_opened → annotation_added → pdf_exported → bid_started

Engagement Funnel:
app_open → session_start → first_swipe → tenth_swipe →
first_like → first_annotation → first_share
```

**Acceptance Criteria:**
- [ ] Все funnel events логируются
- [ ] User properties обновляются (total_likes, total_annotations)
- [ ] Session tracking работает корректно

---

### US-3: User Properties

**As a** аналитик
**I want** сегментировать пользователей по поведению
**So that** могу анализировать cohorts

**User Properties:**
| Property | Type | Description |
|----------|------|-------------|
| `user_mode` | string | beginner / expert |
| `user_role` | string | builder / furniture / investor / etc |
| `preferred_states` | string[] | ["AZ", "SD"] |
| `total_swipes` | int | Lifetime swipes |
| `total_likes` | int | Lifetime likes |
| `total_annotations` | int | Lifetime annotations |
| `has_exported_pdf` | bool | Ever exported PDF |
| `foreclosure_filter_user` | bool | Uses foreclosure filter |
| `subscription_status` | string | free / premium (future) |

**Acceptance Criteria:**
- [ ] User properties устанавливаются корректно
- [ ] Properties обновляются при изменении поведения
- [ ] Properties доступны для сегментации в Firebase Console

---

### US-4: Custom Events for Deal Detective

**As a** продуктовый менеджер
**I want** отслеживать Deal Detective-специфичные действия
**So that** измеряю успех фич

**Custom Events:**
| Event | Trigger | Parameters |
|-------|---------|------------|
| `swipe_action` | Any swipe | direction, property_id, foreclosure_prob |
| `property_liked` | Swipe right | property_id, fvi_score, price |
| `property_passed` | Swipe left | property_id, reason (if provided) |
| `annotation_created` | New annotation | type (point/line/area), expert_role |
| `fvi_viewed` | FVI breakdown opened | property_id |
| `filter_changed` | Filter updated | filter_name, old_value, new_value |
| `foreclosure_filter_toggled` | Toggle foreclosure filter | enabled |
| `pdf_export` | PDF generated | property_id, success |
| `share_initiated` | Share button pressed | property_id, share_type |
| `deep_link_opened` | Opened via deep link | link_type, property_id |
| `offline_mode_entered` | Lost connection | cached_properties_count |
| `sync_completed` | Data synced | items_synced, duration_ms |

**Acceptance Criteria:**
- [ ] Events следуют Firebase naming conventions (snake_case, < 40 chars)
- [ ] Parameters не содержат PII
- [ ] Events не дублируются (debounce где нужно)

---

### US-5: Engagement Metrics

**As a** growth manager
**I want** измерять engagement
**So that** понимаю retention и stickiness

**Metrics:**
- **DAU/MAU** - Daily/Monthly Active Users
- **Session Duration** - Среднее время в приложении
- **Sessions per User** - Частота возвратов
- **Swipes per Session** - Активность за сессию
- **Likes per Session** - Конверсия свайпов в лайки

**Acceptance Criteria:**
- [ ] Firebase автоматически считает DAU/MAU
- [ ] Custom metrics вычисляются через events
- [ ] Dashboard настроен в Firebase Console

---

### US-6: Error & Performance Tracking

**As a** разработчик
**I want** связывать crashes с user actions
**So that** могу воспроизводить и фиксить баги

**Acceptance Criteria:**
- [ ] Firebase Crashlytics интегрирован
- [ ] Custom keys добавляются (last_screen, last_action)
- [ ] Non-fatal errors логируются

---

## Technical Constraints

- **Package:** `firebase_analytics` + `firebase_crashlytics`
- **Minimum iOS:** 12.0
- **Minimum Android:** API 21
- **Data Retention:** 14 months (Firebase default)

---

## Dependencies

### Configuration Sources

**Firebase Config Files:**
```
LOCAL DEVELOPMENT:
├── android/app/google-services.json     # НЕ в git! (в .gitignore)
├── ios/Runner/GoogleService-Info.plist  # НЕ в git! (в .gitignore)
│
CI/CD (GitHub Actions):
├── GitHub Secrets (base64 encoded)
│   ├── GOOGLE_SERVICES_JSON_BASE64
│   └── GOOGLE_SERVICE_INFO_PLIST_BASE64
│
BUILD WORKFLOW:
├── echo $GOOGLE_SERVICES_JSON_BASE64 | base64 -d > android/app/google-services.json
└── echo $GOOGLE_SERVICE_INFO_PLIST_BASE64 | base64 -d > ios/Runner/GoogleService-Info.plist
```

**Alternative: .env approach for Firebase App ID:**
```
.env:
├── FIREBASE_ANDROID_APP_ID=1:123456789:android:abc123
├── FIREBASE_IOS_APP_ID=1:123456789:ios:abc123
├── FIREBASE_PROJECT_ID=taxlien-app
└── FIREBASE_MEASUREMENT_ID=G-XXXXXXXXXX

GitHub Secrets:
├── Same variables as above
```

**Usage in Code:**
```dart
// Firebase инициализируется автоматически из config files
// Но для runtime checks:

class EnvConfig {
  static const firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: '',
  );

  static bool get isFirebaseEnabled => firebaseProjectId.isNotEmpty;
}
```

### Required Files

- `google-services.json` (Android) - from Firebase Console
- `GoogleService-Info.plist` (iOS) - from Firebase Console
- Firebase Console access для team members

---

## Out of Scope (This Iteration)

- Firebase Remote Config (отдельный flow)
- Firebase A/B Testing
- BigQuery export
- Custom dashboards в Looker/DataStudio

---

## Open Questions

- [ ] Нужен ли debug view во время разработки?
- [ ] Какой retention period для events?
- [ ] Нужна ли интеграция с BigQuery для advanced analytics?

---

## References

- [Firebase Analytics for Flutter](https://pub.dev/packages/firebase_analytics)
- [Firebase Crashlytics for Flutter](https://pub.dev/packages/firebase_crashlytics)
- `sdd-taxlien-swipe-app-facebookappevents` - companion marketing analytics

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
