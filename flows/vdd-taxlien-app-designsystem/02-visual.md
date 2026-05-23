# Visual Mockups: Tax Lien App Design System

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-05-24

## Overview

Component previews for the unified Flutter Design System. Each component shown in multiple states and both light/dark themes.

---

## 1. Color Palette

### Brand Colors

```
LIGHT THEME
+----------------------------------------------------------+
|                                                          |
|  Brand Gradient                                          |
|  +------------------------+                              |
|  |  ████████████████████  |  #00C6FB → #005BEA          |
|  |  ████████████████████  |  (cyan to blue, 180deg)     |
|  +------------------------+                              |
|                                                          |
|  Brand Cyan        Brand Blue                            |
|  +----------+      +----------+                          |
|  |  ██████  |      |  ██████  |                          |
|  |  #00C6FB |      |  #005BEA |                          |
|  +----------+      +----------+                          |
|                                                          |
+----------------------------------------------------------+
```

### Neutral Colors (Light / Dark)

```
LIGHT                              DARK
+------------------------+         +------------------------+
| bg       #F8F9FA       |         | bgDark     #0F1419     |
| ░░░░░░░░░░░░░░░░░░░░░░ |         | ████████████████████████|
+------------------------+         +------------------------+
| surface  #FFFFFF       |         | surfaceDark #1A2129    |
| ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ |         | ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ |
+------------------------+         +------------------------+
| fg1      #303F49       |         | fg1Dark    #E7ECEF     |
| ████████ Primary text  |         | ░░░░░░░░ Primary text  |
+------------------------+         +------------------------+
| fg2      #B6B6B6       |         | fg2Dark    #8899A6     |
| ▓▓▓▓▓▓▓▓ Secondary     |         | ▓▓▓▓▓▓▓▓ Secondary     |
+------------------------+         +------------------------+
| line     rgba(156,178,194,0.1)   | lineDark  rgba(255,255,255,0.08)
| ──────── Dividers      |         | ──────── Dividers      |
+------------------------+         +------------------------+
```

### Semantic Colors

```
+------------+  +------------+  +------------+
|   SUCCESS  |  |   WARNING  |  |   DANGER   |
|   ██████   |  |   ██████   |  |   ██████   |
|   #1FB67A  |  |   #FFB020  |  |   #E5484D  |
| Low risk   |  | Med risk   |  | High risk  |
| High ROI   |  | Needs attn |  | Issues     |
+------------+  +------------+  +------------+
```

### Stage Colors

```
+------------+  +------------+  +------------+  +------------+
| PRE-AUCTION|  |   LISTED   |  |    OTC     |  |    SOLD    |
|   ██████   |  |   ██████   |  |   ██████   |  |   ░░░░░░   |
|   #FFB020  |  |   #005BEA  |  |   #00C6FB  |  |   #B6B6B6  |
+------------+  +------------+  +------------+  +------------+
```

### X-Ray Insight Colors

```
+------------+  +------------+  +------------+  +------------+
|    WARN    |  | OPPORTUNITY|  |  ETHICAL   |  |    INFO    |
|   ██████   |  |   ██████   |  |   ██████   |  |   ██████   |
|   #E5484D  |  |   #1FB67A  |  |   #7B5BEA  |  |   #005BEA  |
| Flood zone |  | High ROI   |  | Veteran    |  | Owner since|
| 3+ yr delq |  | Quick pay  |  | Senior     |  | Redemption |
+------------+  +------------+  +------------+  +------------+
```

---

## 2. Typography Scale

```
+----------------------------------------------------------+
|                                                          |
|  timer (40/700)                                          |
|  ████  8.2  ████                                         |
|  FVI Score mega-number                                   |
|                                                          |
|  title (24/600)                                          |
|  Property Details                                        |
|  Screen titles                                           |
|                                                          |
|  screen (20/600)                                         |
|  Maricopa County                                         |
|  Section headers                                         |
|                                                          |
|  body (17/400)                                           |
|  1247 Oak Street, Phoenix, AZ 85001                      |
|  Default content text                                    |
|                                                          |
|  button (17/500)                                         |
|  Add to Watchlist                                        |
|  Button labels                                           |
|                                                          |
|  secondary (15/400)                                      |
|  Last updated 2 hours ago                                |
|  Muted labels, metadata                                  |
|                                                          |
|  label (14/500)                                          |
|  LIEN AMOUNT                                             |
|  Stat tile labels                                        |
|                                                          |
|  caption (13/400)                                        |
|  Parcel: 123-45-678                                      |
|  IDs, timestamps                                         |
|                                                          |
+----------------------------------------------------------+
```

