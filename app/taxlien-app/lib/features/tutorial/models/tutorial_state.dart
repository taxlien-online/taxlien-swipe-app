import 'user_stats.dart';

/// Persisted state for the tutorial system (hints, nudges, achievements, stats).
/// Stored via TutorialService using SharedPreferences.
class TutorialState {
  final Set<String> shownHints;
  final Set<String> shownNudges;
  final bool hintsDisabled;
  final Set<String> unlockedAchievements;
  final Map<String, int> lessonProgress;
  final int totalSwipes;
  final int totalLikes;
  final int totalAnnotations;
  final int modulesCompleted;
  final bool hasVisitedFamilyBoard;
  final bool hasUsedForeclosureFilter;
  final bool hasExportedPdf;
  final bool hasUsedOfflineMode;

  const TutorialState({
    this.shownHints = const {},
    this.shownNudges = const {},
    this.hintsDisabled = false,
    this.unlockedAchievements = const {},
    this.lessonProgress = const {},
    this.totalSwipes = 0,
    this.totalLikes = 0,
    this.totalAnnotations = 0,
    this.modulesCompleted = 0,
    this.hasVisitedFamilyBoard = false,
    this.hasUsedForeclosureFilter = false,
    this.hasExportedPdf = false,
    this.hasUsedOfflineMode = false,
  });

  UserStats get userStats => UserStats(
        totalSwipes: totalSwipes,
        totalLikes: totalLikes,
        totalAnnotations: totalAnnotations,
        modulesCompleted: modulesCompleted,
        hasVisitedFamilyBoard: hasVisitedFamilyBoard,
        hasUsedForeclosureFilter: hasUsedForeclosureFilter,
        hasExportedPdf: hasExportedPdf,
        hasUsedOfflineMode: hasUsedOfflineMode,
        onboardingCompleted: true, // Assume completed if using app
      );

  TutorialState copyWith({
    Set<String>? shownHints,
    Set<String>? shownNudges,
    bool? hintsDisabled,
    Set<String>? unlockedAchievements,
    Map<String, int>? lessonProgress,
    int? totalSwipes,
    int? totalLikes,
    int? totalAnnotations,
    int? modulesCompleted,
    bool? hasVisitedFamilyBoard,
    bool? hasUsedForeclosureFilter,
    bool? hasExportedPdf,
    bool? hasUsedOfflineMode,
  }) {
    return TutorialState(
      shownHints: shownHints ?? this.shownHints,
      shownNudges: shownNudges ?? this.shownNudges,
      hintsDisabled: hintsDisabled ?? this.hintsDisabled,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      lessonProgress: lessonProgress ?? this.lessonProgress,
      totalSwipes: totalSwipes ?? this.totalSwipes,
      totalLikes: totalLikes ?? this.totalLikes,
      totalAnnotations: totalAnnotations ?? this.totalAnnotations,
      modulesCompleted: modulesCompleted ?? this.modulesCompleted,
      hasVisitedFamilyBoard: hasVisitedFamilyBoard ?? this.hasVisitedFamilyBoard,
      hasUsedForeclosureFilter:
          hasUsedForeclosureFilter ?? this.hasUsedForeclosureFilter,
      hasExportedPdf: hasExportedPdf ?? this.hasExportedPdf,
      hasUsedOfflineMode: hasUsedOfflineMode ?? this.hasUsedOfflineMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shownHints': shownHints.toList(),
      'shownNudges': shownNudges.toList(),
      'hintsDisabled': hintsDisabled,
      'unlockedAchievements': unlockedAchievements.toList(),
      'lessonProgress': lessonProgress,
      'totalSwipes': totalSwipes,
      'totalLikes': totalLikes,
      'totalAnnotations': totalAnnotations,
      'modulesCompleted': modulesCompleted,
      'hasVisitedFamilyBoard': hasVisitedFamilyBoard,
      'hasUsedForeclosureFilter': hasUsedForeclosureFilter,
      'hasExportedPdf': hasExportedPdf,
      'hasUsedOfflineMode': hasUsedOfflineMode,
    };
  }

  static TutorialState fromJson(Map<String, dynamic> json) {
    return TutorialState(
      shownHints: (json['shownHints'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {},
      shownNudges: (json['shownNudges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {},
      hintsDisabled: json['hintsDisabled'] as bool? ?? false,
      unlockedAchievements:
          (json['unlockedAchievements'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toSet() ??
              const {},
      lessonProgress: (json['lessonProgress'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          const {},
      totalSwipes: json['totalSwipes'] as int? ?? 0,
      totalLikes: json['totalLikes'] as int? ?? 0,
      totalAnnotations: json['totalAnnotations'] as int? ?? 0,
      modulesCompleted: json['modulesCompleted'] as int? ?? 0,
      hasVisitedFamilyBoard: json['hasVisitedFamilyBoard'] as bool? ?? false,
      hasUsedForeclosureFilter:
          json['hasUsedForeclosureFilter'] as bool? ?? false,
      hasExportedPdf: json['hasExportedPdf'] as bool? ?? false,
      hasUsedOfflineMode: json['hasUsedOfflineMode'] as bool? ?? false,
    );
  }
}
