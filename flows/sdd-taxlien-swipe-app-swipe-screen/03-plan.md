# Plan: Swipe Screen Implementation

**Phase:** REQUIREMENTS/SPECIFICATIONS
**Status:** 🟡 IN PROGRESS

## Phase 1: Foundation & Data Models
- [ ] Define `SwipeMode` enum and update `UserPreferences`.
- [ ] Create `Marker` and `PropertyCardData` models.
- [ ] Set up a mock `TaxLienService` to provide property data with FVI/ROI.

## Phase 2: UI Implementation (Beginner Mode)
- [ ] Implement `SwipeStack` with basic Tinder-like logic.
- [ ] Create `PropertyCard` with financial overlays (FVI, ROI, Price).
- [ ] Implement "Details" bottom sheet.

## Phase 3: Advanced Mode & Navigation
- [ ] Implement `AdvancedSwipeStack` logic (4-way navigation).
- [ ] Create `ContextView` and `DetailsView` overlays/screens.
- [ ] Add "Double-tap to Like" and physical "Like/Pass" buttons.

## Phase 4: Expert Annotation (Canvas)
- [ ] Implement `AnnotationCanvas` overlay on `PropertyCard`.
- [ ] Support "Point" annotation (Tap).
- [ ] Implement "Radial Menu" for advanced разметки (Long press).

## Phase 5: Integration & Refinement
- [ ] Connect to real API Gateway endpoints.
- [ ] Polish animations and transitions.
- [ ] Verify FVI display logic across different family profiles.
