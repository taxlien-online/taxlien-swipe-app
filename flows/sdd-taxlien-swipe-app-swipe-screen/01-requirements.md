# Requirements: Swipe Screen & Deal Detective

**Version:** 0.1 (Draft)
**Status:** 🟡 DRAFT
**Source:** Derived from `sdd-miw-gift` (Deal Detective concept)

## Context
This flow focuses on implementing the "Swipe Screen" for the Tax Lien Swipe App ("Deal Detective"). Unlike traditional swipe interfaces (Tinder-style), this screen serves as a primary data collection and expert annotation tool.

## Core Concepts from sdd-miw-gift

### 1. Multi-Role Annotation
The screen must support different "lenses" or user profiles.
- **Khun Pho (Construction):** Needs to mark structural elements (roof, foundation).
- **Denis (Furniture):** Needs to mark interior items.
- **Anton (Tech/Art):** Needs to mark vintage cars, devices, paintings.
- **Miw (General):** Aesthetic and neighborhood evaluation.

### 2. Interaction Model
- **Swipe:** Right (Like/Collect), Left (Pass).
- **Tap:** Mark a point of interest (Expert Annotation start).
- **Zoom:** Pinch to inspect details.
- **Long Press:** Context menu for detailed annotation (Area, Line, Comment).

### 3. Family Mode (Collaboration)
- Users should be able to see annotations made by other family members on the same property card.

### 4. Data Collection for ML
- Every interaction (especially annotations) is a training signal for the backend ML models (x1000 detectors).

## User Stories (Draft)

### US-1: Basic Navigation
- As a user, I want to swipe through a stack of property cards.
- As a user, I want to see key property details (price, location, image) on the card.

### US-2: Expert Annotation
- As an expert (e.g., Anton), I want to tap on a specific part of a photo (e.g., a car in a garage) to mark it.
- As an expert, I want to add a category or comment to my mark (e.g., "Vintage Mustang").

### US-3: Role-Based Views
- As a user, I want the interface to adapt slightly to my profile (showing relevant existing auto-detected tags).

### US-4: Collaborative View
- As a user, I want to see if another family member has already marked this property (e.g., "Khun Pho marked 'Bad Roof'").

### US-5: Smart Visual Presentation (Adaptive Lens)
- **Full Screen:** Property images occupy the full screen.
- **Smart Source Selection:**
    - Improved Property: Street View/Exterior primary.
    - Vacant Land: Satellite view with boundaries primary.
- **Role-Based Adaptation (The Lens):**
    - **Miw's View:** Prioritize aesthetic shots (lawn, neighborhood, overall curb appeal). Avoid starting with close-ups of damage.
    - **Khun Pho's View:** Prioritize structural details (roof angles, foundation lines, wall integrity).
- **Cross-Role Context (The Bridge):**
    - If Khun Pho recommends a "fixer-upper" to Miw:
        - Do NOT hide the damage, but frame it with context.
        - **UI Signal:** "Khun Pho sees potential here" badge.
        - **Explanation:** "Structure is solid, needs cosmetic fix" (translating technical approval to layperson assurance).
        - **Visual:** Show the "best" angle first, but allow easy access to the damage photos marked by Khun Pho so she understands *what* needs fixing without initial shock.

### US-6: Financial Data & Metrics Overlay
- **Key Metrics:** Display Estimated Value, Lien Cost, Final Purchase Price (Lien + Fees), ROI, and FVI clearly.
- **Presentation:** Use non-intrusive overlays (badges, bottom gradient area) to keep the focus on the image.
- **Info Icon (i):** A small dedicated button to open the detailed financial breakdown (Lien + Admin Fees + Subsequent Taxes + Legal Costs).

### US-7: Swipe Modes (Beginner vs Advanced)
- **Beginner Mode (Tinder-style):**
    - Swipe Left: Pass (Discard).
    - Swipe Right: Like (Add to Shortlist).
    - **Single Tap:** Flip card for Quick Facts.
    - **Double Tap:** Cycle to next photo (Inspect house details).
    - Goal: Rapid filtering for casual users.
- **Advanced Mode (Multi-dimensional):**
    - Swipe Up: Next property in stack.
    - Swipe Down: Previous property in stack.
    - Swipe Right: Open Details (Interiors, additional photos, maps).
    - Swipe Left: Open Context (News articles, obituaries, ownership history).
    - **Double Tap:** Cycle to next photo (Quick visual inspection).
    - Actions (Like/Pass): Handled via dedicated buttons.
    - Goal: Deep research for power users (Anton, Experts).

### US-8: Settings Management
- Users can switch between Beginner and Advanced modes at any time in the app settings.

## Questions for Discussion
1. In Advanced mode, how do we signify that a property is "Liked" or "Passed" if horizontal swipes are used for research? (Proposed: Buttons + Double-tap).
2. Should the "Context" and "Details" views in Advanced mode be separate screens or just specialized overlays/cards within the stack?