---

## 3. Spacing Scale

```
+----------------------------------------------------------+
|                                                          |
|  xxs (4)   |████|                                        |
|  xs  (8)   |████████|                                    |
|  sm  (12)  |████████████|                                |
|  md  (16)  |████████████████|                            |
|  lg  (20)  |████████████████████|                        |
|  xl  (24)  |████████████████████████|                    |
|  xxl (32)  |████████████████████████████████|            |
|                                                          |
|  pageGutter (30)  |  <-- screen edge padding             |
|  rowGutter  (14)  |  <-- card inner padding              |
|                                                          |
+----------------------------------------------------------+
```

---

## 4. Border Radius

```
+----------------------------------------------------------+
|                                                          |
|  sm (8)          md (10)         lg (16)                 |
|  +--------+      +--------+      +--------+              |
|  |        |      |        |      |        |              |
|  |   sm   |      |   md   |      |   lg   |              |
|  |        |      |        |      |        |              |
|  +--------+      +--------+      +--------+              |
|  Small elem      Cards           Large cards             |
|                                                          |
|  xl (20)         pill (999)      circle (50%)            |
|  +--------+      +--------+      +----+                  |
|  |        |      |  PILL  |      |    |                  |
|  |   xl   |      +--------+      |    |                  |
|  |        |                      +----+                  |
|  +--------+      Badges          Buttons                 |
|  Modals                                                  |
|                                                          |
+----------------------------------------------------------+
```

---

## 5. Shadows / Elevation

```
+----------------------------------------------------------+
|                                                          |
|  card (default)                                          |
|  +------------------------+                              |
|  |                        |  0 1px 32px                  |
|  |     Standard card      |  rgba(156,178,194,0.10)      |
|  |                        |                              |
|  +------------------------+                              |
|       ░░░░░░░░░░░░░░░░░                                  |
|                                                          |
|  cardStrong (elevated)                                   |
|  +------------------------+                              |
|  |                        |  0 4px 24px                  |
|  |    Elevated card       |  rgba(156,178,194,0.22)      |
|  |    (floating, drag)    |                              |
|  +------------------------+                              |
|      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒                                  |
|                                                          |
|  modal (sheets, dialogs)                                 |
|  +------------------------+                              |
|  |                        |  0 12px 48px                 |
|  |       Modal            |  rgba(20,35,50,0.20)         |
|  |                        |                              |
|  +------------------------+                              |
|     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                 |
|                                                          |
+----------------------------------------------------------+
```

---

## 6. Component: StatTile

### Variants

```
STANDARD                    COMPACT                   WITH DELTA
+-------------+             +----------+              +-------------+
|  [icon]     |             | $45k     |              |  [icon]     |
|   $45,000   |             | VALUE    |              |   $45,000   |
|   VALUE     |             +----------+              |   VALUE     |
+-------------+                                       |  +12% ↑     |
                                                      +-------------+

ACCENT COLORS
+-------------+  +-------------+  +-------------+
|   18.5%     |  |    72       |  |   $12,450   |
|   ROI       |  |   RISK      |  |   TAX DUE   |
| (green)     |  |  (red)      |  | (orange)    |
+-------------+  +-------------+  +-------------+
```

### Light vs Dark

```
LIGHT                           DARK
+-------------+                 +-------------+
|  [icon]     |  #FFFFFF bg     |  [icon]     |  #1A2129 bg
|   $45,000   |  #303F49 text   |   $45,000   |  #E7ECEF text
|   VALUE     |  #B6B6B6 label  |   VALUE     |  #8899A6 label
+-------------+                 +-------------+
    shadow                          shadow
```

---

## 7. Component: Badge

### Tone Variants

```
+--------+  +--------+  +--------+  +--------+
|  HOT   |  |  GOOD  |  |  INFO  |  |  WARN  |
+--------+  +--------+  +--------+  +--------+
 #E5484D     #1FB67A     #005BEA     #FFB020
 red bg      green bg    blue bg     orange bg

+--------+  +--------+  +--------+  +--------+
| PURPLE |  |  CYAN  |  |NEUTRAL |  |DEFAULT |
+--------+  +--------+  +--------+  +--------+
 #7B5BEA     #00C6FB     #303F49     #303F49
 purple bg   cyan bg     gray bg     subtle bg
```

### With Icon

```
+------------+  +-----------+  +------------+
| ● LIVE     |  | ♥ SAVED   |  | ⚠ STALE    |
+------------+  +-----------+  +------------+
```

### Usage Examples

