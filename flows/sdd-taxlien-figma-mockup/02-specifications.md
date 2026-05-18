# Specifications: TaxLien Figma Mockup Design

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-03-11
> Requirements: [01-requirements.md](./01-requirements.md)

---

## Overview

This specification defines how to transfer visual design from Flutter code implementation to Figma, creating a comprehensive design system and screen mockups that enable design iteration without code changes.

---

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| Figma File | Create | New pages, frames, components for 4 key screens |
| SDD Documentation | Reference | Existing specs serve as source material |
| Flutter Code | None (current) | Code is source of truth for current implementation |
| Design Handoff | Future | Future code changes will reference Figma |

---

## Architecture

### Figma File Structure

```
TaxLien.online/
├── Page 1 (existing - branding)
├──  Screens (new)
│   ├── 01_Discovery_Swipe
│   ├── 02_Property_Details
│   ├── 03_Expert_Canvas
│   └── 04_Family_Board
├── 🧩 Components (new)
│   ├── Atoms (buttons, inputs, badges)
│   ├── Molecules (cards, lists, toolbars)
│   └── Organisms (full screens, modals)
├──  Design System (new)
│   ├── Colors
│   ├── Typography
│   ├── Spacing
│   └── Effects
└── 📐 Prototypes (new)
    ├── Swipe Flow
    └── Annotation Flow
```

---

## Design System Specifications

### Colors

Based on current Flutter implementation:

```
Primary Palette:
- Background: #FAFAFA (Colors.grey[100])
- Surface: #FFFFFF
- Primary: [To be defined from existing branding]
- Secondary: [To be defined]

Semantic Colors:
- Success: #4CAF50 (Like/Accept)
- Error: #F44336 (Dislike/Reject)
- Warning: #FF9800 (Foreclosure alerts)
- Info: #2196F3 (Information badges)

Text Colors:
- Primary: #000000
- Secondary: #757575 (Colors.grey)
- Disabled: #BDBDBD
```

### Typography

Based on Flutter default (Material Design):

```
Display: 24px, Bold (Headlines)
Title: 20px, SemiBold (Screen titles)
Body: 16px, Regular (Main content)
Caption: 14px, Regular (Secondary text)
Button: 14px, Medium (Action buttons)
```

### Spacing

```
Base unit: 4px
- xs: 4px
- s: 8px
- m: 16px
- l: 24px
- xl: 32px
- xxl: 48px
```

### Effects

```
Shadows:
- Card: 0px 2px 10px rgba(0,0,0,0.1)
- Elevated: 0px 4px 20px rgba(0,0,0,0.15)
- Modal: 0px 8px 40px rgba(0,0,0,0.2)

Border Radius:
- Small: 8px (buttons, chips)
- Medium: 12px (cards)
- Large: 20px (modals, sheets)
- Full: 999px (avatars)
```

---

## Screen Specifications

### 1. Discovery Swipe Screen (01_Discovery_Swipe)

**Frame:** 375x812 (iPhone X base)

#### Layout Structure:
```
┌─────────────────────────┐
│ AppBar (56px)           │
│ - Title                 │
│ - Filter icon           │
│ - Mode switch           │
│ - Profile picker        │
├─────────────────────────┤
│                         │
│   Card Stack Area       │
│   (flexible)            │
│                         │
├─────────────────────────┤
│ Action Buttons (80px)   │
│ - Dislike | Context |   │
│ - Like | Super Like     │
└─────────────────────────┘
```

#### Components Required:
- **PropertyCard:** 320x480 with image, address, FVI badge
- **FVIIndicator:** Circular progress with score
- **ExpertProfileIcon:** Small avatar with role indicator
- **ActionButton:** Circular button with icon (56x56)
- **FilterSheet:** Bottom sheet modal (full width, variable height)
- **NudgeBanner:** Horizontal banner with CTA

#### Overlays:
- Swipe gesture indicators (arrows)
- Score display (corner badge)
- Foreclosure probability badge

### 2. Property Deep-Dive Screen (02_Property_Details)

**Frame:** 375x812

