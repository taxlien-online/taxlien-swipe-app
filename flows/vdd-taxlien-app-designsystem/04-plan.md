# Implementation Plan: Tax Lien App Design System

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-05-24

## Overview

Implementation broken into 5 phases with 32 tasks total. Dependencies ensure correct build order.

---

## Phase 1: Foundation (Design Tokens)

Core design tokens that all components depend on.

| ID | Task | Files | Deps | Complexity |
|----|------|-------|------|------------|
| 1.1 | Create design directory structure | `lib/design/`, `lib/widgets/`, `lib/services/`, `lib/platform/` | - | Low |
| 1.2 | Implement AppColors | `lib/design/app_colors.dart` | 1.1 | Low |
| 1.3 | Implement AppTypography | `lib/design/app_typography.dart` | 1.1, 1.2 | Low |
| 1.4 | Implement AppSpacing | `lib/design/app_spacing.dart` | 1.1 | Low |
| 1.5 | Implement AppRadius | `lib/design/app_radius.dart` | 1.1 | Low |
| 1.6 | Implement AppShadows | `lib/design/app_shadows.dart` | 1.1, 1.2 | Low |
| 1.7 | Implement AppSizes | `lib/design/app_sizes.dart` | 1.1 | Low |
| 1.8 | Implement AppBreakpoints | `lib/design/app_breakpoints.dart` | 1.1 | Low |
| 1.9 | Implement AppTheme (light + dark) | `lib/design/app_theme.dart` | 1.2-1.7 | Medium |
| 1.10 | Implement color extensions | `lib/design/extensions/*.dart` | 1.2 | Low |
| 1.11 | Create design barrel export | `lib/design/design.dart` | 1.2-1.10 | Low |
| 1.12 | Add dependencies to pubspec | `pubspec.yaml` | - | Low |

**Phase 1 Deliverable:** All design tokens accessible via `import 'design/design.dart'`

---

## Phase 2: Core Components

Basic widgets that don't depend on adaptive layout.

| ID | Task | Files | Deps | Complexity |
|----|------|-------|------|------------|
| 2.1 | Implement StatTile | `lib/widgets/stat_tile.dart` | 1.11 | Medium |
| 2.2 | Implement AppBadge | `lib/widgets/app_badge.dart` | 1.11 | Low |
| 2.3 | Implement GradeBadge | `lib/widgets/grade_badge.dart` | 1.11 | Low |
| 2.4 | Implement CtaButton | `lib/widgets/cta_button.dart` | 1.11 | Medium |
| 2.5 | Implement AppIconButton | `lib/widgets/app_icon_button.dart` | 1.11 | Low |
| 2.6 | Implement HudPill | `lib/widgets/hud_pill.dart` | 1.11 | Low |
| 2.7 | Implement FloatPanel | `lib/widgets/float_panel.dart` | 1.11 | Low |
| 2.8 | Implement GalaxyDot | `lib/widgets/galaxy_dot.dart` | 1.11 | Medium |
| 2.9 | Implement GalaxyCanvas | `lib/widgets/galaxy_canvas.dart` | 2.8 | High |
| 2.10 | Implement PropertyCard (all variants) | `lib/widgets/property_card.dart` | 2.1, 2.2, 2.3 | High |
| 2.11 | Implement AppTopBar | `lib/widgets/app_top_bar.dart` | 1.11, 2.5 | Medium |
| 2.12 | Implement AppBottomNav | `lib/widgets/app_bottom_nav.dart` | 1.11 | Medium |
| 2.13 | Implement AppToast | `lib/widgets/app_toast.dart` | 1.11 | Medium |

**Phase 2 Deliverable:** All core UI components ready for use

---

## Phase 3: Adaptive Layout

Responsive layout system for all platforms.

