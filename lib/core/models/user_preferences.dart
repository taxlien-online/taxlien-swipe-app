import 'expert_role.dart';
import 'swipe_mode.dart';

class UserPreferences {
  final String userId;
  final String userName;
  final ExpertRole role;
  final SwipeMode swipeMode;
  final List<String> interests;

  // Geography settings
  final List<String> states;   // ['AZ', 'FL'] or empty = search everywhere
  final List<String> counties; // ['Maricopa', 'Pinal'] or empty = whole state

  // Onboarding status
  final bool onboardingCompleted;
  final DateTime? onboardingCompletedAt;

  UserPreferences({
    required this.userId,
    required this.userName,
    this.role = ExpertRole.guest,
    this.swipeMode = SwipeMode.beginner,
    this.interests = const [],
    this.states = const [],
    this.counties = const [],
    this.onboardingCompleted = false,
    this.onboardingCompletedAt,
  });

  /// Default preferences for skip onboarding
  factory UserPreferences.defaults() {
    return UserPreferences(
      userId: 'guest',
      userName: 'Guest',
      role: ExpertRole.guest,
      swipeMode: SwipeMode.beginner,
      interests: const [],
      states: const [],        // Search everywhere
      counties: const [],
      onboardingCompleted: true,
      onboardingCompletedAt: DateTime.now(),
    );
  }

  UserPreferences copyWith({
    String? userId,
    String? userName,
    ExpertRole? role,
    SwipeMode? swipeMode,
    List<String>? interests,
    List<String>? states,
    List<String>? counties,
    bool? onboardingCompleted,
    DateTime? onboardingCompletedAt,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      role: role ?? this.role,
      swipeMode: swipeMode ?? this.swipeMode,
      interests: interests ?? this.interests,
      states: states ?? this.states,
      counties: counties ?? this.counties,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      onboardingCompletedAt: onboardingCompletedAt ?? this.onboardingCompletedAt,
    );
  }

  /// Check if searching everywhere (no state filter)
  bool get isSearchingEverywhere => states.isEmpty;

  /// Check if searching whole state (no county filter)
  bool get isSearchingWholeState => counties.isEmpty;
}
