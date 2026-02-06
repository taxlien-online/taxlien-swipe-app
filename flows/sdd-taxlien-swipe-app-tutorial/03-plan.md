# Implementation Plan: Tutorial & Learning System

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-02-04  
> Specifications: [02-specifications.md](./02-specifications.md)

## Summary

Поэтапная реализация tutorial system: сначала TutorialService и контекстные tooltips, затем achievements, learning modules, coach marks, help center.

## Task Breakdown

### Phase 1: Foundation (TutorialService + Tooltips)

#### Task 1.1: Create TutorialService
- **Description**: TutorialService interface and impl, persistence via SharedPreferences
- **Files**:
  - `lib/features/tutorial/services/tutorial_service.dart` — Create
  - `lib/features/tutorial/models/tutorial_state.dart` — Create
- **Dependencies**: None
- **Verification**: Unit test shouldShowHint, markHintShown
- **Complexity**: Medium

#### Task 1.2: Create HintOverlay widget
- **Description**: Reusable overlay for tooltip (bubble, arrow, dismiss button)
- **Files**: `lib/features/tutorial/widgets/hint_overlay.dart` — Create
- **Dependencies**: Task 1.1
- **Verification**: Widget test
- **Complexity**: Medium

#### Task 1.3: Add hint content to l10n
- **Description**: ARB keys for hint_fvi, hint_foreclosure, hint_filter, etc.
- **Files**: `lib/l10n/app_en.arb`, app_ru.arb, etc.
- **Dependencies**: None
- **Verification**: Strings resolve
- **Complexity**: Low

#### Task 1.4: Integrate FVI badge tooltip
- **Description**: PropertyCard — wrap FVI badge with hint trigger
- **Files**: `lib/features/swipe/widgets/property_card_advanced.dart` (or beginner)
- **Dependencies**: Task 1.1, 1.2, 1.3
- **Verification**: Tooltip shows on first view
- **Complexity**: Low

#### Task 1.5: Integrate foreclosure % tooltip
- **Description**: Same pattern for foreclosure probability
- **Files**: Property card widgets
- **Dependencies**: Task 1.4
- **Verification**: Tooltip shows
- **Complexity**: Low

#### Task 1.6: Integrate filter button tooltip
- **Description**: Filter FAB first tap → tooltip
- **Files**: `lib/features/swipe/screens/home_screen.dart` or swipe_screen
- **Dependencies**: Task 1.4
- **Verification**: Tooltip on first tap
- **Complexity**: Low

#### Task 1.7: Settings — "Disable all hints" toggle
- **Description**: Toggle in Profile/Settings
- **Files**: `lib/features/profile/screens/profile_screen.dart` or preferences
- **Dependencies**: Task 1.1
- **Verification**: Toggle disables hints
- **Complexity**: Low

### Phase 2: Achievement System

#### Task 2.1: Create AchievementService
- **Description**: Achievement definitions, checkAndUnlock, persistence
- **Files**:
  - `lib/features/tutorial/services/achievement_service.dart` — Create
  - `lib/features/tutorial/models/achievement.dart` — Create
- **Dependencies**: Task 1.1 (UserStats from providers)
- **Verification**: Unit test unlock logic
- **Complexity**: Medium

#### Task 2.2: Wire achievements to user actions
- **Description**: SwipeProvider, etc. — notify AchievementService on actions
- **Files**: SwipeProvider, FilterProvider, etc.
- **Dependencies**: Task 2.1
- **Verification**: Achievement unlocks on 10 swipes
- **Complexity**: Medium

#### Task 2.3: Achievement toast
- **Description**: Overlay toast when achievement unlocked
- **Files**: `lib/features/tutorial/widgets/achievement_toast.dart` — Create
- **Dependencies**: Task 2.1
- **Verification**: Toast shows on unlock
- **Complexity**: Low

#### Task 2.4: Profile — Achievement badges display
- **Description**: List of achievements (locked/unlocked) in Profile
- **Files**: ProfileScreen or new AchievementsSection
- **Dependencies**: Task 2.1
- **Verification**: Badges visible
- **Complexity**: Medium

### Phase 3: Feature Discovery Nudges

#### Task 3.1: Nudge definitions and logic
- **Description**: Nudge rules (e.g. 50 swipes → Expert mode nudge)
- **Files**: TutorialService extension
- **Dependencies**: Task 1.1, 2.1 (UserStats)
- **Verification**: Nudge triggers at right count
- **Complexity**: Medium

#### Task 3.2: Nudge UI (banner style)
- **Description**: Banner at bottom, "Попробовать" / "Не сейчас"
- **Files**: `lib/features/tutorial/widgets/nudge_banner.dart` — Create
- **Dependencies**: Task 3.1
- **Verification**: Nudge shows, actions work
- **Complexity**: Low

### Phase 4: Learning Center

#### Task 4.1: Learning Center screen
- **Description**: List of modules, progress, Continue button
- **Files**: `lib/features/tutorial/screens/learning_center_screen.dart` — Create
- **Dependencies**: Task 1.1 (lesson progress)
- **Verification**: Screen renders
- **Complexity**: Medium

