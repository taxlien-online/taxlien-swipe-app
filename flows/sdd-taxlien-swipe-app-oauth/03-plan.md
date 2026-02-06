# Implementation Plan: OAuth Authentication

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-02-04  
> Specifications: [02-specifications.md](./02-specifications.md)

## Summary

Реализация OAuth: AuthService, AuthProvider, обновление OAuthScreen и ProfileScreen, интеграция Google Sign-In и Facebook Login с Firebase Auth.

## Task Breakdown

### Phase 1: Foundation

#### Task 1.1: Add dependencies
- **Description**: firebase_core, firebase_auth, google_sign_in, flutter_facebook_auth
- **Files**: `pubspec.yaml`
- **Dependencies**: None
- **Verification**: flutter pub get
- **Complexity**: Low

#### Task 1.2: Firebase project setup
- **Description**: Firebase Console — Auth enabled, google-services.json, GoogleService-Info.plist
- **Files**: android/app/, ios/Runner/
- **Dependencies**: Task 1.1
- **Verification**: App builds
- **Complexity**: Medium

#### Task 1.3: Create AuthService and AuthProvider
- **Description**: AuthService interface, FirebaseAuthService impl, AuthProvider
- **Files**:
  - `lib/features/auth/auth_service.dart` — Create
  - `lib/features/auth/auth_state.dart` — Create
  - `lib/features/auth/auth_provider.dart` — Create
- **Dependencies**: Task 1.1
- **Verification**: Unit test with mocks
- **Complexity**: Medium

### Phase 2: Google Sign-In

#### Task 2.1: Google Cloud Console setup
- **Description**: OAuth 2.0 client IDs (Web, iOS, Android)
- **Files**: N/A (manual)
- **Dependencies**: Task 1.2
- **Verification**: Credentials in Firebase
- **Complexity**: Medium

#### Task 2.2: Implement signInWithGoogle
- **Description**: Google Sign-In flow → Firebase credential
- **Files**: `lib/features/auth/firebase_auth_service.dart`
- **Dependencies**: Task 1.3, 2.1
- **Verification**: Sign-in works on device
- **Complexity**: Medium

#### Task 2.3: iOS/Android config for Google
- **Description**: URL scheme (iOS), default_web_client_id (Android)
- **Files**: ios/Runner/Info.plist, android/build.gradle
- **Dependencies**: Task 2.1
- **Verification**: Google picker opens
- **Complexity**: Low

### Phase 3: Facebook Login

#### Task 3.1: Facebook Developer App setup
- **Description**: App ID, Client Token, Login product
- **Files**: N/A (manual)
- **Dependencies**: None
- **Verification**: App configured
- **Complexity**: Medium

#### Task 3.2: Implement signInWithFacebook
- **Description**: Facebook Login flow → Firebase credential
- **Files**: `lib/features/auth/firebase_auth_service.dart`
- **Dependencies**: Task 1.3, 3.1
- **Verification**: Sign-in works on device
- **Complexity**: Medium

#### Task 3.3: Platform config for Facebook
- **Description**: Info.plist (iOS), AndroidManifest (Android)
- **Files**: ios/Runner/Info.plist, android/.../AndroidManifest.xml
- **Dependencies**: Task 3.1
- **Verification**: Facebook dialog opens
- **Complexity**: Low

### Phase 4: OAuth Screen

#### Task 4.1: OAuthScreen full UI
- **Description**: Benefits list, Google/Facebook buttons, Skip, layout from requirements
- **Files**: `lib/features/onboarding/screens/oauth_screen.dart`
- **Dependencies**: Task 1.3
- **Verification**: UI matches spec
- **Complexity**: Medium

#### Task 4.2: Wire OAuthScreen to AuthProvider
- **Description**: Buttons call signInWithGoogle/Facebook, handle result, navigate
- **Files**: `lib/features/onboarding/screens/oauth_screen.dart`
- **Dependencies**: Task 2.2, 3.2, 4.1
- **Verification**: Full flow works
- **Complexity**: Medium

### Phase 5: Settings Integration

#### Task 5.1: ProfileScreen Account section
- **Description**: Not signed in / Signed in states, Sign In, Sign Out, Delete Account
- **Files**: `lib/features/profile/screens/profile_screen.dart`
- **Dependencies**: Task 1.3
- **Verification**: Account UI visible
- **Complexity**: Medium

#### Task 5.2: Sign Out and Delete Account
- **Description**: Implement signOut, deleteAccount, confirmation dialogs
- **Files**: AuthProvider, ProfileScreen
- **Dependencies**: Task 5.1
- **Verification**: Sign out works, delete requires re-auth
- **Complexity**: Medium

### Phase 6: Account Linking

#### Task 6.1: Link providers (same email)
- **Description**: When user signs in with different provider, offer to link
- **Files**: `lib/features/auth/firebase_auth_service.dart`
- **Dependencies**: Task 2.2, 3.2
- **Verification**: Link flow works
- **Complexity**: Medium

### Phase 7: Sync Integration

#### Task 7.1: SyncManager/FamilyBoard auth check
- **Description**: Enable cloud sync only when signed in
- **Files**: `lib/services/sync_manager.dart`, family board
- **Dependencies**: Task 1.3
- **Verification**: Sync disabled when not signed in
- **Complexity**: Low

### Phase 8: Testing

#### Task 8.1: Unit tests
- **Description**: AuthService, AuthProvider tests
- **Files**: `test/unit_tests/auth_service_test.dart`
- **Dependencies**: Phase 1–6
- **Verification**: Tests pass
- **Complexity**: Medium

## Dependency Graph

```
1.1 ─┬─→ 1.2 ────────────────────────────────────────
     │
     └─→ 1.3 ─┬─→ 2.2 ─┬─→ 4.2
              │        │
              ├─→ 3.2 ─┘
              │
2.1 ─→ 2.2    ├─→ 4.1 ─→ 4.2
2.3 ─→ 2.2    │
              ├─→ 5.1 ─→ 5.2
3.1 ─→ 3.2    ├─→ 6.1
3.3 ─→ 3.2    └─→ 7.1

Phase 8 after Phase 7
```

## File Change Summary

| File | Action |
|------|--------|
| pubspec.yaml | Modify |
| lib/features/auth/auth_service.dart | Create |
| lib/features/auth/auth_state.dart | Create |
| lib/features/auth/auth_provider.dart | Create |
| lib/features/auth/firebase_auth_service.dart | Create |
| lib/features/onboarding/screens/oauth_screen.dart | Modify |
| lib/features/profile/screens/profile_screen.dart | Modify |
| lib/main.dart | Modify (AuthProvider) |
| lib/services/sync_manager.dart | Modify |
| ios/Runner/Info.plist | Modify |
| android/.../AndroidManifest.xml | Modify |

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Apple Sign-In required | Med | High | Add if rejected |
| Config leaks | Low | High | .gitignore, CI secrets |

## Rollback Strategy

1. OAuthScreen: revert to placeholder (Skip only)
2. Remove AuthProvider from main
3. Remove packages

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
