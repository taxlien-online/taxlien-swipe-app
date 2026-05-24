# Implementation Plan: Gesture & Input Handling System

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-05-24

## Overview

Implementation plan for unified gesture/input handling layer. Organized into 4 phases.

**Total Tasks**: 28
**Target Directory**: `lib/core/input/`

---

## Phase 1: Foundation

### 1.1 Create directory structure
- **Files**: Create `lib/core/input/` with subdirectories
- **Changes**:
  ```
  lib/core/input/
  ├── gestures/
  ├── recognizers/
  ├── adapters/
  ├── providers/
  ├── widgets/
  └── testing/
  ```
- **Complexity**: Low
- **Dependencies**: None

### 1.2 Implement GestureSettings
- **Files**: `lib/core/input/providers/gesture_settings.dart`
- **Changes**: Constants for timing/distance thresholds
- **Complexity**: Low
- **Dependencies**: 1.1

### 1.3 Implement InputMode enum and InputModeProvider
- **Files**: `lib/core/input/providers/input_mode_provider.dart`
- **Changes**: InputMode enum, ChangeNotifier for mode detection
- **Complexity**: Low
- **Dependencies**: 1.1

### 1.4 Create barrel export
- **Files**: `lib/core/input/input.dart`
- **Changes**: Export all public APIs
- **Complexity**: Low
- **Dependencies**: 1.1

---

## Phase 2: Gesture Recognizers

### 2.1 Implement FlickRecognizer
- **Files**: `lib/core/input/recognizers/flick_recognizer.dart`
- **Changes**:
  - FlickDetails class
  - FlickDirection enum
  - FlickRecognizer extending OneSequenceGestureRecognizer
  - VelocityTracker integration
- **Complexity**: Medium
- **Dependencies**: 1.2

### 2.2 Implement DirectionalSwipeRecognizer
- **Files**: `lib/core/input/recognizers/directional_swipe_recognizer.dart`
- **Changes**:
  - SwipeDirection enum
  - SwipeCallback typedef
  - DirectionalSwipeRecognizer extending OneSequenceGestureRecognizer
- **Complexity**: Medium
- **Dependencies**: 1.2

### 2.3 Implement LassoRecognizer
- **Files**: `lib/core/input/recognizers/lasso_recognizer.dart`
- **Changes**:
  - LassoDetails class with point-in-polygon test
  - LassoPhase enum
  - LassoRecognizer with path simplification
- **Complexity**: Medium
- **Dependencies**: 1.2

### 2.4 Implement MultiTouchRecognizer
- **Files**: `lib/core/input/recognizers/multi_touch_recognizer.dart`
- **Changes**:
  - MultiTouchDetails class
  - MultiTouchPhase enum
  - MultiTouchRecognizer StatefulWidget with Listener
  - Centroid, scale, rotation calculations
- **Complexity**: High
- **Dependencies**: 1.2

### 2.5 Create recognizers barrel export
- **Files**: `lib/core/input/recognizers/recognizers.dart`
- **Changes**: Export all recognizers
- **Complexity**: Low
- **Dependencies**: 2.1-2.4

---

## Phase 3: Platform Adapters

### 3.1 Implement InputAdapter interface
- **Files**: `lib/core/input/adapters/input_adapter.dart`
- **Changes**:
  - InputAdapter abstract class
  - GestureType enum
  - CursorAction enum
- **Complexity**: Low
- **Dependencies**: 1.3

### 3.2 Implement TouchAdapter
- **Files**: `lib/core/input/adapters/touch_adapter.dart`
- **Changes**: Touch-specific gesture support matrix
- **Complexity**: Low
- **Dependencies**: 3.1

### 3.3 Implement TrackpadAdapter
- **Files**: `lib/core/input/adapters/trackpad_adapter.dart`
- **Changes**:
  - macOS scroll normalization
  - Trackpad gesture support
  - Cursor mappings
- **Complexity**: Low
- **Dependencies**: 3.1

### 3.4 Implement MouseAdapter
- **Files**: `lib/core/input/adapters/mouse_adapter.dart`
- **Changes**:
  - Scroll multiplier
  - Mouse-specific gesture support
  - Full cursor mapping
- **Complexity**: Low
- **Dependencies**: 3.1

### 3.5 Create adapters barrel export
- **Files**: `lib/core/input/adapters/adapters.dart`
- **Changes**: Export all adapters
- **Complexity**: Low
- **Dependencies**: 3.2-3.4

---

## Phase 4: Unified Widgets

### 4.1 Implement HoverBuilder
- **Files**: `lib/core/input/widgets/hover_builder.dart`
- **Changes**: StatefulWidget with MouseRegion, hover state tracking
- **Complexity**: Low
- **Dependencies**: 3.4

### 4.2 Implement CursorRegion
- **Files**: `lib/core/input/widgets/cursor_region.dart`
- **Changes**: Wrapper for dynamic cursor changes
- **Complexity**: Low
- **Dependencies**: 3.1

### 4.3 Implement KeyboardShortcutWrapper
- **Files**: `lib/core/input/widgets/keyboard_shortcuts.dart`
- **Changes**:
  - AppShortcuts static class
  - KeyboardShortcutWrapper using CallbackShortcuts
