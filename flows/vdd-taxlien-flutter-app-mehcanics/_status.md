# Status: vdd-taxlien-flutter-app-mechanics

## Current Phase

REQUIREMENTS

## Phase Status

DRAFTING

## Last Updated

2026-05-18 by Claude

## Blockers

- None

## Progress

- [x] Requirements drafted
- [ ] Requirements approved
- [ ] Visual mockups drafted
- [ ] Visual mockups approved
- [ ] Specifications drafted
- [ ] Specifications approved
- [ ] Plan drafted
- [ ] Plan approved
- [ ] Implementation started
- [ ] Implementation complete
- [ ] Documentation drafted
- [ ] Documentation approved

## Context Notes

Key decisions and context for resuming:

- User provided 25 futuristic UI mechanics ideas originally designed for Russian tax invoices
- Mechanics need adaptation to US tax liens/deeds/foreclosures domain
- Design system from /designsystem/ (VPN Client Pro style) needs Flutter implementation
- Current app has: 4-way swipe, annotation canvas, role-based views, FVI scoring
- Target: spatial document intelligence for tax lien discovery

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

## Next Actions

1. Complete requirements document with user story mapping
2. Create ASCII visual mockups for each core mechanic
3. Get user approval on requirements
4. Get user approval on visuals
5. Proceed to specifications phase
