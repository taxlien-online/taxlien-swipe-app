# Implementation Plan: Tax Lien Spatial Intelligence (Property Galaxy)

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-05-18
> Specifications: [03-specifications.md](./03-specifications.md)

## Summary

This plan implements "Property Galaxy" - a spatial visualization interface for tax lien discovery. The implementation is structured in 5 phases:

1. **Foundation** - Design system tokens and core data models
2. **Galaxy Core** - Viewport, property rendering, clustering
3. **Gestures** - Lasso selection, dimension rotation, zoom/pan
4. **Intelligence** - X-Ray insights, AI Copilot integration
5. **Polish** - Animations, performance optimization, accessibility

Key architectural decisions:
- Provider-based state management (existing pattern)
- CustomPainter for high-performance canvas rendering
- Modular dimension layouts for flexibility
- Incremental feature delivery (Galaxy usable after Phase 2)

---

## Task Breakdown

### Phase 1: Foundation

#### Task 1.1: Design System Tokens
- **Description**: Create Flutter design tokens from VPN Client Pro design system
- **Files**:
  - `lib/core/design/app_colors.dart` - Create
  - `lib/core/design/app_typography.dart` - Create
  - `lib/core/design/app_spacing.dart` - Create
  - `lib/core/design/app_radius.dart` - Create
  - `lib/core/design/app_shadows.dart` - Create
  - `lib/core/design/design_system.dart` - Create (barrel export)
- **Dependencies**: None
- **Verification**: Import design tokens in test widget, verify colors/fonts render correctly
- **Complexity**: Low

#### Task 1.2: Core Data Models
- **Description**: Create spatial position and dimension models
- **Files**:
  - `lib/core/models/spatial_position.dart` - Create
  - `lib/core/models/galaxy_dimension.dart` - Create
  - `lib/core/models/lasso_selection.dart` - Create
  - `lib/core/models/selection_stats.dart` - Create
  - `lib/core/models/xray_insight.dart` - Create
  - `lib/core/models/copilot_models.dart` - Create
- **Dependencies**: None
- **Verification**: Unit tests for all models, especially `LassoSelection.containsPoint()` and `SelectionStats.fromProperties()`
- **Complexity**: Medium

#### Task 1.3: TaxLien Model Extension
- **Description**: Extend existing TaxLien model with new fields from vendor flows
- **Files**:
  - `lib/core/models/tax_lien.dart` - Modify (add ML prediction fields, exemption flags, enrichment data)
- **Dependencies**: Task 1.2
- **Verification**: Existing tests still pass, new fields serialize/deserialize correctly
- **Complexity**: Low

#### Task 1.4: Spatial Interfaces
- **Description**: Define abstract interfaces for spatial visualization
- **Files**:
  - `lib/core/interfaces/spatial_visualization.dart` - Create
- **Dependencies**: Task 1.2
- **Verification**: Interfaces compile, can be implemented by concrete classes
- **Complexity**: Low

---

### Phase 2: Galaxy Core

#### Task 2.1: GalaxyProvider
- **Description**: State management for galaxy visualization
- **Files**:
  - `lib/features/galaxy/providers/galaxy_provider.dart` - Create
- **Dependencies**: Task 1.2, Task 1.3
- **Verification**: Provider notifies listeners on state changes, positions recalculate on dimension change
- **Complexity**: Medium

#### Task 2.2: Dimension Layout Algorithms
- **Description**: Implement layout calculators for each dimension
- **Files**:
  - `lib/features/galaxy/layouts/dimension_layout.dart` - Create (base class)
  - `lib/features/galaxy/layouts/date_layout.dart` - Create
  - `lib/features/galaxy/layouts/roi_layout.dart` - Create
  - `lib/features/galaxy/layouts/risk_layout.dart` - Create
  - `lib/features/galaxy/layouts/stage_layout.dart` - Create
  - `lib/features/galaxy/layouts/county_layout.dart` - Create
  - `lib/features/galaxy/layouts/fvi_layout.dart` - Create
  - `lib/features/galaxy/layouts/type_layout.dart` - Create
