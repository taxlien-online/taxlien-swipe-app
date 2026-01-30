# Requirements: Swipe App Onboarding

**Version:** 0.1
**Status:** 🟡 DRAFT

## Context
First impressions matter. This flow defines how users (Family Members) enter the application, choose their "Lens" (Role), and select their interface complexity (Swipe Mode).

## User Stories

### US-1: Role Selection (The Lens)
- As a user, I need to identify who I am (Miw, Denis, Khun Pho, Anton, or Guest) so the app can adapt the content.
- **Visuals:** Avatar selection.
- **Outcome:** Sets `UserPreferences.role`.

### US-2: Mode Selection (The Complexity)
- As a user, I want to choose between "Simple" (Beginner) and "Advanced" (Expert) modes.
- **UI:** Two large cards with animated previews of the gestures.
    - "Simple": Show Tinder-like swipe animation.
    - "Advanced": Show 4-way navigation animation.
- **Outcome:** Sets `UserPreferences.swipeMode`.

### US-3: Interactive Tutorial
- After selection, the user must practice the gestures of their chosen mode on 3 dummy cards.
- **Constraint:** User cannot proceed until they successfully perform the gestures (Like, Pass, Zoom, etc.).

### US-4: Interest Setup (Quick Start)
- Optional step to select initial interests (e.g., "Vintage Cars", "Cheap Land", "Solid Houses") to seed the ML model.

## Integration
- Outcomes of this flow are stored in `UserPreferences` and persist across sessions.
- Leads directly to `sdd-taxlien-swipe-app-swipe-screen`.
