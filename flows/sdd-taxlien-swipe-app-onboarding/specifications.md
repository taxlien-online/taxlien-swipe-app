# Specifications: Swipe App Onboarding

**Version:** 1.0
**Status:** REVIEW
**Last Updated:** 2026-02-02
**Requirements:** [01-requirements.md](./01-requirements.md)

---

## Overview

Онбординг для Deal Detective приложения. Собирает настройки пользователя (режим, роль, география) и обучает базовым жестам через интерактивный tutorial.

---

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| `lib/features/onboarding/` | Create | Новый feature module |
| `lib/core/models/user_preferences.dart` | Modify | Добавить поля geography |
| `lib/core/navigation/app_router.dart` | Modify | Добавить onboarding routes |
| `lib/services/` | Create | OnboardingService, GeolocationService |

---

## Architecture

### Navigation Flow
```
/onboarding/welcome
    │
    ├── [Skip] ──────────────────────────────────────┐
    │                                                │
    ↓                                                │
/onboarding/mode-selection                           │
    │                                                │
    ├── [Beginner] ───────────────────┐              │
    │                                 │              │
    ├── [Expert] ──→ /onboarding/role │              │
    │                    │            │              │
    │                    ↓            │              │
    │              /onboarding/geo ←──┘              │
    │                    │                           │
    │                    ↓                           │
    │              /onboarding/county (optional)     │
    │                    │                           │
    │                    ↓                           │
    │              /onboarding/tutorial              │
    │                    │                           │
    │                    ↓                           │
    │              /onboarding/auth (optional) ← NEW │
    │                    │                           │
    │                    ↓                           │
    └──────────────→ /onboarding/ready              │
                         │                           │
                         ↓                           │
                    / (home) ←───────────────────────┘

NOTE: /onboarding/auth is OAuth screen for Google/Facebook sign-in.
      Can be skipped. See sdd-taxlien-swipe-app-oauth for details.
```

### Component Architecture
```
lib/features/onboarding/
├── screens/
│   ├── welcome_screen.dart
│   ├── mode_selection_screen.dart
│   ├── role_selection_screen.dart
│   ├── geography_screen.dart
│   ├── county_selection_screen.dart
│   ├── tutorial_screen.dart
│   ├── auth_screen.dart            # NEW - OAuth (Google/Facebook)
│   └── ready_screen.dart
├── widgets/
│   ├── mode_card.dart              # Animated mode preview
│   ├── role_card.dart              # Expert role card
│   ├── state_chip.dart             # Geography state selector
│   ├── county_tile.dart            # County with lien count
│   ├── tutorial_card.dart          # Demo swipe card
│   ├── swipe_hint_overlay.dart     # Arrow/hand animation
│   └── skip_button.dart            # Consistent skip UI
├── providers/
│   └── onboarding_provider.dart    # State management
└── services/
    └── onboarding_service.dart     # Business logic
```

---

## Data Models

### UserPreferences (Extended)
```dart
enum SwipeMode { beginner, advanced }

enum UserRole {
  builder,     // Khun Pho - строительство
  furniture,   // Denis - мебель/реставрация
  autoScience, // Anton - авто/наука
  investor,    // Shon - ROI/риски
  family,      // Miw - район/школы
  universal,   // Без специализации
}

class UserPreferences {
  final SwipeMode swipeMode;
  final UserRole? role;                    // null for Beginner
  final List<String> states;               // ['AZ', 'FL'] or empty = везде
  final List<String> counties;             // ['Maricopa', 'Pinal'] or empty = весь штат
  final bool onboardingCompleted;
  final DateTime? onboardingCompletedAt;

  // Defaults for Skip
  static UserPreferences defaults() => UserPreferences(
    swipeMode: SwipeMode.beginner,
    role: null,
    states: [],                            // везде
    counties: [],
    onboardingCompleted: true,
    onboardingCompletedAt: DateTime.now(),
  );
}
```

### OnboardingState
```dart
class OnboardingState {
  final int currentStep;                   // 0-5
  final SwipeMode? selectedMode;
  final UserRole? selectedRole;
  final List<String> selectedStates;
  final List<String> selectedCounties;
  final int tutorialProgress;              // 0, 1, 2 (or 3 for Expert)
  final bool canProceed;                   // Validation state
}
```

### StateInfo (from API)
```dart
class StateInfo {
  final String code;                       // 'AZ'
  final String name;                       // 'Arizona'
  final String type;                       // 'Tax Lien' or 'Tax Deed'
  final double interestRate;               // 16.0
  final String? nextAuction;               // 'Feb 2026'
  final int totalLiens;
  final int foreclosureCandidates;
}
```

