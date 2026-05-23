# Requirements: Tax Lien Spatial Intelligence

> Version: 2.0
> Status: DRAFT (updated with vendor flow analysis)
> Last Updated: 2026-05-18

## Problem Statement

Current tax lien discovery is list-based and tedious. Investors scroll through thousands of properties in spreadsheet views, unable to see patterns, relationships, or quickly filter opportunities. The cognitive load of evaluating liens/deeds/foreclosures across multiple dimensions (ROI, risk, location, stage) is overwhelming.

**Vision**: Transform property discovery from "searching a table" to "exploring a spatial map of opportunities" where users select with gestures, switch dimensions instantly, see hidden patterns, and get AI-powered insights.

---

## Domain: US Tax Liens/Deeds/Foreclosures

### Key Entities

| Entity | Description | Key Attributes |
|--------|-------------|----------------|
| **Tax Lien** | Certificate purchased at auction giving holder right to collect debt + interest | amount, interest rate, redemption period, county |
| **Tax Deed** | Property ownership transferred due to unpaid taxes | property value, auction date, title status |
| **Foreclosure** | Property seized by lender (bank/county) for non-payment | estimated value, prior years owed, listing stage |
| **Property** | The underlying real estate | address, parcel ID, assessed value, images, FVI score |
| **County** | Jurisdiction handling tax sales | state, auction calendar, interest rates, rules |

### Listing Stages (Acquisition Paths)

```
PRE_AUCTION → LISTED → OTC (Over-the-Counter) → SOLD
     ↓           ↓          ↓
  Research    Bidding    Direct Buy
```

### Risk/Opportunity Signals

- **Redemption Probability** (0.0-1.0): ML prediction (NOTE: high = owner likely to redeem = you get interest, low = foreclosure likely)
- **Risk Score** (0-100): ML composite risk assessment
- **Expected ROI** (%): ML predicted return on investment
- **Payback Months**: ML predicted time to return
- **Prior Years Owed**: Delinquency depth (2+ years = distressed)
- **FVI (Family Value Index)**: Expert composite score
- **Karma Score**: Computed from exemptions (ethical considerations)

### Property Attributes (90+ fields from ETL Pipeline)

| Category | Key Fields | Source |
|----------|------------|--------|
| **Identification** | `parcel_id`, `property_tax_account` | Scraper |
| **Location** | `property_address`, `city`, `county`, `state`, `zip_code`, `latitude`, `longitude` | Scraper + Geocoding |
| **Building** | `building_sqft`, `year_built`, `bedrooms`, `bathrooms`, `stories`, `garage_spaces`, `pool` | Scraper |
| **Land** | `land_acres`, `land_use_code`, `legal_description` | Scraper |
| **Valuation** | `assessed_value`, `market_value`, `land_value`, `building_value`, `zillow_estimate` | Scraper + Zillow API |
| **Tax** | `tax_amount`, `tax_year`, `interest_rate`, `penalty_amount`, `prior_years_owed`, `total_due_amount` | Scraper |
| **Owner** | `owner_name`, `owner_address`, `owner_tenure_years` | Scraper |
| **Exemptions** | `homestead_exemption`, `veteran_exemption`, `senior_exemption`, `disability_exemption` | Scraper |
| **Dates** | `auction_date`, `issue_date`, `redemption_deadline`, `sale_date`, `last_sale_date` | Scraper |
| **Status** | `status` (active/sold/redeemed/foreclosed/pending), `is_available`, `listingStage` | System |
| **Enrichment** | `walkability_score`, `school_rating`, `crime_index`, `flood_zone`, `zillow_rent_estimate` | External APIs |
| **ML Predictions** | `redemption_probability`, `risk_score`, `expected_roi`, `payback_months` | ML Service |
| **Special** | `no_heirs`, `is_tokenized`, `nft_token_id` | System/NFT |

### Exemption Flags (Ethical/Legal Considerations)

| Exemption | Field | Interpretation |
|-----------|-------|----------------|
| **Homestead** | `homestead_exemption > 0` | Owner-occupied primary residence - may fight to redeem |
| **Veteran** | `veteran_exemption > 0` | Military veteran - protected class, ethical consideration |
| **Senior** | `senior_exemption > 0` | Elderly owner - protected class, ethical consideration |
| **Disability** | `disability_exemption > 0` | Disabled owner - protected class, ethical consideration |
| **No Heirs** | `no_heirs = true` | No known heirs - higher foreclosure certainty (from sdd-miw-gift) |

---

## User Stories

### Primary: Property Galaxy View

**As a** tax lien investor
**I want** to see all available properties as a spatial map instead of a list
**So that** I can instantly perceive patterns, outliers, and clusters

