import 'expert_role.dart';
import 'swipe_mode.dart';

class UserPreferences {
  final String userId;
  final String userName;
  final ExpertRole role;
  final SwipeMode swipeMode;
  final List<String> interests;

  UserPreferences({
    required this.userId,
    required this.userName,
    this.role = ExpertRole.guest,
    this.swipeMode = SwipeMode.beginner,
    this.interests = const [],
  });

  UserPreferences copyWith({
    String? userId,
    String? userName,
    ExpertRole? role,
    SwipeMode? swipeMode,
    List<String>? interests,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      role: role ?? this.role,
      swipeMode: swipeMode ?? this.swipeMode,
      interests: interests ?? this.interests,
    );
  }
}
