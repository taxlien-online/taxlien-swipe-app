# Implementation Plan: Extended Mechanics

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-05-24

## Overview

Implementation plan for 9 extended mechanics. Organized into 6 phases with dependency ordering.

**Total Tasks**: 54
**Estimated Complexity**: High

---

## Phase 0: Dependencies & Setup

### 0.1 Add package dependencies
- **Files**: `pubspec.yaml`
- **Changes**: Add google_maps_flutter, speech_to_text, flutter_animate, fuzzywuzzy
- **Complexity**: Low
- **Dependencies**: None

### 0.2 Create feature directory structure
- **Files**: Create `lib/features/mechanics/` with 9 subdirectories
- **Changes**: Empty directory scaffolding
- **Complexity**: Low
- **Dependencies**: None

### 0.3 Create shared models barrel export
- **Files**: `lib/features/mechanics/mechanics.dart`
- **Changes**: Barrel export for all mechanics
- **Complexity**: Low
- **Dependencies**: 0.2

---

## Phase 1: Foundation Models & Services

### 1.1 PropertyLayer model
- **Files**: `lib/features/mechanics/layered_card/models/property_layer.dart`
- **Changes**: PropertyLayerType enum, PropertyLayer class
- **Complexity**: Low
- **Dependencies**: 0.2

### 1.2 TriageBoard model
- **Files**: `lib/features/mechanics/orbit_favorites/models/triage_board.dart`
- **Changes**: TriageBoard class with defaults
- **Complexity**: Low
- **Dependencies**: 0.2

### 1.3 Relationship model
- **Files**: `lib/features/mechanics/magnetic_groups/models/relationship.dart`
- **Changes**: RelationType enum, PropertyClusterData class
- **Complexity**: Low
- **Dependencies**: 0.2

### 1.4 PaletteCommand model
- **Files**: `lib/features/mechanics/command_palette/models/palette_command.dart`
- **Changes**: CommandType enum, PaletteCommand class, default commands
- **Complexity**: Medium
- **Dependencies**: 0.2

### 1.5 MapLayer model
- **Files**: `lib/features/mechanics/map_layers/models/map_layer.dart`
- **Changes**: MapLayerType enum, MapLayer class, PropertyMarkerData
- **Complexity**: Low
- **Dependencies**: 0.2

### 1.6 Counterparty model
- **Files**: `lib/features/mechanics/tax_radar/models/counterparty.dart`
- **Changes**: CounterpartyType enum, Counterparty class, RelationshipHealth
- **Complexity**: Low
- **Dependencies**: 0.2

### 1.7 GraphNode and GraphEdge models
- **Files**:
  - `lib/features/mechanics/tax_graph/models/graph_node_data.dart`
  - `lib/features/mechanics/tax_graph/models/graph_edge_data.dart`
- **Changes**: GraphNodeType, EdgeType enums, data classes, GraphAnomaly
- **Complexity**: Medium
- **Dependencies**: 0.2

### 1.8 AIExplanationService interface
- **Files**: `lib/features/mechanics/ai_loupe/services/ai_explanation_service.dart`
- **Changes**: Abstract service, FieldExplanation model, stub implementation
- **Complexity**: Medium
- **Dependencies**: 0.2

### 1.9 VoiceRecognitionService interface
- **Files**: `lib/features/mechanics/voice_gesture/services/voice_recognition_service.dart`
- **Changes**: Abstract service, FilterTag model, stub implementation
- **Complexity**: Medium
- **Dependencies**: 0.1 (speech_to_text)

---

## Phase 2: Core Widgets (No Gestures)

### 2.1 LayerCard widget
- **Files**: `lib/features/mechanics/layered_card/widgets/layer_card.dart`
- **Changes**: Single layer card with color accent, title, subtitle
- **Complexity**: Low
- **Dependencies**: 1.1

### 2.2 LayerContent widget
- **Files**: `lib/features/mechanics/layered_card/widgets/layer_content.dart`
- **Changes**: Expanded content view per layer type
- **Complexity**: Medium
- **Dependencies**: 1.1

### 2.3 OrbitZone widget
- **Files**: `lib/features/mechanics/orbit_favorites/widgets/orbit_zone.dart`
- **Changes**: Radial zone with label, count badge, glow
- **Complexity**: Low
- **Dependencies**: 1.2

### 2.4 FlickCard widget
- **Files**: `lib/features/mechanics/orbit_favorites/widgets/flick_card.dart`
- **Changes**: Draggable mini property card
- **Complexity**: Medium
- **Dependencies**: 1.2, PropertyCard