**Acceptance Criteria:**
1. Properties displayed as points/cards in 2D space
2. Point size encodes value/ROI
3. Point color encodes stage/risk
4. Pinch-to-zoom navigates time periods or clusters
5. Double-tap on cluster expands to individual properties

---

### Primary: Lasso Selection

**As a** researcher analyzing multiple properties
**I want** to select properties by drawing a shape around them
**So that** I can quickly create groups for comparison/export without checkbox tedium

**Acceptance Criteria:**
1. Draw freeform lasso with finger to select enclosed properties
2. Two-finger lasso adds to existing selection
3. Counter-clockwise lasso excludes from selection
4. After selection, floating panel shows: count, total value, avg ROI, risk distribution
5. Selected properties can be exported or added to watchlist

---

### Primary: Dimension Wheel

**As a** analyst exploring data from different angles
**I want** to rotate through different "views" of the same dataset
**So that** I can discover patterns I wouldn't see in a fixed layout

**Acceptance Criteria:**
1. Two-finger rotation gesture switches dimension
2. **Core Dimensions (MVP):**
   - **Date**: X = auction_date timeline, Y = spread by county
   - **County**: Clustered by county, sized by count
   - **ROI**: X = expected_roi (0-30%+), Y = assessed_value
   - **Risk**: X = risk_score (0-100), Y = redemption_probability
   - **Stage**: Columns for pre_auction | listed | otc | sold
   - **FVI**: X = FVI score, Y = tax_amount
   - **Property Type**: Clusters by residential | commercial | vacant | agricultural
3. **Extended Dimensions (Post-MVP):**
   - **Prior Years**: X = prior_years_owed (1-5+), Y = tax_amount
   - **Exemptions**: Clusters by homestead | veteran | senior | none
   - **Owner Tenure**: X = owner_tenure_years, Y = redemption_probability
   - **Payback**: X = payback_months, Y = expected_roi
   - **Tax Year**: X = tax_year, Y = county
4. Smooth animated transition between layouts (300ms)
5. Current dimension displayed in corner HUD with icon
6. Maintain selection across dimension switches
7. Dimension indicator shows available dimensions in wheel UI

---

### Primary: X-Ray Mode

**As a** due diligence researcher
**I want** to instantly highlight issues and opportunities on a property
**So that** I can make faster decisions without reading every field

**Acceptance Criteria:**
1. Two-finger swipe down on property card activates X-Ray
2. **Warning Insights (Red):**
   - `flood_zone != 'Zone X'` → "FEMA flood zone - insurance required"
   - `prior_years_owed >= 3` → "3+ years delinquent - severely distressed"
   - `risk_score >= 70` → "High risk property (score: 78/100)"
   - `last_scraped_at < 7 days ago` → "Stale data - verify before bidding"
   - `assessed_value` missing or 0 → "Missing valuation data"
3. **Opportunity Insights (Green):**
   - `expected_roi >= 15` → "High ROI opportunity (18.5%)"
   - `payback_months <= 6` → "Quick payback - 4 months estimated"
   - `zillow_estimate > assessed_value * 1.3` → "Zillow 40% above assessment - undervalued?"
   - `school_rating >= 8` → "Excellent schools nearby (8.2/10)"
   - `walkability_score >= 70` → "Walkable neighborhood - high demand"
   - `interest_rate >= 16` → "High interest rate (18%) - excellent if redeemed"
4. **Ethical Insights (Purple):**
   - `homestead_exemption > 0` → "Owner-occupied - may fight to redeem"
   - `veteran_exemption > 0` → "Veteran owner - ethical consideration"
   - `senior_exemption > 0` → "Senior owner - ethical consideration"
   - `disability_exemption > 0` → "Disabled owner - ethical consideration"
   - `no_heirs = true` → "No known heirs - higher foreclosure certainty"
5. **Informational Insights (Blue):**
   - `owner_tenure_years` → "Owner since 2018 (6 years)"
   - `last_sale_price` vs `assessed_value` → "Last sold for $110k, assessed at $125k"
   - `redemption_probability` → "72% chance owner redeems (you get interest)"
6. AI-generated summary explanation combining top insights
7. Exit with two-finger swipe up

---

### Primary: AI Deal Copilot

**As a** investor on mobile
**I want** to speak or type natural language queries
**So that** I can filter/navigate without complex UI interactions

**Acceptance Criteria:**
1. Bottom sheet with text input and microphone
2. **Basic Queries:**
   - "Show high ROI in Florida" → `expected_roi > 15 AND state = 'FL'`
   - "Find liens under $5k" → `tax_amount < 5000`
   - "Properties in Maricopa County" → `county = 'Maricopa'`
