# Requirements: OAuth Authentication (Google & Facebook)

**Version:** 1.0
**Status:** DRAFT
**Last Updated:** 2026-02-03

---

## Problem Statement

Deal Detective нуждается в опциональной авторизации для облачных функций:
- **Cloud Sync** - синхронизация likes, annotations между устройствами
- **Family Sharing** - общий доступ к Family Board для членов семьи
- **Cross-device** - продолжить работу на другом устройстве
- **Backup** - сохранение данных при переустановке

**Принцип:** Авторизация **опциональна**. Приложение полностью функционально без неё (локальный режим).

---

## Позиционирование в Onboarding

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ONBOARDING FLOW                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Welcome → Mode → [Role] → Geography → [County] → Tutorial                  │
│                                                                             │
│                                    ↓                                        │
│                                                                             │
│                    ┌──────────────────────────────┐                        │
│                    │   🔐 OAUTH SCREEN (NEW)      │                        │
│                    │                              │                        │
│                    │   Последний шаг перед Ready  │                        │
│                    │   Можно пропустить           │                        │
│                    │                              │                        │
│                    └──────────────────────────────┘                        │
│                                                                             │
│                                    ↓                                        │
│                                                                             │
│                               Ready → Home                                  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## User Stories

### US-1: OAuth Screen in Onboarding

**As a** новый пользователь завершающий онбординг
**I want** понять зачем нужна авторизация и решить входить или нет
**So that** могу сделать осознанный выбор

