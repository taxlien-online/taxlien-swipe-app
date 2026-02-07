import 'user_stats.dart';

/// Definition of a feature-discovery nudge: when to show and its id for l10n.
class NudgeDefinition {
  final String id;
  final bool Function(UserStats stats, {required bool isBeginnerMode}) condition;

  const NudgeDefinition({
    required this.id,
    required this.condition,
  });
}

/// Ordered list: first matching and not yet shown is returned.
List<NudgeDefinition> get nudgeDefinitions => [
      NudgeDefinition(
        id: 'expert_mode',
        condition: (s, {required isBeginnerMode}) =>
            isBeginnerMode && s.totalSwipes >= 50,
      ),
      NudgeDefinition(
        id: 'annotation',
        condition: (s, {required isBeginnerMode}) =>
            s.totalLikes >= 10 && s.totalAnnotations == 0,
      ),
      NudgeDefinition(
        id: 'foreclosure_filter',
        condition: (s, {required isBeginnerMode}) =>
            s.totalSwipes >= 20 && !s.hasUsedForeclosureFilter,
      ),
      NudgeDefinition(
        id: 'family_board',
        condition: (s, {required isBeginnerMode}) =>
            s.totalLikes >= 5 && !s.hasVisitedFamilyBoard,
      ),
    ];
