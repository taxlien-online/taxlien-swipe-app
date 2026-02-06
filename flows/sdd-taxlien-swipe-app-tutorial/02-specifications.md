# Specifications: Tutorial & Learning System

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-02-04  
> Requirements: [01-requirements.md](./01-requirements.md)

## Overview

Интерактивная система подсказок и обучения в Deal Detective: контекстные tooltips при первом взаимодействии, feature discovery nudges, learning modules, achievement system, coach marks и help center. Принцип "Learn by Doing" — подсказки появляются во время работы, не блокируют UI.

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| `lib/features/tutorial/` | Create | HintOverlay, TutorialService, AchievementService |
| `lib/core/models/user_preferences.dart` | Modify | TutorialState (shown hints, achievements, progress) |
| `lib/features/swipe/` | Modify | Tooltips on FVI badge, foreclosure %, filter |
| `lib/features/details/` | Modify | Tooltips, FVI viewed hint |
| `lib/features/annotation/` | Modify | Annotation tool hint |
| `lib/features/family/` | Modify | Family indicator hint |
| `lib/features/profile/` | Modify | Achievement badges, Skill profile |
| `lib/core/navigation/app_router.dart` | Modify | Learning Center route |
| `lib/l10n/` | Modify | Tutorial content strings |

## Architecture

### Component Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         TUTORIAL SYSTEM                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  TutorialService ──────► UserPreferences / SharedPreferences            │
│       │                  (shown_hints, achievements_unlocked)           │
│       │                                                                 │
│       ├─► shouldShowHint(hintId) → bool                                 │
│       ├─► markHintShown(hintId)                                         │
│       └─► getHintContent(hintId) → HintData                             │
│                                                                         │
│  HintOverlay (OverlayEntry) ──► Renders tooltip/coach mark/banner       │
│       │                                                                 │
│       └─► Overlay.of(context).insert(entry)                             │
│                                                                         │
│  AchievementService ────► Check triggers (swipe count, like count…)     │
│       │                  Emit achievement unlocked → Toast              │
│       └─► Storage: unlocked list                                        │
│                                                                         │
│  LearningCenterScreen ──► Modules, lessons, progress                    │
│  HelpCenterScreen ──────► Search, categories, articles                  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Data Flow

```
User views FVI badge for first time
    │
    ▼
TutorialService.shouldShowHint('fvi_badge') → true
    │
    ▼
Widget shows HintOverlay with tooltip content
    │
    ▼
User taps "Понятно"
    │
    ▼
TutorialService.markHintShown('fvi_badge')
    │
    ▼
Future views: shouldShowHint → false
```

## Interfaces

### TutorialService

```dart
// lib/features/tutorial/services/tutorial_service.dart

abstract class TutorialService {
  Future<bool> shouldShowHint(String hintId);
  Future<void> markHintShown(String hintId, {bool dontShowAgain = false});
  Future<void> disableAllHints();
  Future<bool> areHintsDisabled();

  /// For feature discovery nudges
  Future<bool> shouldShowNudge(String nudgeId, UserStats stats);
  Future<void> markNudgeShown(String nudgeId);
}
```

### AchievementService

```dart
// lib/features/tutorial/services/achievement_service.dart

abstract class AchievementService {
  Stream<Achievement> get onAchievementUnlocked;
  Future<List<Achievement>> getAllAchievements();
  Future<List<String>> getUnlockedIds();
  Future<void> checkAndUnlock(UserStats stats);
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String badgeEmoji;
  final AchievementCategory category;
}
```

### HintOverlay Widget

```dart
// lib/features/tutorial/widgets/hint_overlay.dart

class HintOverlay extends StatelessWidget {
  final String hintId;
  final Widget child;
  final HintType type; // tooltip, coachMark, banner, pulse
  final String title;
  final String body;
  final VoidCallback? onDismiss;
  final bool showDontShowAgain;
}
```

## Data Models

### TutorialState (in UserPreferences or separate)

```dart
class TutorialState {
  final Set<String> shownHints;
  final Set<String> shownNudges;
  final bool hintsDisabled;
  final Set<String> unlockedAchievements;
  final Map<String, int> lessonProgress; // moduleId -> completedLessonIndex
}
```

