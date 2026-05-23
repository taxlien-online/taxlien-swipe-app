# Requirements: Tax Lien App Design System

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-05-24

## Problem Statement

The Tax Lien app currently has design assets scattered across two directories:
1. **designsystem/** - VPN Client Pro base design system (not domain-specific)
2. **designlayouts/** - Tax Lien specific screens and extensions (not implemented in Flutter)

This creates several problems:
- No unified Flutter design system in `app/taxlien-app/lib/`
- Developers must reference CSS files instead of Dart code
- Design tokens are duplicated and may drift
- New mechanics (9 concepts in designlayouts) are not documented for implementation
- No clear mapping from design to Flutter widgets

**Goal**: Create a unified Flutter Design System that consolidates both sources into production-ready Dart code.

---

## Scope

### In Scope

1. **Design Tokens (Flutter)**
   - Color palette (brand, neutrals, semantic, stage, risk, xray)
   - **Dark mode colors** (full dark theme support)
   - Typography scale (7 text styles)
   - Spacing scale (8 values + page/row gutters)
   - Border radius scale (6 values)
   - Elevation/shadows (3 levels)
   - Standard sizes (frame, tile, button, nav)

2. **Core Components (Flutter Widgets)**
   - StatTile - Metric display card
   - Badge - Status pill/chip
   - PropertyCard - Mini/compact/full variants
   - GalaxyDot - Point representation
   - TopBar - Screen header
   - BottomNav - Tab bar with frosted glass
   - FloatPanel - Floating summary panels
   - IconButton - Circular icon action
   - GradeBadge - A/B/C/D/F grade display
   - CTA Button - Primary/ghost variants
   - HUD - Floating pill indicators

3. **Domain Extensions**
   - Stage colors (pre-auction, listed, OTC, sold)
   - Risk gradient (low, mid, high)
   - X-Ray insight tints (warn, opportunity, ethical, info)
   - Property type iconography

4. **Mechanics Documentation**
   - Document 9 new mechanics from designlayouts for vdd-taxlien-flutter-app-mechanics

### Out of Scope

- Full screen implementations (handled by vdd-taxlien-flutter-app-mechanics)
- Backend integration
- Localization (separate concern)
- Animation definitions (separate file)

---

## User Stories

### US-1: Design Tokens Access

**As a** Flutter developer
**I want** access to all design tokens as Dart constants
**So that** I can build consistent UI without referencing CSS files

**Acceptance Criteria:**
1. `AppColors` class with all color definitions
2. `AppTypography` class with TextStyle presets
3. `AppSpacing` class with spacing constants
4. `AppRadius` class with BorderRadius presets
5. `AppShadows` class with BoxShadow presets
6. `AppSizes` class with standard dimensions
7. All values match CSS tokens exactly

---

### US-2: Stat Tile Component

**As a** developer building property views
**I want** a reusable StatTile widget
**So that** I can display metrics (ROI, FVI, Value) consistently

**Acceptance Criteria:**
1. Displays icon, value, label, optional delta
2. Accent color customization
3. Compact and standard size variants
4. Matches `designlayouts/styles/app.css` `.stile` class

```
+-------------+
|  [icon]     |
|   $45k      |
|   VALUE     |
|  +12% ↑     |
+-------------+
```

---

### US-3: Badge Component

**As a** developer showing status indicators
**I want** a Badge widget with tone variants
**So that** I can indicate property stage, risk, and special flags

**Acceptance Criteria:**
1. 8 tone variants: hot, good, info, warn, purple, cyan, neutral, default
2. Optional icon prefix
3. Uppercase text, correct typography
4. Matches `.badge` class from app.css

---

### US-4: Property Card Variants

**As a** developer showing property information
**I want** PropertyCard widget with 3 variants
**So that** I can use appropriate density for different contexts

**Variants:**
1. **Mini** (Galaxy View): `$45k 18% [LIEN] LOW RSK`
2. **Compact** (List View): Image + address + county + type + ROI + FVI
3. **Full** (Detail View): Image + full address + parcel + 3 stat tiles + type/stage + auction date + actions

---

### US-5: Galaxy Visualization Components

**As a** developer building the Property Galaxy
**I want** GalaxyDot and GalaxyCanvas widgets
**So that** I can render properties as points in 2D space

**Acceptance Criteria:**
1. GalaxyDot: size, color, opacity, optional halo, selection state
2. GalaxyCanvas: dot grid background, gradient, border radius
3. Performance: render 500+ dots at 60fps

---

### US-6: Navigation Components

**As a** developer building app shell
**I want** TopBar and BottomNav widgets
**So that** consistent navigation across screens

**TopBar:**
- Title + subtitle
- Leading action (back, close)
- Trailing actions (icon buttons)

**BottomNav:**
- 4 tabs: Galaxy, List, Watchlist, Profile
- Active/inactive states
- Frosted glass background
- Safe area handling

---

### US-7: Floating Panel

**As a** developer showing contextual information
**I want** FloatPanel widget
**So that** I can display selection summaries, AI insights, action panels

**Acceptance Criteria:**
1. White background with strong shadow
2. 16px border radius
3. Flexible content area
4. Optional dismiss action

---

### US-8: Domain Color Extensions

**As a** developer working with tax lien data
**I want** domain-specific color getters
**So that** I can color-code stages, risk levels, and insights

**Extensions needed:**
```dart
extension StageColors on AppColors {
  Color get stagePreAuction;
  Color get stageListed;
  Color get stageOtc;
  Color get stageSold;
}

extension RiskColors on AppColors {
  Color get riskLow;
  Color get riskMid;
  Color get riskHigh;
  Color riskGradient(double score); // 0-100
}

extension XRayColors on AppColors {
  Color get xrayWarn;
  Color get xrayOpportunity;
  Color get xrayEthical;
  Color get xrayInfo;
}
```

---

### US-9: Dark Mode Theme

**As a** user who prefers dark interfaces
**I want** the app to support dark mode
**So that** I can use it comfortably in low-light conditions

**Acceptance Criteria:**
1. Full dark theme with all tokens mapped
2. System preference detection (MediaQuery.platformBrightness)
3. Manual toggle in settings
4. Smooth transition between themes
5. All components render correctly in both modes
6. Brand gradient remains unchanged (accent)

---

### US-10: Responsive Layout System

**As a** user on any device
**I want** the app to adapt to my screen size
**So that** I can use it effectively on phone, tablet, or desktop

**Acceptance Criteria:**
1. `AdaptiveScaffold` widget handles breakpoint transitions
2. Navigation switches between bottom tabs / rail / sidebar
3. Content reflows based on available width
4. Maintains usability at all breakpoints
5. Smooth transitions when resizing (web/desktop)

---

### US-11: Desktop Navigation

**As a** desktop user
**I want** sidebar navigation with keyboard shortcuts
**So that** I can navigate efficiently with mouse and keyboard

**Acceptance Criteria:**
1. Collapsible sidebar (icons only / icons + labels)
2. Keyboard shortcuts: `Cmd+1-4` for tabs, `Cmd+K` for search
3. Menu bar integration (macOS)
4. Window controls respect platform conventions

---

### US-12: Push Notifications

**As a** investor tracking properties
**I want** to receive push notifications for important events
**So that** I don't miss auction deadlines or price changes

**Acceptance Criteria:**
1. Push notification service integration (FCM/APNs)
2. Notification categories: Auctions, Price Changes, Watchlist
3. Per-category opt-in/opt-out in settings
4. Deep link to relevant screen when tapped
5. Badge count on app icon

---

### US-13: System Tray / Menu Bar

**As a** desktop user
**I want** quick access from system tray/menu bar
**So that** I can check status without opening the full app

**Acceptance Criteria:**
1. Menu bar icon (macOS) with dropdown
2. System tray icon (Windows/Linux) with context menu
3. Quick stats: watchlist count, upcoming auctions
4. Recent properties list (last 5 viewed)
5. Open app / Quit actions

---

## Design Token Mapping

### Colors

| Token | CSS Variable | Hex | Use |
|-------|-------------|-----|-----|
| brandCyan | `--brand-cyan` | #00C6FB | Gradient top |
| brandBlue | `--brand-blue` | #005BEA | Gradient bottom, primary |
| bg | `--bg` | #F8F9FA | Page background |
| surface | `--surface` | #FFFFFF | Cards |
| fg1 | `--fg-1` | #303F49 | Primary text |
| fg2 | `--fg-2` | #B6B6B6 | Secondary text |
| fg3 | `--fg-3` | #A2A2A2 | Off-state icons |
| line | `--line` | rgba(156,178,194,0.1) | Dividers |
| disabled | `--disabled` | #E0E0E0 | Disabled state |
| success | `--success` | #1FB67A | Positive |
| warning | `--warning` | #FFB020 | Caution |
| danger | `--danger` | #E5484D | Negative |
| stagePre | `--stage-pre` | #FFB020 | Pre-auction |
| stageListed | `--stage-listed` | #005BEA | Listed |
| stageOtc | `--stage-otc` | #00C6FB | OTC |
| stageSold | `--stage-sold` | #B6B6B6 | Sold |
| xrayWarn | `--xray-warn` | #E5484D | Warning insight |
| xrayOpp | `--xray-opp` | #1FB67A | Opportunity insight |
| xrayEth | `--xray-eth` | #7B5BEA | Ethical insight |
| xrayInfo | `--xray-info` | #005BEA | Info insight |

### Dark Mode Colors

| Token | CSS Variable | Hex | Use |
|-------|-------------|-----|-----|
| bgDark | `--bg-dark` | #0F1419 | Page background (dark) |
| surfaceDark | `--surface-dark` | #1A2129 | Cards (dark) |
| surfaceDark2 | `--surface-dark-2` | #222B33 | Elevated cards (dark) |
| fg1Dark | `--fg-1-dark` | #E7ECEF | Primary text (dark) |
| fg2Dark | (derived) | #8899A6 | Secondary text (dark) |
| lineDark | (derived) | rgba(255,255,255,0.08) | Dividers (dark) |
| switchTrackDark | `--switch-track-dark` | #3A4750 | Switch track (dark) |

Note: Brand gradient, semantic colors (success/warning/danger), and stage/risk/xray colors remain unchanged in dark mode.

### Typography

| Style | Size | Weight | Line Height | Use |
|-------|------|--------|-------------|-----|
| timer | 40 | 700 | 1.0 | FVI mega-number |
| title | 24 | 600 | 1.15 | Screen titles |
| screen | 20 | 600 | 1.2 | Section headers |
| body | 17 | 400 | 1.3 | Default text |
| button | 17 | 500 | 1.0 | Button labels |
| secondary | 15 | 400 | 1.35 | Muted labels |
| label | 14 | 500 | 1.0 | Stat labels |
| caption | 13 | 400 | 1.3 | Metadata |

### Spacing

| Token | Value | Use |
|-------|-------|-----|
| xxs | 4 | Tight gaps |
| xs | 8 | Small gaps |
| sm | 12 | Component padding |
| md | 16 | Standard gap |
| lg | 20 | Section spacing |
| xl | 24 | Large gaps |
| xxl | 32 | Major sections |
| pageGutter | 30 | Screen edges |
| rowGutter | 14 | Card inner padding |

### Radius

| Token | Value | Use |
|-------|-------|-----|
| sm | 8 | Small elements |
| md | 10 | Cards |
| lg | 16 | Large cards, panels |
| xl | 20 | Modals |
| pill | 999 | Badges, pills |
| circle | 50% | Buttons, dots |

### Shadows

| Token | Value | Use |
|-------|-------|-----|
| card | 0 1px 32px rgba(156,178,194,0.10) | Cards |
| cardStrong | 0 4px 24px rgba(156,178,194,0.22) | Elevated cards |
| modal | 0 12px 48px rgba(20,35,50,0.20) | Modals, sheets |

---

## File Structure

```
app/taxlien-app/lib/
├── design/
│   ├── app_colors.dart
│   ├── app_typography.dart
│   ├── app_spacing.dart
│   ├── app_radius.dart
│   ├── app_shadows.dart
│   ├── app_sizes.dart
│   ├── app_theme.dart         # ThemeData builder (light + dark)
│   └── extensions/
│       ├── stage_colors.dart
│       ├── risk_colors.dart
│       └── xray_colors.dart
├── widgets/
│   ├── stat_tile.dart
│   ├── badge.dart
│   ├── property_card.dart
│   ├── galaxy_dot.dart
│   ├── galaxy_canvas.dart
│   ├── top_bar.dart
│   ├── bottom_nav.dart
│   ├── float_panel.dart
│   ├── icon_button.dart
│   ├── grade_badge.dart
│   ├── cta_button.dart
│   └── hud.dart
```

---

## Constraints

- **Flutter**: Dart 3.0+, Flutter 3.10+
- **Platforms**: iOS, Android, Web, macOS, Windows, Linux (all equally)
- **Performance**: All widgets must be const-constructible where possible
- **Accessibility**: Semantic labels, contrast ratios
- **Testing**: Widget tests for each component

---

## Adaptive Design

### Breakpoints

| Name | Width | Layout |
|------|-------|--------|
| `compact` | < 600px | Phone (single column, bottom nav) |
| `medium` | 600-839px | Small tablet (two column possible) |
| `expanded` | 840-1199px | Large tablet / small desktop (sidebar + content) |
| `large` | 1200-1599px | Desktop (sidebar + content + panel) |
| `extraLarge` | >= 1600px | Wide desktop (three column) |

### Platform Adaptations

| Platform | Navigation | Chrome | Notifications |
|----------|------------|--------|---------------|
| iOS | Bottom tabs | Safe areas, notch | APNs, badges |
| Android | Bottom tabs | Status bar, nav bar | FCM, badges |
| Web | Sidebar (expanded+) | Browser chrome | Web Push |
| macOS | Sidebar + menu bar | Title bar, traffic lights | UNUserNotification, menu bar |
| Windows | Sidebar + title bar | Win11 style | Windows Notifications, system tray |
| Linux | Sidebar | GTK/Qt title bar | Desktop notifications, tray |

### Navigation Patterns

**Compact (Phone)**:
- Bottom navigation (4 tabs)
- Full-screen modals
- Swipe gestures

**Medium (Tablet Portrait)**:
- Bottom navigation or rail
- Side sheets instead of full modals
- Split view optional

**Expanded+ (Tablet Landscape / Desktop)**:
- Sidebar navigation (collapsible)
- Persistent panels
- Multi-pane layouts
- Keyboard shortcuts

---

## System Integration

### Notifications

| Type | Use Case | Platforms |
|------|----------|-----------|
| **Push** | New auction alerts, price changes | All |
| **Local** | Reminder: auction in 1 hour | All |
| **Badge** | Unread count on app icon | iOS, Android, macOS |
| **In-app** | Toast/snackbar for actions | All |

### System Tray / Menu Bar

| Platform | Feature |
|----------|---------|
| macOS | Menu bar icon with quick stats, recent properties |
| Windows | System tray icon with context menu |
| Linux | Tray icon (AppIndicator) |

### Deep Links

- `taxlien://property/{id}` - Open property detail
- `taxlien://watchlist` - Open watchlist
- `taxlien://auction/{county}/{date}` - Open auction calendar

---

## Dependencies

- No external design system packages (custom implementation)
- Standard Flutter material/cupertino for primitives
- google_fonts for Inter font family (or bundled)

---

## Open Questions

- [x] Should we support dark mode in v1? **YES - required**
- [ ] Animation curves and durations - separate file?
- [ ] Should GalaxyCanvas use CustomPainter or positioned widgets?

---

## Approval

- [x] Reviewed by: Anton
- [x] Approved on: 2026-05-24
- [x] Notes: Dark mode required in v1. Proceed to visual phase.
