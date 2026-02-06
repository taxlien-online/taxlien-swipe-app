import 'dart:async';

import 'package:flutter/foundation.dart';

import 'auth_service.dart';
import 'auth_state.dart';

/// Provider that exposes [AuthState] and auth actions to the UI.
class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthService authService})
      : _authService = authService,
        _state = authService.currentUser {
    _subscription = authService.authStateChanges.listen((state) {
      _state = state.isSignedIn ? state : null;
      notifyListeners();
    });
  }

  final AuthService _authService;
  StreamSubscription<AuthState>? _subscription;
  AuthState? _state;

  AuthState? get state => _state;

  bool get isSignedIn => _state?.isSignedIn ?? false;

  Future<AuthResult> signInWithGoogle() async {
    final result = await _authService.signInWithGoogle();
    if (result == AuthResult.success) notifyListeners();
    return result;
  }

  Future<AuthResult> signInWithFacebook() async {
    final result = await _authService.signInWithFacebook();
    if (result == AuthResult.success) notifyListeners();
    return result;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  Future<AuthResult> deleteAccount() async {
    final result = await _authService.deleteAccount();
    if (result == AuthResult.success) notifyListeners();
    return result;
  }

  Future<AuthResult> linkWithFacebook() async {
    final result = await _authService.linkWithFacebook();
    if (result == AuthResult.success) notifyListeners();
    return result;
  }

  Future<AuthResult> linkWithGoogle() async {
    final result = await _authService.linkWithGoogle();
    if (result == AuthResult.success) notifyListeners();
    return result;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _authService.dispose();
    super.dispose();
  }
}