**Screen Design:**
```
┌─────────────────────────────────────────────────────────────────────────────┐
│  ←                                              [ Пропустить → ]           │
│                                                                             │
│                              ☁️                                             │
│                                                                             │
│                    Синхронизация и облако                                   │
│                                                                             │
│         Войдите, чтобы разблокировать:                                     │
│                                                                             │
│         ┌─────────────────────────────────────────────────────────────┐    │
│         │  ☁️  Синхронизация между устройствами                       │    │
│         │      Ваши likes и заметки доступны везде                    │    │
│         └─────────────────────────────────────────────────────────────┘    │
│                                                                             │
│         ┌─────────────────────────────────────────────────────────────┐    │
│         │  👨‍👩‍👧  Family Board                                           │    │
│         │      Делитесь находками с семьёй                           │    │
│         └─────────────────────────────────────────────────────────────┘    │
│                                                                             │
│         ┌─────────────────────────────────────────────────────────────┐    │
│         │  💾  Резервное копирование                                  │    │
│         │      Данные сохранятся при переустановке                   │    │
│         └─────────────────────────────────────────────────────────────┘    │
│                                                                             │
│                                                                             │
│         ┌─────────────────────────────────────────────────────────────┐    │
│         │  [G]  Войти через Google                                    │    │
│         └─────────────────────────────────────────────────────────────┘    │
│                                                                             │
│         ┌─────────────────────────────────────────────────────────────┐    │
│         │  [f]  Войти через Facebook                                  │    │
│         └─────────────────────────────────────────────────────────────┘    │
│                                                                             │
│                                                                             │
│              Вы можете войти позже в Настройках                            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Acceptance Criteria:**
- [ ] Экран показывается после Tutorial, перед Ready
- [ ] Skip button ("Пропустить →") всегда доступен
- [ ] Краткое описание benefits (3 пункта)
- [ ] Кнопки Google и Facebook Sign-In
- [ ] Текст "Войти позже в Настройках" внизу
- [ ] При skip → переход на Ready screen без авторизации

---

### US-2: Google Sign-In

**As a** пользователь с Google аккаунтом
**I want** войти через Google
**So that** использую существующий аккаунт

**Flow:**
```
1. Tap "Войти через Google"
2. System OAuth dialog (Google Sign-In SDK)
3. User selects/enters Google account
4. On success → show brief confirmation → proceed to Ready
5. On cancel → stay on OAuth screen
6. On error → show error message, allow retry
```

**Acceptance Criteria:**
- [ ] Google Sign-In SDK интегрирован
- [ ] Запрашиваем только email и profile (minimal scope)
- [ ] После успеха: сохраняем user ID, email, display name
- [ ] Firebase Auth используется как backend
- [ ] Error handling: network error, cancelled, account conflict

---

### US-3: Facebook Login

**As a** пользователь с Facebook аккаунтом
**I want** войти через Facebook
**So that** использую существующий аккаунт

**Flow:**
```
1. Tap "Войти через Facebook"
2. Facebook Login SDK dialog
3. User authorizes app
4. On success → show brief confirmation → proceed to Ready
5. On cancel → stay on OAuth screen
6. On error → show error message, allow retry
```

**Acceptance Criteria:**
- [ ] Facebook Login SDK интегрирован
- [ ] Запрашиваем только public_profile и email
- [ ] После успеха: сохраняем user ID, email, name
- [ ] Firebase Auth используется как backend (link with Facebook credential)
- [ ] Error handling: network error, cancelled, account exists with different provider

---

### US-4: Account Linking

**As a** пользователь с несколькими аккаунтами
**I want** связать Google и Facebook с одним профилем
**So that** могу входить любым способом

**Scenarios:**
| Situation | Behavior |
|-----------|----------|
| New user, Google login | Create new Firebase user |
| New user, Facebook login | Create new Firebase user |
| Existing Google user, Facebook login (same email) | Link accounts |
| Existing Facebook user, Google login (same email) | Link accounts |
| Different emails | Separate accounts (or offer to link) |

**Acceptance Criteria:**
- [ ] Firebase Auth handles account linking
- [ ] If email matches existing account → offer to link
- [ ] User can have both providers linked
- [ ] Settings screen shows linked providers

---

### US-5: Sign In from Settings (Post-Onboarding)

**As a** пользователь который пропустил авторизацию
**I want** войти позже из Настроек
**So that** получаю cloud features когда готов

**Settings Screen Addition:**
```
┌─────────────────────────────────────────────────────────────────────────────┐
│  ←  Settings                                                                │
│                                                                             │
│  ─────────────────────────────────────────────────────────────────────────  │
│                                                                             │
│  ACCOUNT                                                                    │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Not signed in                                                      │   │
│  │                                                                      │   │
│  │  Sign in to enable cloud sync and Family Board                      │   │
│  │                                                                      │   │
│  │  [ Sign In ]                                                        │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ─────────────────────────────────────────────────────────────────────────  │
│                                                                             │
│  ... other settings ...                                                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘

// After sign in:
┌─────────────────────────────────────────────────────────────────────────────┐
│  ACCOUNT                                                                    │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  👤 John Doe                                                        │   │
│  │     john.doe@gmail.com                                              │   │
│  │                                                                      │   │
│  │  Connected:  [G] Google  [f] Facebook                               │   │
│  │                                                                      │   │
│  │  [ Sign Out ]    [ Delete Account ]                                 │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Acceptance Criteria:**
- [ ] Settings → Account section
- [ ] Not signed in: show benefits + Sign In button
- [ ] Signed in: show user info + linked providers
- [ ] Sign Out функциональность
- [ ] Delete Account (GDPR compliance)

---

### US-6: Sign Out & Data Handling

**As a** авторизованный пользователь
**I want** выйти из аккаунта
**So that** могу использовать другой аккаунт или работать локально

**Behavior:**
```
Sign Out:
├── Clear auth tokens
├── Keep local data (likes, annotations)
├── Stop cloud sync
├── Show "Not signed in" state
└── Offer to sign in again

Data remains local until:
├── User signs in again → sync resumes
└── User explicitly deletes local data
```

**Acceptance Criteria:**
- [ ] Sign Out не удаляет локальные данные
- [ ] После Sign Out приложение работает в offline режиме
- [ ] При повторном Sign In → данные синхронизируются

