# Specifications: OAuth Authentication (Google & Facebook)

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-02-04  
> Requirements: [01-requirements.md](./01-requirements.md)

## Overview

Опциональная OAuth-авторизация через Google и Facebook для облачных функций Deal Detective: синхронизация между устройствами, Family Board, резервное копирование. Firebase Auth — backend для credential management и account linking. Авторизация не обязательна; приложение полностью работает без неё.

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| `lib/features/auth/` | Create | AuthService, AuthState, OAuth logic |
| `lib/features/onboarding/screens/oauth_screen.dart` | Modify | Полная реализация UI |
| `lib/features/profile/screens/profile_screen.dart` | Modify | Account section |
| `lib/core/navigation/app_router.dart` | Modify | OAuth route (уже есть) |
| `lib/main.dart` | Modify | AuthProvider, Firebase init |
| `lib/features/onboarding/services/onboarding_service.dart` | Modify | Сохранять auth state |
| `android/app/` | Modify | google-services.json, SHA-1 |
| `ios/Runner/` | Modify | Info.plist URL schemes, GoogleService-Info.plist |

## Architecture

### Component Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         DEAL DETECTIVE APP                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  OAuthScreen ──────► AuthProvider ──────► AuthService                    │
│  ProfileScreen ────┤                      │                              │
│  (Settings)        │                      ├─► Google Sign-In SDK         │
│                    │                      ├─► Facebook Login SDK         │
│                    │                      └─► Firebase Auth              │
│                    │                                                     │
│  SyncManager ──────┴─► if signed in: enable cloud sync                   │
│  FamilyBoardService ─► if signed in: enable sharing                      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Data Flow

```
User taps "Войти через Google"
    │
    ▼
AuthService.signInWithGoogle()
    │
    ▼
Google Sign-In SDK (native dialog)
    │
    ▼
Firebase Auth: signInWithCredential(GoogleAuthProvider)
    │
    ▼
AuthState updated → UI reflects signed-in
    │
    ▼
On success: navigate to /onboarding/ready (or stay on Settings)
```

## Interfaces

### AuthService

```dart
// lib/features/auth/auth_service.dart

abstract class AuthService {
  Stream<AuthState> get authStateChanges;
  AuthState? get currentUser;

  Future<AuthResult> signInWithGoogle();
  Future<AuthResult> signInWithFacebook();
  Future<void> signOut();
  Future<void> deleteAccount();

  /// Link Facebook to existing Google account (or vice versa)
  Future<AuthResult> linkWithFacebook();
  Future<AuthResult> linkWithGoogle();
}

class AuthState {
  final String? userId;
  final String? email;
  final String? displayName;
  final List<String> linkedProviders; // ['google', 'facebook']
}

enum AuthResult { success, cancelled, error }
```

### AuthProvider (Provider)

```dart
// lib/features/auth/auth_provider.dart

class AuthProvider extends ChangeNotifier {
  AuthState? _state;
  AuthState? get state => _state;

  Future<void> signInWithGoogle() async { ... }
  Future<void> signInWithFacebook() async { ... }
  Future<void> signOut() async { ... }
  Future<void> deleteAccount() async { ... }
}
```

## Data Models

### UserPreferences Extension

- `authUserId` — Firebase UID when signed in
- `authEmail`, `authDisplayName` — for display
- `authProviders` — list of linked providers

### Persistence

- Firebase Auth maintains session (automatic)
- On sign-out: clear local auth fields, keep likes/annotations
- On delete: remove Firebase user + cloud data

## Behavior Specifications

### Happy Path: Google Sign-In

1. User taps "Войти через Google"
2. Google Sign-In SDK shows account picker
3. User selects account
4. Firebase Auth creates/links user
5. AuthProvider emits new AuthState
6. OAuthScreen shows brief "Успешно" → navigate to Ready
7. Settings shows user info

### Happy Path: Skip

1. User taps "Пропустить"
2. Navigate to Ready without auth
3. App works in local-only mode

### Edge Cases

| Case | Trigger | Expected Behavior |
|------|---------|-------------------|
| User cancels OAuth | Taps outside / Back | Stay on OAuth screen |
| Network error | No internet | Show error SnackBar, retry |
| Account exists (different provider) | Same email, different provider | Offer to link accounts |
| Facebook not configured | Missing App ID | Hide Facebook button or no-op |

### Error Handling

| Error | Cause | Response |
|-------|-------|----------|
| sign_in_failed | Credential invalid | SnackBar: "Ошибка входа. Попробуйте снова." |
| network_error | No connection | SnackBar: "Нет интернета" |
| account_exists_with_different_credential | Linking needed | Dialog: "Связать с Google?" |

### Delete Account

1. Settings → Delete Account
2. Confirmation dialog
3. Re-authenticate (Firebase reauthenticateWithCredential)
4. Delete Firebase user
5. Clear cloud data (Firestore, Storage — if implemented)
6. Sign out locally
7. Optional: keep local data with warning

## Dependencies

### Pubspec

- `firebase_core`: ^3.8.1
- `firebase_auth`: ^5.3.4
- `google_sign_in`: ^6.2.2
- `flutter_facebook_auth`: ^7.0.0

### Requires

- Firebase project with Auth enabled
- Google Cloud Console: OAuth 2.0 client IDs (Web, iOS, Android)
- Facebook Developer App: Login product, App ID, Client Token
- iOS: URL scheme for Google, Info.plist Facebook/Google keys
- Android: SHA-1 in Firebase Console, google-services.json

## Integration Points

### Onboarding Flow

```
TutorialScreen → _complete() → context.push('/onboarding/oauth')
OAuthScreen → Skip → context.pushReplacement('/onboarding/ready')
OAuthScreen → Success → context.pushReplacement('/onboarding/ready')
```

### Settings (ProfileScreen)

- Account section: Not signed in / Signed in state
- Sign In button → Navigate to OAuthScreen (or show bottom sheet)
- Sign Out, Delete Account

### SyncManager / FamilyBoardService

- Check `AuthProvider.state != null` before cloud operations
- When signed in: enable sync
- When signed out: disable sync, keep local

## Platform Configuration

### iOS

- Info.plist: `CFBundleURLTypes` for Google URL scheme
- Info.plist: `FacebookAppID`, `FacebookClientToken`, `FacebookDisplayName`
- GoogleService-Info.plist
- URL scheme: `com.googleusercontent.apps.XXX`

### Android

- build.gradle: google-services plugin
- strings.xml or build.gradle: `default_web_client_id` (from Firebase)
- Facebook: meta-data in AndroidManifest
- SHA-1 in Firebase Console

## Testing Strategy

### Unit Tests

- [ ] AuthService — mock Firebase/Google/Facebook, verify calls
- [ ] AuthProvider — state transitions

### Integration Tests

- [ ] Sign-in flow with mock credentials (if possible)

### Manual Verification

- [ ] Google Sign-In on device
- [ ] Facebook Sign-In on device
- [ ] Skip works
- [ ] Sign Out from Settings
- [ ] Delete Account flow

## Migration / Rollout

- OAuthScreen already exists (placeholder)
- Can ship with Skip-only (buttons no-op until SDK integrated)
- Firebase must be configured before auth works

## Open Design Questions

- [ ] Apple Sign-In required if other social logins? (App Store guideline)
- [ ] Keep local data after Delete Account?
- [ ] Show OAuth on reinstall if returning user?

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