| ID | Task | Files | Deps | Complexity |
|----|------|-------|------|------------|
| 3.1 | Implement AppNavigationRail | `lib/widgets/app_navigation_rail.dart` | 2.12 | Medium |
| 3.2 | Implement AppSidebar | `lib/widgets/app_sidebar.dart` | 1.11 | Medium |
| 3.3 | Implement AdaptiveScaffold | `lib/widgets/adaptive_scaffold.dart` | 1.8, 2.12, 3.1, 3.2 | High |
| 3.4 | Create widgets barrel export | `lib/widgets/widgets.dart` | 2.1-2.13, 3.1-3.3 | Low |

**Phase 3 Deliverable:** Responsive layout working across all breakpoints

---

## Phase 4: Platform Integration

Notifications and system tray for desktop.

| ID | Task | Files | Deps | Complexity |
|----|------|-------|------|------------|
| 4.1 | Implement NotificationService interface | `lib/services/notification_service.dart` | 1.12 | Medium |
| 4.2 | Implement push notification setup | `lib/services/notification_service.dart`, platform configs | 4.1 | High |
| 4.3 | Implement TrayService interface | `lib/services/tray_service.dart` | 1.12 | Low |
| 4.4 | Implement macOS tray | `lib/platform/macos/macos_tray.dart` | 4.3 | Medium |
| 4.5 | Implement macOS menu bar | `lib/platform/macos/macos_menu_bar.dart` | 1.12 | Medium |
| 4.6 | Implement Windows tray | `lib/platform/windows/windows_tray.dart` | 4.3 | Medium |
| 4.7 | Implement Linux tray | `lib/platform/linux/linux_tray.dart` | 4.3 | Medium |
| 4.8 | Implement platform detection | `lib/platform/platform.dart` | - | Low |
| 4.9 | Create services barrel export | `lib/services/services.dart` | 4.1-4.3 | Low |

**Phase 4 Deliverable:** Notifications and system tray working on all platforms

---

## Phase 5: Integration & Testing

Wire everything together and ensure quality.

| ID | Task | Files | Deps | Complexity |
|----|------|-------|------|------------|
| 5.1 | Update main.dart with AppTheme | `lib/main.dart` | 1.9 | Low |
| 5.2 | Create golden tests for all components | `test/widgets/*_test.dart` | 2.1-2.13, 3.1-3.3 | High |
| 5.3 | Create breakpoint tests | `test/adaptive/*_test.dart` | 3.3 | Medium |
| 5.4 | Create accessibility tests | `test/a11y/*_test.dart` | 2.1-2.13 | Medium |
| 5.5 | Document usage examples | `lib/design/README.md` | All | Low |

**Phase 5 Deliverable:** Tested, documented design system

---

## Task Details

### 1.2 Implement AppColors

```
File: lib/design/app_colors.dart

Create:
- abstract final class AppColors
- All color constants (brand, neutrals light/dark, semantic, stage, xray)
- LinearGradient for brandGradient
- Helper method withOpacity()

Test:
- All colors match hex values from spec
- Gradient renders correctly
```

### 1.9 Implement AppTheme

```
File: lib/design/app_theme.dart

Create:
- abstract final class AppTheme
- static ThemeData get light
- static ThemeData get dark

Includes:
- ColorScheme from AppColors
- TextTheme from AppTypography
- CardTheme, AppBarTheme, DividerTheme
- SystemUiOverlayStyle for status bar

Test:
- Theme applies correctly to MaterialApp
- Dark/light switching works
```

### 2.9 Implement GalaxyCanvas

```
File: lib/widgets/galaxy_canvas.dart

Create:
- GalaxyCanvas widget with CustomPainter
- Dot grid background pattern
- Gradient background
- Lasso gesture detection (future)

Performance:
- Must render 500+ dots at 60fps
- Use RepaintBoundary for dots layer
- Viewport culling for off-screen dots

Test:
- Golden test for empty state
- Performance test with 500 dots
```

### 2.10 Implement PropertyCard

```
File: lib/widgets/property_card.dart

Create:
- PropertyCard widget
- PropertyCardVariant enum (mini, compact, full)
- Internal layout builders for each variant
- Image placeholder when imageUrl is null

Dependencies:
- StatTile for metrics
- AppBadge for stage/type
- GradeBadge for FVI grade

Test:
- Golden tests for each variant
- Test with missing optional fields
```

