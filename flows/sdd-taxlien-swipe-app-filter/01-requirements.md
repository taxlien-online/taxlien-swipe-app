# Requirements: Search Filters System

**Version:** 1.1 (Visuals Added)
**Status:** 🟡 REVIEW
**Last Updated:** 2026-02-02

---

## Problem Statement

Users need a way to narrow down the vast dataset of tax liens/deeds to find properties that match their specific investment criteria, budget, and family interests. The filter system must bridge the gap between "hard" financial constraints (Budget < $1000, ROI > 16%) and "soft" AI-driven interests (x1000 potentials, expert annotations), all within a mobile-first "Deal Detective" experience.

---

## User Stories

### US-1: State & Geography Selection
**As a** user
**I want** to select states and specific counties
**So that** I focus on jurisdictions relevant to my family (AZ, SD) or strategy (FL OTC).

**Acceptance Criteria:**
- [ ] List of available states (populated from API).
- [ ] Multi-select capability.
- [ ] Hierarchical selection: State -> County.
- [ ] "Select All" / "Clear All" options.

### US-2: Financial & Auction Filters (Hard Constraints)
**As a** budget-conscious investor (Miw/Denis)
**I want** to filter by price, interest rate, and auction date
**So that** I stick to my $1,000 budget and meet the Feb 2026 deadline.

**Filters Needed:**
- **Max Lien Price:** Slider (e.g., $0 - $1000+). Default: $300 (Miw's max per lien).
- **Min Interest Rate:** Slider (e.g., 0% - 20%). Default: 10%.
- **Value-to-Lien Ratio (LTV):** Slider (e.g., 0% - 50%). Default: <10%.
- **Auction Date:** Date Range picker. Default: "Upcoming 30 days" or "Feb 2026".
- **Sale Type:** Chips [Auction, OTC, Any].

### US-3: Property Type & Status
**As a** strategic investor
**I want** to choose between houses and land
**So that** I execute my specific strategy (Property Acquisition vs Land Flipping).

**Filters Needed:**
- **Structure Type:** Chips [Improved/House, Vacant Land, Commercial, Agricultural].
- **Occupancy Status:** Chips [Occupied, Vacant, Unknown] (if available).

### US-4: AI & Score Filters (Smart Filtering)
**As an** expert user (Anton)
**I want** to filter by AI-predicted scores
**So that** I find high-potential "needles in the haystack".

**Filters Needed:**
- **Min Foreclosure Score:** Slider (0-100). "Show me likely foreclosures".
- **Min x1000 Score:** Slider (0-100). "Show me potential antiques/treasures".
- **FVI (Family Value Index):** Slider (0-10). "Show me things my family liked".

### US-5: Data Quality & Expert Context
**As a** remote investor (Khun Pho)
**I want** to ensure I only see properties with sufficient data
**So that** I can actually evaluate them.

**Filters Needed:**
- **Toggles:**
    - "Has Photos" (Don't show properties with no imagery).
    - "Has Street View".
    - "Has Expert Annotation" (Already marked by family).
    - "Has Obituaries/Context" (For Anton).

---

## Wireframes (Visual Design)

### Main Filter Screen (Modal Bottom Sheet)

This sheet slides up from the bottom when the user taps the "Filters" icon.

```text
┌───────────────────────────────────────────┐
│  Filters                         Reset    │  <-- Header with Reset
├───────────────────────────────────────────┤
│                                           │
│  📍 LOCATION                              │
│  ┌─────────────────────────────────────┐  │
│  │ [ AZ ] [ FL ] [ + Add State ]       │  │  <-- Horizontal Scroll Chips
│  └─────────────────────────────────────┘  │
│  Counties: All in Arizona (15)      >     │  <-- Drill-down to County Select
│                                           │
├───────────────────────────────────────────┤
│                                           │
│  💰 FINANCIAL                             │
│                                           │
│  Budget (Lien Price)          $300        │
│  ├──●─────────────────────────────┤       │
│  $0                              $5k+     │
│                                           │
│  Min Interest Rate             16%        │
│  ├───────────────●────────────────┤       │
│  0%                              25%      │
│                                           │
├───────────────────────────────────────────┤
│                                           │
│  🏠 PROPERTY TYPE                         │
│  ┌──────────────┐  ┌──────────────┐       │
│  │   🏠 House   │  │   🌳 Land    │       │  <-- Large Selectable Cards
│  │     (Selected)    │     (Selected)    │       │
│  └──────────────┘  └──────────────┘       │
│                                           │
├───────────────────────────────────────────┤
│                                           │
│  🧠 SMART FILTERS (Advanced)        ▼     │  <-- Collapsible Section
│                                           │
│  Min x1000 Score (Antiques)    50+        │
│  ├──────────────────●─────────────┤       │
│                                           │
│  [✓] Has Photos                           │
│  [ ] Has Street View                      │
│                                           │
├───────────────────────────────────────────┤
│                                           │
│       [ SHOW 142 PROPERTIES ]             │  <-- Sticky Bottom Button
│                                           │
└───────────────────────────────────────────┘
```

### County Selection (Drill-down)

```text
┌───────────────────────────────────────────┐
│  < Arizona Counties              Done     │
├───────────────────────────────────────────┤
│  🔍 Search counties...                    │
├───────────────────────────────────────────┤
│  [✓] Select All (15)                      │
├───────────────────────────────────────────┤
│  [✓] Maricopa (Phoenix)                   │
│      12,450 Liens                         │
├───────────────────────────────────────────┤
│  [✓] Pinal                                │
│      3,200 Liens                          │
├───────────────────────────────────────────┤
│  [ ] Yavapai                              │
│      1,800 Liens                          │
└───────────────────────────────────────────┘
```

---

## Filter Definitions

| Category | Filter Name | Type | Options/Range | Default |
| :--- | :--- | :--- | :--- | :--- |
| **Location** | State | Multi-select | AZ, FL, IA, SD... | User Prefs |
| | County | Multi-select | Maricopa, Pinal... | All |
| **Financial** | Max Price | Slider | $0 - $5,000 | $1,000 |
| | Min Interest | Slider | 0% - 25% | 8% |
| | LTV Ratio | Slider | 0% - 100% | <10% |
| **Property** | Type | Choice Chip | House, Land, Comm. | House + Land |
| **Auction** | Type | Choice Chip | Auction, OTC | Any |
| | Date | Date Range | Calendar | Next 30 days |
| **Intelligence**| Foreclosure Score | Slider | 0 - 100 | >50 |
| | x1000 Score | Slider | 0 - 100 | Any |
| **Data** | Has Photos | Toggle | On/Off | On |
| | Has Street View| Toggle | On/Off | Off |

---

## Constraints

- **Dynamic Count:** The "Apply" button must show the estimated number of results (e.g., "Show 142 Results") to prevent zero-result searches.
- **Persistence:** Filters must be saved in `UserPreferences` so they survive app restarts.

---

## Open Questions

1. **Granularity:** Should we expose specific "Land Use Codes" (e.g., "0135 - Single Family Residence") or stick to the simplified "House/Land" mapping?
2. **x1000 Categories:** Should users filter by *specific* x1000 types (e.g., "Filter for: Antique Cars") or just general high score?

---