### CountyInfo (from API)
```dart
class CountyInfo {
  final String name;                       // 'Maricopa'
  final String stateCode;                  // 'AZ'
  final String? majorCity;                 // 'Phoenix'
  final int lienCount;
  final int foreclosureCount;
}
```

---

## Screen Specifications

### 1. Welcome Screen

**Route:** `/onboarding/welcome`

**UI Elements:**
- App logo + title "DEAL DETECTIVE"
- Tagline: "Найдите foreclosure properties по лучшей цене"
- Primary CTA: "Начать настройку"
- Secondary CTA: "Я уже знаю как свайпать" → Skip
- Skip button (top-right): "Пропустить →"

**Behavior:**
- First screen shown to new users
- Check `UserPreferences.onboardingCompleted` → if true, skip to home
- "Начать настройку" → navigate to mode selection
- Any skip action → set defaults, navigate to home

---

### 2. Mode Selection Screen

**Route:** `/onboarding/mode-selection`

**UI Elements:**
- Header: "Как хотите искать?"
- Two large cards:
  - **ПРОСТОЙ**: Animated horizontal swipe preview
  - **ЭКСПЕРТ**: Animated 4-way navigation preview
- Skip button (top-right)
- Back button (top-left)

**Animations:**
```dart
// Beginner card animation
AnimationController _beginnerAnim;
// Show card moving left/right with thumbs down/up icons

// Expert card animation
AnimationController _expertAnim;
// Show card with 4 arrows, peeking edges for Context/Details
```

**Behavior:**
- Tap on card → select mode, proceed to next screen
- Beginner → skip Role Selection, go to Geography
- Expert → go to Role Selection
- Auto-play animations on loop

---

### 3. Role Selection Screen (Expert Only)

**Route:** `/onboarding/role`

**UI Elements:**
- Header: "Ваша специализация?"
- Subheader: "(AI адаптирует фокус под ваш профиль)"
- Grid of 6 role cards (2x3):
  - 👷 Строитель - структура, крыша
  - 🛋️ Мебель - интерьер, антиквариат
  - 🚗 Авто/Наука - гараж, история
  - 💰 Инвестор - ROI, риски, foreclosure
  - 🏠 Для семьи - район, школы
- Bottom option: "Универсальный профиль"
- Skip button, Back button

**Behavior:**
- Tap on role → select, proceed to Geography
- "Универсальный" → role = null, proceed
- Skip → role = null, proceed to Geography

---

### 4. Geography Screen

**Route:** `/onboarding/geo`

**UI Elements:**
- Header: "Где искать properties?"
- Section 1: Auto-detected (if geolocation available)
  ```
  📍 Рядом с вами
  ✓ Arizona (Tax Lien, 16%, Feb auction)
  ○ Utah (Tax Deed, May auction)
  ○ Nevada (Tax Deed)
  ```
- Section 2: Search field
  ```
  🔍 Поиск штата или county...
  ```
- Section 3: Popular quick-select chips
  ```
  [ Arizona ] [ Florida ] [ Texas ] [ South Dakota ]
  ```
- Section 4: Search everywhere option
  ```
  🌎 Искать везде
  (система сама ранжирует по foreclosure)
  ```
- Primary CTA: "Продолжить"
- Skip button, Back button

**Data Source: Local Mock Data (NO Gateway API)**
```dart
// States и counties загружаются из локальных mock данных
// OnboardingService._mockStates и _mockCounties
// Gateway API НЕ используется в onboarding

// При появлении реального API - можно включить через:
// OnboardingService._useApi = true (currently false)
```

**Behavior:**
- Multi-select states (checkboxes)
- "Искать везде" → clear all selections, states = []
- If state selected → offer County selection (optional)
- If "везде" → skip County, go to Tutorial

---

### 5. County Selection Screen (Optional)

**Route:** `/onboarding/county?state={stateCode}`

**UI Elements:**
- Header: "{State Name}"
- Subheader: "Какие counties интересуют?"
- Option: "Весь штат {State}" (default selected)
- Grid of county cards with:
  - County name
  - Major city
  - Lien count
- Primary CTA: "Продолжить"
- Skip button, Back button

**Data Source: Local Mock Data (NO Gateway API)**
```dart
// Counties загружаются из OnboardingService._mockCounties[stateCode]
// Gateway API НЕ используется
```

