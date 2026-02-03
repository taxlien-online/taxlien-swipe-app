# Specifications: Search Filters System

**Version:** 1.0
**Status:** 🟡 DRAFT
**Last Updated:** 2026-02-02

---

## 1. Data Models

### 1.1 `FilterOptions` Model
A new model to encapsulate all filterable criteria.

```dart
// lib/core/models/filter_options.dart

class FilterOptions {
  final List<String> states;
  final List<String> counties;
  final double maxPrice;
  final double minInterestRate;
  final double maxLtvRatio;
  final List<String> propertyTypes; // ['Residential', 'Vacant Land', etc.]
  final List<String> saleTypes; // ['Auction', 'OTC']
  final DateTimeRange? auctionDateRange;
  final double minForeclosureScore;
  final double minX1000Score;
  final bool hasPhotos;
  final bool hasStreetView;

  FilterOptions({
    this.states = const [],
    this.counties = const [],
    this.maxPrice = 1000.0,
    this.minInterestRate = 0.08,
    this.maxLtvRatio = 0.10,
    this.propertyTypes = const ['Residential', 'Vacant Land'],
    this.saleTypes = const ['Auction', 'OTC'],
    this.auctionDateRange,
    this.minForeclosureScore = 0.0,
    this.minX1000Score = 0.0,
    this.hasPhotos = true,
    this.hasStreetView = false,
  });

  // copyWith, toJson, fromJson methods...
}
```

### 1.2 `UserPreferences` Integration
Update `UserPreferences` to include the current filter.

```dart
// lib/core/models/user_preferences.dart

class UserPreferences {
  // ... existing fields ...
  final FilterOptions filter;

  UserPreferences({
    // ...
    required this.filter,
  });
}
```

---

## 2. Service Layer Changes

### 2.1 `TaxLienService` Update
The `searchLiens` method should be updated to accept `FilterOptions`.

```dart
// lib/services/tax_lien_service.dart

Future<List<TaxLien>> searchLiens({
  FilterOptions? filter,
  int limit = 50,
}) async {
  // 1. Map FilterOptions to API query parameters
  // 2. Add 'foreclosure_score_min'
  // 3. Add 'x1000_score_min'
  // 4. Add 'property_type' list
  // ...
}
```

---

## 3. UI Components

### 3.1 `FilterSheet` (Modal Bottom Sheet)
A scrollable sheet containing the filter controls.

- **Location Section:** 
    - `StateSelector`: Horizontal list of chips with a "+" button.
    - `CountyDrillDown`: A ListTile that opens a full-screen or nested list of counties.
- **Financial Section:**
    - `FilterSlider`: Custom themed slider with labels for min/max.
- **Property Type Section:**
    - `PropertyTypeToggle`: ToggleButtons or custom Cards for "House" vs "Land".
- **Expert/Smart Section (Collapsible):**
    - `ExpansionTile`: Contains Foreclosure and x1000 sliders.
- **Bottom Action Bar:**
    - `ApplyButton`: Sticky button showing the match count.

### 3.2 Dynamic Result Counter
The `FilterSheet` should trigger a lightweight `HEAD` request or a specific `/count` endpoint on every filter change (debounced) to show the user how many properties match their selection.

---

## 4. State Management

### 4.1 `FilterController` (GetX/Riverpod/Provider)
- Holds the temporary `FilterOptions` while the sheet is open.
- Debounces count requests.
- On "Apply", updates the global `UserPreferences` and triggers a refresh of the property stack.

---

## 5. Persistence
- Use `shared_preferences` or a local database to save `FilterOptions` as part of `UserPreferences`.

---

## 6. Edge Cases & Error Handling
- **Zero Results:** If filters result in 0 properties, show a "No results found. Try broadening your filters" message instead of the apply button.
- **Offline Mode:** If offline, use cached `TaxLien` data and perform client-side filtering (if feasible) or show a "Filter not available offline" warning.
- **API Timeout:** Handle slow count requests gracefully (show a spinner on the button).

---