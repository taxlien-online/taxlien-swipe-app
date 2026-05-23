import 'dart:async';
import '../models/achievement.dart';
import '../models/user_stats.dart';
import 'tutorial_service.dart';

/// Service that evaluates unlock conditions and emits newly unlocked achievements.
abstract class AchievementService {
  Stream<Achievement> get onAchievementUnlocked;
  Future<List<Achievement>> getAllAchievements();
  Future<List<String>> getUnlockedIds();
  Future<void> checkAndUnlock(UserStats stats);
}

/// All achievement definitions (from requirements).
List<Achievement> get _allAchievements => [
      Achievement(
        id: 'first_steps',
        title: 'First Steps',
        description: 'Complete onboarding',
        badgeEmoji: '🎯',
        category: AchievementCategory.onboarding,
        isUnlocked: (s) => s.onboardingCompleted,
      ),
      Achievement(
        id: 'swiper',
        title: 'Swiper',
        description: '10 swipes',
        badgeEmoji: '👆',
        category: AchievementCategory.swipes,
        isUnlocked: (s) => s.totalSwipes >= 10,
      ),
      Achievement(
        id: 'power_swiper',
        title: 'Power Swiper',
        description: '100 swipes',
        badgeEmoji: '💪',
        category: AchievementCategory.swipes,
        isUnlocked: (s) => s.totalSwipes >= 100,
      ),
      Achievement(
        id: 'swipe_master',
        title: 'Swipe Master',
        description: '1000 swipes',
        badgeEmoji: '🏆',
        category: AchievementCategory.swipes,
        isUnlocked: (s) => s.totalSwipes >= 1000,
      ),
      Achievement(
        id: 'collector',
        title: 'Collector',
        description: '10 likes',
        badgeEmoji: '❤️',
        category: AchievementCategory.likes,
        isUnlocked: (s) => s.totalLikes >= 10,
      ),
      Achievement(
        id: 'curator',
        title: 'Curator',
        description: '50 likes',
        badgeEmoji: '🎨',
        category: AchievementCategory.likes,
        isUnlocked: (s) => s.totalLikes >= 50,
      ),
      Achievement(
        id: 'connoisseur',
        title: 'Connoisseur',
        description: '200 likes',
        badgeEmoji: '👑',
        category: AchievementCategory.likes,
        isUnlocked: (s) => s.totalLikes >= 200,
      ),
      Achievement(
        id: 'first_mark',
        title: 'First Mark',
        description: '1 annotation',
        badgeEmoji: '✏️',
        category: AchievementCategory.annotations,
        isUnlocked: (s) => s.totalAnnotations >= 1,
      ),
      Achievement(
        id: 'detail_spotter',
        title: 'Detail Spotter',
        description: '10 annotations',
        badgeEmoji: '🔍',
        category: AchievementCategory.annotations,
        isUnlocked: (s) => s.totalAnnotations >= 10,
      ),
      Achievement(
        id: 'expert_eye',
        title: 'Expert Eye',
        description: '50 annotations',
        badgeEmoji: '👁️',
        category: AchievementCategory.annotations,
        isUnlocked: (s) => s.totalAnnotations >= 50,
      ),
      Achievement(
        id: 'student',
        title: 'Student',
        description: 'Complete 1 module',
        badgeEmoji: '📖',
        category: AchievementCategory.learning,
        isUnlocked: (s) => s.modulesCompleted >= 1,
      ),
      Achievement(
        id: 'scholar',
        title: 'Scholar',
        description: 'Complete 3 modules',
        badgeEmoji: '📚',
        category: AchievementCategory.learning,
        isUnlocked: (s) => s.modulesCompleted >= 3,
      ),
      Achievement(
        id: 'family_player',
        title: 'Family Player',
        description: 'View Family Board',
        badgeEmoji: '👨‍👩‍👧',
        category: AchievementCategory.special,
        isUnlocked: (s) => s.hasVisitedFamilyBoard,
      ),
      Achievement(
        id: 'foreclosure_hunter',
        title: 'Foreclosure Hunter',
        description: 'Filter ON + 10 likes',
        badgeEmoji: '🎯',
        category: AchievementCategory.special,
        isUnlocked: (s) =>
            s.hasUsedForeclosureFilter && s.totalLikes >= 10,
      ),
      Achievement(
        id: 'pdf_pro',
        title: 'PDF Pro',
        description: 'Export 5 PDFs',
        badgeEmoji: '📄',
        category: AchievementCategory.special,
        isUnlocked: (s) => s.hasExportedPdf,
      ),
      Achievement(
        id: 'offline_ready',
        title: 'Offline Ready',
        description: 'Use offline mode',
        badgeEmoji: '📴',
        category: AchievementCategory.special,
        isUnlocked: (s) => s.hasUsedOfflineMode,
      ),
    ];

class AchievementServiceImpl implements AchievementService {
  AchievementServiceImpl({required TutorialService tutorialService})
      : _tutorial = tutorialService;

  final TutorialService _tutorial;
  final StreamController<Achievement> _unlockedController =
      StreamController<Achievement>.broadcast();

  @override
  Stream<Achievement> get onAchievementUnlocked => _unlockedController.stream;

  @override
  Future<List<Achievement>> getAllAchievements() async =>
      List<Achievement>.from(_allAchievements);

  @override
  Future<List<String>> getUnlockedIds() async {
    final state = await _tutorial.getState();
    return state.unlockedAchievements.toList();
  }

  @override
  Future<void> checkAndUnlock(UserStats stats) async {
    final unlockedIds = await getUnlockedIds();
    final unlockedSet = unlockedIds.toSet();
    for (final a in _allAchievements) {
      if (unlockedSet.contains(a.id)) continue;
      if (a.isUnlocked(stats)) {
        await _tutorial.addUnlockedAchievement(a.id);
        _unlockedController.add(a);
      }
    }
  }

  void dispose() {
    _unlockedController.close();
  }
}
