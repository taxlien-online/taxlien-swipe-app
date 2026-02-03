# Plan: Swipe Screen Implementation

> Version: 2.0
> Status: REVIEW
> Last Updated: 2026-02-03
> Specifications: [02-specifications.md](./02-specifications.md)

## Summary

Most core features are already implemented (~75%). This plan focuses on:
1. **Model unification** - Align PropertyCardBeginner (TaxLien) and PropertyCardAdvanced (PropertyCardData)
2. **Annotation system completion** - Line/box rendering, persistence
3. **ContextView & DetailsView** - Replace placeholders with real data
4. **Integration fixes** - Constructor params, mode toggles, visual indicators

## Task Breakdown

### Phase 1: Model Unification (Foundation Fix)

#### Task 1.1: Create TaxLien → PropertyCardData Converter
- **Description**: Add extension method to convert TaxLien to PropertyCardData for unified usage
- **Files**:
  - `lib/core/models/property_card_data.dart` - Add `fromTaxLien()` factory
- **Dependencies**: None
- **Verification**: Unit test conversion preserves all relevant fields
- **Complexity**: Low

#### Task 1.2: Fix FinancialDetailsSheet Model Usage
- **Description**: Update FinancialDetailsSheet to accept TaxLien or add converter
- **Files**:
  - `lib/features/swipe/widgets/financial_details_sheet.dart` - Modify to use TaxLien
- **Dependencies**: Task 1.1
- **Verification**: FinancialDetailsSheet opens correctly from beginner mode cards
- **Complexity**: Low

#### Task 1.3: Populate RoleMetrics in TaxLienService
- **Description**: Generate role-specific metrics when creating mock data
- **Files**:
  - `lib/services/tax_lien_service.dart` - Add roleMetrics population
  - `lib/core/models/property_card_data.dart` - Ensure roleMetrics field exists
- **Dependencies**: Task 1.1
- **Verification**: Advanced HUD displays role-specific secondary metrics
- **Complexity**: Medium

### Phase 2: Annotation Canvas Completion

#### Task 2.1: Add Rect/Endpoints to AnnotationMarker
- **Description**: Extend AnnotationMarker model to store rect bounds for box and endpoints for line
- **Files**:
  - `lib/core/models/marker.dart` - Add `endPosition`, `rect` fields
- **Dependencies**: None
- **Verification**: Marker model can represent all three types properly
- **Complexity**: Low

#### Task 2.2: Implement Line & Box CustomPainter Rendering
- **Description**: Complete the commented-out line and box rendering in AnnotationCanvasPainter
- **Files**:
  - `lib/features/swipe/widgets/annotation_canvas.dart` - Lines 172-177
- **Dependencies**: Task 2.1
- **Verification**: Draw box/line markers visible on canvas
- **Complexity**: Medium

#### Task 2.3: Implement Visual Radial Menu
- **Description**: Replace AlertDialog with a proper radial/pie menu UI
- **Files**:
  - `lib/features/swipe/widgets/annotation_canvas.dart` - Refactor radial menu
  - `lib/features/swipe/widgets/radial_menu.dart` - Create new widget
- **Dependencies**: Task 2.2
- **Verification**: Long-press shows circular menu with Box/Line/Comment options
- **Complexity**: Medium

#### Task 2.4: Add Annotation Persistence
- **Description**: Save/load markers via DataRepository
- **Files**:
  - `lib/core/repositories/data_repository.dart` - Add marker CRUD methods
  - `lib/core/database/database_service.dart` - Add markers table
  - `lib/features/swipe/widgets/annotation_canvas.dart` - Integrate save/load
- **Dependencies**: Task 2.2
- **Verification**: Markers persist across app restarts
- **Complexity**: High

### Phase 3: ContextView & DetailsView Implementation

#### Task 3.1: Define ContextView Data Model
- **Description**: Create model for context data (news, obituaries, ownership history)
- **Files**:
  - `lib/core/models/property_context.dart` - Create new model
- **Dependencies**: None
- **Verification**: Model holds all context fields from spec
- **Complexity**: Low

#### Task 3.2: Define DetailsView Data Model
- **Description**: Create model for details data (interior photos, maps, utilities)
- **Files**:
  - `lib/core/models/property_details.dart` - Create new model
- **Dependencies**: None
- **Verification**: Model holds all detail fields from spec
- **Complexity**: Low

#### Task 3.3: Implement ContextView UI
- **Description**: Replace placeholder with real UI showing news, ownership history, etc.
- **Files**:
  - `lib/features/swipe/views/context_view.dart` - Full implementation
- **Dependencies**: Task 3.1
- **Verification**: ContextView shows real data (mock initially)
- **Complexity**: Medium

#### Task 3.4: Implement DetailsView UI
- **Description**: Replace placeholder with real UI showing photos, maps, utilities
- **Files**:
  - `lib/features/swipe/views/details_view.dart` - Full implementation
- **Dependencies**: Task 3.2
- **Verification**: DetailsView shows real data with photo gallery
- **Complexity**: Medium

#### Task 3.5: Add TaxLienService Methods for Context/Details
- **Description**: Add API methods to fetch context and details data
- **Files**:
  - `lib/services/tax_lien_service.dart` - Add getPropertyContext(), getPropertyDetails()
- **Dependencies**: Tasks 3.1, 3.2
- **Verification**: Service returns context/details data (mock initially)
- **Complexity**: Medium

### Phase 4: Integration Fixes

#### Task 4.1: Fix PropertyCardAdvanced Constructor in AdvancedSwipeStack
- **Description**: Pass required onAddMarker and mainImageUrl parameters
- **Files**:
  - `lib/features/swipe/widgets/advanced_swipe_stack.dart` - Line ~280
