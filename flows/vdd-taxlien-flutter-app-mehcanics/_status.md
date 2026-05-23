# Status: vdd-taxlien-flutter-app-mechanics

## Current Phase

IMPLEMENTATION

## Phase Status

COMPLETE

## Last Updated

2026-05-18 by Claude

## Blockers

- None

## Progress

- [x] Requirements drafted
- [x] Requirements approved
- [x] Visual mockups drafted
- [x] Visual mockups approved
- [x] Specifications drafted
- [x] Specifications approved
- [x] Plan drafted
- [x] Plan approved
- [x] Implementation started
- [x] Implementation complete
- [ ] Documentation drafted
- [ ] Documentation approved

## Context Notes

Key decisions and context for resuming:

- User provided 25 futuristic UI mechanics ideas originally designed for Russian tax invoices
- Mechanics need adaptation to US tax liens/deeds/foreclosures domain
- Design system from /designsystem/ (VPN Client Pro style) needs Flutter implementation
- Current app has: 4-way swipe, annotation canvas, role-based views, FVI scoring
- Target: spatial document intelligence for tax lien discovery
- **v2.0**: Updated with 90+ field data schema from vendor flows (ETL pipeline analysis)
- Field corrections: use `redemption_probability` (not foreclosureProbability), `risk_score`, `expected_roi`, `payback_months`
- Added: exemption flags (homestead, veteran, senior, disability), enrichment data (Zillow, WalkScore, school ratings, flood zones)
- Extended dimensions: 7 MVP + 5 post-MVP (prior years, exemptions, owner tenure, payback, tax year)

## Domain Adaptation Notes

Russian tax invoice concepts → US Tax Lien equivalents:
- "Накладная" (invoice) → Tax Lien Certificate / Tax Deed
- "Контрагент" (counterparty) → Property Owner / County
- "НДС" (VAT) → Lien Amount / Interest Rate
- "Сумма" (amount) → Property Value / ROI
- "Статус регистрации" → Listing Stage (pre-auction, listed, OTC, sold)
- "Риск" → Foreclosure Probability / Karma Score
- "Избранное" → Watchlist / Family Board

## MVP Mechanics Selected

From user's 25 mechanics, prioritizing for MVP:
1. Property Galaxy (spatial map view)
2. Lasso Selection (gesture-based multi-select)
3. Dimension Wheel (switch: date/county/ROI/risk/stage)
4. X-Ray Mode (highlight issues/opportunities)
5. AI Copilot (voice + gesture property search)

## Extended Mechanics (from designlayouts)

Added 2026-05-24 from `designlayouts/screens/mechanics-phone.jsx`:
- See `02-visual-extended.md` for 9 additional mechanics:
  1. Layered Card (document stack)
  2. Orbit Favorites (radial triage)
  3. Magnetic Groups (relation clustering)
  4. AI Loupe (field magnifier)
  5. Command Palette (power-user access)
  6. Voice + Gesture (combined input)
  7. Map Layers (geographic overlay)
  8. Tax Radar (portfolio hub)
  9. Tax Graph (knowledge graph)

## Next Actions

1. Review extended mechanics in 02-visual-extended.md
2. Get user approval on extended visuals
3. Update specifications to include new mechanics
4. Update plan to include new mechanics implementation