**Behavior:**
- "Весь штат" selected by default
- Selecting specific counties → unselect "Весь штат"
- Multi-select counties
- Proceed → go to Tutorial

---

### 6. Tutorial Screen

**Route:** `/onboarding/tutorial`

**UI Elements:**
- Header: "Попробуйте! (1/2)" or "(1/3)"
- Instruction text (changes per step)
- Demo card with property data
- Visual hint overlay (animated arrow/hand)
- Progress dots
- Skip button

**Tutorial Steps - Beginner:**
| Step | Instruction | Action Required | Hint |
|------|-------------|-----------------|------|
| 1 | "Свайпните ВПРАВО на интересное" | Swipe right | → 👍 |
| 2 | "Свайпните ВЛЕВО чтобы пропустить" | Swipe left | 👎 ← |

**Tutorial Steps - Expert:**
| Step | Instruction | Action Required | Hint |
|------|-------------|-----------------|------|
| 1 | "Свайпните ВПРАВО для деталей" | Swipe right | → Details |
| 2 | "Свайпните ВЛЕВО для контекста" | Swipe left | Context ← |
| 3 | "Долгое нажатие для разметки" | Long press | 👆 hold |

**Demo Cards:**
```dart
final demoCards = [
  PropertyCard(
    image: 'assets/demo/property_1.jpg',
    location: 'Phoenix, AZ',
    foreclosureProbability: 0.85,
    lienAmount: 320,
  ),
  PropertyCard(
    image: 'assets/demo/property_2.jpg',
    location: 'Remote Location, AZ',
    foreclosureProbability: 0.20,
    lienAmount: 4500,
  ),
  // ... more demo cards
];
```

**Behavior:**
- Block proceed until gesture completed (or skip)
- Show success animation on correct gesture
- Auto-advance to next step
- After last step → Ready screen

---

### 7. Ready Screen

**Route:** `/onboarding/ready`

**UI Elements:**
- Success icon: ✅
- Header: "Готово к поиску!"
- Summary card:
  ```
  📍 Регион:    Arizona
  🎯 Counties:  Maricopa, Pinal
  📊 Доступно:  15,650 properties
  🔥 Foreclosures: 2,340
  ```
- Tip: "💡 Совет: Тапните на карточку чтобы увидеть детали"
- Primary CTA: "🔍 Начать поиск"

**Data Source: Local Mock Stats (NO Gateway API)**
```dart
// Statistics вычисляются из mock данных
// OnboardingService.getStats() суммирует mock counties/states
// Gateway API НЕ используется
```

**Behavior:**
- Save all preferences to local storage
- Set `onboardingCompleted = true`
- "Начать поиск" → navigate to home, clear navigation stack

---

## Services

### OnboardingService
```dart
class OnboardingService {
  final UserPreferencesRepository _prefsRepo;
  final GatewayApi _api;

  // Check if should show onboarding
  Future<bool> shouldShowOnboarding();

  // Save partial progress (for resume)
  Future<void> saveProgress(OnboardingState state);

  // Complete onboarding with final preferences
  Future<void> completeOnboarding(UserPreferences prefs);

  // Skip with defaults
  Future<void> skipOnboarding();

  // Fetch state/county data
  Future<List<StateInfo>> getStates();
  Future<List<StateInfo>> getNearbyStates(double lat, double lng);
  Future<List<CountyInfo>> getCounties(String stateCode);
  Future<GeoStats> getStats(List<String> states, List<String> counties);
}
```

### GeolocationService
```dart
class GeolocationService {
  // Request permission and get location
  Future<Position?> getCurrentPosition();

  // Check if permission granted
  Future<bool> hasPermission();
}
```

---

## GoRouter Configuration

