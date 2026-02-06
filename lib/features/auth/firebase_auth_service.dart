import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'auth_service.dart';
import 'auth_state.dart';

/// Firebase Auth implementation of [AuthService].
/// Requires [Firebase.initializeApp()] to have been called (e.g. with platform config files).
class FirebaseAuthService implements AuthService {
  FirebaseAuthService({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn() {
    _subscription = _auth.authStateChanges().listen(_onAuthStateChanged);
    _onAuthStateChanged(_auth.currentUser);
  }

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  late final StreamSubscription<User?> _subscription;

  final StreamController<AuthState> _stateController =
      StreamController<AuthState>.broadcast();

  AuthState? _cachedState;

  void _onAuthStateChanged(User? user) {
    final state = user == null
        ? null
        : AuthState(
            userId: user.uid,
            email: user.email,
            displayName: user.displayName,
            linkedProviders: user.providerData
                .map((e) => e.providerId == 'google.com'
                    ? 'google'
                    : e.providerId == 'facebook.com'
                        ? 'facebook'
                        : e.providerId)
                .toSet()
                .toList(),
          );
    _cachedState = state;
    _stateController.add(state ?? const AuthState());
  }

  @override
  Stream<AuthState> get authStateChanges => _stateController.stream;

  @override
  AuthState? get currentUser {
    if (_cachedState != null) return _cachedState;
    final user = _auth.currentUser;
    if (user == null) return null;
    _onAuthStateChanged(user);
    return _cachedState;
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return AuthResult.cancelled;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return AuthResult.error; // Caller may offer linking
      }
      return AuthResult.error;
    } catch (_) {
      return AuthResult.error;
    }
  }

  @override
  Future<AuthResult> signInWithFacebook() async {
    try {
      final loginResult = await FacebookAuth.instance.login();
      if (loginResult.status != LoginStatus.success) {
        return loginResult.status == LoginStatus.cancelled
            ? AuthResult.cancelled
            : AuthResult.error;
      }
      final accessToken = loginResult.accessToken;
      if (accessToken == null) return AuthResult.error;

      final credential =
          FacebookAuthProvider.credential(accessToken.tokenString);
      await _auth.signInWithCredential(credential);
      return AuthResult.success;
    } on FirebaseAuthException catch (_) {
      return AuthResult.error;
    } catch (_) {
      return AuthResult.error;
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
      FacebookAuth.instance.logOut(),
    ]);
  }

  @override
  Future<AuthResult> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return AuthResult.error;
    try {
      await user.delete();
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return AuthResult.requiresRecentLogin;
      }
      return AuthResult.error;
    } catch (_) {
      return AuthResult.error;
    }
  }

  @override
  Future<AuthResult> linkWithFacebook() async {
    try {
      final loginResult = await FacebookAuth.instance.login();
      if (loginResult.status != LoginStatus.success ||
          loginResult.accessToken == null) {
        return loginResult.status == LoginStatus.cancelled
            ? AuthResult.cancelled
            : AuthResult.error;
      }
      final credential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
      await _auth.currentUser?.linkWithCredential(credential);
      return AuthResult.success;
    } catch (_) {
      return AuthResult.error;
    }
  }

  @override
  Future<AuthResult> linkWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return AuthResult.cancelled;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.currentUser?.linkWithCredential(credential);
      return AuthResult.success;
    } catch (_) {
      return AuthResult.error;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _stateController.close();
  }
}