```
Property type:    [LIEN] [DEED] [FORECLOSURE]
Stage:            [PRE-AUCTION] [LISTED] [OTC] [SOLD]
Risk:             [LOW RISK] [MED RISK] [HIGH RISK]
Special:          [HOMESTEAD] [VETERAN] [SENIOR] [NO HEIRS]
X-Ray:            [Anomaly] [3yr stack] [Quick pay]
```

---

## 8. Component: PropertyCard

### Mini (Galaxy View)

```
+------------------------+
|  $45k   18%   [LIEN]   |
|  LOW RSK               |
+------------------------+
  Size: ~100 x 40
  Use: Galaxy dots when zoomed
```

### Compact (List View)

```
+----------------------------------------------------------+
| [IMG] | 1234 Oak St, Phoenix, AZ           |   $45,000   |
|  60x  | Maricopa | LIEN | ROI: 18%         |   FVI 8.2   |
+----------------------------------------------------------+
  Height: 64px
  Use: List rows, search results
```

### Full (Detail View)

```
+----------------------------------------------------------+
|  +------------------------------------------------------+|
|  |                                                      ||
|  |              [PROPERTY IMAGE]                        ||
|  |                                                      ||
|  +------------------------------------------------------+|
|                                                          |
|  1247 Oak Street                                         |
|  Maricopa County, AZ 85001                               |
|  Parcel: 123-45-678                                      |
|                                                          |
|  +------------+  +------------+  +------------+          |
|  |  $45,000   |  |   18%      |  |   8.2      |          |
|  |  VALUE     |  |   ROI      |  |   FVI      |          |
|  +------------+  +------------+  +------------+          |
|                                                          |
|  Type: TAX LIEN          Stage: LISTED                   |
|  Auction: Jun 15, 2026                                   |
|                                                          |
|  [Watchlist]  [Annotate]  [Share]  [Details →]           |
+----------------------------------------------------------+
```

---

## 9. Component: GradeBadge

```
+----+  +----+  +----+  +----+  +----+
| A+ |  | B  |  | C  |  | D  |  | F  |
+----+  +----+  +----+  +----+  +----+
green   cyan    orange  red     dark red

Size variants:
+--+   +----+   +------+
|A |   | A  |   |  A   |
+--+   +----+   +------+
 sm     md       lg
(20)   (28)     (36)
```

---

## 10. Component: GalaxyDot

### States

```
DEFAULT        SELECTED       HOVERED        WATCHLIST
    o              ●             ◉              ◎
   8px           8px+ring       8px+glow       8px+halo

Size by value:
  .    o    O    ●
 4px  8px  12px 16px
<$10k $10-50k $50-100k >$100k
```

### Color by dimension

```
ROI dimension:     Risk dimension:    Stage dimension:
● green (>15%)     ● green (low)      ● orange (pre)
● blue (5-15%)     ● orange (med)     ● blue (listed)
● gray (<5%)       ● red (high)       ● cyan (otc)
                                      ○ gray (sold)
```

---

## 11. Component: TopBar

```
STANDARD
+----------------------------------------------------------+
|  [←]  Deal Detective                     [?] [AI] [:]    |
|       847 properties                                      |
+----------------------------------------------------------+

WITH SELECTION
+----------------------------------------------------------+
|  [X]  18 selected                    [SELECTING]         |
+----------------------------------------------------------+

DETAIL VIEW
+----------------------------------------------------------+
|  [←]  1247 Oak Street                   [Share] [X-Ray]  |
|       Maricopa County                                     |
+----------------------------------------------------------+
```

---

## 12. Component: BottomNav

```
+----------------------------------------------------------+
|                                                          |
|   [*]         [#]         [♥]         [@]                |
|  Galaxy      List      Watchlist    Profile              |
|    ●                                                     |
+----------------------------------------------------------+

States:
- Active: brand-blue fill, label visible
- Inactive: fg-2 stroke only

Style:
- Background: rgba(248,249,250,0.78) + blur(40px)
- Height: 58px (+ 34px safe area = 92px total)
- Border-top: 1px line color
```

### Dark Mode

```
+----------------------------------------------------------+  #1A2129
|                                                          |
|   [*]         [#]         [♥]         [@]                |
|  Galaxy      List      Watchlist    Profile              |
|    ●                                                     |
+----------------------------------------------------------+
  Background: rgba(26,33,41,0.85) + blur(40px)
```

---

## 13. Component: FloatPanel

```
+------------------------------------------------------+
|  12 properties selected                              |
|  Total Value: $456,000                               |
|  Avg ROI: 14.2%  |  Risk: Low (3)  Med (7)  High (2) |
|                                                      |
|  [Add to Watchlist]     [Export]     [Clear]         |
+------------------------------------------------------+
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ (strong shadow)

Style:
- Background: surface
- Radius: 16px (lg)
- Shadow: modal level
- Padding: 14px
```

