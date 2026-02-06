# Status: sdd-taxlien-swipe-app-oauth

## Current Phase

REQUIREMENTS | **SPECIFICATIONS** | **PLAN** | IMPLEMENTATION

## Phase Status

**DRAFTING** | REVIEW | APPROVED | BLOCKED

## Last Updated

2026-02-03 by Claude

## Blockers

- None

## Progress

- [x] Requirements drafted
- [x] Specifications drafted
- [x] Plan drafted
- [x] Implementation started (placeholder OAuth screen in onboarding flow)
- [x] AuthService, AuthProvider, FirebaseAuthService, NoOpAuthService
- [x] OAuthScreen wired to AuthProvider (Google/Facebook buttons, Skip, success/error handling)
- [ ] Task 1.2: Firebase project setup (manual)
- [ ] Tasks 2.1–2.3: Google Sign-In config (OAuth client IDs, iOS/Android)
- [ ] Tasks 3.1–3.3: Facebook Login config
- [x] Tasks 5.1–5.2: ProfileScreen Account section (Sign In / Out, Delete)
- [x] Task 7.1: SyncManager auth check (enable sync only when signed in)

## Context Notes

Key decisions and context for resuming:

- OAuth via Google and Facebook for cloud features
- Optional step at end of onboarding (can skip)
- AuthService chosen at startup: FirebaseAuthService when Firebase.apps.isNotEmpty, else NoOpAuthService
- flutter_facebook_auth AccessToken uses `tokenString`, not `token`

## Integration Point

```
ONBOARDING FLOW (updated):
Welcome → Mode → [Role] → Geography → [County] → Tutorial →
→ **[OAuth - optional]** → Ready → Home
```

## References

- `sdd-taxlien-swipe-app-onboarding` - Onboarding flow
- `sdd-taxlien-swipe-app-facebookappevents` - Facebook SDK (shares config)
- `sdd-taxlien-swipe-app-firebaseanalytics` - Firebase (shares config)

## Next Actions

1. (Manual) Task 1.2: Add google-services.json / GoogleService-Info.plist if not present; enable Auth in Firebase Console
2. Tasks 2.1–2.3: Google Cloud OAuth client IDs, iOS URL scheme, Android default_web_client_id
3. Tasks 3.1–3.3: Facebook Developer App, Info.plist / AndroidManifest
4. Task 6.1: Account linking (same email, different provider)