#### Task 4.2: Lesson content and format
- **Description**: Module/lesson model, content in ARB or JSON
- **Files**: `lib/features/tutorial/models/lesson.dart`, content assets
- **Dependencies**: Task 4.1
- **Verification**: Lessons display
- **Complexity**: Medium

#### Task 4.3: Lesson screen
- **Description**: Single lesson view, "Try It Now", "Mark Complete"
- **Files**: `lib/features/tutorial/screens/lesson_screen.dart` — Create
- **Dependencies**: Task 4.2
- **Verification**: Lesson flow works
- **Complexity**: Medium

#### Task 4.4: Route and navigation
- **Description**: /learning path, link from Profile
- **Files**: app_router.dart, ProfileScreen
- **Dependencies**: Task 4.1
- **Verification**: Navigation works
- **Complexity**: Low

### Phase 5: Coach Marks (Guided Tours)

#### Task 5.1: Coach mark overlay
- **Description**: Spotlight + overlay, step navigation
- **Files**: `lib/features/tutorial/widgets/coach_mark_overlay.dart` — Create
- **Dependencies**: Task 1.2
- **Verification**: Overlay renders
- **Complexity**: High

#### Task 5.2: Expert Mode tour
- **Description**: Tour definition, trigger on first Expert mode
- **Files**: TutorialService, Expert mode entry point
- **Dependencies**: Task 5.1
- **Verification**: Tour runs
- **Complexity**: Medium

#### Task 5.3: Annotation tour
- **Description**: Tour for annotation tools
- **Files**: TutorialService, Annotation screen
- **Dependencies**: Task 5.1
- **Verification**: Tour runs
- **Complexity**: Medium

### Phase 6: Help Center

#### Task 6.1: Help Center screen
- **Description**: Categories, article list, search
- **Files**: `lib/features/tutorial/screens/help_center_screen.dart` — Create
- **Dependencies**: None
- **Verification**: Screen renders
- **Complexity**: Medium

#### Task 6.2: Help content
- **Description**: Articles (markdown or rich text) per category
- **Files**: l10n or JSON assets
- **Dependencies**: Task 6.1
- **Verification**: Articles display
- **Complexity**: Medium

#### Task 6.3: Help entry point
- **Description**: ? icon in AppBar, contextual open
- **Files**: AppBar, app_router
- **Dependencies**: Task 6.1
- **Verification**: Help accessible
- **Complexity**: Low

### Phase 7: Skill Profile

#### Task 7.1: Skill progression model
- **Description**: Skills (Swipe, Annotation, Filter, etc.), progress %
- **Files**: `lib/features/tutorial/models/skill_profile.dart` — Create
- **Dependencies**: Task 2.1 (UserStats)
- **Verification**: Profile computes correctly
- **Complexity**: Medium

#### Task 7.2: Skill profile in Profile
- **Description**: Display skills, next milestone
- **Files**: ProfileScreen
- **Dependencies**: Task 7.1
- **Verification**: Profile shows
- **Complexity**: Low

## Dependency Graph

```
1.1 ─┬─→ 1.2 ─→ 1.4 ─→ 1.5 ─→ 1.6
     │
     ├─→ 1.7
     │
1.3 ─┘

1.1, 1.4 ─→ 2.1 ─→ 2.2 ─→ 2.3
                  └─→ 2.4

2.1 ─→ 3.1 ─→ 3.2

1.1 ─→ 4.1 ─→ 4.2 ─→ 4.3
       └─→ 4.4

1.2 ─→ 5.1 ─→ 5.2
            └─→ 5.3

6.1 ─→ 6.2 ─→ 6.3

2.1 ─→ 7.1 ─→ 7.2
```

## File Change Summary

| File | Action |
|------|--------|
| lib/features/tutorial/services/tutorial_service.dart | Create |
| lib/features/tutorial/services/achievement_service.dart | Create |
| lib/features/tutorial/models/tutorial_state.dart | Create |
| lib/features/tutorial/models/achievement.dart | Create |
| lib/features/tutorial/models/lesson.dart | Create |
| lib/features/tutorial/models/skill_profile.dart | Create |
| lib/features/tutorial/widgets/hint_overlay.dart | Create |
| lib/features/tutorial/widgets/achievement_toast.dart | Create |
| lib/features/tutorial/widgets/nudge_banner.dart | Create |
| lib/features/tutorial/widgets/coach_mark_overlay.dart | Create |
| lib/features/tutorial/screens/learning_center_screen.dart | Create |
| lib/features/tutorial/screens/lesson_screen.dart | Create |
| lib/features/tutorial/screens/help_center_screen.dart | Create |
| lib/features/swipe/widgets/ | Modify |
| lib/features/profile/screens/profile_screen.dart | Modify |
| lib/core/navigation/app_router.dart | Modify |
| lib/l10n/*.arb | Modify |

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Overlay z-index issues | Med | Low | Test on various screens |
| Content volume | Med | Med | Start with minimal lessons |
| Performance (achievement checks) | Low | Low | Debounce, batch |

## Rollback Strategy

1. Feature flag: disable tutorial module
2. Remove HintOverlay wrappers from widgets
3. Hide Learning Center / Help routes

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
