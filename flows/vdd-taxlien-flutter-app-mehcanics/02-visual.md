# Visual Mockups: Tax Lien Spatial Intelligence

> Version: 1.0
> Status: APPROVED
> Last Updated: 2026-05-18

## Overview

ASCII mockups for the "Property Galaxy" spatial intelligence interface. The core concept: properties are objects in space, not rows in a table.

---

## Screen 1: Property Galaxy (Main View)

The primary screen showing properties as points in 2D space.

### Default State (Zoomed Out)

```
+--------------------------------------------------+
|  = Deal Detective         [?] [AI] [:]           |
+--------------------------------------------------+
|                                                  |
|         o              O                         |
|    .  o    .    O           .                    |
|       O        .    o  .        o                |
|    .     o          O     .                      |
|  o    .    O    .       o    .    O              |
|       .        o    O        .       o           |
|    O     .  o        .    o     .                |
|       .        O  .     o    .     O             |
|    o        .       O        o        .          |
|       O  .     o        .  O     o               |
|                                                  |
+--------------------------------------------------+
|  [Dimension: ROI]     [Show: 847 properties]     |
+--------------------------------------------------+
|  [Galaxy]  [List]  [Watchlist]  [Profile]        |
+--------------------------------------------------+

Legend:
O = Large: High value property ($100k+)
o = Medium: Mid-range ($20k-$100k)
. = Small: Low value (<$20k)

Colors (not shown in ASCII):
- Green: High ROI (>15%)
- Blue: Listed/Active
- Orange: OTC Available
- Red: High Risk
- Gold: Watchlisted (glow)
```

### Zoomed In (County Cluster)

```
+--------------------------------------------------+
|  = Maricopa County, AZ    [<] [AI] [:]           |
+--------------------------------------------------+
|                                                  |
|   +----------------+    +----------------+       |
|   | 1234 Oak St    |    | 789 Pine Ave   |       |
|   | $45,000        |    | $23,500        |       |
|   | ROI: 18%       |    | ROI: 12%       |       |
|   | [LIEN]         |    | [OTC]          |       |
|   +----------------+    +----------------+       |
|                                                  |
|   +----------------+    +----------------+       |
|   | 456 Elm Rd     |    | 321 Maple Dr   |       |
|   | $67,200        |    | $89,000        |       |
|   | ROI: 22%  ***  |    | ROI: 9%        |       |
|   | [DEED]         |    | [PRE-AUCTION]  |       |
|   +----------------+    +----------------+       |
|                                                  |
|   [Pinch to zoom out]                            |
+--------------------------------------------------+
|  [Dimension: ROI]     [Showing: 24 of 847]       |
+--------------------------------------------------+
|  [Galaxy]  [List]  [Watchlist]  [Profile]        |
+--------------------------------------------------+

*** = Highlighted opportunity (high ROI + low risk)
```

### Gestures on Galaxy View

```
PINCH OUT: Zoom to see more properties
           +-----------+
           |  . o O .  |
           +-----------+
                 |
                 V
           +-----------+
           |.o.O.o.O.o.|
           |.o.o.O.o.o.|
           |O.o.o.o.O.o|
           +-----------+

PINCH IN: Zoom to see details
           +-----------+
           |.o.O.o.O.o.|
           |.o.o.O.o.o.|
           +-----------+
                 |
                 V
           +-----------+
           | +------+  |
           | | Card |  |
           | +------+  |
           +-----------+

TWO-FINGER ROTATE: Switch dimension
           [ROI] --> [County] --> [Risk] --> [Date]
                      ^                        |
                      |________________________|
```

---

## Screen 2: Lasso Selection

User draws freeform shape to select multiple properties.

### Drawing Lasso