- **Complexity**: Low
- **Dependencies**: 1.1

### 4.4 Implement UnifiedGestureDetector
- **Files**: `lib/core/input/widgets/unified_gesture_detector.dart`
- **Changes**:
  - All gesture callbacks as optional params
  - Integration with all recognizers
  - Input mode detection
  - Platform adapter selection
- **Complexity**: High
- **Dependencies**: 2.5, 3.5, 4.1-4.3

### 4.5 Create widgets barrel export
- **Files**: `lib/core/input/widgets/widgets.dart`
- **Changes**: Export all widgets
- **Complexity**: Low
- **Dependencies**: 4.1-4.4

### 4.6 Update main barrel export
- **Files**: `lib/core/input/input.dart`
- **Changes**: Export all sub-barrels
- **Complexity**: Low
- **Dependencies**: 2.5, 3.5, 4.5

---

## Phase 5: Testing & Integration

### 5.1 Implement gesture test helpers
- **Files**: `lib/core/input/testing/gesture_test_helpers.dart`
- **Changes**:
  - GestureTestExtensions on WidgetTester
  - flick(), twoFingerDrag(), threeFingerPullDown()
- **Complexity**: Medium
- **Dependencies**: 2.5

### 5.2 Write FlickRecognizer tests
- **Files**: `test/core/input/recognizers/flick_recognizer_test.dart`
- **Changes**:
  - Test velocity threshold
  - Test direction detection
  - Test rejection for slow gestures
- **Complexity**: Medium
- **Dependencies**: 2.1, 5.1

### 5.3 Write LassoRecognizer tests
- **Files**: `test/core/input/recognizers/lasso_recognizer_test.dart`
- **Changes**:
  - Test point collection
  - Test point-in-polygon
  - Test path simplification
- **Complexity**: Medium
- **Dependencies**: 2.3, 5.1

### 5.4 Write MultiTouchRecognizer tests
- **Files**: `test/core/input/recognizers/multi_touch_recognizer_test.dart`
- **Changes**:
  - Test 2-finger detection
  - Test 3-finger detection
  - Test centroid calculation
- **Complexity**: Medium
- **Dependencies**: 2.4, 5.1

### 5.5 Write UnifiedGestureDetector tests
- **Files**: `test/core/input/widgets/unified_gesture_detector_test.dart`
- **Changes**:
  - Test tap, double tap, long press
  - Test flick delegation
  - Test multi-touch delegation
  - Test input mode switching
- **Complexity**: High
- **Dependencies**: 4.4, 5.1

### 5.6 Write adapter tests
- **Files**: `test/core/input/adapters/adapters_test.dart`
- **Changes**:
  - Test gesture support matrix
  - Test scroll normalization
  - Test cursor mapping
- **Complexity**: Low
- **Dependencies**: 3.5

### 5.7 Integration with GalaxyCanvas
- **Files**: `lib/widgets/galaxy_canvas.dart`
- **Changes**:
  - Replace raw Listener with UnifiedGestureDetector
  - Use LassoRecognizer instead of manual path
  - Add keyboard shortcuts for navigation
- **Complexity**: Medium
- **Dependencies**: 4.6

### 5.8 Documentation
- **Files**: `lib/core/input/README.md`
- **Changes**:
  - Usage examples for each widget
  - Gesture catalog reference
  - Platform behavior notes
- **Complexity**: Low
- **Dependencies**: 4.6

---

## Task Summary

| Phase | Tasks | Complexity |
|-------|-------|------------|
| 1: Foundation | 4 | Low |
| 2: Recognizers | 5 | Medium-High |
| 3: Adapters | 5 | Low |
| 4: Widgets | 6 | Low-High |
| 5: Testing | 8 | Low-High |
| **Total** | **28** | |

---

## Dependency Graph

```
Phase 1 (Foundation)
    │
    ├──► Phase 2 (Recognizers)
    │         │
    │         ▼
    └──► Phase 3 (Adapters)
              │
              ▼
         Phase 4 (Widgets)
              │
              ▼
         Phase 5 (Testing & Integration)
```

---

## Critical Path

1. **1.1** Create dirs → **1.2** GestureSettings → **1.3** InputModeProvider
2. **2.1** FlickRecognizer → **2.4** MultiTouchRecognizer (parallel: 2.2, 2.3)
3. **3.1** InputAdapter → **3.2-3.4** Platform adapters (parallel)
4. **4.4** UnifiedGestureDetector (needs all above)
5. **5.7** Integration with GalaxyCanvas

---

## Files Changed/Created Summary

| Action | Count | Files |
|--------|-------|-------|
| Create | 22 | All lib/core/input/ files |
| Create | 5 | All test/core/input/ files |
| Modify | 1 | lib/widgets/galaxy_canvas.dart |
| **Total** | **28** | |

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Gesture conflicts | Test with arena, explicit priority |
| Platform differences | Adapter pattern isolates behavior |
| Performance | VelocityTracker is optimized, path simplification |
| 3-finger on iPad | May conflict with system gestures - test edge cases |

---

## Approval

- [x] Reviewed by: Anton
- [x] Approved on: 2026-05-24
- [x] Notes: Proceed with implementation
