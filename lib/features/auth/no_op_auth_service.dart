import 'dart:async';

import 'auth_service.dart';
import 'auth_state.dart';

/// No-op [AuthService] when Firebase is not configured.
/// Sign-in methods return [AuthResult.cancelled]; state stays signed out.
class NoOpAuthService implements AuthService {
  NoOpAuthService() : _controller = StreamController<AuthState>.broadcast();

  final StreamController<AuthState> _controller;

  @override
  Stream<AuthState> get authStateChanges => _controller.stream;

  @override
  AuthState? get currentUser => null;

  @override
  Future<AuthResult> signInWithGoogle() async => AuthResult.cancelled;

  @override
  Future<AuthResult> signInWithFacebook() async => AuthResult.cancelled;

  @override
  Future<void> signOut() async {}

  @override
  Future<AuthResult> deleteAccount() async => AuthResult.cancelled;

  @override
  Future<AuthResult> linkWithFacebook() async => AuthResult.cancelled;

  @override
  Future<AuthResult> linkWithGoogle() async => AuthResult.cancelled;

  @override
  Future<AuthResult> completeLinkBySigningInWithGoogle() async =>
      AuthResult.cancelled;

  @override
  Future<AuthResult> completeLinkBySigningInWithFacebook() async =>
      AuthResult.cancelled;

  @override
  String? get pendingLinkExistingProvider => null;

  @override
  void dispose() {}
}
