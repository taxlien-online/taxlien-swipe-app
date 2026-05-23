/// Result of a sign-in, link, or delete operation.
enum AuthResult {
  success,
  cancelled,
  error,
  /// Delete account failed because Firebase requires recent login (re-auth).
  requiresRecentLogin,
  /// Same email exists with different provider; caller should offer linking.
  accountExistsWithDifferentCredential,
}

/// Current auth state (signed-in user info or signed out).
class AuthState {
  const AuthState({
    this.userId,
    this.email,
    this.displayName,
    this.linkedProviders = const [],
  });

  final String? userId;
  final String? email;
  final String? displayName;
  final List<String> linkedProviders;

  bool get isSignedIn => userId != null && userId!.isNotEmpty;

  AuthState copyWith({
    String? userId,
    String? email,
    String? displayName,
    List<String>? linkedProviders,
  }) {
    return AuthState(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      linkedProviders: linkedProviders ?? this.linkedProviders,
    );
  }
}