3. **Property Type Queries:**
   - "Show vacant land" → `property_type = 'Vacant Land'`
   - "Find commercial properties" → `property_type = 'Commercial'`
   - "Residential only" → `property_type = 'Residential'`
4. **Advanced Queries:**
   - "Homesteaded properties with high ROI" → `homestead_exemption > 0 AND expected_roi > 15`
   - "3+ years delinquent" → `prior_years_owed >= 3`
   - "Quick payback under 6 months" → `payback_months <= 6`
   - "Good schools near Phoenix" → `school_rating >= 7 AND city LIKE '%Phoenix%'`
   - "Low flood risk" → `flood_zone = 'Zone X'`
   - "No heirs properties" → `no_heirs = true`
   - "OTC deals available now" → `listingStage = 'otc' AND is_available = true`
5. **Comparison Queries:**
   - "Compare Florida vs Arizona ROI" → Show side-by-side stats
   - "Best counties for liens" → Rank by avg ROI, count
6. **Temporal Queries:**
   - "Auctions next week" → `auction_date BETWEEN NOW() AND NOW() + 7 days`
   - "New listings today" → `created_at >= TODAY()`
   - "Expiring redemption deadlines" → `redemption_deadline <= NOW() + 30 days`
7. AI interprets and applies filters to spatial view
8. Can combine with gesture: lasso + voice "keep only deeds"
9. History of recent queries accessible
10. Smart suggestions based on current selection context

---

### Secondary: Swipe Focus Mode (Tinder-style)

**As a** investor processing many properties
**I want** a rapid-fire card review mode
**So that** I can make quick yes/no/maybe decisions on batches

**Acceptance Criteria:**
1. Full-screen property card
2. Right swipe = Add to Watchlist
3. Left swipe = Pass
4. Up swipe = Super Like (priority)
5. Down swipe = Maybe Later
6. Two-finger up = Share with family member
7. Long press = Add annotation/comment

---

### Secondary: Timeline Replay

**As a** market researcher
**I want** to see how properties appeared over time
**So that** I can understand market trends and timing

**Acceptance Criteria:**
1. Play button animates properties appearing chronologically
2. Scrubbing timeline with finger controls playback
3. Shows: when liens filed, when moved to OTC, when sold
4. Pause on any moment to inspect
5. Speed control (1x, 2x, 5x)

---

### Secondary: Risk Gravity Visualization

**As a** risk-aware investor
**I want** high-risk properties to visually "pull" related properties
**So that** I can see contamination patterns in portfolios

**Acceptance Criteria:**
1. High-risk properties glow red with gravity effect
2. Related properties (same owner, same street, same county) orbit around
3. Tap orbit line to see relationship type
4. Toggle gravity view on/off

---

### Secondary: Comparison Bridge

**As a** analyst comparing two properties
**I want** to drag two cards apart to see differences
**So that** I can make informed choices between similar opportunities

**Acceptance Criteria:**
1. Touch two cards with two hands (tablet) or long-press + drag
2. Comparison bridge appears between them
3. Shows: delta on ROI, value, risk, FVI scores
4. Highlight matching vs. differing attributes
5. Swipe bridge away to dismiss

---

### Secondary: Property as Living Object

**As a** glanceable-UI user
**I want** property cards to animate based on state
**So that** I can read status without text

**Acceptance Criteria:**
1. Overdue liens pulse subtly
2. High-opportunity properties glow
3. Stale listings have "crack" visual
4. New listings have shimmer
5. Watchlisted have soft halo

---

### Secondary: Timeline Heatmap

**As a** market researcher
**I want** to see a heatmap of properties by county/month
**So that** I can identify seasonal patterns and hot markets

**Acceptance Criteria:**
1. Matrix view: rows = counties, columns = months
2. Cell color = sum of tax_amount or count of properties
3. Pinch to zoom from year → quarter → month → week
4. Tap cell to filter Galaxy to that county/period
5. Data sourced from ClickHouse analytics warehouse

---

### Secondary: Property Badges

**As a** investor scanning many properties
**I want** visual badges on property cards indicating key attributes
**So that** I can quickly identify important characteristics

**Acceptance Criteria:**

| Badge | Condition | Color | Icon |
|-------|-----------|-------|------|
| `HOMESTEAD` | `homestead_exemption > 0` | Purple | House with heart |
| `MULTI-YEAR` | `prior_years_owed >= 2` | Red | Calendar with exclamation |
| `FLOOD RISK` | `flood_zone != 'Zone X'` | Blue | Water droplet |
| `NO HEIRS` | `no_heirs = true` | Orange | Warning triangle |
| `VETERAN` | `veteran_exemption > 0` | Green | Star |
| `SENIOR` | `senior_exemption > 0` | Teal | Person with cane |
| `QUICK PAY` | `payback_months <= 6` | Gold | Clock with checkmark |
| `HIGH ROI` | `expected_roi >= 20` | Green gradient | Trending up arrow |
| `STALE` | `last_scraped_at < 7 days ago` | Gray | Refresh icon |
| `NEW` | `created_at >= TODAY() - 3 days` | Cyan shimmer | Sparkle |

Badges stack horizontally, max 3 visible ("+N more" indicator).

---

## Design System Integration

The VPN Client Pro design system will be adapted for tax lien domain:

### Color Mapping

| VPN Concept | Tax Lien Adaptation |
|-------------|---------------------|
| `--brand-cyan` / `--brand-blue` | Primary gradient for CTA, high-opportunity |
| `--success` (#1FB67A) | Good ROI, low risk |
| `--warning` (#FFB020) | Medium risk, needs review |
| `--danger` (#E5484D) | High risk, issues flagged |
| `--fg-1` / `--fg-2` | Text hierarchy |
| `--surface` | Card backgrounds |
| `--shadow-card` | Elevated property cards |

### Component Reuse

- `ConnectButton` style → "Scan Galaxy" / "Enable X-Ray" toggle buttons
- `StatTile` → ROI, FVI, Risk score tiles
- `ServerCard` → Property summary card
- `Switch` → Filter toggles
- `ListRow` → Property list fallback view
- `TabBar` → Navigation (Galaxy | List | Watchlist | Profile)

### Typography

- `t-timer` (40/700) → FVI mega-number
- `t-title` (24/600) → Screen titles
- `t-body` (17/400) → Property details
- `t-secondary` (15/400) → Labels, metadata
- `t-caption` (13/400) → Timestamps, IDs

---

## Constraints

- **Platform**: iOS and Android (Flutter)
- **Performance**: Galaxy view must render 500+ properties at 60fps
- **Offline**: Core features work with cached data
- **Accessibility**: VoiceOver/TalkBack support for primary flows
- **Gestures**: Must not conflict with system gestures (swipe-from-edge)

---

## Won't Have (This Iteration)

- 3D cube visualization (too complex for MVP)
- AR mode (future feature)
- Voice commands (text AI copilot first)
- Multi-window tablet mode (single-pane focus)
- Real-time collaboration (single-user first)

---

## Open Questions

- [x] Which 5 mechanics for MVP? → Galaxy, Lasso, Dimension Wheel, X-Ray, AI Copilot
- [x] Should swipe focus mode replace or complement current swipe? → **Complement** (toggle between Galaxy and Focus modes)
- [x] How to handle 10,000+ properties in galaxy without performance issues? → **Use existing API with pagination**, cluster points <20px apart, viewport culling, Redis cache (15 min TTL)
- [x] Which AI model for copilot queries (local vs. cloud)? → **Cloud API** via `/detective/copilot/query` endpoint for MVP
- [x] What field is "foreclosure probability"? → **Use `redemption_probability`** (inverse relationship: high redemption = low foreclosure)
- [ ] Should X-Ray insights be cached or computed on-demand?
- [ ] Voice input language support (English only for MVP?)

---

## References

### App Architecture
- Current app architecture: `/lib/features/swipe/`
- Design system: `/designsystem/`
- Domain models: `/lib/core/models/property_card_data.dart`, `tax_lien_models.dart`

### Data Pipeline (Vendor Flows)
- **Data Structure**: `/flows/sdd-data-structure/DATA_STRUCTURE.md` (90+ field schema)
- **ETL Pipeline**: `/flows/sdd-data-structure/02-data-flow-etl.md` (scraping → parsing → enrichment → ML)
- **ML Service**: `/vendor/taxlien-ml/flows/sdd-taxlien-ml/` (redemption probability, risk score, ROI prediction)
- **Gateway**: `/vendor/taxlien-gateway/` (API endpoints)
- **Parser**: `/vendor/taxlien-parser/` (platform configs for QPublic, Beacon, Bid4Assets, Tyler)

### External APIs (Enrichment)
- Zillow API: market estimates, rent estimates
- WalkScore API: walkability scores
- School Rating API: nearby school ratings
- FEMA API: flood zone data

### Original Concepts
- Original mechanics ideas: User input (25 concepts from Russian tax invoice UI)

---

## Approval

### Version 1.0
- [x] Reviewed by: Anton
- [x] Approved on: 2026-05-18
- [x] Notes: Requirements approved, proceed to visual phase

### Version 2.0 (Current)
- [ ] Reviewed by: Anton
- [ ] Approved on: [pending]
- [ ] Notes: Updated with vendor flow analysis (90+ fields, ML predictions, enrichment data, new dimensions, enhanced X-Ray insights, AI Copilot queries, property badges)