---

## 14. Component: CTA Button

### Primary (Gradient)

```
+---------------------------+
|    Add to Watchlist       |
+---------------------------+
      ░░░░░░░░░░░░░░░░░ (blue glow shadow)

Background: brand-gradient
Color: white
Radius: 12px
Shadow: 0 8px 24px rgba(0,91,234,0.22)
```

### Ghost

```
+---------------------------+
|      View Details         |
+---------------------------+
      ░░░░░░░░░░ (card shadow)

Background: surface
Color: fg-1
Radius: 12px
Shadow: card
```

### Small Variant

```
+----------+  +----------+
| Dismiss  |  | Apply    |
+----------+  +----------+
  ghost        primary
```

---

## 15. Component: HUD

Floating status pills inside Galaxy view.

```
+------------------+     +------------------+
| ● ROI            |     | ● REC            |
+------------------+     +------------------+
  Dimension active        Recording voice

+------------------+     +------------------+
| ● Magnets ON     |     | 847 properties   |
+------------------+     +------------------+
  Feature toggle          Count display

Style:
- Background: rgba(255,255,255,0.86) + blur(20px)
- Radius: pill (999)
- Shadow: card
- Dot: 8x8 circle, colored by state
```

---

## 16. Component: IconButton

```
STANDARD           ACCENT             ACTIVE
+----+             +----+             +----+
|[?] |             |[AI]|             |[X] |
+----+             +----+             +----+
surface bg         gradient bg        danger bg
fg-1 icon          white icon         white icon

Size: 36x36
Radius: circle (50%)
Shadow: card
```

---

## Theme Comparison

```
LIGHT THEME                         DARK THEME
+---------------------------+       +---------------------------+
| bg: #F8F9FA               |       | bg: #0F1419               |
| +------------------------+|       | +------------------------+|
| | surface: #FFFFFF       ||       | | surface: #1A2129       ||
| |                        ||       | |                        ||
| | text: #303F49          ||       | | text: #E7ECEF          ||
| | muted: #B6B6B6         ||       | | muted: #8899A6         ||
| |                        ||       | |                        ||
| | +------------------+   ||       | | +------------------+   ||
| | |  Gradient CTA    |   ||       | | |  Gradient CTA    |   ||
| | +------------------+   ||       | | +------------------+   ||
| |                        ||       | |                        ||
| +------------------------+|       | +------------------------+|
|  [Galaxy] [List] [♥] [@] |       |  [Galaxy] [List] [♥] [@] |
+---------------------------+       +---------------------------+
  frosted nav                         frosted nav (dark)
```

---

## Accessibility

- All interactive elements: min 44x44 touch target
- Color contrast: WCAG AA minimum (4.5:1 for text)
- Focus rings: 2px brand-blue, 2px offset
- Icons accompanied by labels or semantic descriptions
- Badge colors supplemented with text/icons

---

## 17. Adaptive Layouts

### Breakpoint Visualization

```
COMPACT (<600px)          MEDIUM (600-839px)         EXPANDED (840-1199px)
+------------+            +------------------+        +------------------------+
|  TopBar    |            |     TopBar       |        | S |      TopBar        |
+------------+            +------------------+        | I +--------------------+
|            |            |        |         |        | D |                    |
|  Content   |            | List   | Detail  |        | E |      Content       |
|  (single)  |            | (40%)  | (60%)   |        | B |                    |
|            |            |        |         |        | A |                    |
+------------+            +------------------+        | R |                    |
| Bottom Nav |            |    Bottom Nav    |        +---+--------------------+
+------------+            +------------------+

LARGE (1200-1599px)                    EXTRA LARGE (>=1600px)
+--------------------------------+     +----------------------------------------+
| S |        TopBar        | P   |     | S |        TopBar              | P    |
| I +----------------------+ A   |     | I +----------------------------+ A    |
| D |                      | N   |     | D |            |               | N    |
| E |       Content        | E   |     | E |   List     |    Detail     | E    |
| B |                      | L   |     | B |   (30%)    |    (45%)      | L    |
| A |                      |     |     | A |            |               |      |
| R |                      |     |     | R |            |               |      |
+---+----------------------+-----+     +---+------------+---------------+------+
```

### Sidebar Navigation (Expanded+)