```
+--------------------------------------------------+
|  = Deal Detective         [?] [SELECTING]        |
+--------------------------------------------------+
|                                                  |
|         o        ....O..                         |
|    .  o    . .../       \                        |
|       O     /   o  .    .\   o                   |
|    .     o |         O    |                      |
|  o    .   :|   .       o  |  .    O              |
|       .   :|     o    O   |     .       o        |
|    O     . \  o        . /   o     .             |
|       .     \.  O  .    /o    .     O            |
|    o        .'.........'     o        .          |
|       O  .     o        .  O     o               |
|                                                  |
+--------------------------------------------------+
|  Drawing selection... [Cancel]                   |
+--------------------------------------------------+
|  [Galaxy]  [List]  [Watchlist]  [Profile]        |
+--------------------------------------------------+
```

### Selection Complete - Floating Panel

```
+--------------------------------------------------+
|  = Deal Detective         [?] [AI] [:]           |
+--------------------------------------------------+
|                                                  |
|         o        ****O**                         |
|    .  o    . ***       **                        |
|       O     *   o  .    *    o                   |
|    .     o **         O   **                     |
|  o    .   **   .       o  **   .    O            |
|       .   **     o    O   **      .       o      |
|    O     . *  o        . *    o     .            |
|       .     *.  O  .    *o    .     O            |
|    o        .**********      o        .          |
|       O  .     o        .  O     o               |
|                                                  |
+--------------------------------------------------+
|  +----------------------------------------------+|
|  |  12 properties selected                      ||
|  |  Total Value: $456,000                       ||
|  |  Avg ROI: 14.2%  |  Risk: Low (3)  Med (7)   ||
|  |  [Add to Watchlist] [Export] [Clear]         ||
|  +----------------------------------------------+|
+--------------------------------------------------+
|  [Galaxy]  [List]  [Watchlist]  [Profile]        |
+--------------------------------------------------+

** = Selected properties (highlighted)
```

### Lasso Gesture Variants

```
CLOCKWISE LASSO: Select all inside
     .---->---.
    /          \
   |   SELECT   |
    \          /
     '----<----'

COUNTER-CLOCKWISE: Exclude from selection
     .----<----.
    /           \
   |   EXCLUDE   |
    \           /
     '------>---'

TWO-FINGER LASSO: Add to existing selection
     [1]-------[2]
      \         /
       \   +   /
        \_____/
```

---

## Screen 3: Dimension Wheel

Visual showing how two-finger rotation switches data dimension.

### Rotation Gesture

```
+--------------------------------------------------+
|  = Deal Detective                                |
+--------------------------------------------------+
|                                                  |
|         [Current View: By ROI]                   |
|                                                  |
|                   /----\                         |
|                  /      \                        |
|    [1]---------|  WHEEL  |---------[2]           |
|        rotate   \      /   rotate                |
|                  \----/                          |
|                                                  |
|        <-- COUNTY    ROI -->                     |
|                                                  |
+--------------------------------------------------+

Dimensions available (cycle through):
+--------+    +--------+    +--------+    +--------+
|  DATE  | -> | COUNTY | -> |  ROI   | -> |  RISK  |
+--------+    +--------+    +--------+    +--------+
     ^                                        |
     |________________________________________|

+--------+    +--------+    +--------+
| STAGE  | -> |  FVI   | -> |  TYPE  |
+--------+    +--------+    +--------+
```

### Dimension: By Date (Timeline)

```
+--------------------------------------------------+
|  = Deal Detective         [Dimension: Date]      |
+--------------------------------------------------+
|                                                  |
|  JAN    FEB    MAR    APR    MAY    JUN          |
|  |      |      |      |      |      |            |
|  o      O      .      o      O      .            |
|  .  o   o  .   O   o  .  o   o  O   O   o        |
|  O      .  O   o      .      o      .   O        |
|  |      |      |      |      |      |            |
|  '------'------'------'------'------'            |
|                                                  |
|  [<< 2025]              [2026 >>]                |
|                                                  |
+--------------------------------------------------+
```

### Dimension: By County