### 3.3 Implement AdaptiveScaffold

```
File: lib/widgets/adaptive_scaffold.dart

Create:
- AdaptiveScaffold widget
- AdaptiveDestination model
- Internal breakpoint detection
- Layout switching logic

Behavior:
- compact: body + BottomNav
- medium: body + NavigationRail
- expanded+: Sidebar + body + optional panel

Test:
- Layout at each breakpoint
- Smooth transition animation
- Keyboard shortcuts (desktop)
```

### 4.2 Implement Push Notification Setup

```
Files:
- lib/services/notification_service.dart (implementation)
- android/app/src/main/AndroidManifest.xml
- ios/Runner/Info.plist
- macos/Runner/Info.plist

Setup:
- Firebase Messaging initialization
- Permission request flow
- Token registration
- Background/foreground handlers
- Deep link parsing from payload

Test:
- Permission request shows dialog
- Token is retrieved
- Tap handler fires with payload
```

---

## Dependency Graph

```
Phase 1: Foundation
1.1 ─┬─> 1.2 ──┬─> 1.3 ──┐
     ├─> 1.4   │         │
     ├─> 1.5   │         ├─> 1.9 ─┬─> 1.11
     ├─> 1.7   │         │        │
     ├─> 1.8   ├─> 1.6 ──┤        │
     │         │         │        │
     └─> 1.10 ─┴─────────┘        │
                                  │
Phase 2: Core Components         │
     ┌────────────────────────────┘
     │
     ├─> 2.1 ──┬─> 2.10
     ├─> 2.2 ──┤
     ├─> 2.3 ──┘
     ├─> 2.4
     ├─> 2.5 ──> 2.11
     ├─> 2.6
     ├─> 2.7
     ├─> 2.8 ──> 2.9
     ├─> 2.12 ─┬─> 3.1 ─┐
     └─> 2.13  │        │
               │        │
Phase 3: Adaptive       │
     ┌─────────┘        │
     │                  │
     └─> 3.2 ──────────>├─> 3.3 ──> 3.4
                        │
Phase 4: Platform       │
1.12 ─┬─> 4.1 ──> 4.2   │
      │                 │
      ├─> 4.3 ─┬─> 4.4  │
      │        ├─> 4.6  │
      │        └─> 4.7  │
      │                 │
      ├─> 4.5           │
      └─> 4.8           │
              │         │
              └─> 4.9   │
                        │
Phase 5: Integration    │
     ┌──────────────────┘
     │
     ├─> 5.1
     ├─> 5.2
     ├─> 5.3
     ├─> 5.4
     └─> 5.5
```

---

## Implementation Order (Critical Path)

1. **Day 1**: 1.1-1.8, 1.10, 1.12 (foundation setup)
2. **Day 2**: 1.9, 1.11 (theme complete)
3. **Day 3**: 2.1-2.7 (simple components)
4. **Day 4**: 2.8-2.9 (galaxy components)
5. **Day 5**: 2.10-2.13 (complex components)
6. **Day 6**: 3.1-3.4 (adaptive layout)
7. **Day 7**: 4.1-4.2 (notifications)
8. **Day 8**: 4.3-4.9 (system tray)
9. **Day 9**: 5.1-5.5 (integration, tests)

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| GalaxyCanvas performance | Profile early, use CustomPainter, viewport culling |
| Platform-specific bugs | Test on all platforms during Phase 4 |
| Push notification setup complexity | Follow Firebase docs exactly, test on real devices |
| System tray package compatibility | Have fallback (hide feature if unsupported) |

---

## Success Criteria

- [ ] All 32 tasks completed
- [ ] Golden tests pass for all components
- [ ] Light/dark theme switching works
- [ ] Responsive layout works at all breakpoints
- [ ] Notifications work on iOS, Android, macOS
- [ ] System tray works on macOS, Windows, Linux
- [ ] No lint warnings
- [ ] Documentation complete

---

## Approval

- [x] Reviewed by: Anton
- [x] Approved on: 2026-05-24
- [x] Notes: Begin implementation
