# Implementation Plan: Swipe App Onboarding

**Version:** 1.0
**Status:** REVIEW
**Last Updated:** 2026-02-02
**Specifications:** [specifications.md](./specifications.md)

---

## Summary

Реализация онбординга для Deal Detective в 4 фазах:
1. **Foundation** - модели, сервисы, навигация
2. **Core Screens** - Welcome, Mode, Geography
3. **Advanced Features** - Role Selection, Tutorial
4. **Polish** - анимации, тестирование

---

## Task Breakdown

### Phase 1: Foundation

#### Task 1.1: Create Onboarding Feature Structure
- **Description**: Создать структуру директорий для onboarding feature
- **Files**:
  - `lib/features/onboarding/` - Create directory structure
- **Dependencies**: None
- **Verification**: Directory structure exists
- **Complexity**: Low

```
lib/features/onboarding/
├── screens/
├── widgets/
├── providers/
└── services/
```

---

#### Task 1.2: Extend UserPreferences Model
- **Description**: Добавить поля для географии и onboarding status
- **Files**:
  - `lib/core/models/user_preferences.dart` - Modify
- **Dependencies**: None
- **Verification**: Model compiles, defaults work
- **Complexity**: Low

**Changes:**
```dart
+ enum UserRole { builder, furniture, autoScience, investor, family, universal }
+ final List<String> states;
+ final List<String> counties;
+ final bool onboardingCompleted;
+ static UserPreferences defaults()
```

---

#### Task 1.3: Create OnboardingState Model
- **Description**: State management для онбординга
- **Files**:
  - `lib/features/onboarding/providers/onboarding_state.dart` - Create
- **Dependencies**: Task 1.2
- **Verification**: State transitions work
- **Complexity**: Low

---

#### Task 1.4: Create OnboardingService
- **Description**: Business logic для онбординга
- **Files**:
  - `lib/features/onboarding/services/onboarding_service.dart` - Create
- **Dependencies**: Task 1.2, Task 1.3
- **Verification**: Service methods work
- **Complexity**: Medium

---

#### Task 1.5: Add Onboarding Routes to GoRouter
- **Description**: Настроить навигацию для онбординга
- **Files**:
  - `lib/core/navigation/app_router.dart` - Modify
- **Dependencies**: Task 1.1
- **Verification**: Routes navigate correctly
- **Complexity**: Low

**Routes:**
- `/onboarding/welcome`
- `/onboarding/mode`
- `/onboarding/role`
- `/onboarding/geo`
- `/onboarding/county`
- `/onboarding/tutorial`
- `/onboarding/ready`

---

### Phase 2: Core Screens

#### Task 2.1: Create SkipButton Widget
- **Description**: Переиспользуемая кнопка "Пропустить"
- **Files**:
  - `lib/features/onboarding/widgets/skip_button.dart` - Create
- **Dependencies**: Task 1.4
- **Verification**: Button renders, skip works
- **Complexity**: Low

---

#### Task 2.2: Create Welcome Screen
- **Description**: Первый экран онбординга
- **Files**:
  - `lib/features/onboarding/screens/welcome_screen.dart` - Create
- **Dependencies**: Task 1.5, Task 2.1
- **Verification**: Screen renders, navigation works
- **Complexity**: Low

**UI:**
- Logo + title
- "Начать настройку" button
- "Я уже знаю как свайпать" link
- Skip button (top-right)

---

#### Task 2.3: Create ModeCard Widget
- **Description**: Карточка выбора режима с анимацией
- **Files**:
  - `lib/features/onboarding/widgets/mode_card.dart` - Create
- **Dependencies**: None
- **Verification**: Animation plays, selection works
- **Complexity**: Medium

**Features:**
- Animated swipe preview (loop)
- Title + description
- Selected state

---

#### Task 2.4: Create Mode Selection Screen
- **Description**: Экран выбора Beginner/Expert
- **Files**:
  - `lib/features/onboarding/screens/mode_selection_screen.dart` - Create
- **Dependencies**: Task 2.1, Task 2.3
- **Verification**: Both modes navigate correctly
- **Complexity**: Low