### Hint Definitions

| hintId | Trigger Element | Content Key | Type |
|--------|-----------------|-------------|------|
| fvi_badge | FVI badge on card | hint_fvi | tooltip |
| foreclosure_pct | Foreclosure % on card | hint_foreclosure | tooltip |
| filter_button | Filter FAB | hint_filter | tooltip |
| annotation_tool | Long press on card | hint_annotation | tooltip |
| family_indicator | Family match indicator | hint_family | tooltip |
| export_pdf | Export button in details | hint_export_pdf | tooltip |

### Achievement Definitions

From requirements: First Steps, Swiper, Power Swiper, Collector, First Mark, etc. Each has trigger condition and badge.

## Behavior Specifications

### Happy Path: Tooltip

1. User opens property card, sees FVI badge
2. `shouldShowHint('fvi_badge')` → true (first time)
3. HintOverlay renders tooltip bubble below badge
4. User taps "Понятно" → markHintShown
5. Overlay dismissed
6. Next time: shouldShowHint → false

### Edge Cases

| Case | Trigger | Expected Behavior |
|------|---------|-------------------|
| Hints disabled in Settings | User toggled off | shouldShowHint always false |
| "Don't show again" | User selected | disableAllHints(), all hints off |
| Multiple triggers same frame | Race | Maximum 1 hint visible (queue or debounce) |
| App restart | - | Shown hints persisted, not shown again |

### Coach Mark (Guided Tour)

1. User switches to Expert mode first time
2. Tour "Expert Mode Introduction" starts
3. Step 1: Spotlight on card area, text overlay
4. User taps "Далее" → step 2
5. ... until complete or Skip
6. Mark tour as shown

### Learning Modules

- Content in ARB or JSON (localized)
- Lesson format: title, body (markdown), optional image, "Try It Now" deep link
- Progress: moduleId → lastCompletedLessonIndex
- "Try It Now" → router.go(path) with highlight param

### Help Center

- Articles in l10n or bundled JSON
- Full-text search (client-side)
- Categories: App Basics, Properties, Annotations, Family, Tax Liens, Settings
- Contextual: from details → open Help with Properties expanded

## Dependencies

### Pubspec

- Existing: provider, go_router, shared_preferences
- Optional: markdown widget for lesson content
- Optional: overlay_tutorial or custom overlay

### Requires

- sdd-taxlien-swipe-app-onboarding — completed
- sdd-taxlien-swipe-app-localizations — for content
- sdd-taxlien-swipe-app-firebaseanalytics — progress tracking (optional)

## Integration Points

### Call Sites for Hints

| Location | hintId | Trigger |
|----------|--------|---------|
| PropertyCardAdvanced/Beginner | fvi_badge | FVI visible |
| PropertyCardAdvanced/Beginner | foreclosure_pct | Foreclosure % visible |
| SwipeHomeScreen | filter_button | Filter FAB tapped |
| SwipeableCard | annotation_tool | Long press |
| PropertyCard | family_indicator | Family match shown |
| DetailsScreen | export_pdf | Export button visible |

### UserStats (for achievements and nudges)

- total_swipes, total_likes, total_annotations
- sessions_count
- has_visited_family_board
- has_used_foreclosure_filter
- has_exported_pdf
- modules_completed

Sources: SwipeProvider, FilterProvider, SyncManager, TutorialService

## Testing Strategy

### Unit Tests

- [ ] TutorialService — shouldShowHint, markHintShown logic
- [ ] AchievementService — checkAndUnlock conditions
- [ ] Hint definitions loaded correctly

### Widget Tests

- [ ] HintOverlay renders and dismisses
- [ ] Achievement toast appears

### Manual Verification

- [ ] Tooltips show on first view
- [ ] "Don't show again" disables all
- [ ] Learning Center progress persists
- [ ] Help search works

## Migration / Rollout

- Phase 1: Tooltips only (lowest risk)
- Phase 2: Feature discovery nudges
- Phase 3: Learning modules, achievements
- Phase 4: Coach marks, Help Center

## Open Design Questions

- [ ] Format for lesson content (ARB vs JSON)?
- [ ] Leaderboard (family/global)?

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
