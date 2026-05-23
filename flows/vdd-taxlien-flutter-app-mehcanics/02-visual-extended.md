# Visual Mockups: Extended Mechanics

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-05-24
> Source: designlayouts/screens/mechanics-phone.jsx

## Overview

Additional 9 mechanics discovered in `designlayouts/screens/mechanics-phone.jsx` that extend the core 5 MVP mechanics (Galaxy, Lasso, Dimension Wheel, X-Ray, AI Copilot).

---

## Screen 7: Layered Card (Document Stack)

Property document as a stack of layers that can be swiped through.

### Stack View

```
+--------------------------------------------------+
|  = Property        [<] [Stack · swipe to dig]    |
+--------------------------------------------------+
|  +----------------------------------------------+|
|  |  [A] 1247 Oak Street                 LISTED  ||
|  |  Maricopa · 123-45-678 · LIEN                ||
|  |  +--------+ +--------+ +--------+            ||
|  |  | $12,450| | 18.5%  | | 8.2    |            ||
|  |  | Lien   | | ROI    | | FVI    |            ||
|  |  +--------+ +--------+ +--------+            ||
|  +----------------------------------------------+|
|                                                  |
|  +--------------------------------------------+ |
|  | Layer 5: Risk analysis                     | |
|  | ML scores + comparable redemption history  | |
|  +--------------------------------------------+ |
|     +------------------------------------------+ |
|     | Layer 4: Edit history                   | |
|     | 5 changes · last by County of Maricopa  | |
|     +------------------------------------------+ |
|        +----------------------------------------+|
|        | Layer 3: Connections                  ||
|        | Linked auction · 2 prior owners       ||
|        +----------------------------------------+|
|           +-------------------------------------+|
|           | Layer 2: Tax parameters            ||
|           | Issue date · rate · expiration     ||
|           +-------------------------------------+|
|              +----------------------------------+|
|              | Layer 1: Items & valuation      ||
|              | Building + land breakdown       ||
|              +----------------------------------+|
|                                                  |
|                        [Swipe down to dive] ↓   |
+--------------------------------------------------+
|  [Galaxy]  [List]  [Watchlist]  [Profile]        |
+--------------------------------------------------+

Layers (bottom to top):
1. Items & valuation (green) - Building + land breakdown
2. Tax parameters (orange) - Issue date, rate, subsequent taxes
3. Connections (blue) - Linked auction, prior owners, satellites
4. Edit history (purple) - Changes, who made them
5. Risk analysis (red) - ML scores, comparable redemption
```

### Gesture

```
SWIPE DOWN: Dive into current layer
     +----------------+
     |  Main Card     |
     |                |
     |  [1] finger    |
     |   |            |
     |   V down       |
     +----------------+
     Reveals full layer content

SWIPE UP: Return to stack
```

---

## Screen 8: Orbit Favorites (Radial Triage)

Radial drop zones around a draggable card for quick categorization.

### Orbit View

```
+--------------------------------------------------+
|  = Triage          [<] [Flick to send]           |
+--------------------------------------------------+
|                                                  |
|                    (Watchlist)                   |
|                      [24]                        |
|                       |                          |
|      (To attorney)    |    (To review)           |
|          [2]    \     |     /    [8]             |
|                  \    |    /                     |
|                   \   |   /                      |
|    (Disputed)-------[CARD]-------(Urgent)        |
|        [1]          /   \          [3]           |
|                    /     \                       |
|                   /       \                      |
|      (Archive)---          ---                   |
|         [47]                                     |
|                                                  |
|  Card being triaged:                             |
|  +----------------+                              |
|  | [A] LIEN       |                              |
|  | 1247 Oak St    |                              |
|  | Maricopa $12k  |                              |
|  +----------------+                              |
|                                                  |
+--------------------------------------------------+
|  Flick to send · long-press to drop              |
+--------------------------------------------------+

Drop zones (radial positions):
- ↑ Watchlist (24) - blue
- ↗ To review (8) - orange
- → Urgent (3) - red
- ↘ Disputed (1) - purple
- ↓ To attorney (2) - gray
- ↙ Archive (47) - muted
```

### Gesture

```
FLICK: Send card to nearest zone in direction
       Direction determines target

LONG-PRESS + DRAG: Fine control over destination
```

---

## Screen 9: Magnetic Groups

Properties automatically cluster by detected relationships.

### Magnetic View

```
+--------------------------------------------------+
|  = Magnetic groups  [<] [Drag two to see]    [:] |
+--------------------------------------------------+
|  [Magnets ON] ●                                  |
|                                                  |
|        +--------------------+                    |
|       /  Owner: John K. (5) \                    |
|      /    o   o              \                   |
|     |      \ /                |                  |
|     |       o                 |                  |
|      \     / \               /                   |
|       \   o   o             /                    |
|        +-------------------+                     |
|                                                  |
|    +------------------+   +------------------+   |
|   / Oak Street (4)    \ / $12k ± 5% (7)     \   |
|  |   o     o           |    o   o   o        |  |
|  |    \   /            |     \ | /           |  |
|  |     o               |      o              |  |
|  |    / \              |     / \             |  |
|   \  o   o            / \   o   o           /   |
|    +------------------+   +------------------+   |
|                                                  |
+--------------------------------------------------+
|  Relation strength:                              |
|  [Same owner·5] [Same street·4] [Similar amt·7]  |
|  [Same auction·3] [Same tax year·12]             |
|  ─────────────────────────────────────────────── |
|  2 strong matches detected                       |
|  Both properties at 1247 Oak have same owner     |
|                               [Investigate]      |
+--------------------------------------------------+

Cluster types:
- Same owner (blue) - Properties owned by same person
- Same street (green) - Geographic proximity
- Similar amount (orange) - Tax amount within 5%
- Same auction (purple) - Listed on same date
- Same tax year (gray) - Filed in same year
```

### Gesture

```
DRAG TWO PROPERTIES TOGETHER: See relationship
PINCH ON CLUSTER: Expand to show all
TAP CLUSTER LABEL: Filter to that group
```

---

## Screen 10: AI Loupe

Circular magnifier that provides AI explanations for any field.

### Loupe Active

```
+--------------------------------------------------+
|  = Property        [<]           [AI LOUPE] ●    |
+--------------------------------------------------+
|  +----------------------------------------------+|
|  |           [PROPERTY IMAGE]                   ||
|  +----------------------------------------------+|
|  +----------------------------------------------+|
|  |  1247 Oak Street                             ||
|  |  Maricopa · 123-45-678                       ||
|  |                                              ||
|  |  +--------+  +--------+  +--------+          ||
|  |  | $12,450|  | $89,000|  | 18.5%  |          ||
|  |  | Tax    |  | Value  |  | ROI    |          ||
|  |  +---⭕---+  +--------+  +--------+          ||
|  |      ↑                                       ||
|  |      |  LOUPE HERE                           ||
|  +------+---------------------------------------+|
|         |                                        |
|    +----+-------+    +---------------------------+
|    |  $12,450   |    | AI LOUPE                  |
|    | 2.6× AVG   |    | Tax amount is 2.6× the    |
|    +------------+    | Maricopa median for       |
|                      | similar-value parcels.    |
|                      |                           |
|                      | Likely cause: 3 prior     |
|                      | unpaid years stacked.     |
|                      | Each compounds at 16%.    |
|                      |                           |
|                      | [Anomaly] [3yr stack]     |
|                      +---------------------------+
|                                                  |
|            [Drag loupe over any field]           |
+--------------------------------------------------+
```

### Gesture

```
LONG-PRESS: Activate loupe at finger position
DRAG: Move loupe over different fields
RELEASE: Keep explanation visible
TAP ELSEWHERE: Dismiss loupe
```

---

## Screen 11: Command Palette

Power-user quick access panel activated by 3-finger pull-down.

### Palette Open

```
+--------------------------------------------------+
|              (Galaxy View dimmed behind)         |
|                                                  |
|  +----------------------------------------------+|
|  |  🔍 roi█                              [⌘K]   ||
|  +----------------------------------------------+|
|  |                                              ||
|  |  [🔍] Find liens by John K.      owner search||
|  |  [!] Show overdue 3+ years          preset  ||
|  |  [📈] ROI > 20% in Florida         AI query ||
|  |  [⚖] Compare 1247 Oak vs 5602 Palm   bridge ||
|  |  [♥] Add selection to Watchlist  14 selected||
|  |  [🔗] Export selection as CSV    ELITE 🔒   ||
|  |  [📅] Auctions next 7 days         temporal ||
|  |  [↻] Refresh Pima County data    manual sync||
|  |                                              ||
|  +----------------------------------------------+|
|  |  ↑↓ navigate · ↵ run     3-finger ↓ to open ||
|  +----------------------------------------------+|
|                                                  |
+--------------------------------------------------+

Commands:
- Search by owner name
- Preset filters (overdue, high ROI, etc.)
- AI natural language queries
- Property comparison
- Batch actions (add to watchlist)
- Export (premium feature)
- Temporal filters (auctions by date)
- Manual data refresh
```

### Gesture

```
3-FINGER PULL-DOWN: Open palette
TYPE: Filter commands
↑↓: Navigate
ENTER: Execute
ESC / 3-FINGER UP: Close
```

---

## Screen 12: Voice + Gesture Combo

Voice refinement while lasso selection is active.

### Listening State

```
+--------------------------------------------------+
|  = 18 selected     [X]   [REC] ●                 |
+--------------------------------------------------+
|  [ROI] ●                                         |
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
|       (lasso selection shown with dotted line)   |
|                                                  |
+--------------------------------------------------+
|  +----------------------------------------------+|
|  |  ████████████████████░░░░░░░░░░ (waveform)   ||
|  |                                              ||
|  |  "Keep only the deeds with prior years      ||
|  |   three or more…"█                          ||
|  |                                              ||
|  |  🎤 Hold and speak · release to apply       ||
|  |                           [deed] [3+ yr]     ||
|  +----------------------------------------------+|
+--------------------------------------------------+

Features:
- Real-time waveform visualization
- Live transcription with entity highlighting
- Extracted filter tags shown as badges
- Combined with existing lasso selection
```

### Gesture

```
HOLD MIC: Start recording
SPEAK: Refine current selection
RELEASE: Apply filter to selection
```

---

## Screen 13: Map Layers

Geographic map with toggleable data layers.

### Map View

```
+--------------------------------------------------+
|  = Map · Maricopa   [<] [3 layers on]       [🔍] |
+--------------------------------------------------+
|  +----------------------------------------------+|
|  |                                          [+] ||
|  |     ~~~water~~~                          [-] ||
|  |                    ● ● ●                     ||
|  |        ░░░░░░░░░░░░░░░░ (flood zone)        ||
|  |  ●    ░░░░░░░░░░░░░░░░░░●  ●                ||
|  |    ●  ░░░░░░░░░░░░░░░░░░     ●              ||
|  |         ●    ●                   ●           ||
|  |              ████████ (risk heat)            ||
|  |    ●        █████████████                    ||
|  |       ●    █████●██████████  ●              ||
|  |            █████████████████                 ||
|  |    ●         ████████████        ●           ||
|  |                ████████                      ||
|  |        ⚖ Phoenix Courthouse · Jun 15        ||
|  |                                              ||
|  |    ●     ●        ●                  ●      ||
|  |                                              ||
|  +----------------------------------------------+|
|  +----------------------------------------------+|
|  |  Layers:                          [Manage →] ||
|  |  [●Properties 847] [●Risk heatmap]           ||
|  |  [○Owner clusters] [●Flood zones 11]         ||
|  |  [○School ratings] [●Auction venues 8]       ||
|  |  [○Walkability]                              ||
|  +----------------------------------------------+|
+--------------------------------------------------+

Layers:
- Properties (dots) - Individual property markers
- Owner clusters - Same-owner groupings
- Risk heatmap - Hot spots of high-risk properties
- Flood zones (FEMA) - Flood-prone areas
- School ratings - Good school districts
- Auction venues - Courthouse locations + dates
- Walkability - WalkScore overlay
```

### Gesture

```
PINCH: Zoom map
PAN: Move around
TAP LAYER: Toggle on/off
TAP PIN: Show property card
```

---

## Screen 14: Tax Radar

Hub-and-spoke visualization centered on user's portfolio.

### Radar View

```
+--------------------------------------------------+
|  = Tax Radar       [<] [LIVE ●]                  |
+--------------------------------------------------+
|                                                  |
|                   ○ John K.                      |
|                    \                             |
|                     \                            |
|      Acme Inc. ○-----\-----○ Sarah M.            |
|                  \    \   /                      |
|                   \    \ /                       |
|    Maricopa Co.    \   ●   ──── Duval Tax        |
|         ○───────────\═YOU═/──────────○           |
|                      / | \                       |
|                     /  |  \                      |
|                    /   |   \                     |
|        Heritage ○-/    |    \-○ Orange Co.       |
|             LLC       |                          |
|                       |                          |
|              P. Davis ○         ○ Riverside Tr.  |
|                                                  |
|               Bexar Co. ○                        |
|                                                  |
|     (concentric rings = recency of interaction)  |
|     (dot size = volume of dealings)              |
+--------------------------------------------------+
|  [John K. · ping] New lien filing · 18s ago [▶]  |
+--------------------------------------------------+

Elements:
- Center: Your portfolio ($184k, 14 liens)
- Spokes: Counterparties (owners, counties, entities)
- Distance: Recency of last transaction
- Size: Volume of dealings
- Glow color: Relationship type (danger, success, etc.)
- Sweep line: Live activity scan
```

### Gesture

```
TAP NODE: Show counterparty details
DRAG NODE: Investigate relationship
PINCH: Zoom to specific region
```

---

## Screen 15: Tax Graph

Full node-and-edge knowledge graph.

### Graph View

```
+--------------------------------------------------+
|  = Tax graph       [<] [Filter] [AI]             |
+--------------------------------------------------+
|                                                  |
|           ○ Maricopa                             |
|          /|\                                     |
|         / | \                                    |
|        /  |  \                                   |
|   Oak St  |   Palm Ave                           |
|      ○────|────○                                 |
|       \   |   /                                  |
|    pay \  |  / deed                              |
|     $13k\ | /  2023                              |
|          \|/                                     |
|    John   ●YOU                   Acme            |
|    K.────/   \────────────────────○              |
|     ○   /     \                   |              |
|        /       \                  |              |
|    Hilltop   Magnolia         Duval              |
|       ○         ○                 ○              |
|        \       /                  |              |
|         \     /                   |              |
|          \   /                   Jun15           |
|           \ /                     ○              |
|            ○ Duval                               |
|                                                  |
+--------------------------------------------------+
|  Legend:                                         |
|  ●You ○Properties ○Owners ○Counties ○Auctions    |
|  ─────────────────────────────────────────────── |
|  [Anomaly] John K. & Acme LLC share 2 addresses  |
|                                        [Explain] |
+--------------------------------------------------+

Node types:
- You (blue, center)
- Properties (green)
- Owners (orange)
- Counties (purple)
- Auctions (red)
- Payments (cyan)
- Contracts (teal)

Edges: Relationships between entities
AI: Anomaly detection (hidden connections, suspicious patterns)
```

### Gesture

```
DRAG NODE: Rearrange layout
TAP NODE: Highlight connections
PINCH: Zoom
TAP "Explain": AI explains detected pattern
```

---

## Flow: Extended Mechanics Navigation

```
[Galaxy View]
     |
     +-- (3-finger down) --> [Command Palette]
     |                              |
     +-- (tap property) --> [Property Detail]
     |                              |
     |                     +-- (swipe down stack) --> [Layered Card]
     |                     |
     |                     +-- (long-press field) --> [AI Loupe]
     |
     +-- (hold + lasso + speak) --> [Voice + Gesture]
     |
     +-- (switch to map tab) --> [Map Layers]
     |
     +-- (radar icon) --> [Tax Radar]
     |
     +-- (graph icon) --> [Tax Graph]
     |
     +-- (long-press + drag to triage) --> [Orbit Favorites]
     |
     +-- (two-finger drag) --> [Magnetic Groups]
```

---

## Approval

- [ ] Reviewed by: Anton
- [ ] Approved on: [pending]
- [ ] Notes: Extended mechanics from designlayouts/screens/mechanics-phone.jsx