### 2.5 PropertyCluster widget
- **Files**: `lib/features/mechanics/magnetic_groups/widgets/property_cluster.dart`
- **Changes**: Cluster boundary with label, expandable
- **Complexity**: Medium
- **Dependencies**: 1.3

### 2.6 RelationBadge widget
- **Files**: `lib/features/mechanics/magnetic_groups/widgets/relation_badge.dart`
- **Changes**: Colored badge showing relation type and count
- **Complexity**: Low
- **Dependencies**: 1.3

### 2.7 LoupeCircle widget
- **Files**: `lib/features/mechanics/ai_loupe/widgets/loupe_circle.dart`
- **Changes**: Circular magnifier with border, shadow
- **Complexity**: Low
- **Dependencies**: None

### 2.8 ExplanationPanel widget
- **Files**: `lib/features/mechanics/ai_loupe/widgets/explanation_panel.dart`
- **Changes**: Floating panel with explanation text, tags
- **Complexity**: Medium
- **Dependencies**: 1.8

### 2.9 CommandInput widget
- **Files**: `lib/features/mechanics/command_palette/widgets/command_input.dart`
- **Changes**: Text field with icon, shortcut hint
- **Complexity**: Low
- **Dependencies**: None

### 2.10 CommandItem widget
- **Files**: `lib/features/mechanics/command_palette/widgets/command_item.dart`
- **Changes**: List item with icon, label, description, premium lock
- **Complexity**: Low
- **Dependencies**: 1.4

### 2.11 CommandList widget
- **Files**: `lib/features/mechanics/command_palette/widgets/command_list.dart`
- **Changes**: Scrollable list with keyboard navigation
- **Complexity**: Medium
- **Dependencies**: 2.10

### 2.12 WaveformVisualizer widget
- **Files**: `lib/features/mechanics/voice_gesture/widgets/waveform_visualizer.dart`
- **Changes**: Animated bars from stream
- **Complexity**: Medium
- **Dependencies**: None

### 2.13 TranscriptionDisplay widget
- **Files**: `lib/features/mechanics/voice_gesture/widgets/transcription_display.dart`
- **Changes**: Live text with cursor, entity highlighting
- **Complexity**: Medium
- **Dependencies**: None

### 2.14 FilterTag widget
- **Files**: `lib/features/mechanics/voice_gesture/widgets/filter_tag.dart`
- **Changes**: Pill badge for extracted filter
- **Complexity**: Low
- **Dependencies**: 1.9

### 2.15 LayerToggle widget
- **Files**: `lib/features/mechanics/map_layers/widgets/layer_toggle.dart`
- **Changes**: Chip toggle with active state, count
- **Complexity**: Low
- **Dependencies**: 1.5

### 2.16 PropertyMarker widget
- **Files**: `lib/features/mechanics/map_layers/widgets/property_marker.dart`
- **Changes**: Map marker with color, tap handler
- **Complexity**: Low
- **Dependencies**: 1.5

### 2.17 LayerPanel widget
- **Files**: `lib/features/mechanics/map_layers/widgets/layer_panel.dart`
- **Changes**: Bottom sheet with layer toggles, opacity sliders
- **Complexity**: Medium
- **Dependencies**: 2.15

### 2.18 CounterpartyNode widget
- **Files**: `lib/features/mechanics/tax_radar/widgets/counterparty_node.dart`
- **Changes**: Circular node with size, glow, label
- **Complexity**: Low
- **Dependencies**: 1.6

### 2.19 ActivityFeed widget
- **Files**: `lib/features/mechanics/tax_radar/widgets/activity_feed.dart`
- **Changes**: Scrolling feed with timestamps
- **Complexity**: Medium
- **Dependencies**: 1.6

### 2.20 GraphNode widget
- **Files**: `lib/features/mechanics/tax_graph/widgets/graph_node.dart`
- **Changes**: Colored node by type, draggable
- **Complexity**: Low
- **Dependencies**: 1.7

### 2.21 GraphEdge widget
- **Files**: `lib/features/mechanics/tax_graph/widgets/graph_edge.dart`
- **Changes**: Line/curve between nodes, optional label
- **Complexity**: Medium
- **Dependencies**: 1.7

### 2.22 AnomalyPanel widget
- **Files**: `lib/features/mechanics/tax_graph/widgets/anomaly_panel.dart`
- **Changes**: Bottom panel with anomaly details, action buttons
- **Complexity**: Medium
- **Dependencies**: 1.7

---

## Phase 3: Canvas & Layout Widgets

### 3.1 LayerStack widget
- **Files**: `lib/features/mechanics/layered_card/widgets/layer_stack.dart`
- **Changes**: Stacked layers with offset, swipe gesture handling
- **Complexity**: High
- **Dependencies**: 2.1, 2.2

