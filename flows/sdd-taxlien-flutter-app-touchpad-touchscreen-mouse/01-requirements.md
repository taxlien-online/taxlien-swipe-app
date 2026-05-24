# Requirements: Gesture & Input Handling System

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-05-24

## Overview

A unified input handling layer that provides consistent gesture detection across touchscreen, trackpad, and mouse devices. This foundation enables the extended mechanics (Layered Card, Orbit Favorites, etc.) to work seamlessly on all platforms.

## Goals

1. **Platform abstraction** - Same gesture API works on touch, trackpad, and mouse
2. **Multi-touch support** - Track 1-4 simultaneous pointers
3. **Velocity detection** - Enable flick gestures with physics
4. **Composability** - Gestures can be combined (e.g., long-press + drag)
5. **Accessibility** - Keyboard alternatives for all gestures

---

## User Stories

### US-1: Touch Gestures (Mobile)

As a mobile user, I want to use natural touch gestures so that I can interact with properties intuitively.

**Acceptance Criteria:**
- [ ] Single tap selects/activates elements
- [ ] Double tap zooms or opens detail
- [ ] Long press (500ms) activates contextual mode
- [ ] Swipe navigates or dismisses
- [ ] Flick (velocity > 1000px/s) triggers quick actions
- [ ] Pinch zooms canvas views
- [ ] Two-finger pan moves without selecting
- [ ] Lasso draw with single finger selects multiple

### US-2: Multi-Touch Gestures

As a power user on touch devices, I want multi-finger gestures so that I can access advanced features quickly.

**Acceptance Criteria:**
- [ ] Two-finger drag detects property relationships (Magnetic Groups)
- [ ] Three-finger pull-down opens Command Palette
- [ ] Three-finger pull-up closes Command Palette
- [ ] Four-finger swipe reserved for system (no conflict)

### US-3: Trackpad Gestures (Desktop)

As a macOS/laptop user, I want trackpad gestures so that I can work efficiently without a mouse.

**Acceptance Criteria:**
- [ ] Two-finger scroll pans canvas/lists
- [ ] Two-finger pinch zooms canvas
- [ ] Two-finger rotate (optional, for graph view)
- [ ] Three-finger swipe matches touch behavior
- [ ] Force touch triggers long-press equivalent (if available)

### US-4: Mouse Interactions

As a desktop user with a mouse, I want precise click/hover interactions so that I can work efficiently.

**Acceptance Criteria:**
- [ ] Left click selects/activates
- [ ] Right click opens context menu
- [ ] Double click opens detail/zooms
- [ ] Hover shows tooltips/previews
- [ ] Click + drag moves elements
- [ ] Shift + click adds to selection
- [ ] Scroll wheel zooms or scrolls (context-dependent)
- [ ] Cursor changes indicate affordances (pointer, grab, crosshair)

### US-5: Keyboard Alternatives

As a user with accessibility needs, I want keyboard alternatives so that I can use all features without pointing devices.

**Acceptance Criteria:**
- [ ] Tab navigates focusable elements
- [ ] Enter/Space activates focused element
- [ ] Arrow keys navigate within containers
- [ ] Esc cancels/closes overlays
- [ ] Cmd/Ctrl + K opens Command Palette
- [ ] Shortcuts documented and discoverable

### US-6: Gesture Conflicts Resolution

As a developer, I want clear gesture priority rules so that conflicting gestures are handled predictably.

**Acceptance Criteria:**
- [ ] Vertical swipe wins over horizontal if Δy > Δx * 1.5
- [ ] Long press cancels if move > 10px before threshold
- [ ] Multi-finger gestures take priority over single-finger
- [ ] System gestures (4-finger) never intercepted
- [ ] Gesture arena resolves conflicts deterministically

---

## Gesture Catalog

### Single Pointer

| Gesture | Touch | Trackpad | Mouse | Keyboard |
|---------|-------|----------|-------|----------|
| Tap | 1-finger tap | Click | Left click | Enter |
| Double tap | 2x tap | Double click | Double click | - |
| Long press | Hold 500ms | Force touch | - | - |
| Swipe | Drag + release | Two-finger scroll | - | Arrow keys |
| Flick | Drag + fast release | - | - | - |
| Drag | Hold + move | Click + drag | Click + drag | - |

### Multi Pointer

| Gesture | Touch | Trackpad | Mouse | Keyboard |
|---------|-------|----------|-------|----------|
| Pinch/zoom | 2 fingers | 2-finger pinch | Scroll wheel | +/- keys |
| Pan | 2-finger drag | 2-finger scroll | Middle drag | Arrows |
| Rotate | 2-finger rotate | 2-finger rotate | - | - |
| Lasso | 1-finger draw | Click + drag | Click + drag | - |
| Relationship | 2-finger drag | - | Shift + drag | - |
| Command | 3-finger down | 3-finger down | - | Cmd+K |

---

## Platform-Specific Behaviors

### iOS
- Respect system gesture zones (edges for back swipe)
- Support haptic feedback for long press
- Handle notch/Dynamic Island safe areas

### Android
- Support system back gesture (edge swipe)
- Handle navigation bar gestures
- Support stylus input

### macOS
- Support trackpad gestures natively
- Handle menu bar and dock interactions
- Support force touch where available

### Windows/Linux
- Mouse-centric by default
- Support touchpad gestures via libinput (Linux)
- Handle window snap gestures

---

## Non-Goals

- N1: Game controller input
- N2: Stylus pressure sensitivity
- N3: Eye tracking
- N4: Voice-as-gesture (separate from Voice+Gesture mechanic)

## Constraints

- C1: Must not conflict with OS-level gestures
- C2: Must work with Flutter's gesture arena
- C3: Must support hot reload during development
- C4: Performance: gesture detection < 16ms (60fps)

## Dependencies

- D1: Flutter gesture system (`GestureDetector`, `Listener`, `RawGestureDetector`)
- D2: Design system tokens (for timing thresholds)
- D3: Extended mechanics (consumers of this system)

---

## Approval

- [x] Reviewed by: Anton
- [x] Approved on: 2026-05-24
- [x] Notes: Foundation for extended mechanics gestures
