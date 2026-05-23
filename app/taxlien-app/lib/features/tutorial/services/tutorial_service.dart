import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lesson.dart';
import '../models/nudge_data.dart';
import '../models/tutorial_state.dart';
import '../models/user_stats.dart';

const String _kTutorialStateKey = 'tutorial_state';

/// Service for contextual hints, nudges, and tutorial progress.
/// Persists which hints have been shown, whether hints are disabled, and user stats.
abstract class TutorialService {
  Future<bool> shouldShowHint(String hintId);
  Future<void> markHintShown(String hintId, {bool dontShowAgain = false});
  Future<void> disableAllHints();
  Future<void> enableHints();
  Future<bool> areHintsDisabled();
  Future<TutorialState> getState();
  Future<UserStats> getStats();
  Future<void> incrementSwipes();
  Future<void> incrementLikes();
  Future<void> addUnlockedAchievement(String achievementId);

  /// Returns the next nudge id to show, or null if none.
  Future<String?> getNextNudge(UserStats stats, {bool isBeginnerMode = true});
  Future<void> markNudgeShown(String nudgeId);

  /// Mark lesson at [lessonIndex] in module [moduleId] as completed. Updates progress and modulesCompleted.
  Future<void> setLessonCompleted(String moduleId, int lessonIndex);
}

class TutorialServiceImpl implements TutorialService {
  TutorialServiceImpl({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;
  TutorialState? _cachedState;

  Future<SharedPreferences> get _storage async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<TutorialState> _loadState() async {
    if (_cachedState != null) return _cachedState!;
    final prefs = await _storage;
    final raw = prefs.getString(_kTutorialStateKey);
    if (raw == null) {
      _cachedState = const TutorialState();
      return _cachedState!;
    }
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _cachedState = TutorialState.fromJson(map);
      return _cachedState!;
    } catch (_) {
      _cachedState = const TutorialState();
      return _cachedState!;
    }
  }

  Future<void> _saveState(TutorialState state) async {
    _cachedState = state;
    final prefs = await _storage;
    await prefs.setString(_kTutorialStateKey, jsonEncode(state.toJson()));
  }

  @override
  Future<bool> shouldShowHint(String hintId) async {
    final state = await _loadState();
    if (state.hintsDisabled) return false;
    return !state.shownHints.contains(hintId);
  }

  @override
  Future<void> markHintShown(String hintId, {bool dontShowAgain = false}) async {
    final state = await _loadState();
    final newShown = {...state.shownHints, hintId};
    final newState = state.copyWith(
      shownHints: newShown,
      hintsDisabled: dontShowAgain ? true : state.hintsDisabled,
    );
    await _saveState(newState);
  }

  @override
  Future<void> disableAllHints() async {
    final state = await _loadState();
    await _saveState(state.copyWith(hintsDisabled: true));
  }

  @override
  Future<void> enableHints() async {
    final state = await _loadState();
    await _saveState(state.copyWith(hintsDisabled: false));
  }

  @override
  Future<bool> areHintsDisabled() async {
    final state = await _loadState();
    return state.hintsDisabled;
  }

  @override
  Future<TutorialState> getState() async => _loadState();

  @override
  Future<UserStats> getStats() async {
    final state = await _loadState();
    return state.userStats;
  }

  @override
  Future<void> incrementSwipes() async {
    final state = await _loadState();
    await _saveState(state.copyWith(totalSwipes: state.totalSwipes + 1));
  }

  @override
  Future<void> incrementLikes() async {
    final state = await _loadState();
    await _saveState(state.copyWith(totalLikes: state.totalLikes + 1));
  }

  @override
  Future<void> addUnlockedAchievement(String achievementId) async {
    final state = await _loadState();
    final newSet = {...state.unlockedAchievements, achievementId};
    await _saveState(state.copyWith(unlockedAchievements: newSet));
  }

  @override
  Future<String?> getNextNudge(UserStats stats,
      {bool isBeginnerMode = true}) async {
    final state = await _loadState();
    for (final def in nudgeDefinitions) {
      if (state.shownNudges.contains(def.id)) continue;
      if (def.condition(stats, isBeginnerMode: isBeginnerMode)) {
        return def.id;
      }
    }
    return null;
  }

  @override
  Future<void> markNudgeShown(String nudgeId) async {
    final state = await _loadState();
    await _saveState(
        state.copyWith(shownNudges: {...state.shownNudges, nudgeId}));
  }

  @override
  Future<void> setLessonCompleted(String moduleId, int lessonIndex) async {
    final state = await _loadState();
    final current = state.lessonProgress[moduleId] ?? -1;
    final newIndex = current > lessonIndex ? current : lessonIndex;
    final newProgress = {...state.lessonProgress, moduleId: newIndex};
    int completedCount = 0;
    for (final m in learningModules) {
      final last = (newProgress[m.id] ?? -1);
      if (last >= m.lessonCount - 1) completedCount++;
    }
    await _saveState(state.copyWith(
      lessonProgress: newProgress,
      modulesCompleted: completedCount,
    ));
  }
}