```
+--------------------------------------------------+
|  = Deal Detective         [Dimension: County]    |
+--------------------------------------------------+
|                                                  |
|    +----------+     +----------+                 |
|    | Maricopa |     | Pima     |                 |
|    | AZ (142) |     | AZ (87)  |                 |
|    | o O . o  |     | . o O o  |                 |
|    +----------+     +----------+                 |
|                                                  |
|    +----------+     +----------+                 |
|    | Duval    |     | Orange   |                 |
|    | FL (203) |     | FL (156) |                 |
|    | O o O .  |     | o . O o  |                 |
|    +----------+     +----------+                 |
|                                                  |
+--------------------------------------------------+
```

### Dimension: By Risk (Gravity)

```
+--------------------------------------------------+
|  = Deal Detective         [Dimension: Risk]      |
+--------------------------------------------------+
|                                                  |
|  LOW RISK              HIGH RISK                 |
|  (Green)               (Red)                     |
|                                                  |
|  o  o  o  o  o . . . o . . O . . o  O  O         |
|                                      \  \        |
|  Safe Zone           |       Danger Zone         |
|  (78%)               |       (22%)               |
|                      |                           |
|  [====GREEN====]     [==ORANGE==] [RED]          |
|                                                  |
+--------------------------------------------------+
```

---

## Screen 4: X-Ray Mode

Two-finger swipe down activates diagnostic overlay on property card.

### Normal Property Card

```
+--------------------------------------------------+
|  = 1234 Oak Street        [<] [Share] [X-Ray]    |
+--------------------------------------------------+
|  +----------------------------------------------+|
|  |  [      PROPERTY IMAGE                     ] ||
|  |  [                                         ] ||
|  |  [                                         ] ||
|  +----------------------------------------------+|
|                                                  |
|  Maricopa County, AZ                             |
|  Parcel: 123-45-678                              |
|                                                  |
|  +-------------+  +-------------+  +-------------+
|  | Lien Amount |  | Est. Value  |  | ROI         |
|  | $12,450     |  | $89,000     |  | 18%         |
|  +-------------+  +-------------+  +-------------+
|                                                  |
|  Stage: LISTED          Auction: Jun 15, 2026   |
|                                                  |
|  [Add to Watchlist]              [Make Offer]   |
+--------------------------------------------------+
```

### X-Ray Mode Active

```
+--------------------------------------------------+
|  = 1234 Oak Street        [<] [X-RAY ACTIVE]     |
+--------------------------------------------------+
|  +----------------------------------------------+|
|  |  [      PROPERTY IMAGE                     ] ||
|  |  [   !!! ROOF DAMAGE VISIBLE !!!           ] ||
|  |  [                                         ] ||
|  +----------------------------------------------+|
|                                                  |
|  ! Title Issue: Prior lien from 2019 unresolved |
|  +----------------------------------------------+|
|                                                  |
|  +-------------+  +-------------+  +-------------+
|  | Lien Amount |  | Est. Value  |  | ROI         |
|  | $12,450     |  | $89,000 (?) |  | 18% !!!     |
|  | [normal]    |  | [OUTDATED]  |  | [HIGH]      |
|  +-------------+  +-------------+  +-------------+
|                                                  |
|  ! Prior Years Owed: 3 (indicates distress)     |
|  * Similar property sold for $72k last month    |
|  +----------------------------------------------+|
|                                                  |
|  AI Insight: "High ROI but title risk. Verify   |
|  2019 mechanic's lien before bidding. Value     |
|  estimate may be stale (last updated 2024)."    |
|                                                  |
|  [Swipe up to exit X-Ray]                       |
+--------------------------------------------------+

Legend:
! = Warning/Issue (red highlight)
* = Opportunity/Insight (green highlight)
(?) = Uncertain/Stale data
!!! = Strong signal
```

### X-Ray Activation Gesture