```dart
final onboardingRoutes = [
  GoRoute(
    path: '/onboarding/welcome',
    name: 'onboarding_welcome',
    builder: (context, state) => const WelcomeScreen(),
  ),
  GoRoute(
    path: '/onboarding/mode',
    name: 'onboarding_mode',
    builder: (context, state) => const ModeSelectionScreen(),
  ),
  GoRoute(
    path: '/onboarding/role',
    name: 'onboarding_role',
    builder: (context, state) => const RoleSelectionScreen(),
  ),
  GoRoute(
    path: '/onboarding/geo',
    name: 'onboarding_geo',
    builder: (context, state) => const GeographyScreen(),
  ),
  GoRoute(
    path: '/onboarding/county',
    name: 'onboarding_county',
    builder: (context, state) {
      final stateCode = state.uri.queryParameters['state'];
      return CountySelectionScreen(stateCode: stateCode!);
    },
  ),
  GoRoute(
    path: '/onboarding/tutorial',
    name: 'onboarding_tutorial',
    builder: (context, state) => const TutorialScreen(),
  ),
  GoRoute(
    path: '/onboarding/auth',
    name: 'onboarding_auth',
    builder: (context, state) => const AuthScreen(),
  ),
  GoRoute(
    path: '/onboarding/ready',
    name: 'onboarding_ready',
    builder: (context, state) => const ReadyScreen(),
  ),
];

// Redirect logic in main router
redirect: (context, state) {
  final prefs = ref.read(userPreferencesProvider);
  final isOnboarding = state.matchedLocation.startsWith('/onboarding');

  if (!prefs.onboardingCompleted && !isOnboarding) {
    return '/onboarding/welcome';
  }
  if (prefs.onboardingCompleted && isOnboarding) {
    return '/';
  }
  return null;
},
```

---

## Testing Strategy

### Unit Tests
- [ ] `OnboardingService` - all methods
- [ ] `UserPreferences.defaults()` - correct values
- [ ] State transitions in `OnboardingProvider`

### Widget Tests
- [ ] Each screen renders correctly
- [ ] Skip button navigates to home
- [ ] Mode selection updates state
- [ ] Tutorial gesture detection

### Integration Tests
- [ ] Full Beginner flow (Welcome → Ready)
- [ ] Full Expert flow (Welcome → Role → Ready)
- [ ] Skip flow (Welcome → Home)
- [ ] Persistence after app restart

---

## Error Handling

| Error | Cause | Response |
|-------|-------|----------|
| Geolocation denied | User rejected permission | Show manual state selection only |
| API unavailable | Network error | Use cached state list, show offline notice |
| Invalid state | State not supported | Show error, suggest "Искать везде" |

---

## Analytics Events (REQUIRED)

**Onboarding Funnel Events:**
| Event | Screen | Parameters | When |
|-------|--------|------------|------|
| `onboarding_start` | Welcome | - | При показе welcome screen |
| `onboarding_skip` | Any | `from_screen` | При нажатии Skip |
| `mode_selected` | Mode Selection | `mode: beginner/expert` | При выборе режима |
| `role_selected` | Role Selection | `role: builder/furniture/...` | При выборе роли (Expert) |
| `geography_selected` | Geography | `states: [], search_everywhere: bool` | При продолжении |
| `county_selected` | County | `state, counties: [], whole_state: bool` | При продолжении |
| `tutorial_step_completed` | Tutorial | `step: 1/2/3, mode` | После каждого жеста |
| `tutorial_skipped` | Tutorial | `at_step: 1/2/3` | При skip tutorial |
| `onboarding_complete` | Ready | `mode, role, states, duration_sec` | При нажатии "Начать" |

**User Properties (set once):**
| Property | Type | Description |
|----------|------|-------------|
| `user_mode` | string | beginner / expert |
| `user_role` | string | builder / furniture / investor / ... / null |
| `preferred_states` | string[] | ["AZ", "SD"] или [] для "везде" |
| `onboarding_completed` | bool | true после завершения |
| `onboarding_skipped` | bool | true если skip на welcome |

**Implementation:**
```dart
// lib/core/services/analytics_service.dart
class AnalyticsService {
  Future<void> logOnboardingStart();
  Future<void> logOnboardingSkip(String fromScreen);
  Future<void> logModeSelected(SwipeMode mode);
  Future<void> logRoleSelected(ExpertRole role);
  Future<void> logGeographySelected(List<String> states, bool searchEverywhere);
  Future<void> logTutorialStepCompleted(int step, SwipeMode mode);
  Future<void> logOnboardingComplete(UserPreferences prefs, Duration duration);

  // Set user properties
  Future<void> setUserMode(SwipeMode mode);
  Future<void> setUserRole(ExpertRole? role);
  Future<void> setPreferredStates(List<String> states);
}
```

---

## Dependencies

### Requires
- Local storage (SharedPreferences or Hive)
- Geolocation package (geolocator)
- Analytics service (Firebase + Facebook)
- **NO Gateway API** - all data from local mock

### Blocks
- Main swipe screen (needs UserPreferences)
- Property filtering (needs geography settings)

---

## Open Design Questions

- [x] Animations for mode cards - **Lottie или custom Flutter animations**
- [x] Demo card images - **Use real property images or illustrations**
- [ ] Localization - русский + английский?

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
