# Requirements: Extended Mechanics for Tax Lien App

> Version: 1.0
> Status: APPROVED (inherited from vdd-taxlien-flutter-app-mechanics)
> Last Updated: 2026-05-24

## Overview

This document specifies requirements for 9 advanced mechanics that extend the core Tax Lien App functionality. These mechanics provide power-user features for property discovery, analysis, and organization.

## Target Platform

- **App**: `app/taxlien-app/` (Flutter)
- **Design System**: `app/taxlien-app/lib/design/` (already implemented)
- **Core Mechanics**: Galaxy, Lasso, Dimension Wheel, X-Ray, AI Copilot (from parent flow)

---

## Mechanic 7: Layered Card (Document Stack)

### User Story

As a tax lien investor, I want to view property information as stacked layers so that I can drill into specific aspects (valuation, tax parameters, connections, history, risk) without leaving the property context.

### Requirements

- R7.1: Property detail shows 5 stacked layers visually offset
- R7.2: Layers (bottom to top):
  1. Items & valuation (green) - Building + land breakdown
  2. Tax parameters (orange) - Issue date, rate, subsequent taxes
  3. Connections (blue) - Linked auction, prior owners, satellites
  4. Edit history (purple) - Changes, who made them
  5. Risk analysis (red) - ML scores, comparable redemption
- R7.3: Swipe down gesture dives into the currently focused layer
- R7.4: Swipe up returns to stack overview
- R7.5: Each layer expands to full-screen detail view

### Acceptance Criteria

- [ ] Stack visually shows layer offset/peek
- [ ] Swipe down expands current layer
- [ ] Swipe up collapses to stack
- [ ] All 5 layers have distinct content

---

## Mechanic 8: Orbit Favorites (Radial Triage)

### User Story

As a tax lien investor reviewing properties quickly, I want to flick cards into categorized zones so that I can triage large volumes efficiently.

### Requirements

- R8.1: Card in center, radial drop zones around it
- R8.2: Zones (customizable):
  - ↑ Watchlist (default)
  - ↗ To review
  - → Urgent
  - ↘ Disputed
  - ↓ To attorney
  - ↙ Archive
- R8.3: Flick gesture sends card to zone in that direction
- R8.4: Long-press + drag for precise placement
- R8.5: Zone badge shows current count
- R8.6: Zones are user-configurable boards

### Acceptance Criteria

- [ ] Radial zones visible around draggable card
- [ ] Flick sends to nearest zone
- [ ] Long-press enables fine control
- [ ] Counts update in real-time

---

## Mechanic 9: Magnetic Groups

### User Story

As a tax lien investor, I want properties with relationships to automatically cluster so that I can identify patterns (same owner, same street, similar amounts).

### Requirements

- R9.1: Toggle "Magnets ON" activates clustering
- R9.2: Properties cluster by detected relationship:
  - Same owner (blue)
  - Same street (green)
  - Similar amount ±5% (orange)
  - Same auction (purple)
  - Same tax year (gray)
- R9.3: Dragging two properties together shows relationship
- R9.4: Pinch on cluster expands to show all members
- R9.5: Tap cluster label filters to that group
- R9.6: Relationship strength bar shows match quality

### Acceptance Criteria

- [ ] Toggle enables magnetic clustering
- [ ] Properties animate into clusters
- [ ] Relationship type shown on cluster
- [ ] Expand/collapse clusters with pinch

---

## Mechanic 10: AI Loupe

### User Story

As a novice investor, I want to hover over any field and get an AI explanation so that I understand what values mean and whether they're unusual.

### Requirements

- R10.1: Long-press activates circular loupe at finger position
- R10.2: Loupe magnifies underlying UI element
- R10.3: AI explanation panel shows:
  - Field value
  - Comparison to median/average
  - Interpretation (anomaly, normal, opportunity)
  - Likely causes
- R10.4: Drag to move loupe over different fields
- R10.5: Release keeps explanation visible
- R10.6: Tap elsewhere dismisses

### Acceptance Criteria

- [ ] Long-press shows circular loupe
- [ ] Loupe follows finger drag
- [ ] AI explanation appears for hovered field
- [ ] Dismiss on tap outside

---

## Mechanic 11: Command Palette

### User Story

As a power user, I want a quick-access command palette so that I can execute searches, presets, and batch actions without navigating menus.

### Requirements

