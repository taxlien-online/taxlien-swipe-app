# Requirements: Search Filters System

**Version:** 1.2 (Owner/Estate, Sale & Listing Status)
**Status:** 🟡 REVIEW
**Last Updated:** 2026-02-04

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
- **Sale Type:** Chips [**Auction**, **OTC**, Any].
  - **Auction** — property/lien will be or was sold at a scheduled auction.
  - **OTC (Over-the-Counter)** — available after auction (no bid) or direct purchase without auction.
- **Listing / Lifecycle Status** (optional filter or display): [Delinquent → Will be listed, Listed for auction, OTC available, Sold]. Enables "просрочка — будет выставлено на аукцион".

### US-2a: Owner & Estate Status (Foreclosure Certainty)
**As a** foreclosure-focused investor (Miw)
**I want** to filter by owner/estate status
**So that** I focus on properties with high acquisition certainty (no heirs, owner deceased).

**Filters Needed:**
- **No Heirs Only:** Toggle. When ON, show only properties where there are no known heirs → higher probability of foreclosure / no redemption.
- **Owner Deceased** (optional): Toggle or chip. Filter by "owner deceased" when backend/ML provides this.
- **Estate / Probate Status** (optional, future): If API supports — [No probate, Probate filed, Abandoned probate] to refine "no heirs" scenarios.

**Rationale (sdd-miw-gift):** Foreclosure Score = no heirs → guaranteed foreclosure. Explicit "no heirs" and "owner deceased" criteria align with Miw's strategy.

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
| **Location** | State | Multi-select | AZ, FL, TX, NV, CO, SD... | User Prefs |
| | County | Multi-select | Full list per state (StateCounties) | All |
| **Financial** | Max Price | Slider | $0 - $5,000 | $1,000 |
| | Min Interest | Slider | 0% - 25% | 8% |
| | LTV Ratio | Slider | 0% - 100% | <10% |
| **Property** | Type | Choice Chip | House, Land, Comm. | House + Land |
| **Sale / Listing** | Sale Type | Choice Chip | **Auction**, **OTC**, Any | Any |
| | Listing Status (optional) | Choice Chip | Delinquent→Auction, Listed, OTC, Sold | Any |
| | Auction Date | Date Range | Calendar | Next 30 days |
| **Owner / Estate** | No Heirs Only | Toggle | On/Off | Off |
| | Owner Deceased (optional) | Toggle | On/Off | Any |
| **Intelligence** | Foreclosure Score | Slider | 0 - 100 | >50 |
| | x1000 Score | Slider | 0 - 100 | Any |
| **Data** | Has Photos | Toggle | On/Off | On |
| | Has Street View | Toggle | On/Off | Off |

### Sale Type & Listing Status (clarification)

- **Auction** — объект будет или был продан на назначенном аукционе.
- **OTC (Over-the-Counter)** — доступен после аукциона (без ставок) или прямая покупка без аукциона.
- **Просрочка → будет выставлено на аукцион:** отражается либо через **Listing Status** (Delinquent / Will be listed), либо через дату аукциона + статус "active" / "listed". Требует от бэкенда/API поля типа `listing_stage` или использования `status` + `auction_date`.

---

## Lien / Deed / Foreclosure: сценарии по этапу (до аукциона, аукцион, OTC)

Тип продукта и этап жизненного цикла задают, что именно видит пользователь и как работают фильтры **Sale Type** и **Listing Status**.

### Ось «этап»: до аукциона → аукцион → OTC

```text
  ДО АУКЦИОНА          АУКЦИОН              OTC (ПОСЛЕ АУКЦИОНА)
  ─────────────         ───────              ─────────────────────
  Просрочка по          Назначенная           Не продано на
  налогам               дата продажи          аукционе (no bid)
  → будет               → торги              или выкуп не состоялся
  выставлено            (lien или deed)      → можно купить
  на аукцион                                  без торгов
```