### 3.2 OrbitCanvas widget
- **Files**: `lib/features/mechanics/orbit_favorites/widgets/orbit_canvas.dart`
- **Changes**: CustomPainter for radial layout, zone positioning
- **Complexity**: High
- **Dependencies**: 2.3, 2.4

### 3.3 MagneticCanvas widget
- **Files**: `lib/features/mechanics/magnetic_groups/widgets/magnetic_canvas.dart`
- **Changes**: Animated clustering, spring physics
- **Complexity**: High
- **Dependencies**: 2.5, 2.6, GalaxyDot

### 3.4 RadarCanvas widget
- **Files**: `lib/features/mechanics/tax_radar/widgets/radar_canvas.dart`
- **Changes**: CustomPainter for hub-spoke, sweep animation
- **Complexity**: High
- **Dependencies**: 2.18

### 3.5 GraphCanvas widget
- **Files**: `lib/features/mechanics/tax_graph/widgets/graph_canvas.dart`
- **Changes**: Force-directed layout, node/edge rendering
- **Complexity**: High
- **Dependencies**: 2.20, 2.21

### 3.6 ForceDirectedLayout utility
- **Files**: `lib/features/mechanics/tax_graph/utils/force_directed_layout.dart`
- **Changes**: Layout algorithm (Fruchterman-Reingold)
- **Complexity**: High
- **Dependencies**: 1.7

---

## Phase 4: Gesture Recognizers

### 4.1 SwipeVerticalGestureRecognizer
- **Files**: `lib/features/mechanics/layered_card/gestures/swipe_vertical.dart`
- **Changes**: Swipe up/down detection with velocity threshold
- **Complexity**: Medium
- **Dependencies**: None

### 4.2 FlickGestureRecognizer
- **Files**: `lib/features/mechanics/orbit_favorites/gestures/flick_gesture.dart`
- **Changes**: Flick detection with direction + velocity
- **Complexity**: Medium
- **Dependencies**: None

### 4.3 ThreeFingerGestureRecognizer
- **Files**: `lib/features/mechanics/command_palette/gestures/three_finger.dart`
- **Changes**: 3-finger pull-down/up detection
- **Complexity**: High
- **Dependencies**: None

### 4.4 LongPressAndDragGestureRecognizer
- **Files**: `lib/features/mechanics/ai_loupe/gestures/long_press_drag.dart`
- **Changes**: Long-press activation + drag tracking
- **Complexity**: Medium
- **Dependencies**: None

### 4.5 TwoFingerDragGestureRecognizer
- **Files**: `lib/features/mechanics/magnetic_groups/gestures/two_finger_drag.dart`
- **Changes**: Two-finger drag for relationship detection
- **Complexity**: Medium
- **Dependencies**: None

---

## Phase 5: Screens & Overlays

### 5.1 LayeredCardScreen
- **Files**: `lib/features/mechanics/layered_card/layered_card_screen.dart`
- **Changes**: Full screen with header card + layer stack
- **Complexity**: Medium
- **Dependencies**: 3.1, 4.1

### 5.2 OrbitTriageScreen
- **Files**: `lib/features/mechanics/orbit_favorites/orbit_triage_screen.dart`
- **Changes**: Full screen with orbit canvas + card queue
- **Complexity**: Medium
- **Dependencies**: 3.2, 4.2

### 5.3 MagneticGroupsScreen
- **Files**: `lib/features/mechanics/magnetic_groups/magnetic_groups_screen.dart`
- **Changes**: Full screen with toggle, canvas, relation panel
- **Complexity**: Medium
- **Dependencies**: 3.3, 4.5

### 5.4 AILoupeOverlay
- **Files**: `lib/features/mechanics/ai_loupe/ai_loupe_overlay.dart`
- **Changes**: Overlay widget wrapping child, loupe + panel
- **Complexity**: High
- **Dependencies**: 2.7, 2.8, 4.4, 1.8

### 5.5 CommandPaletteOverlay
- **Files**: `lib/features/mechanics/command_palette/command_palette_overlay.dart`
- **Changes**: Modal overlay with input + list
- **Complexity**: High
- **Dependencies**: 2.9, 2.11, 4.3

### 5.6 VoiceGesturePanel
- **Files**: `lib/features/mechanics/voice_gesture/voice_gesture_panel.dart`
- **Changes**: Bottom panel during lasso selection
- **Complexity**: High
- **Dependencies**: 2.12, 2.13, 2.14, 1.9

### 5.7 MapLayersScreen
- **Files**: `lib/features/mechanics/map_layers/map_layers_screen.dart`
- **Changes**: Full screen with map, markers, layer panel
- **Complexity**: High
- **Dependencies**: 2.16, 2.17, 0.1 (google_maps_flutter)