---

### US-7: Delete Account

**As a** пользователь
**I want** удалить свой аккаунт и данные
**So that** мои данные не хранятся в облаке

**Flow:**
```
1. Settings → Account → Delete Account
2. Confirmation dialog: "Вы уверены? Это удалит все ваши данные из облака."
3. Require re-authentication (security)
4. Delete:
   ├── Firebase Auth user
   ├── Cloud Firestore user data
   ├── Cloud Storage user files
   └── (Optional) Keep local data with warning
5. Sign out locally
```

**Acceptance Criteria:**
- [ ] Double confirmation required
- [ ] Re-authentication before delete
- [ ] All cloud data deleted
- [ ] Local data optionally kept
- [ ] GDPR/CCPA compliant

---

## Cloud Features Enabled by Auth

| Feature | Without Auth | With Auth |
|---------|--------------|-----------|
| Swipe & Like | ✅ Local only | ✅ + Cloud sync |
| Annotations | ✅ Local only | ✅ + Cloud sync |
| Family Board | ❌ Not available | ✅ Share with family |
| Cross-device | ❌ No | ✅ Yes |
| Backup | ❌ Manual export | ✅ Automatic |
| Offline mode | ✅ Full functionality | ✅ Syncs when online |

---

## Technical Constraints

### Configuration Sources

```
.env (local development):
├── GOOGLE_WEB_CLIENT_ID=xxx.apps.googleusercontent.com
├── GOOGLE_IOS_CLIENT_ID=xxx.apps.googleusercontent.com
├── FACEBOOK_APP_ID=123456789
└── FACEBOOK_CLIENT_TOKEN=abc123

GitHub Secrets (CI/CD):
├── Same variables as above

Firebase Config:
├── google-services.json (Android)
└── GoogleService-Info.plist (iOS)
```

### Packages

- `google_sign_in` - Google OAuth
- `flutter_facebook_auth` - Facebook OAuth
- `firebase_auth` - Backend auth management
- `cloud_firestore` - User data storage (future)

### Platform Requirements

**iOS:**
- Info.plist: URL schemes for Google & Facebook
- GoogleService-Info.plist
- Facebook App ID in Info.plist

**Android:**
- google-services.json
- Facebook App ID in strings.xml
- SHA-1 fingerprint in Firebase Console

---

## Analytics Events

| Event | Parameters | When |
|-------|------------|------|
| `auth_screen_viewed` | `from: onboarding/settings` | OAuth screen shown |
| `auth_started` | `provider: google/facebook` | Button tapped |
| `auth_success` | `provider, is_new_user` | Login successful |
| `auth_failed` | `provider, error_type` | Login failed |
| `auth_cancelled` | `provider` | User cancelled |
| `auth_skipped` | - | Skip in onboarding |
| `sign_out` | - | User signed out |
| `account_deleted` | - | Account deleted |

---

## Dependencies

### Requires
- Firebase project with Auth enabled
- Google Cloud Console OAuth credentials
- Facebook Developer App with Login enabled
- `sdd-taxlien-swipe-app-onboarding` - integration point

### Blocks
- Family Board feature (needs auth for sharing)
- Cloud sync feature
- Cross-device continuity

---

## Out of Scope (This Iteration)

- Apple Sign-In (can add later)
- Email/Password authentication
- Phone number authentication
- Two-factor authentication
- Social features beyond Family Board

---

## Open Questions

- [ ] Нужен ли Apple Sign-In? (required for iOS if other social logins present)
- [ ] Хранить ли локальные данные после Delete Account?
- [ ] Показывать ли OAuth screen если user returning (reinstall)?

---

## References

- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Facebook Auth for Flutter](https://pub.dev/packages/flutter_facebook_auth)
- [Firebase Auth](https://pub.dev/packages/firebase_auth)
- `sdd-taxlien-swipe-app-onboarding` - Onboarding flow

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