- R11.1: 3-finger pull-down gesture opens palette
- R11.2: Search input at top with fuzzy matching
- R11.3: Command types:
  - Owner search
  - Preset filters (overdue, high ROI)
  - AI natural language queries
  - Property comparison
  - Batch actions (add to watchlist)
  - Export (premium)
  - Temporal filters (auctions by date)
  - Manual data refresh
- R11.4: Keyboard navigation (↑↓ navigate, ↵ execute)
- R11.5: 3-finger up or ESC closes
- R11.6: Recent commands shown first

### Acceptance Criteria

- [ ] 3-finger down opens palette
- [ ] Typing filters commands
- [ ] Commands execute correctly
- [ ] Palette dismisses properly

---

## Mechanic 12: Voice + Gesture Combo

### User Story

As a mobile user, I want to refine my lasso selection using voice so that I can filter without typing on a small screen.

### Requirements

- R12.1: While lasso selection active, hold mic button to record
- R12.2: Real-time waveform visualization
- R12.3: Live transcription with entity highlighting
- R12.4: Extracted filter tags shown as badges
- R12.5: Release applies filter to current selection
- R12.6: Supports commands like "keep only deeds" or "remove high risk"

### Acceptance Criteria

- [ ] Mic button visible during selection
- [ ] Waveform shows while recording
- [ ] Transcription appears in real-time
- [ ] Filter applies on release

---

## Mechanic 13: Map Layers

### User Story

As a location-focused investor, I want to see properties on a geographic map with toggleable data layers so that I can analyze spatial patterns.

### Requirements

- R13.1: Full-screen map with property markers
- R13.2: Toggleable layers:
  - Properties (dots)
  - Owner clusters (grouped by owner)
  - Risk heatmap (hot spots)
  - Flood zones (FEMA data)
  - School ratings (district overlay)
  - Auction venues (courthouse pins + dates)
  - Walkability (WalkScore)
- R13.3: Layer panel shows active count
- R13.4: Pinch to zoom, pan to move
- R13.5: Tap marker shows property card

### Acceptance Criteria

- [ ] Map renders with markers
- [ ] Layers toggle on/off
- [ ] Layer counts update
- [ ] Property card on marker tap

---

## Mechanic 14: Tax Radar

### User Story

As a portfolio holder, I want to see a radar visualization centered on my holdings so that I can monitor counterparty activity in real-time.

### Requirements

- R14.1: Hub (center) = user's portfolio summary
- R14.2: Spokes = counterparties (owners, counties, entities)
- R14.3: Distance from center = recency of last interaction
- R14.4: Node size = volume of dealings
- R14.5: Glow color = relationship type (danger, success, neutral)
- R14.6: Sweep line animates live activity scan
- R14.7: Activity feed shows recent pings

### Acceptance Criteria

- [ ] User portfolio at center
- [ ] Counterparties positioned by recency
- [ ] Node sizes reflect volume
- [ ] Activity feed updates

---

## Mechanic 15: Tax Graph

### User Story

As an investigator, I want to see a full knowledge graph of entities and relationships so that I can discover hidden connections and anomalies.

### Requirements

- R15.1: Node types:
  - You (blue, center)
  - Properties (green)
  - Owners (orange)
  - Counties (purple)
  - Auctions (red)
  - Payments (cyan)
  - Contracts (teal)
- R15.2: Edges show relationships (owns, listed_in, sold_at, etc.)
- R15.3: AI anomaly detection highlights suspicious patterns
- R15.4: Drag nodes to rearrange layout
- R15.5: Tap node highlights all connections
- R15.6: "Explain" button for AI pattern explanation

### Acceptance Criteria

- [ ] Graph renders with typed nodes
- [ ] Edges connect related entities
- [ ] AI anomalies highlighted
- [ ] Explanation modal works

---

## Non-Goals

- N1: Real-time collaboration (future release)
- N2: Offline graph sync (requires server)
- N3: Voice input in Command Palette (only in Voice+Gesture)

## Constraints

- C1: Must use existing design system tokens
- C2: Must work on iOS and Android
- C3: Must degrade gracefully without AI service
- C4: Map layers require location permissions

## Dependencies

- D1: Core mechanics from `vdd-taxlien-flutter-app-mechanics`
- D2: Design system from `vdd-taxlien-app-designsystem`
- D3: AI service for Loupe and Graph anomalies
- D4: Speech recognition SDK for Voice+Gesture
- D5: Map SDK (Google Maps or Mapbox)
