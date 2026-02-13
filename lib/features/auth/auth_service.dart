import 'auth_state.dart';

/// Abstraction for OAuth (Google/Facebook) and session management.
/// Implement with Firebase Auth or no-op when Firebase is not configured.
abstract class AuthService {
  Stream<AuthState> get authStateChanges;
  AuthState? get currentUser;

  Future<AuthResult> signInWithGoogle();
  Future<AuthResult> signInWithFacebook();
  Future<void> signOut();
  /// Returns [AuthResult.requiresRecentLogin] when Firebase demands re-auth before delete.
  Future<AuthResult> deleteAccount();

  /// Link Facebook to existing Google account (or vice versa).
  Future<AuthResult> linkWithFacebook();
  Future<AuthResult> linkWithGoogle();

  /// When [accountExistsWithDifferentCredential], sign in with existing provider then link.
  Future<AuthResult> completeLinkBySigningInWithGoogle();
  Future<AuthResult> completeLinkBySigningInWithFacebook();

  /// Provider to use for linking when pending (e.g. 'google' when user tried Facebook).
  String? get pendingLinkExistingProvider;

  /// Release resources (e.g. stream subscriptions). No-op for stateless implementations.
  void dispose();
}