### Таблица: Lien / Deed / Foreclosure по этапам

| Этап (Listing)      | Lien‑штат (напр. AZ) | Deed‑штат (напр. TX, FL deed) | Foreclosure (исход lien) |
|---------------------|----------------------|--------------------------------|---------------------------|
| **До аукциона**     | Delinquent → будет выставлен **lien** на аукцион. Покупка = сертификат lien (проценты + право на foreclosure после срока выкупа). | Delinquent → будет выставлен **deed** на аукцион. Покупка = право на недвижимость. | Не применимо (ещё не куплен lien). |
| **Аукцион**         | Продаётся **lien certificate** на аукционе. Победитель получает сертификат; позже — redemption или **foreclosure**. | Продаётся **tax deed** на аукционе. Победитель получает недвижимость (или право по правилам штата). | На аукционе покупают **lien**, не foreclosure; foreclosure — следующий этап после невыкупа. |
| **OTC**             | Lien не купили на аукционе → доступен **OTC** (покупка lien без торгов). Дальше те же исходы: redemption или **foreclosure**. | Deed не купили на аукционе → **struck-off** / OTC deed. Покупка напрямую у округа. | После истечения срока выкупа по lien — **foreclosure** (переход права на недвижимость). Это исход, не этап продажи. |

### Упрощённая схема по осям

```text
                    ДО АУКЦИОНА              АУКЦИОН                    OTC
                    (delinquent,             (sale event)                (post-auction)
                     will be listed)

  LIEN               Просрочка →             Продажа lien               Lien доступен
  (AZ, FL lien,      лист на аукцион         certificate                OTC (no bid)
   LA 2026)          для lien                на аукционе

  DEED               Просрочка →             Продажа tax deed           Deed доступен
  (TX, FL deed,      лист на аукцион         на аукционе                OTC / struck-off
   SD, UT)           для deed

  FORECLOSURE        —                       —                          Исход: по lien
  (исход)            (ещё не куплен)         (покупают lien,            не выкуплен →
                                            не deed)                   foreclosure → property
```

### Связь с фильтрами

| Фильтр / Поле | До аукциона | Аукцион | OTC |
|---------------|-------------|--------|-----|
| **Sale Type** | — (или «Auction» = «запланирован на аукцион») | **Auction** | **OTC** |
| **Listing Status** (опц.) | Delinquent / Will be listed | Listed / At auction | OTC available |
| **Тип продукта (Lien/Deed)** | Зависит от штата (lien state vs deed state) | То же | То же; OTC может быть и lien, и deed |
| **Foreclosure** | Не применимо | Покупка lien → возможный будущий foreclosure | Либо уже foreclosure (исход), либо купленный OTC lien → будущий foreclosure |

**Итог для UI/API:** этап (до аукциона / аукцион / OTC) и тип продукта (Lien / Deed) — независимые измерения. Foreclosure — результат по уже купленному lien, а не отдельный «тип продажи». Фильтр **Sale Type** = способ покупки (Auction vs OTC); **Listing Status** = этап в жизненном цикле (до аукциона, на аукционе, OTC, Sold).

---

## Constraints

- **Dynamic Count:** The "Apply" button must show the estimated number of results (e.g., "Show 142 Results") to prevent zero-result searches.
- **Persistence:** Filters must be saved in `UserPreferences` so they survive app restarts.

---

## Open Questions

1. **Granularity:** Should we expose specific "Land Use Codes" (e.g., "0135 - Single Family Residence") or stick to the simplified "House/Land" mapping?
2. **x1000 Categories:** Should users filter by *specific* x1000 types (e.g., "Filter for: Antique Cars") or just general high score?
3. **Listing Status:** Expose as filter (Delinquent / Will be listed / Listed / OTC / Sold) or derive from `status` + `auction_date` in UI only?
4. **Owner Deceased:** Add as separate toggle when API/ML provides it, or keep only "No Heirs" as proxy for foreclosure certainty?

---