```
     +----------------+
     |                |
     |  [1]     [2]   |
     |   |       |    |
     |   V       V    |
     |                |
     +----------------+
     Two fingers swipe DOWN
     = ACTIVATE X-RAY

     +----------------+
     |                |
     |   ^       ^    |
     |   |       |    |
     |  [1]     [2]   |
     |                |
     +----------------+
     Two fingers swipe UP
     = EXIT X-RAY
```

---

## Screen 5: AI Deal Copilot

Bottom sheet for natural language queries.

### Collapsed State (Pill)

```
+--------------------------------------------------+
|  = Deal Detective         [?] [AI] [:]           |
+--------------------------------------------------+
|                                                  |
|         o              O                         |
|    .  o    .    O           .                    |
|       O        .    o  .        o                |
|                  ...                             |
+--------------------------------------------------+
|                                                  |
|       [ Ask AI: "Find high ROI in Florida" ]     |
|                                                  |
+--------------------------------------------------+
|  [Galaxy]  [List]  [Watchlist]  [Profile]        |
+--------------------------------------------------+
```

### Expanded State (Active)

```
+--------------------------------------------------+
|  = Deal Detective                                |
+--------------------------------------------------+
|         o              O                         |
|    .  o    .    O           .    (dimmed)        |
+--------------------------------------------------+
|                                                  |
|  +----------------------------------------------+|
|  |  = AI Deal Copilot                     [X]  ||
|  +----------------------------------------------+|
|  |                                              ||
|  |  "Show me tax deeds in Maricopa County      ||
|  |   with ROI above 15% and low risk"          ||
|  |                                              ||
|  |  [ Type or speak your query... ] [MIC]      ||
|  |                                              ||
|  +----------------------------------------------+|
|  |  Recent:                                     ||
|  |  > "liens under $10k in Arizona"             ||
|  |  > "properties near Phoenix"                 ||
|  |  > "high FVI scores"                         ||
|  +----------------------------------------------+|
|  |                                              ||
|  |  Suggestions:                                ||
|  |  [OTC deals] [New this week] [Expiring soon]||
|  |                                              ||
|  +----------------------------------------------+|
+--------------------------------------------------+
```

### Query Result

```
+--------------------------------------------------+
|  = Deal Detective                                |
+--------------------------------------------------+
|                                                  |
|  AI: Found 23 properties matching your criteria  |
|                                                  |
|     ***O**    **o***                             |
|    *       *   *    *                            |
|   *    o    * *  O   *     (highlighted)         |
|    *       *   *    *                            |
|     *****      ****                              |
|                                                  |
|  +----------------------------------------------+|
|  | 23 results | Avg ROI: 17.3% | Low risk: 19   ||
|  | [View as List] [Add all to Watchlist]        ||
|  +----------------------------------------------+|
|                                                  |
+--------------------------------------------------+
```

---

## Screen 6: Swipe Focus Mode

Full-screen card-by-card review (existing feature enhanced).

### Card View

```
+--------------------------------------------------+
|                                                  |
|  +----------------------------------------------+|
|  |                                              ||
|  |  [          PROPERTY IMAGE                 ] ||
|  |  [                                         ] ||
|  |  [                                         ] ||
|  |  +------------------------------------------+||
|  |  | 1234 Oak Street                         |||
|  |  | Maricopa County, AZ                     |||
|  |  +------------------------------------------+||
|  |                                              ||
|  |  +--------+  +--------+  +--------+          ||
|  |  | $45k   |  | 18%    |  | FVI:8.2|          ||
|  |  | VALUE  |  | ROI    |  | SCORE  |          ||
|  |  +--------+  +--------+  +--------+          ||
|  |                                              ||
|  |  [TAX LIEN]     Stage: LISTED               ||
|  |                                              ||
|  +----------------------------------------------+|
|                                                  |
|       <-- PASS        LIKE -->                   |
|            DOWN: Maybe  |  UP: Super Like        |
|                                                  |
|  [1/50]                       [Exit Focus Mode]  |
+--------------------------------------------------+
```

### Swipe Actions