---

#### Task 2.5: Create StateChip Widget
- **Description**: Чип для выбора штата
- **Files**:
  - `lib/features/onboarding/widgets/state_chip.dart` - Create
- **Dependencies**: None
- **Verification**: Selection toggles
- **Complexity**: Low

---

#### Task 2.6: Create Geography Screen
- **Description**: Экран выбора географии
- **Files**:
  - `lib/features/onboarding/screens/geography_screen.dart` - Create
- **Dependencies**: Task 2.1, Task 2.5
- **Verification**: State selection works, "везде" works
- **Complexity**: Medium

**Sections:**
- Auto-detected states (if geolocation)
- Search field
- Popular chips
- "Искать везде" option

---

#### Task 2.7: Create CountyTile Widget
- **Description**: Плитка county с количеством liens
- **Files**:
  - `lib/features/onboarding/widgets/county_tile.dart` - Create
- **Dependencies**: None
- **Verification**: Renders correctly
- **Complexity**: Low

---

#### Task 2.8: Create County Selection Screen
- **Description**: Опциональный экран выбора counties
- **Files**:
  - `lib/features/onboarding/screens/county_selection_screen.dart` - Create
- **Dependencies**: Task 2.1, Task 2.7
- **Verification**: County selection works
- **Complexity**: Low

---

### Phase 3: Advanced Features

#### Task 3.1: Create RoleCard Widget
- **Description**: Карточка выбора роли эксперта
- **Files**:
  - `lib/features/onboarding/widgets/role_card.dart` - Create
- **Dependencies**: None
- **Verification**: Selection works
- **Complexity**: Low

---

#### Task 3.2: Create Role Selection Screen
- **Description**: Экран выбора специализации (Expert only)
- **Files**:
  - `lib/features/onboarding/screens/role_selection_screen.dart` - Create
- **Dependencies**: Task 2.1, Task 3.1
- **Verification**: Roles select correctly
- **Complexity**: Low

---

#### Task 3.3: Create TutorialCard Widget
- **Description**: Демо-карточка для tutorial
- **Files**:
  - `lib/features/onboarding/widgets/tutorial_card.dart` - Create
- **Dependencies**: None
- **Verification**: Swipe gestures detected
- **Complexity**: Medium

---

#### Task 3.4: Create SwipeHintOverlay Widget
- **Description**: Анимированная подсказка (стрелка/рука)
- **Files**:
  - `lib/features/onboarding/widgets/swipe_hint_overlay.dart` - Create
- **Dependencies**: None
- **Verification**: Animation plays
- **Complexity**: Medium

---

#### Task 3.5: Create Tutorial Screen
- **Description**: Интерактивный tutorial
- **Files**:
  - `lib/features/onboarding/screens/tutorial_screen.dart` - Create
- **Dependencies**: Task 3.3, Task 3.4
- **Verification**: Tutorial steps complete
- **Complexity**: High

**Features:**
- Gesture detection (swipe, long press)
- Progress tracking
- Success animations
- Beginner (2 steps) vs Expert (3 steps)

---

#### Task 3.6: Create Ready Screen
- **Description**: Финальный экран с summary
- **Files**:
  - `lib/features/onboarding/screens/ready_screen.dart` - Create
- **Dependencies**: Task 1.4
- **Verification**: Summary displays, navigation to home works
- **Complexity**: Low

---

### Phase 4: Polish & Testing

#### Task 4.1: Add Geolocation Service
- **Description**: Сервис определения местоположения
- **Files**:
  - `lib/features/onboarding/services/geolocation_service.dart` - Create
- **Dependencies**: None
- **Verification**: Location detected (with permission)
- **Complexity**: Medium

---

#### Task 4.2: Connect to Gateway API
- **Description**: Интеграция с API для states/counties
- **Files**:
  - `lib/features/onboarding/services/onboarding_service.dart` - Modify
- **Dependencies**: Task 1.4
- **Verification**: API calls work, fallback to cache
- **Complexity**: Medium

