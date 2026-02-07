# Implementation Log: Tutorial & Learning System

> Started: 2026-02-04
> Plan: [03-plan.md](./03-plan.md)

## Progress Tracker

| Task | Status | Notes |
|------|--------|-------|
| 1.1 TutorialService + tutorial_state | ✅ Done | lib/features/tutorial/ |
| 1.2 HintOverlay widget | ✅ Done | hint_overlay.dart, hint_trigger.dart |
| 1.3 Hint content l10n | ✅ Done | app_en.arb + generated getters |
| 1.4 FVI badge tooltip | ✅ Done | PropertyCardBeginner wrapped with HintTrigger |
| 1.5 Foreclosure % tooltip | ⏸ Deferred | Expert card / swipeable_card; Phase 1 focus |
| 1.6 Filter button tooltip | ✅ Done | SwipeScreen _onFilterPressed dialog |
| 1.7 Settings — Disable hints toggle | ✅ Done | ProfileScreen SwitchListTile |
| 2.1 AchievementService + Achievement model | ✅ Done | achievement_service.dart, achievement.dart, user_stats.dart |
| 2.2 Wire achievements to SwipeProvider | ✅ Done | incrementSwipes/Likes, checkAndUnlock on like/pass |
| 2.3 Achievement toast | ✅ Done | achievement_toast.dart, listener in MaterialApp builder |
| 2.4 Profile — Achievement badges | ✅ Done | _AchievementsSection in ProfileScreen |
| 3.1 Nudge definitions and logic | ✅ Done | nudge_data.dart, TutorialService.getNextNudge, markNudgeShown |
| 3.2 Nudge UI (banner) | ✅ Done | nudge_banner.dart, SwipeScreen Stack + NudgeBanner |

## Session 2026-02-04 (Phase 1)

- Created TutorialState model (shownHints, shownNudges, hintsDisabled, etc.) with toJson/fromJson.
- Created TutorialService interface and TutorialServiceImpl with SharedPreferences persistence; added enableHints().
- Created HintOverlay (tooltip bubble) and HintTrigger (async shouldShowHint + Column layout).
- Added l10n: hintFviTitle/Body, hintForeclosure*, hintFilter*, hintGotIt, hintDontShowAgain, disableAllHints, showHints.
- Registered Provider<TutorialService> in main.dart.
- PropertyCardBeginner: FVI badge wrapped in HintTrigger('fvi_badge').
- SwipeScreen: filter button shows hint dialog on first tap, then FilterSheet.
- ProfileScreen: SwitchListTile to disable/enable all hints (loads state in didChangeDependencies).
- Foreclosure % tooltip left for Expert card / Phase 1.5 when needed.

## Session 2026-02-04 (Phase 2)

- Extended TutorialState with totalSwipes, totalLikes, totalAnnotations, modulesCompleted, hasVisitedFamilyBoard, hasUsedForeclosureFilter, hasExportedPdf, hasUsedOfflineMode; added userStats getter.
- TutorialService: getStats(), incrementSwipes(), incrementLikes(), addUnlockedAchievement().
- UserStats model; Achievement + AchievementCategory; AchievementService with all definitions (Swiper, Collector, etc.), checkAndUnlock(UserStats), onAchievementUnlocked stream.
- SwipeProvider: inject TutorialService and AchievementService; handleLike/handlePass call incrementSwipes (and incrementLikes for like), then checkAndUnlock(stats).
- main: Provider TutorialService, AchievementService; SwipeProvider gets tutorial + achievement.
- AchievementToast widget; AchievementToastListener subscribes to stream, shows overlay toast; MaterialApp.router builder wraps with listener.
- ProfileScreen: _AchievementsSection with FutureBuilder loading achievements + unlocked IDs, Wrap of badge chips (locked/unlocked).

## Session 2026-02-04 (Phase 3)

- NudgeDefinition + nudgeDefinitions (expert_mode 50 swipes, annotation 10 likes 0 annotations, foreclosure_filter 20 swipes + !hasUsedForeclosureFilter, family_board 5 likes + !hasVisitedFamilyBoard).
- TutorialService: getNextNudge(stats, isBeginnerMode), markNudgeShown(nudgeId).
- l10n: nudgeExpertModeTitle/Body, nudgeAnnotation*, nudgeForeclosureFilter*, nudgeFamilyBoard*, nudgeTryIt, nudgeNotNow (en + ru + bn/hi/th/zh fallback).
- NudgeBanner widget: title/body from l10n by nudgeId, Try it / Not now buttons.
- SwipeScreen: _nudgeId, _scheduleNudgeCheck(provider), getNextNudge after frame; Stack with NudgeBanner at bottom; onTry switches to advanced / opens FilterSheet / pushes /family, onDismiss marks shown.