```
       +-------------+
       |   UP: +++   |  Super Like (priority)
       |   (blue)    |
       +-------------+
             ^
             |
+------+     |     +------+
| LEFT |<----+---->| RIGHT|
| PASS |           | LIKE |
| (red)|           |(green)|
+------+           +------+
             |
             v
       +-------------+
       | DOWN: ~     |  Maybe Later (save for review)
       | (orange)    |
       +-------------+

TWO-FINGER UP: Share with family member
TWO-FINGER DOWN: Archive/Hide
LONG PRESS: Add annotation
TAP: Expand to full details
```

---

## Component: Property Card (Reusable)

```
MINI CARD (Galaxy View)
+----------------+
| $45k    18%    |
| [LIEN] LOW RSK |
+----------------+

COMPACT CARD (List View)
+------------------------------------------------+
| [IMG] | 1234 Oak St, Phoenix, AZ     | $45,000 |
|       | Maricopa | LIEN | ROI: 18%   | FVI 8.2 |
+------------------------------------------------+

FULL CARD (Detail View)
+------------------------------------------------+
| +--------------------------------------------+ |
| |           [PROPERTY IMAGE]                 | |
| +--------------------------------------------+ |
| 1234 Oak Street                                |
| Maricopa County, AZ 85001                      |
| Parcel: 123-45-678                             |
|                                                |
| +----------+ +----------+ +----------+         |
| | $45,000  | | 18% ROI  | | FVI: 8.2 |         |
| | Value    | | Return   | | Score    |         |
| +----------+ +----------+ +----------+         |
|                                                |
| Type: TAX LIEN   Stage: LISTED                 |
| Auction: Jun 15, 2026                          |
|                                                |
| [Watchlist] [Annotate] [Share] [Details]       |
+------------------------------------------------+
```

---

## Component: Stat Tiles (Design System)

```
+-------------+  +-------------+  +-------------+
|  [icon]     |  |  [icon]     |  |  [icon]     |
|   $45k      |  |    18%      |  |    8.2      |
|   VALUE     |  |    ROI      |  |    FVI      |
+-------------+  +-------------+  +-------------+

Style: surface-card, 10px radius, --shadow-card
Colors:
  - High value: --success green
  - Medium: --brand-blue
  - Low/Risk: --danger red
```

---

## Component: Bottom Tab Bar

```
+--------------------------------------------------+
|                                                  |
|   [*]         [#]         [<3]        [@]        |
|  Galaxy      List      Watchlist    Profile      |
|                                                  |
+--------------------------------------------------+

Active state: --brand-blue fill
Inactive: --fg-2 stroke only
Background: rgba(248,249,250,0.6) + blur(40px)
Height: 92px (58px tabs + 34px home indicator)
```

---

## Flow: New User First Launch

```
[Splash] --> [Welcome] --> [Role Select] --> [Geo Select]
                                                   |
                                                   v
[Galaxy] <-- [Ready] <-- [County Select] <-- [Tutorial]
```

---

## Flow: Property Discovery

```
[Galaxy View]
     |
     +-- (pinch in) --> [Cluster View] --> [Card Detail]
     |                                           |
     +-- (lasso) --> [Selection Panel] --------+
     |                     |                   |
     +-- (tap) --> [Card Detail] --> [X-Ray] --+
     |                                         |
     +-- (AI query) --> [Filtered Results] ----+
                                               |
                                               v
                                    [Add to Watchlist]
```

---

## Accessibility Notes

- All gestures have button alternatives
- X-Ray highlights have text descriptions
- Galaxy view has list fallback
- Color coding supplemented with icons/patterns
- Minimum touch targets: 44x44 dp
- VoiceOver: "Property at 1234 Oak Street, value $45,000, ROI 18%, low risk"

---

## Approval

- [x] Reviewed by: Anton
- [x] Approved on: 2026-05-18
- [x] Notes: Visual mockups approved, proceed to specifications
