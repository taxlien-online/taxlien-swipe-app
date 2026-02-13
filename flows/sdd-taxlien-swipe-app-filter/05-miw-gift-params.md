# sdd-miw-gift Parameters vs Filter (Reference)

**Purpose:** Track which Miw/Foreclosure criteria from sdd-miw-gift are exposed in the app filter and which are backend/ML only.

## Implemented in Filter / Model

| Parameter | In App | Notes |
|-----------|--------|-------|
| **No Heirs** | ✅ | `TaxLien.noHeirs`, `FilterOptions.noHeirsOnly`, API `no_heirs=true` |
| **Foreclosure score** | ✅ | `minForeclosureScore` (Foreclosure Score = no heirs → guaranteed foreclosure) |
| **State / County** | ✅ | Full county list per state via `StateCounties` (AZ, FL, TX, NV, CO, SD) |
| **Max price** | ✅ | `maxPrice` |
| **Min interest rate** | ✅ | `minInterestRate` |
| **Property type** | ✅ | `propertyTypes` |
| **Sale type (Auction/OTC)** | ✅ | `saleTypes` |
| **x1000 score** | ✅ | `minX1000Score` (antique/rarity potential) |

## From miw-gift Not (Yet) in Filter

| Parameter | miw-gift spec | Possible future |
|-----------|----------------|-----------------|
| **Clear title (no other liens)** | MUST HAVE | Backend/API flag or ML |
| **Road access** | MUST HAVE | Backend/parcel data |
| **Not in flood zone** | MUST HAVE | FEMA/flood API, backend |
| **Landlocked** | AVOID | Backend/parcel |
| **Redemption probability** | Shon/Miw criteria | Derived from ML; we have foreclosure prob |
| **Value-to-lien ratio (LTV)** | `maxLtvRatio` in FilterOptions | Already in model; UI slider optional |

## County Data

- **Source:** `lib/core/data/state_counties.dart` — full list per state (Census-style).
- **States:** AZ (15), FL (67), TX (254), NV (17), CO (64), SD (66).
- **Filter flow:** State chips → tap Counties → `CountySelectorScreen` shows `StateCounties.getCountiesForState(state)`.