#### Layout Structure:
```
┌─────────────────────────┐
│ Gallery Carousel (240px)│
│ - Main image            │
│ - Dot indicators        │
├─────────────────────────┤
│ Scrollable Content      │
│ - Address & Header      │
│ - FVI Breakdown Chart   │
│ - Property Details      │
│ - Tax Info              │
│ - Foreclosure Data      │
│ - Map Placeholder       │
│ - Annotations Preview   │
├─────────────────────────┤
│ Smart Banner (optional) │
└─────────────────────────┘
```

#### Components Required:
- **GalleryCarousel:** Image slider with dots
- **FVIBreakdownChart:** Bar/radar chart showing expert scores
- **DetailRow:** Label + Value pair
- **InfoSection:** Section with title and content
- **MapPlaceholder:** Gray box with map icon
- **AnnotationPreview:** List of marker previews

### 3. Expert Canvas Screen (03_Expert_Canvas)

**Frame:** 375x812

#### Layout Structure:
```
┌─────────────────────────┐
│ Top Bar (transparent)   │
│ - Back button           │
│ - Save/Submit           │
├─────────────────────────┤
│                         │
│   Image Canvas          │
│   (full screen)         │
│   + Annotation Layer    │
│                         │
├─────────────────────────┤
│ Toolbar (80px)          │
│ - Point tool           │
│ - Line tool            │
│ - Area tool            │
│ - Voice note           │
│ - Tag picker           │
└─────────────────────────┘
```

#### Components Required:
- **AnnotationCanvas:** Full-screen image with overlay
- **ToolButton:** Icon button with active state
- **Marker:** Point/line/area visualizations
- **CommentBubble:** Speech bubble with text
- **TagChip:** Emoji + text label
- **VoiceNoteButton:** Recording indicator

### 4. Family Board Screen (04_Family_Board)

**Frame:** 375x812

#### Layout Structure:
```
┌─────────────────────────┐
│ AppBar (56px)           │
│ - Title: Family Board   │
├─────────────────────────┤
│ Member Status (120px)   │
│ - Avatars with status   │
├─────────────────────────┤
│ Shared Interests List   │
│ (scrollable)            │
│ - Match cards           │
│ - Interest indicators   │
│ - Decision badges       │
├─────────────────────────┤
│ FAB: Add Interest       │
└─────────────────────────┘
```

#### Components Required:
- **MemberAvatar:** Circle with status indicator
- **MatchCard:** Property + expert agreement display
- **InterestIndicator:** Progress bar showing alignment
- **DecisionBadge:** Buy/Skip/Review recommendation
- **EmptyState:** Illustration + CTA

---

## Interactive Prototypes

### Flow 1: Swipe Flow
```
Discovery → (Like) → Details → (Annotate) → Canvas → (Save) → Family Board
```

### Flow 2: Filter Flow
```
Discovery → (Filter) → Filter Sheet → (Apply) → Filtered Discovery
```

---

## Edge Cases

| Case | Visual Treatment |
|------|------------------|
| Empty property list | Illustration + "No properties" message |
| Offline mode | Orange warning banner + cached indicator |
| Loading state | Skeleton screens, not spinners |
| Error state | Error icon + retry button |
| Long text | Truncation with ellipsis, expandable |

---

## Dependencies

### Requires
- Figma access with edit permissions
- Existing branding elements from current Figma file
- Expert profile colors/icons from code

### Blocks
- Future UI implementation changes
- Design system documentation
- Developer handoff process

---

## Integration Points

### External Systems
- Figma API (for programmatic updates if needed)

### Internal Systems
- SDD documentation (this spec references existing requirements)
- Flutter codebase (current source of truth)

---

## Testing Strategy

### Visual Verification
- [ ] All screens match current Flutter implementation
- [ ] Components are properly named and organized
- [ ] Design system tokens are defined

### Usability Review
- [ ] Touch targets meet 44x44 minimum
- [ ] Text has sufficient contrast (WCAG AA)
- [ ] Layout works on 375x812 and 414x896

---

## Open Design Questions

- [ ] What color scheme for each expert role?
- [ ] Should FVI use circular or linear progress indicator?
- [ ] How to visualize multi-dimensional swipe gestures?
- [ ] Should foreclosure mode have distinct theme?

---

## Approval

- [ ] Reviewed by: [name]
- [ ] Approved on: [date]
- [ ] Notes: [any conditions or clarifications]
