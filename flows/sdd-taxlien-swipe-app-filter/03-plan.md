# Plan: Search Filters System

**Version:** 1.0
**Status:** ✅ APPROVED
**Last Updated:** 2026-02-04

---

## 1. Model Development

### Task 1.1: Create `FilterOptions` Model
- Create `lib/core/models/filter_options.dart`.
- Define the class with all fields: states, counties, maxPrice, minInterestRate, etc.
- Implement `copyWith`, `toJson`, and `fromJson`.

### Task 1.2: Update `UserPreferences`
- Modify `lib/core/models/user_preferences.dart`.
- Add `FilterOptions filter` field.
- Update constructor and `copyWith`.

---

## 2. Service & Logic Layer

### Task 2.1: Update `TaxLienService`
- Modify `lib/services/tax_lien_service.dart`.
- Update `searchLiens` and `searchForeclosureCandidates` to accept `FilterOptions`.
- Map filter fields to query parameters (e.g., `state`, `county`, `max_amount`, `property_type`).

### Task 2.2: Create `FilterController`
- Create `lib/features/swipe/controllers/filter_controller.dart` (using GetX as seen in other parts of the project, or standard ChangeNotifier if GetX is not used everywhere - checking project structure).
- Logic to hold temporary filter state.
- Logic to fetch matching count from API (debounced).

---

## 3. UI Implementation

### Task 3.1: Create `FilterSheet` Widget
- Create `lib/features/swipe/widgets/filter_sheet.dart`.
- Implement sections:
    - Location (Chips + Drill down).
    - Financial (Sliders).
    - Property Type (Toggle cards).
    - Expert Scores (ExpansionTile).

### Task 3.2: Create `CountySelectorScreen`
- Create `lib/features/swipe/screens/county_selector_screen.dart` for deep county selection.

### Task 3.3: Integrate Filter Button
- Modify `lib/features/swipe/screens/swipe_screen.dart` (or equivalent main screen).
- Add Filter icon button to the AppBar.
- Trigger `FilterSheet` on tap.

---

## 4. Persistence & Refinement

### Task 4.1: Save/Load Filters
- Ensure `FilterOptions` are saved to local storage when `UserPreferences` are updated.

### Task 4.2: UX Polishing
- Add loading state to the "Show X Properties" button.
- Ensure smooth animations for the bottom sheet and expansion tiles.

---

## Testing Strategy

1.  **Unit Tests:** Verify `FilterOptions` serialization and `copyWith`.
2.  **Service Tests:** Verify `TaxLienService` generates correct query strings for different filter combinations.
3.  **Widget Tests:** Verify the bottom sheet opens and sliders update the temporary state.
4.  **Integration Test:** Select filters, apply, and verify the property stack updates with filtered results.

---