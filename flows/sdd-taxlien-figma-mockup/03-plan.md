# Plan: TaxLien Figma Mockup Creation

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-03-11
> Specifications: [02-specifications.md](./02-specifications.md)

---

## Overview

This plan breaks down the creation of Figma mockups into atomic tasks, following the specifications defined in `02-specifications.md`.

---

## Task Breakdown

### Phase 1: Design System Setup (Estimated: 2 hours)

#### Task 1.1: Create Figma Pages Structure
- [ ] Create "📱 Screens" page
- [ ] Create "🧩 Components" page
- [ ] Create "🎨 Design System" page
- [ ] Create "📐 Prototypes" page
- **Output:** Organized Figma file structure

#### Task 1.2: Define Color Styles
- [ ] Create color styles for Primary palette (Background, Surface)
- [ ] Create color styles for Semantic colors (Success, Error, Warning, Info)
- [ ] Create color styles for Text (Primary, Secondary, Disabled)
- [ ] Document usage for each color
- **Output:** Figma Color Styles library

#### Task 1.3: Define Text Styles
- [ ] Create text style: Display (24px, Bold)
- [ ] Create text style: Title (20px, SemiBold)
- [ ] Create text style: Body (16px, Regular)
- [ ] Create text style: Caption (14px, Regular)
- [ ] Create text style: Button (14px, Medium)
- **Output:** Figma Text Styles library

#### Task 1.4: Define Effects & Grid
- [ ] Create shadow styles (Card, Elevated, Modal)
- [ ] Define border radius tokens
- [ ] Set up layout grid (8px base)
- **Output:** Effect styles and grid system

---

### Phase 2: Component Library (Estimated: 3 hours)

#### Task 2.1: Atomic Components
- [ ] Button (Primary, Secondary, Icon variants)
- [ ] IconButton (Circular, 56x56)
- [ ] Chip/Tag (Selectable, Default states)
- [ ] Badge (Score, Status indicators)
- [ ] Avatar (Circular, with status ring)
- [ ] Input field (Text, Search)
- **Output:** Atom component library

#### Task 2.2: Molecular Components
- [ ] PropertyCard (320x480, with image placeholder)
- [ ] ActionButtonRow (4 buttons layout)
- [ ] DetailRow (Label + Value)
- [ ] InfoSection (Title + content group)
- [ ] FilterChip (Multi-select)
- [ ] ExpertIndicator (Avatar + score)
- **Output:** Molecule component library

#### Task 2.3: Organism Components
- [ ] AppBar (with title and actions)
- [ ] BottomSheet (Filter, Share, etc.)
- [ ] NudgeBanner (Tutorial prompt)
- [ ] GalleryCarousel (Image + dots)
- [ ] FVIBreakdown (Chart visualization)
- [ ] AnnotationToolbar (Drawing tools)
- **Output:** Organism component library

---

### Phase 3: Screen Mockups (Estimated: 4 hours)

#### Task 3.1: Discovery Swipe Screen
- [ ] Create frame: 375x812, named "01_Discovery_Swipe"
- [ ] Add AppBar with filter icon, mode switch, profile picker
- [ ] Place PropertyCard in center
- [ ] Add FVI overlay indicator
- [ ] Add ActionButtonRow at bottom
- [ ] Create FilterSheet variant (bottom sheet modal)
- [ ] Add NudgeBanner variant
- [ ] Add swipe gesture annotations (arrows, labels)
- **Output:** Complete Discovery screen mockup

#### Task 3.2: Property Deep-Dive Screen
- [ ] Create frame: 375x812, named "02_Property_Details"
- [ ] Add GalleryCarousel at top (240px height)
- [ ] Add property header (address, badges)
- [ ] Add FVIBreakdown chart
- [ ] Add DetailRow sections (Tax Info, Foreclosure Data)
- [ ] Add MapPlaceholder
- [ ] Add AnnotationPreview section
- [ ] Add SmartBanner (optional variant)
- **Output:** Complete Property Details screen mockup

#### Task 3.3: Expert Canvas Screen
- [ ] Create frame: 375x812, named "03_Expert_Canvas"
- [ ] Add full-screen image placeholder
- [ ] Add transparent top bar with back/save buttons
- [ ] Add AnnotationToolbar at bottom
- [ ] Create marker variants (Point, Line, Area)
- [ ] Add CommentBubble example
- [ ] Add TagChip examples
- **Output:** Complete Expert Canvas screen mockup

#### Task 3.4: Family Board Screen
- [ ] Create frame: 375x812, named "04_Family_Board"
- [ ] Add AppBar with title
- [ ] Add MemberStatus row (avatars with status)
- [ ] Add MatchCard examples
- [ ] Add InterestIndicator components
- [ ] Add DecisionBadge examples
- [ ] Add EmptyState variant
- [ ] Add FAB (Floating Action Button)
- **Output:** Complete Family Board screen mockup

---

### Phase 4: Prototypes & Handoff (Estimated: 1 hour)

#### Task 4.1: Create Interactive Prototypes
- [ ] Link Discovery → Details (on Like action)
- [ ] Link Details → Canvas (on Annotate action)
- [ ] Link Discovery → FilterSheet (on Filter action)
- [ ] Add hover states for buttons
- [ ] Add transition annotations
- **Output:** Clickable prototype flow

#### Task 4.2: Documentation & Handoff
- [ ] Add notes to each screen (measurements, behaviors)
- [ ] Create export settings for assets
- [ ] Organize layers with proper naming
- [ ] Add version note to _status.md
- **Output:** Developer-ready handoff

---

## Dependencies

```
Phase 1 (Design System)
    ↓
Phase 2 (Components)
    ↓
Phase 3 (Screens)
    ↓
Phase 4 (Prototypes)
```

---

## File Changes

### Figma File (External)
- **Create:** New pages, frames, components, styles
- **Modify:** Existing Page 1 (keep branding, add organization)

### SDD Artifacts
- **Update:** `_status.md` after each phase completion
- **Create:** This plan document
- **Reference:** Existing requirements and specifications

---

## Estimated Complexity

| Phase | Complexity | Time Estimate |
|-------|------------|---------------|
| Phase 1: Design System | Low | 2 hours |
| Phase 2: Components | Medium | 3 hours |
| Phase 3: Screens | High | 4 hours |
| Phase 4: Prototypes | Low | 1 hour |
| **Total** | **Medium-High** | **10 hours** |

---

## Rollback Considerations

- If Figma file access is unavailable, pause and notify user
- If scope is too large, prioritize Phase 1-2 and Phase 3.1 (Discovery screen) first
- If design decisions require approval, update _status.md with blockers

---

## Success Criteria

- [ ] All 4 screens are designed as separate Figma frames
- [ ] Design system is defined with colors, typography, effects
- [ ] Components are reusable and properly named
- [ ] Layers are organized and named logically
- [ ] Prototype links demonstrate key user flows
- [ ] Handoff notes are complete for developers

---

## Approval

- [ ] Reviewed by: [name]
- [ ] Approved on: [date]
- [ ] Notes: [any conditions or clarifications]
