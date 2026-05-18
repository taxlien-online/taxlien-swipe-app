# Requirements: TaxLien Figma Mockup Design

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-03-11

---

## Problem Statement

**Current State:** Visual specifications exist only in:
- SDD documentation (`02-specifications.md`)
- Flutter code implementation (`lib/features/**/*.dart`)
- Partial Figma file with branding elements only

**Problem:** Design iterations require code changes, making it difficult to:
- Quickly prototype visual changes
- Collaborate on design with non-technical stakeholders
- Maintain design consistency across screens
- Test different visual approaches before implementation

**Goal:** Create comprehensive Figma mockups that serve as the single source of truth for UI/UX design, enabling design refinement before code implementation.

---

## User Stories

### Primary

**As a** Product Designer
**I want** complete Figma mockups for all TaxLien app screens
**So that** I can iterate on design visually without modifying code

**As a** Developer
**I want** Figma designs with proper layers, components, and specs
**So that** I can implement pixel-perfect UI with clear guidance

**As a** Product Owner
**I want** to see visual representation of features before development
**So that** I can validate UX decisions and provide feedback early

### Secondary

**As an** Expert User (Khun Pho, Denis, Anton, Vasilisa)
**I want** role-specific UI visualizations
**So that** I can see how my expertise is represented in the interface

---

## Acceptance Criteria

### Must Have

1. **Given** existing Figma file with branding elements
   **When** mockup creation is complete
   **Then** all 4 key screens are designed as separate frames with proper naming

2. **Given** Flutter code implementation
   **When** transferred to Figma
   **Then** all UI elements are represented as proper Figma components (buttons, cards, overlays)

3. **Given** expert profile requirements
   **When** designing screens
   **Then** each expert's unique UI elements are visualized (annotation tools, markers, FVI display)

4. **Given** multi-dimensional swipe gestures
   **When** documented in Figma
   **Then** gesture indicators and interactions are shown with annotations

### Should Have

- Design system with colors, typography, spacing tokens
- Component library (buttons, cards, modals, sheets)
- Interactive prototypes for key flows
- Mobile responsive variants (different screen sizes)

### Won't Have (This Iteration)

- Dark mode variants
- Tablet/iPad layouts
- Animation specifications (separate SDD if needed)

---

## Constraints

- **Technical:** Must work within existing Figma file structure (TaxLien.online)
- **Platform:** iOS/Android mobile (375x812 base resolution)
- **Dependencies:** Requires access to Figma file with edit permissions
- **Time:** Design should reflect current code implementation, not future features

---

## Scope: Screens to Design

### 1. Discovery Swipe Screen (Home)
- Card stack with property images
- FVI (Financial Value Index) overlay indicators
- Expert profile indicator
- Action buttons (Like, Dislike, Super Like, Context)
- Filter sheet modal
- Tutorial nudge banners

### 2. Property Deep-Dive Screen
- Photo gallery carousel
- FVI breakdown visualization
- Property details (address, tax info, foreclosure probability)
- Interactive map placeholder
- Expert annotations preview
- Smart banner for deep links

### 3. Expert Canvas (Annotation Mode)
- Full-screen image with annotation layer
- Drawing toolbar (point, line, area tools)
- Voice note button
- Tag/emoji picker
- Comment display

### 4. Family Collaborative Board
- Shared interests list
- Match indicators between experts
- Decision recommendations
- Family member avatars with status

---

## Open Questions

- [ ] Should we design for specific iOS/Android device frames?
- [ ] Do we need separate frames for beginner vs advanced swipe modes?
- [ ] Should foreclosure filter mode have distinct visual treatment?
- [ ] What is the target resolution for Figma frames?

---

## References

- Existing SDD: `flows/sdd-taxlien-swipe-app/01-requirements.md`
- Existing SDD: `flows/sdd-taxlien-swipe-app/02-specifications.md`
- Figma File: https://www.figma.com/design/xZyZSj9QI8NHgN5MXNPbQD/TaxLien.online
- Current Node: 1-8 (TaxLien.online header)

---

## Approval

- [ ] Reviewed by: [name]
- [ ] Approved on: [date]
- [ ] Notes: [any conditions or clarifications]
