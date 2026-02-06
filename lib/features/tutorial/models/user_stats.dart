/// Aggregated user activity stats for achievement and nudge logic.
class UserStats {
  final int totalSwipes;
  final int totalLikes;
  final int totalAnnotations;
  final int modulesCompleted;
  final bool hasVisitedFamilyBoard;
  final bool hasUsedForeclosureFilter;
  final bool hasExportedPdf;
  final bool hasUsedOfflineMode;
  final bool onboardingCompleted;

  const UserStats({
    this.totalSwipes = 0,
    this.totalLikes = 0,
    this.totalAnnotations = 0,
    this.modulesCompleted = 0,
    this.hasVisitedFamilyBoard = false,
    this.hasUsedForeclosureFilter = false,
    this.hasExportedPdf = false,
    this.hasUsedOfflineMode = false,
    this.onboardingCompleted = false,
  });
}