- **Dependencies**: Task 1.2, Task 1.4
- **Verification**: Unit tests for each layout, verify positions are in 0-1 range, correct colors assigned
- **Complexity**: High

#### Task 2.3: PropertyPointPainter
- **Description**: CustomPainter for rendering property points on canvas
- **Files**:
  - `lib/features/galaxy/painters/property_point_painter.dart` - Create
- **Dependencies**: Task 1.1, Task 2.1
- **Verification**: Renders 500+ points at 60fps, colors and sizes correct
- **Complexity**: Medium

#### Task 2.4: ClusteringService
- **Description**: DBSCAN-inspired clustering for dense regions
- **Files**:
  - `lib/features/galaxy/services/clustering_service.dart` - Create
- **Dependencies**: Task 1.2
- **Verification**: Clusters form when points < 20px apart, clusters expand on zoom
- **Complexity**: High

#### Task 2.5: GalaxyViewport Widget
- **Description**: Main viewport widget with InteractiveViewer
- **Files**:
  - `lib/features/galaxy/widgets/galaxy_viewport.dart` - Create
  - `lib/features/galaxy/widgets/property_cluster_layer.dart` - Create
- **Dependencies**: Task 2.1, Task 2.3, Task 2.4
- **Verification**: Pan/zoom works smoothly, properties render in correct positions
- **Complexity**: Medium

#### Task 2.6: GalaxyScreen
- **Description**: Full screen with HUD, bottom bar, floating panels
- **Files**:
  - `lib/features/galaxy/screens/galaxy_screen.dart` - Create
  - `lib/features/galaxy/widgets/galaxy_hud.dart` - Create
  - `lib/features/galaxy/widgets/dimension_indicator.dart` - Create
- **Dependencies**: Task 2.5
- **Verification**: Screen renders, HUD shows current dimension, tab bar switches views
- **Complexity**: Medium

#### Task 2.7: Navigation Integration
- **Description**: Add Galaxy route and view mode toggle
- **Files**:
  - `lib/core/navigation/app_router.dart` - Modify (add /galaxy route)
  - `lib/features/swipe/providers/swipe_provider.dart` - Modify (add ViewMode enum)
- **Dependencies**: Task 2.6
- **Verification**: Can navigate to Galaxy from tab bar, view mode persists
- **Complexity**: Low

---

### Phase 3: Gestures

#### Task 3.1: SelectionProvider
- **Description**: State management for lasso selection
- **Files**:
  - `lib/features/galaxy/providers/selection_provider.dart` - Create
- **Dependencies**: Task 1.2, Task 2.1
- **Verification**: Selection updates, stats calculated correctly, clockwise/CCW detection works
- **Complexity**: Medium

#### Task 3.2: LassoGestureDetector
- **Description**: Custom gesture detector for lasso drawing
- **Files**:
  - `lib/features/galaxy/gestures/lasso_gesture_detector.dart` - Create
- **Dependencies**: Task 3.1
- **Verification**: Lasso starts on long-press, updates on drag, closes on release
- **Complexity**: Medium

#### Task 3.3: LassoSelectionLayer
- **Description**: CustomPainter for lasso path visualization
- **Files**:
  - `lib/features/galaxy/painters/lasso_painter.dart` - Create
  - `lib/features/galaxy/widgets/lasso_selection_layer.dart` - Create
- **Dependencies**: Task 3.1, Task 3.2
- **Verification**: Lasso path renders smoothly, fills with semi-transparent color
- **Complexity**: Low

#### Task 3.4: DimensionWheelGesture
- **Description**: Two-finger rotation gesture for dimension cycling
- **Files**:
  - `lib/features/galaxy/gestures/dimension_wheel_gesture.dart` - Create
- **Dependencies**: Task 2.1
- **Verification**: 90-degree rotation cycles dimension, haptic feedback fires, animation smooth
- **Complexity**: Medium