```
EXPANDED (Icons + Labels)           COLLAPSED (Icons only)
+-------------------------+         +----+
| [LOGO] Deal Detective   |         |[L] |
+-------------------------+         +----+
|                         |         |    |
| [*]  Galaxy      (142)  |         |[*] |
| [#]  List               |         |[#] |
| [♥]  Watchlist    (8)   |         |[♥] |
| [@]  Profile            |         |[@] |
|                         |         |    |
|-------------------------|         |----|
| [?]  Help               |         |[?] |
| [⚙]  Settings           |         |[⚙] |
+-------------------------+         +----+
  Width: 240px                       72px
```

### Navigation Rail (Medium)

```
+----+---------------------------+
|    |                           |
|[*] |                           |
|    |        Content            |
|[#] |                           |
|    |                           |
|[♥] |                           |
|    |                           |
|[@] |                           |
|    |                           |
+----+---------------------------+
Rail: 72px width, icons centered
```

---

## 18. Desktop Window Chrome

### macOS

```
+----------------------------------------------------------+
| [●][●][●]     Deal Detective                       |  -  |
+----------------------------------------------------------+
| S |                                                | P   |
| I |              Content Area                      | A   |
| D |                                                | N   |
| E |                                                | E   |
| B |                                                | L   |
| A |                                                |     |
| R |                                                |     |
+---+------------------------------------------------+-----+

Traffic lights: Close, Minimize, Fullscreen
Title: Centered (macOS style)
```

### Windows 11

```
+----------------------------------------------------------+
| [Icon] Deal Detective                         [_][□][X]  |
+----------------------------------------------------------+
| S |                                                | P   |
| I |              Content Area                      | A   |
| D |                                                | N   |
| E |                                                | E   |
| B |                                                | L   |
| A |                                                |     |
| R |                                                |     |
+---+------------------------------------------------+-----+

Title bar: Left-aligned with icon
Controls: Minimize, Maximize, Close (right)
```

---

## 19. Menu Bar / System Tray

### macOS Menu Bar

```
                                    [Icon ▾]
                                    +------------------+
                                    | Watchlist: 8     |
                                    | Auctions: 3 today|
                                    +------------------+
                                    | Recent:          |
                                    | • 1247 Oak St    |
                                    | • 456 Pine Ave   |
                                    | • 789 Maple Dr   |
                                    +------------------+
                                    | Open App         |
                                    | Preferences...   |
                                    +------------------+
                                    | Quit             |
                                    +------------------+
```

### Windows System Tray

```
[Tray Icon] Right-click:
+------------------+
| Deal Detective   |
+------------------+
| Watchlist (8)    |
| Upcoming (3)     |
+------------------+
| Open             |
| Settings         |
+------------------+
| Exit             |
+------------------+
```

---

## 20. Notifications

### Push Notification (Mobile)

```
+----------------------------------------------------------+
| [App Icon]  Deal Detective              now               |
|                                                          |
|  Auction starting soon                                   |
|  1247 Oak St auction begins in 1 hour                    |
|                                                          |
|  [View Property]              [Dismiss]                  |
+----------------------------------------------------------+
```

### In-App Toast

```
+----------------------------------------------------------+
|                                                          |
|    +------------------------------------------------+   |
|    | [✓]  Added to Watchlist              [Undo]    |   |
|    +------------------------------------------------+   |
|                                                          |
+----------------------------------------------------------+

Position: Bottom center, 16px margin
Duration: 4 seconds
Action: Optional undo/action button
```

### Desktop Notification (macOS)

```
+----------------------------------+
| [Icon] Deal Detective            |
| Auction Alert                    |
| 1247 Oak St - Starting in 1 hour |
+----------------------------------+
```

### Notification Badge

```
App Icon:
+------+
|      |
| [App]| (8)  <-- Red badge, count
|      |
+------+

Tab with badge:
[♥] Watchlist
 (3) <-- Badge on tab icon
```

---

## 21. Component: AdaptiveScaffold

```
Phone:                    Tablet:                   Desktop:
+------------+            +--------+-------+        +----+-----------+----+
|  AppBar    |            | AppBar         |        |    |  AppBar   |    |
+------------+            +--------+-------+        |Side+-----------+Side|
|            |            |        |       |        |bar |           |Pan |
|   Body     |            | Master |Detail |        |    |   Body    |el  |
|            |            |        |       |        |    |           |    |
+------------+            +--------+-------+        |    |           |    |
| BottomNav  |            | BottomNav/Rail |        +----+-----------+----+
+------------+            +--------+-------+

Handles:
- Breakpoint detection
- Navigation mode switching
- Panel visibility
- Safe areas
```

---

## Approval

- [x] Reviewed by: Anton
- [x] Approved on: 2026-05-24
- [x] Notes: Proceed to specifications phase
