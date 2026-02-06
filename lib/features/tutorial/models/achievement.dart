import 'user_stats.dart';

/// Category for grouping achievements in UI.
enum AchievementCategory {
  onboarding,
  swipes,
  likes,
  annotations,
  learning,
  special,
}

/// Single achievement definition and unlock condition.
class Achievement {
  final String id;
  final String title;
  final String description;
  final String badgeEmoji;
  final AchievementCategory category;
  final bool Function(UserStats stats) isUnlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.badgeEmoji,
    required this.category,
    required this.isUnlocked,
  });
}