#### Task 3.5: SelectionFloatingPanel
- **Description**: Bottom panel showing selection stats and actions
- **Files**:
  - `lib/features/galaxy/widgets/selection_floating_panel.dart` - Create
- **Dependencies**: Task 3.1
- **Verification**: Panel shows count/value/ROI, buttons work (Add to Watchlist, Export, Clear)
- **Complexity**: Low

#### Task 3.6: Gesture Integration
- **Description**: Integrate all gestures into GalaxyViewport
- **Files**:
  - `lib/features/galaxy/widgets/galaxy_viewport.dart` - Modify
- **Dependencies**: Task 3.2, Task 3.3, Task 3.4
- **Verification**: All gestures work together without conflicts, zoom doesn't trigger lasso
- **Complexity**: High

---

### Phase 4: Intelligence

#### Task 4.1: XRayInsightGenerator
- **Description**: Rule-based insight generation from property data
- **Files**:
  - `lib/features/xray/services/insight_generator.dart` - Create
- **Dependencies**: Task 1.2, Task 1.3
- **Verification**: Unit tests for each insight type, correct categorization
- **Complexity**: Medium

#### Task 4.2: XRayOverlay
- **Description**: X-Ray mode overlay for property cards
- **Files**:
  - `lib/features/xray/widgets/xray_overlay.dart` - Create
  - `lib/features/xray/widgets/insight_badge.dart` - Create
  - `lib/features/xray/widgets/insight_detail_sheet.dart` - Create
- **Dependencies**: Task 4.1, Task 1.1
- **Verification**: Insights highlight correctly, tapping shows details, colors match type
- **Complexity**: Medium

#### Task 4.3: XRayGesture
- **Description**: Two-finger swipe down to activate X-Ray mode
- **Files**:
  - `lib/features/xray/gestures/xray_gesture.dart` - Create
- **Dependencies**: Task 4.2
- **Verification**: Gesture activates mode, doesn't conflict with other gestures
- **Complexity**: Low

#### Task 4.4: CopilotProvider
- **Description**: State management for AI Copilot
- **Files**:
  - `lib/features/copilot/providers/copilot_provider.dart` - Create
- **Dependencies**: Task 1.2
- **Verification**: Query history persists, suggestions update, loading states work
- **Complexity**: Medium

#### Task 4.5: CopilotService
- **Description**: API integration for AI Copilot queries
- **Files**:
  - `lib/features/copilot/services/copilot_service.dart` - Create
- **Dependencies**: Task 4.4
- **Verification**: API calls succeed, responses parse correctly, errors handled
- **Complexity**: Medium

#### Task 4.6: CopilotSheet
- **Description**: Draggable sheet UI for Copilot interaction
- **Files**:
  - `lib/features/copilot/widgets/copilot_sheet.dart` - Create
  - `lib/features/copilot/widgets/copilot_input.dart` - Create
  - `lib/features/copilot/widgets/suggestion_chips.dart` - Create
  - `lib/features/copilot/widgets/copilot_response.dart` - Create
- **Dependencies**: Task 4.4, Task 4.5, Task 1.1
- **Verification**: Sheet opens/closes, input works, suggestions appear, results highlight on Galaxy
- **Complexity**: High

#### Task 4.7: Voice Input Integration
- **Description**: Speech-to-text for Copilot
- **Files**:
  - `lib/features/copilot/services/voice_input_service.dart` - Create
  - `lib/features/copilot/widgets/copilot_input.dart` - Modify
  - `pubspec.yaml` - Modify (add speech_to_text)
- **Dependencies**: Task 4.6
- **Verification**: Mic button starts/stops recording, transcription appears in input
- **Complexity**: Medium

---

### Phase 5: Polish

#### Task 5.1: Dimension Transition Animations
- **Description**: Animated property movement when switching dimensions
- **Files**:
  - `lib/features/galaxy/animations/dimension_transition.dart` - Create
  - `lib/features/galaxy/providers/galaxy_provider.dart` - Modify
- **Dependencies**: Task 2.2
- **Verification**: Properties animate smoothly between positions, no flickering
- **Complexity**: Medium