### 5.8 TaxRadarScreen
- **Files**: `lib/features/mechanics/tax_radar/tax_radar_screen.dart`
- **Changes**: Full screen with radar canvas + activity feed
- **Complexity**: Medium
- **Dependencies**: 3.4, 2.19

### 5.9 TaxGraphScreen
- **Files**: `lib/features/mechanics/tax_graph/tax_graph_screen.dart`
- **Changes**: Full screen with graph canvas + anomaly panel
- **Complexity**: High
- **Dependencies**: 3.5, 2.22, 3.6

---

## Phase 6: Integration & Testing

### 6.1 Update navigation routes
- **Files**: `lib/core/navigation/app_router.dart`
- **Changes**: Add routes for all 9 mechanics screens
- **Complexity**: Low
- **Dependencies**: Phase 5 complete

### 6.2 Add mechanics to bottom nav/tabs
- **Files**: `lib/widgets/app_bottom_nav.dart`, `lib/widgets/adaptive_scaffold.dart`
- **Changes**: Add Map, Radar, Graph tabs/icons
- **Complexity**: Low
- **Dependencies**: 6.1

### 6.3 Integrate AILoupeOverlay into property detail
- **Files**: `lib/features/details/screens/details_screen.dart`
- **Changes**: Wrap content with AILoupeOverlay
- **Complexity**: Low
- **Dependencies**: 5.4

### 6.4 Integrate CommandPaletteOverlay into app scaffold
- **Files**: `lib/widgets/adaptive_scaffold.dart`
- **Changes**: Add 3-finger gesture detector at app level
- **Complexity**: Medium
- **Dependencies**: 5.5

### 6.5 Integrate VoiceGesturePanel into Galaxy/Lasso
- **Files**: `lib/widgets/galaxy_canvas.dart`
- **Changes**: Show panel during lasso selection
- **Complexity**: Medium
- **Dependencies**: 5.6

### 6.6 Write unit tests for models
- **Files**: `test/features/mechanics/**/*_test.dart`
- **Changes**: Tests for all models and enums
- **Complexity**: Medium
- **Dependencies**: Phase 1 complete

### 6.7 Write widget tests for core widgets
- **Files**: `test/features/mechanics/**/*_test.dart`
- **Changes**: Tests for gesture detection, rendering
- **Complexity**: High
- **Dependencies**: Phase 2-3 complete

### 6.8 Write integration tests
- **Files**: `integration_test/mechanics_test.dart`
- **Changes**: End-to-end flows for each mechanic
- **Complexity**: High
- **Dependencies**: Phase 5 complete

### 6.9 Update barrel exports
- **Files**: `lib/features/mechanics/mechanics.dart`
- **Changes**: Export all public widgets and models
- **Complexity**: Low
- **Dependencies**: Phase 5 complete

---

## Task Summary

| Phase | Tasks | Complexity |
|-------|-------|------------|
| 0: Setup | 3 | Low |
| 1: Models | 9 | Low-Medium |
| 2: Widgets | 22 | Low-Medium |
| 3: Canvas | 6 | High |
| 4: Gestures | 5 | Medium-High |
| 5: Screens | 9 | Medium-High |
| 6: Integration | 9 | Low-High |
| **Total** | **63** | |

---

## Dependency Graph

```
Phase 0 (Setup)
    │
    ▼
Phase 1 (Models)
    │
    ▼
Phase 2 (Widgets) ◄──── Phase 4 (Gestures)
    │                        │
    ▼                        │
Phase 3 (Canvas) ◄───────────┘
    │
    ▼
Phase 5 (Screens)
    │
    ▼
Phase 6 (Integration)
```

---

## Implementation Order (Critical Path)

1. **0.1** Add dependencies → **0.2** Create dirs
2. **1.1-1.9** All models (parallel)
3. **2.1-2.22** Core widgets (parallel, respecting model deps)
4. **4.1-4.5** Gesture recognizers (parallel)
5. **3.1-3.6** Canvas widgets (need widgets + gestures)
6. **5.1-5.9** Screens (need canvases)
7. **6.1-6.9** Integration

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Map SDK licensing | Use flutter_map (open source) as fallback |
| Speech recognition accuracy | Provide manual text input fallback |
| Force layout performance | Run in isolate, limit iterations |
| 3-finger gesture conflicts | Detect only on specific screens |
| AI API latency | Cache responses, show skeleton UI |

---

## Approval

- [ ] Reviewed by: Anton
- [ ] Approved on: [pending]
- [ ] Notes:
