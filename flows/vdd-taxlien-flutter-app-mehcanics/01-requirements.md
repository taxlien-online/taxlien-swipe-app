# Requirements: Tax Lien Spatial Intelligence

> Version: 1.0
> Status: DRAFT
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

- **Foreclosure Probability** (0.0-1.0): ML prediction
- **Prior Years Owed**: Delinquency depth
- **Karma Score** (-1.0 to 1.0): Ethical considerations
- **FVI (Family Value Index)**: Expert composite score
- **X1000 Score**: Hidden treasure potential

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
2. Dimensions: Date | County | ROI | Risk | Stage | FVI | Property Type
3. Smooth animated transition between layouts (300ms)
4. Current dimension displayed in corner HUD
5. Maintain selection across dimension switches

---

### Primary: X-Ray Mode

**As a** due diligence researcher
**I want** to instantly highlight issues and opportunities on a property
**So that** I can make faster decisions without reading every field

**Acceptance Criteria:**
1. Two-finger swipe down on property card activates X-Ray
2. Highlights: title issues, environmental flags, high ROI, unusual patterns
3. Shows: missing data fields, stale listings, price anomalies
4. AI explanation for each highlighted issue
5. Exit with two-finger swipe up

---

### Primary: AI Deal Copilot

**As a** investor on mobile
**I want** to speak or type natural language queries
**So that** I can filter/navigate without complex UI interactions

**Acceptance Criteria:**
1. Bottom sheet with text input and microphone
2. Queries like: "Show high ROI in Florida", "Find liens under $5k"
3. AI interprets and applies filters to spatial view
4. Can combine with gesture: lasso + voice "keep only deeds"
5. History of recent queries accessible

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
- [ ] Should swipe focus mode replace or complement current swipe?
- [ ] How to handle 10,000+ properties in galaxy without performance issues?
- [ ] Which AI model for copilot queries (local vs. cloud)?

---

## References

- Current app architecture: `/lib/features/swipe/`
- Design system: `/designsystem/`
- Domain models: `/lib/core/models/property_card_data.dart`, `tax_lien_models.dart`
- Original mechanics ideas: User input (25 concepts from Russian tax invoice UI)

---

## Approval

- [ ] Reviewed by: Anton
- [ ] Approved on: [pending]
- [ ] Notes: [any conditions or clarifications]