#### Task 5.2: Selection Animation
- **Description**: Pulse effect on selected properties
- **Files**:
  - `lib/features/galaxy/animations/selection_animation.dart` - Create
- **Dependencies**: Task 3.1
- **Verification**: Selected properties pulse, animation doesn't affect performance
- **Complexity**: Low

#### Task 5.3: Performance Optimization
- **Description**: Viewport culling, LOD, canvas optimization
- **Files**:
  - `lib/features/galaxy/services/viewport_culling.dart` - Create
  - `lib/features/galaxy/painters/property_point_painter.dart` - Modify
- **Dependencies**: Task 2.3, Task 2.5
- **Verification**: Maintain 60fps with 1000+ properties, memory usage stable
- **Complexity**: High

#### Task 5.4: Empty States
- **Description**: Empty state UI for no properties, no selection, AI errors
- **Files**:
  - `lib/features/galaxy/widgets/empty_states.dart` - Create
- **Dependencies**: Task 2.6
- **Verification**: Empty states show correctly, messages are helpful
- **Complexity**: Low

#### Task 5.5: Accessibility
- **Description**: Screen reader support, semantic labels
- **Files**:
  - `lib/features/galaxy/widgets/galaxy_viewport.dart` - Modify
  - `lib/features/galaxy/widgets/selection_floating_panel.dart` - Modify
- **Dependencies**: All Phase 2-4 tasks
- **Verification**: VoiceOver/TalkBack can navigate Galaxy, announces selections
- **Complexity**: Medium

#### Task 5.6: Integration Tests
- **Description**: Full flow integration tests
- **Files**:
  - `integration_test/galaxy_test.dart` - Create
- **Dependencies**: All previous tasks
- **Verification**: Tests cover: load galaxy, zoom, lasso select, dimension switch, AI query
- **Complexity**: Medium

---

## Dependency Graph

```
Phase 1 (Foundation):
Task 1.1 ─────────────────────────────────────────────────────┐
Task 1.2 ─┬─→ Task 1.3 ───────────────────────────────────────┤
          └─→ Task 1.4 ───────────────────────────────────────┤
                                                              │
Phase 2 (Galaxy Core):                                        │
Task 1.2 + 1.3 ─→ Task 2.1 ─┬─→ Task 2.5 ─→ Task 2.6 ─→ Task 2.7
Task 1.2 + 1.4 ─→ Task 2.2 ─┘        ↑
Task 1.1 + 2.1 ─→ Task 2.3 ──────────┤
Task 1.2 ───────→ Task 2.4 ──────────┘

Phase 3 (Gestures):
Task 2.1 + 1.2 ─→ Task 3.1 ─┬─→ Task 3.2 ─→ Task 3.3 ─┐
                            │                         │
Task 2.1 ─────────────────→ Task 3.4 ─────────────────┼─→ Task 3.6
                            │                         │
Task 3.1 ─────────────────→ Task 3.5 ─────────────────┘

Phase 4 (Intelligence):
Task 1.2 + 1.3 ─→ Task 4.1 ─→ Task 4.2 ─→ Task 4.3
Task 1.2 ───────→ Task 4.4 ─→ Task 4.5 ─→ Task 4.6 ─→ Task 4.7

Phase 5 (Polish):
Task 2.2 ─────────────────→ Task 5.1
Task 3.1 ─────────────────→ Task 5.2
Task 2.3 + 2.5 ───────────→ Task 5.3
Task 2.6 ─────────────────→ Task 5.4
All Phase 2-4 ────────────→ Task 5.5 ─→ Task 5.6
```

---

## File Change Summary