**Endpoints:**
- `GET /api/v1/states`
- `GET /api/v1/states/nearby`
- `GET /api/v1/states/{code}/counties`
- `GET /api/v1/stats`

---

#### Task 4.3: Add Mode Card Animations
- **Description**: Анимации для ModeCard (Lottie или custom)
- **Files**:
  - `lib/features/onboarding/widgets/mode_card.dart` - Modify
  - `assets/animations/` - Create if using Lottie
- **Dependencies**: Task 2.3
- **Verification**: Smooth animations
- **Complexity**: Medium

---

#### Task 4.4: Unit Tests
- **Description**: Тесты для сервисов и state
- **Files**:
  - `test/features/onboarding/` - Create
- **Dependencies**: All Phase 1-3
- **Verification**: Tests pass
- **Complexity**: Medium

---

#### Task 4.5: Widget Tests
- **Description**: Тесты для экранов
- **Files**:
  - `test/features/onboarding/screens/` - Create
- **Dependencies**: All Phase 2-3
- **Verification**: Tests pass
- **Complexity**: Medium

---

#### Task 4.6: Integration Test
- **Description**: E2E тест полного flow
- **Files**:
  - `integration_test/onboarding_test.dart` - Create
- **Dependencies**: All tasks
- **Verification**: Full flow works
- **Complexity**: Medium

---

## Dependency Graph

```
Phase 1 (Foundation)
─────────────────────
1.1 ──┬──→ 1.5 ──→ Phase 2
      │
1.2 ──┼──→ 1.3 ──→ 1.4 ──→ Phase 2, 3, 4
      │
      └──────────────────→ Phase 2

Phase 2 (Core Screens)
──────────────────────
2.1 ──┬──→ 2.2 (Welcome)
      │
      ├──→ 2.4 (Mode) ←── 2.3
      │
      ├──→ 2.6 (Geo) ←── 2.5
      │
      └──→ 2.8 (County) ←── 2.7

Phase 3 (Advanced)
──────────────────
3.1 ──→ 3.2 (Role)

3.3 ──┬──→ 3.5 (Tutorial)
3.4 ──┘

3.6 (Ready)

Phase 4 (Polish)
────────────────
4.1, 4.2, 4.3 (parallel)
     │
     ↓
4.4, 4.5 (parallel)
     │
     ↓
    4.6
```

---

## File Change Summary

| File | Action | Reason |
|------|--------|--------|
| `lib/features/onboarding/` | Create | New feature module |
| `lib/core/models/user_preferences.dart` | Modify | Add geography fields |
| `lib/core/navigation/app_router.dart` | Modify | Add onboarding routes |
| `pubspec.yaml` | Modify | Add geolocator dependency |
| `test/features/onboarding/` | Create | Tests |

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Geolocation permission denied | Medium | Low | Fallback to manual selection |
| Gateway API not ready | Medium | Medium | Use mock data, cache |
| Animation performance issues | Low | Low | Simplify or use Lottie |
| Tutorial gesture conflicts | Low | Medium | Careful gesture detection tuning |

---

## Rollback Strategy

1. Feature flag: `isOnboardingEnabled` in config
2. If issues: set flag to false, users go straight to home
3. Onboarding state stored separately from main app state

---

## Checkpoints

### After Phase 1:
- [ ] Models compile
- [ ] Routes work
- [ ] Service methods callable

### After Phase 2:
- [ ] Welcome → Mode → Geo → County navigates
- [ ] Skip works from any screen
- [ ] State selection persists

### After Phase 3:
- [ ] Full Beginner flow works
- [ ] Full Expert flow works
- [ ] Tutorial gestures detected

### After Phase 4:
- [ ] All tests pass
- [ ] Geolocation works (when permitted)
- [ ] API integration works

---

## Estimated Task Count

| Phase | Tasks | Complexity |
|-------|-------|------------|
| 1. Foundation | 5 | Low-Medium |
| 2. Core Screens | 8 | Low-Medium |
| 3. Advanced | 6 | Medium-High |
| 4. Polish | 6 | Medium |
| **Total** | **25** | |

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
