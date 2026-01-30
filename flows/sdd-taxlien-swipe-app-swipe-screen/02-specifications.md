# Specifications: Swipe Screen & Deal Detective

**Version:** 0.1
**Status:** 🟡 DRAFT

## 1. Data Models

### 1.1 SwipeMode
```dart
enum SwipeMode {
  beginner,
  advanced,
}
```

### 1.2 UserPreferences (Extension)
```dart
class UserPreferences {
  final SwipeMode swipeMode;
  // ... existing fields
}
```

## 2. UI Components

### 2.1 SwipeStack & Modes

#### Beginner Mode (Emotional Layer)
- **Interactions:**
    - `HorizontalDismissal`: Classic Tinder swipe.
    - `FlipGesture`: Single Tap triggers a 3D flip animation showing `QuickFacts`.
    - `PhotoCycleGesture`: Double Tap cycles to the next image in the `property.images` list.
    - `InfoAction`: Tapping the `(i)` icon opens `FinancialDetailsSheet`.
    - `MatchAnimation`: Visual celebration when a property is liked by multiple family members.

#### Advanced Mode (Expert Layer)
- **UI Architecture:**
    - `FourWayNavigationStack`: Handles vertical (list) and horizontal (data) movement.
    - `PeekingOverlay`: Context/Details visible on the edges of the main card.
- **Role-Based Adaptive HUD (The Lens):**
    - **Businessman (Shon):** HUD focus on ROI, Margins, Risk. Context: Tax payment history.
    - **Builder (Khun Pho):** HUD focus on Roof, Foundation, Walls. Context: Building permits, code violations.
    - **Inventor/Art (Anton):** HUD focus on Rarity, Provenance, Authenticity. Context: Owner biography, obituaries.
    - **Restorer (Denis):** HUD focus on Furniture style, Wood types, Restoration potential. Context: Interior era history.
    - **Caregiver (Vannisa):** HUD focus on Safety, School ratings, Healthcare proximity. Context: Crime maps, community reviews.
    - **Lifestyle (Women):** HUD focus on Walkability, Services (Cafes, Yoga), Neighborhood vibe. Context: Local events, social heatmaps.
    - **Explorer (Kids):** Gamified HUD (Fun Score, Castle Potential). Focus on Playgrounds, Pools, Hobby clubs. Context: Map of adventure spots.
- **Interactions:**
    - `VerticalScroll`: Change property.
    - `HorizontalPeek`: Swipe Left for `ContextView` (Adaptive based on Role), Swipe Right for `DetailsView`.
    - `PhotoCycleShortcut`: Double Tap cycles images for quick visual inspection (Priority based on Role).
    - `InfoAction`: Tapping the `(i)` icon or Price Badge opens `FinancialDetailsSheet`.
    - `AnnotationCanvas`: Transparent drawing layer enabled on long-press.

### 2.2 PropertyCard (Advanced Mode)
- **Top Layer:** Main Image (Full screen).
    - **Logic:** Selected based on `UserPreferences.role` (e.g., Roof focus for Khun Pho, Curb appeal for Miw).
- **Cross-Role Badge:**
    - If recommended by another expert (e.g., Khun Pho), display a reassuring badge: "🏗️ Khun Pho: Solid Structure".
    - Tap on badge to see *specific* photos marked by the expert (e.g., the good foundation).
- **Left/Right Overlays:** Indicators that "Context" (Left) or "Details" (Right) are available.
- **Swipe Interactions:**
    - `onSwipeLeft`: Trigger "Context View" animation.
    - `onSwipeRight`: Trigger "Details View" animation.
    - `onSwipeUp/Down`: Change the current property card.

### 2.3 Financial Overlay
A semi-transparent gradient at the bottom of the card.
- **FVI Badge:** Top-left of the overlay.
- **ROI Badge:** Top-right of the overlay.
- **Price Label:** Center-bottom.
- **Expandable Icon:** Small "chevron-up" to open the detailed breakdown sheet.

## 3. Expert Annotation System (Canvas)

### 3.1 Interaction Modes
- **Point Mode (Default):** A single tap creates a `Marker`.
- **Selection Mode:** Long press opens a radial menu:
    - [Box] Draw a rectangle.
    - [Line] Draw a line.
    - [Comment] Add text note.

### 3.2 Marker Model
```dart
class Marker {
  final Offset position;
  final String authorId; // e.g., 'anton', 'khun-pho'
  final String? category;
  final String? comment;
  final MarkerType type; // point, box, line
}
```

## 4. Onboarding Flow
1. **Welcome Screen.**
2. **"Choose Your Style" Screen:**
    - Two large cards/buttons: "Beginner" (Simple) vs "Advanced" (Expert).
    - Descriptive text for each.
3. **Interactive Mini-Tutorial:** 3 cards to practice the chosen mode.

## 5. Technical Constraints
- **Self-hosted ML:** No calls to OpenAI Vision. Use local object detection results passed from the backend.
- **Offline First:** Local caching of property data and images for smooth swiping.