| File | Action | Reason |
|------|--------|--------|
| `lib/core/design/app_colors.dart` | Create | Design tokens - colors |
| `lib/core/design/app_typography.dart` | Create | Design tokens - typography |
| `lib/core/design/app_spacing.dart` | Create | Design tokens - spacing |
| `lib/core/design/app_radius.dart` | Create | Design tokens - border radius |
| `lib/core/design/app_shadows.dart` | Create | Design tokens - shadows |
| `lib/core/design/design_system.dart` | Create | Barrel export for design system |
| `lib/core/models/spatial_position.dart` | Create | Position model for Galaxy |
| `lib/core/models/galaxy_dimension.dart` | Create | Dimension enum and extension |
| `lib/core/models/lasso_selection.dart` | Create | Lasso selection model |
| `lib/core/models/selection_stats.dart` | Create | Selection statistics |
| `lib/core/models/xray_insight.dart` | Create | X-Ray insight model |
| `lib/core/models/copilot_models.dart` | Create | AI Copilot models |
| `lib/core/models/tax_lien.dart` | Modify | Add ML prediction fields, exemptions |
| `lib/core/interfaces/spatial_visualization.dart` | Create | Spatial interfaces |
| `lib/features/galaxy/` | Create | New feature module (entire directory) |
| `lib/features/xray/` | Create | New feature module (entire directory) |
| `lib/features/copilot/` | Create | New feature module (entire directory) |
| `lib/core/navigation/app_router.dart` | Modify | Add /galaxy, /property/:id/xray routes |
| `lib/features/swipe/providers/swipe_provider.dart` | Modify | Add ViewMode enum |
| `pubspec.yaml` | Modify | Add speech_to_text, gesture_x_detector |
| `integration_test/galaxy_test.dart` | Create | Integration tests |

**Total: ~40 new files, ~4 modified files**

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Gesture conflicts (zoom vs lasso vs rotation) | High | Medium | Careful gesture detection zones, haptic feedback, visual cues |
| Performance with 1000+ properties | Medium | High | Viewport culling, clustering, canvas rendering (not widgets) |
| AI Copilot API latency | Medium | Medium | Loading states, optimistic UI, query caching |
| Two-finger rotation misdetected | Medium | Low | Require minimum finger separation (50px), debounce |
| Clustering algorithm edge cases | Low | Medium | Unit tests, fallback to grid layout |
| Speech recognition accuracy | Medium | Low | Show transcription for editing, suggestion chips as fallback |

---

## Rollback Strategy

If implementation fails or needs to be reverted:

1. Galaxy feature is self-contained in `lib/features/galaxy/` - can delete entire directory
2. ViewMode toggle in SwipeProvider can be removed without breaking existing swipe
3. Design tokens are additive - existing code unaffected
4. TaxLien model extensions are nullable - backward compatible
5. Navigation routes can be removed independently

---

## Checkpoints

### After Phase 1:
- [ ] All models compile and have unit tests
- [ ] Design tokens match VPN Client Pro spec
- [ ] TaxLien model accepts new fields from API

### After Phase 2:
- [ ] Galaxy screen renders with property points
- [ ] Pan/zoom works smoothly
- [ ] Clustering activates at appropriate zoom levels
- [ ] Can navigate to Galaxy from app

### After Phase 3:
- [ ] Lasso selection works (CW to select, CCW to exclude)
- [ ] Dimension wheel rotation switches dimensions
- [ ] Selection panel shows correct stats
- [ ] All gestures work without conflicts

### After Phase 4:
- [ ] X-Ray mode shows insights on properties
- [ ] AI Copilot accepts queries and highlights results
- [ ] Voice input transcribes correctly

### After Phase 5:
- [ ] Animations are smooth (60fps)
- [ ] Performance acceptable with 1000+ properties
- [ ] Accessibility audit passes
- [ ] All integration tests pass

---

## Open Implementation Questions

- [ ] Clustering: Should clusters show count label or aggregate stats?
- [ ] X-Ray: Should insights be cached per property or computed on-demand?
- [ ] Copilot: What backend endpoint will be used? (assume `/detective/copilot/query`)
- [ ] Voice: English only for MVP, or multi-language?
- [ ] Offline: Should Galaxy work offline with cached properties?

---

## Approval

- [ ] Reviewed by: Anton
- [ ] Approved on: [pending]
- [ ] Notes: [any conditions or clarifications]