- **Dependencies**: None
- **Verification**: No runtime errors when using advanced mode
- **Complexity**: Low

#### Task 4.2: Implement Annotation Mode Toggle
- **Description**: Connect annotation icon button to toggle annotation canvas
- **Files**:
  - `lib/features/swipe/widgets/advanced_swipe_stack.dart` - Wire up button
- **Dependencies**: Task 4.1
- **Verification**: Tapping annotation icon enables/disables drawing
- **Complexity**: Low

#### Task 4.3: Add Photo Cycling Indicators
- **Description**: Add "1/5" style indicator and visual feedback for double-tap cycling
- **Files**:
  - `lib/features/swipe/widgets/property_card_advanced.dart` - Add indicator widget
  - `lib/features/swipe/widgets/property_card_beginner.dart` - Add indicator widget
- **Dependencies**: None
- **Verification**: User sees current photo position out of total
- **Complexity**: Low

#### Task 4.4: Add Cross-Role "Bridge" Badge Logic
- **Description**: Show expert reassurance badge when property recommended by another role
- **Files**:
  - `lib/features/swipe/widgets/property_card_advanced.dart` - Add badge widget
  - `lib/features/swipe/widgets/property_card_beginner.dart` - Add badge widget
- **Dependencies**: Task 1.3
- **Verification**: Badge shows "🏗️ Khun Pho: Solid Structure" style message
- **Complexity**: Medium

### Phase 5: Testing & Polish

#### Task 5.1: Write Model Conversion Tests
- **Description**: Unit tests for TaxLien → PropertyCardData conversion
- **Files**:
  - `test/unit_tests/property_card_data_test.dart` - Create
- **Dependencies**: Task 1.1
- **Verification**: All tests pass
- **Complexity**: Low

#### Task 5.2: Write Annotation Canvas Widget Tests
- **Description**: Widget tests for annotation interactions
- **Files**:
  - `test/widget_tests/annotation_canvas_test.dart` - Create
- **Dependencies**: Task 2.2
- **Verification**: All tests pass
- **Complexity**: Medium

#### Task 5.3: Verify Mode Switching Flow
- **Description**: End-to-end test of switching between beginner/advanced modes
- **Files**:
  - `test/integration_tests/swipe_mode_test.dart` - Create
- **Dependencies**: All Phase 4 tasks
- **Verification**: Mode switch works without data loss
- **Complexity**: Medium

## Dependency Graph

```
Phase 1:
Task 1.1 ─┬─→ Task 1.2
          └─→ Task 1.3

Phase 2:
Task 2.1 ─→ Task 2.2 ─┬─→ Task 2.3
                      └─→ Task 2.4

Phase 3:
Task 3.1 ─→ Task 3.3 ─┐
Task 3.2 ─→ Task 3.4 ─┼─→ Task 3.5
                      ┘

Phase 4:
Task 4.1 ─→ Task 4.2
Task 4.3 (independent)
Task 1.3 ─→ Task 4.4

Phase 5:
Task 1.1 ─→ Task 5.1
Task 2.2 ─→ Task 5.2
Phase 4 ─→ Task 5.3
```

## File Change Summary

| File | Action | Reason |
|------|--------|--------|
| `lib/core/models/property_card_data.dart` | Modify | Add fromTaxLien factory |
| `lib/core/models/marker.dart` | Modify | Add endPosition/rect fields |
| `lib/core/models/property_context.dart` | Create | Context data model |
| `lib/core/models/property_details.dart` | Create | Details data model |
| `lib/features/swipe/widgets/financial_details_sheet.dart` | Modify | Support TaxLien model |
| `lib/features/swipe/widgets/annotation_canvas.dart` | Modify | Complete line/box rendering |
| `lib/features/swipe/widgets/radial_menu.dart` | Create | Visual radial menu |
| `lib/features/swipe/widgets/advanced_swipe_stack.dart` | Modify | Fix constructor, wire toggle |
| `lib/features/swipe/widgets/property_card_advanced.dart` | Modify | Add indicators, badges |
| `lib/features/swipe/widgets/property_card_beginner.dart` | Modify | Add indicators, badges |
| `lib/features/swipe/views/context_view.dart` | Modify | Full implementation |
| `lib/features/swipe/views/details_view.dart` | Modify | Full implementation |
| `lib/services/tax_lien_service.dart` | Modify | Add context/details methods |
| `lib/core/repositories/data_repository.dart` | Modify | Add marker CRUD |
| `lib/core/database/database_service.dart` | Modify | Add markers table |
| `test/unit_tests/property_card_data_test.dart` | Create | Conversion tests |
| `test/widget_tests/annotation_canvas_test.dart` | Create | Widget tests |
| `test/integration_tests/swipe_mode_test.dart` | Create | Integration tests |

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Model mismatch causes data loss | Medium | High | Task 1.1 adds safe conversion with null handling |
| Annotation persistence breaks offline sync | Medium | Medium | Task 2.4 uses existing DataRepository pattern |
| Context/Details API not ready | High | Low | Mock data fallback already in place |

## Rollback Strategy

If implementation fails or needs to be reverted:
1. Revert file changes via git
2. Model changes are additive (don't break existing code)
3. New files can be deleted without side effects

## Checkpoints

After each phase, verify:
- [ ] All tests pass (`flutter test`)
- [ ] No new warnings (`flutter analyze`)
- [ ] App runs without crashes (`flutter run`)
- [ ] Behavior matches specifications

## Open Implementation Questions

- [x] Model unification approach: Use converter (Task 1.1) ✓
- [ ] Radial menu style: Pie menu vs floating action buttons?
- [ ] Context/Details loading: Eager vs lazy fetch?

---

## Approval

- [ ] Reviewed by: [pending]
- [ ] Approved on: [pending]
- [ ] Notes:
