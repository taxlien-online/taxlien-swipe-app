# Specifications: Extended Mechanics for Tax Lien App

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-05-24

## Overview

Technical specifications for 9 extended mechanics in Flutter. All components use the existing design system (`lib/design/`) and follow established patterns from `lib/widgets/`.

---

## Directory Structure

```
lib/
├── features/
│   └── mechanics/
│       ├── layered_card/
│       │   ├── layered_card_screen.dart
│       │   ├── widgets/
│       │   │   ├── layer_stack.dart
│       │   │   ├── layer_card.dart
│       │   │   └── layer_content.dart
│       │   └── models/
│       │       └── property_layer.dart
│       │
│       ├── orbit_favorites/
│       │   ├── orbit_triage_screen.dart
│       │   ├── widgets/
│       │   │   ├── orbit_zone.dart
│       │   │   ├── orbit_canvas.dart
│       │   │   └── flick_card.dart
│       │   └── models/
│       │       └── triage_board.dart
│       │
│       ├── magnetic_groups/
│       │   ├── magnetic_groups_screen.dart
│       │   ├── widgets/
│       │   │   ├── magnetic_canvas.dart
│       │   │   ├── property_cluster.dart
│       │   │   └── relation_badge.dart
│       │   └── models/
│       │       └── relationship.dart
│       │
│       ├── ai_loupe/
│       │   ├── ai_loupe_overlay.dart
│       │   ├── widgets/
│       │   │   ├── loupe_circle.dart
│       │   │   └── explanation_panel.dart
│       │   └── services/
│       │       └── ai_explanation_service.dart
│       │
│       ├── command_palette/
│       │   ├── command_palette_overlay.dart
│       │   ├── widgets/
│       │   │   ├── command_input.dart
│       │   │   ├── command_list.dart
│       │   │   └── command_item.dart
│       │   └── models/
│       │       └── palette_command.dart
│       │
│       ├── voice_gesture/
│       │   ├── voice_gesture_panel.dart
│       │   ├── widgets/
│       │   │   ├── waveform_visualizer.dart
│       │   │   ├── transcription_display.dart
│       │   │   └── filter_tag.dart
│       │   └── services/
│       │       └── voice_recognition_service.dart
│       │
│       ├── map_layers/
│       │   ├── map_layers_screen.dart
│       │   ├── widgets/
│       │   │   ├── layer_toggle.dart
│       │   │   ├── property_marker.dart
│       │   │   └── layer_panel.dart
│       │   └── models/
│       │       └── map_layer.dart
│       │
│       ├── tax_radar/
│       │   ├── tax_radar_screen.dart
│       │   ├── widgets/
│       │   │   ├── radar_canvas.dart
│       │   │   ├── counterparty_node.dart
│       │   │   └── activity_feed.dart
│       │   └── models/
│       │       └── counterparty.dart
│       │
│       └── tax_graph/
│           ├── tax_graph_screen.dart
│           ├── widgets/
│           │   ├── graph_canvas.dart
│           │   ├── graph_node.dart
│           │   ├── graph_edge.dart
│           │   └── anomaly_panel.dart
│           └── models/
│               ├── graph_node_data.dart
│               └── graph_edge_data.dart
```

---

## Mechanic 7: Layered Card

### Data Models

```dart
/// lib/features/mechanics/layered_card/models/property_layer.dart

enum PropertyLayerType {
  valuation,    // Green - Building + land breakdown
  taxParams,    // Orange - Issue date, rate, expiration
  connections,  // Blue - Linked auction, prior owners
  editHistory,  // Purple - Changes, who made them
  riskAnalysis, // Red - ML scores, comparable redemption
}

extension PropertyLayerTypeExt on PropertyLayerType {
  Color get color => switch (this) {
    PropertyLayerType.valuation => AppColors.success,
    PropertyLayerType.taxParams => AppColors.warning,
    PropertyLayerType.connections => AppColors.brandBlue,
    PropertyLayerType.editHistory => const Color(0xFF9B59B6),
    PropertyLayerType.riskAnalysis => AppColors.danger,
  };

  String get title => switch (this) {
    PropertyLayerType.valuation => 'Items & valuation',
    PropertyLayerType.taxParams => 'Tax parameters',
    PropertyLayerType.connections => 'Connections',
    PropertyLayerType.editHistory => 'Edit history',
    PropertyLayerType.riskAnalysis => 'Risk analysis',
  };

  String get subtitle => switch (this) {
    PropertyLayerType.valuation => 'Building + land breakdown',
    PropertyLayerType.taxParams => 'Issue date · rate · expiration',
    PropertyLayerType.connections => 'Linked auction · prior owners',
    PropertyLayerType.editHistory => 'Changes · who made them',
    PropertyLayerType.riskAnalysis => 'ML scores · comparable redemption',
  };

  int get index => switch (this) {
    PropertyLayerType.valuation => 1,
    PropertyLayerType.taxParams => 2,
    PropertyLayerType.connections => 3,
    PropertyLayerType.editHistory => 4,
    PropertyLayerType.riskAnalysis => 5,
  };
}

class PropertyLayer {
  final PropertyLayerType type;
  final Map<String, dynamic> data;

  const PropertyLayer({
    required this.type,
    required this.data,
  });
}
```

### Widget Specifications

```dart
/// lib/features/mechanics/layered_card/widgets/layer_stack.dart

class LayerStack extends StatefulWidget {
  final List<PropertyLayer> layers;
  final Widget headerCard;
  final void Function(PropertyLayerType)? onLayerTap;
  final void Function(PropertyLayerType)? onLayerExpand;

  // State: collapsed (stack view) or expanded (single layer)
}

// Gesture: Swipe down to expand, swipe up to collapse
// Animation: Spring-based (400ms), stagger 50ms between layers
// Layout: Layers offset by 8px vertically, 4px horizontally
```

### Gestures

| Gesture | Action | Animation |
|---------|--------|-----------|
| Swipe down | Expand focused layer | SlideTransition + FadeTransition |
| Swipe up | Collapse to stack | Reverse of expand |
| Tap layer | Focus layer (move to top) | ReorderableList animation |

---

## Mechanic 8: Orbit Favorites

### Data Models

```dart
/// lib/features/mechanics/orbit_favorites/models/triage_board.dart

class TriageBoard {
  final String id;
  final String name;
  final Color color;
  final int count;
  final double angle; // Radial position in degrees

  const TriageBoard({
    required this.id,
    required this.name,
    required this.color,
    required this.count,
    required this.angle,
  });

  static List<TriageBoard> defaults() => [
    TriageBoard(id: 'watchlist', name: 'Watchlist', color: AppColors.brandBlue, count: 0, angle: 90),
    TriageBoard(id: 'review', name: 'To review', color: AppColors.warning, count: 0, angle: 45),
    TriageBoard(id: 'urgent', name: 'Urgent', color: AppColors.danger, count: 0, angle: 0),
    TriageBoard(id: 'disputed', name: 'Disputed', color: const Color(0xFF9B59B6), count: 0, angle: 315),
    TriageBoard(id: 'attorney', name: 'To attorney', color: AppColors.fg2, count: 0, angle: 270),
    TriageBoard(id: 'archive', name: 'Archive', color: AppColors.fg3, count: 0, angle: 225),
  ];
}
```

### Widget Specifications

```dart
/// lib/features/mechanics/orbit_favorites/widgets/orbit_canvas.dart

class OrbitCanvas extends StatefulWidget {
  final Widget card;
  final List<TriageBoard> boards;
  final void Function(String boardId)? onFlick;
  final void Function(String boardId)? onDrop;
}

// Layout: Card in center, zones on circle at radius = 40% of min(width, height)
// Detection: Flick velocity > 1000px/s, direction ±30° to zone angle
```

### Gestures

| Gesture | Action | Threshold |
|---------|--------|-----------|
| Flick | Send to nearest zone | velocity > 1000 px/s |
| Long-press + drag | Fine control | 500ms hold |
| Tap zone | Show zone contents | - |

### Physics

```dart
// Flick physics
final SpringDescription spring = SpringDescription(
  mass: 1.0,
  stiffness: 500.0,
  damping: 25.0,
);

// Direction detection
double _detectZone(Offset velocity) {
  final angle = atan2(velocity.dy, velocity.dx) * 180 / pi;
  // Normalize to 0-360 and find nearest zone
  return _nearestZone(angle);
}
```

---

## Mechanic 9: Magnetic Groups

### Data Models

```dart
/// lib/features/mechanics/magnetic_groups/models/relationship.dart

enum RelationType {
  sameOwner,
  sameStreet,
  similarAmount,
  sameAuction,
  sameTaxYear,
}

extension RelationTypeExt on RelationType {
  Color get color => switch (this) {
    RelationType.sameOwner => AppColors.brandBlue,
    RelationType.sameStreet => AppColors.success,
    RelationType.similarAmount => AppColors.warning,
    RelationType.sameAuction => const Color(0xFF9B59B6),
    RelationType.sameTaxYear => AppColors.fg2,
  };

  String get label => switch (this) {
    RelationType.sameOwner => 'Same owner',
    RelationType.sameStreet => 'Same street',
    RelationType.similarAmount => 'Similar amount',
    RelationType.sameAuction => 'Same auction',
    RelationType.sameTaxYear => 'Same tax year',
  };
}

class PropertyClusterData {
  final String id;
  final RelationType type;
  final String label; // e.g., "John K." or "Oak Street"
  final List<String> propertyIds;
  final Offset center;
  final double radius;

  const PropertyClusterData({...});
}
```

### Widget Specifications

```dart
/// lib/features/mechanics/magnetic_groups/widgets/magnetic_canvas.dart

class MagneticCanvas extends StatefulWidget {
  final List<GalaxyDotData> dots;
  final bool magnetsEnabled;
  final List<PropertyClusterData> clusters;
  final void Function(PropertyClusterData)? onClusterTap;
  final void Function(List<String> ids)? onInvestigate;
}

// Clustering algorithm: Simple centroid-based grouping
// Animation: Properties animate toward cluster center (500ms ease-out)
// Interaction: Pinch to expand cluster, tap label to filter
```

### Physics

```dart
// Magnetic attraction
void _updatePositions() {
  for (final dot in _dots) {
    final cluster = _findCluster(dot);
    if (cluster != null && _magnetsEnabled) {
      // Apply spring force toward cluster center
      dot.velocity += (cluster.center - dot.position) * _attractionStrength;
    }
    dot.position += dot.velocity * dt;
    dot.velocity *= _damping;
  }
}
```

---

## Mechanic 10: AI Loupe

### Services

```dart
/// lib/features/mechanics/ai_loupe/services/ai_explanation_service.dart

abstract class AIExplanationService {
  Future<FieldExplanation> explainField({
    required String fieldName,
    required dynamic fieldValue,
    required String propertyId,
    required String county,
  });
}

class FieldExplanation {
  final String fieldName;
  final String displayValue;
  final String? comparison; // e.g., "2.6× AVG"
  final String explanation;
  final List<String> tags; // e.g., ["Anomaly", "3yr stack"]
  final ExplanationSeverity severity;
}

enum ExplanationSeverity { normal, warning, opportunity, info }
```

### Widget Specifications

```dart
/// lib/features/mechanics/ai_loupe/ai_loupe_overlay.dart

class AILoupeOverlay extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final AIExplanationService service;

  // Overlay shows:
  // 1. Circular magnifier at finger position (diameter 80dp)
  // 2. Explanation panel (anchored to side, max 200dp wide)
}

/// lib/features/mechanics/ai_loupe/widgets/loupe_circle.dart

class LoupeCircle extends StatelessWidget {
  final Offset position;
  final double size; // default 80dp
  final Widget? magnifiedContent;
}
```

### Gestures

| Gesture | Action | State |
|---------|--------|-------|
| Long-press (500ms) | Activate loupe | active |
| Drag | Move loupe | active |
| Release | Keep explanation | pinned |
| Tap elsewhere | Dismiss | inactive |

### Hit Testing

```dart
// Detect which field is under the loupe
Element? _findFieldAtPosition(Offset position) {
  Element? result;
  WidgetsBinding.instance.renderViewElement?.visitChildElements((element) {
    final renderBox = element.renderObject as RenderBox?;
    if (renderBox != null) {
      final bounds = renderBox.paintBounds;
      final globalBounds = MatrixUtils.transformRect(
        renderBox.getTransformTo(null),
        bounds,
      );
      if (globalBounds.contains(position)) {
        result = element;
      }
    }
  });
  return result;
}
```

---

## Mechanic 11: Command Palette

### Data Models

```dart
/// lib/features/mechanics/command_palette/models/palette_command.dart

enum CommandType {
  search,
  preset,
  aiQuery,
  compare,
  batch,
  export,
  temporal,
  sync,
}

class PaletteCommand {
  final String id;
  final CommandType type;
  final String label;
  final String description;
  final IconData icon;
  final bool isPremium;
  final String? shortcut; // e.g., "⌘K"
  final Future<void> Function(BuildContext context)? execute;

  // Fuzzy match score for filtering
  double matchScore(String query) {
    // Implement Levenshtein or similar
  }
}

// Default commands
static List<PaletteCommand> defaultCommands() => [
  PaletteCommand(
    id: 'search_owner',
    type: CommandType.search,
    label: 'Find liens by owner',
    description: 'owner search',
    icon: Icons.search,
    isPremium: false,
  ),
  // ... more commands
];
```

### Widget Specifications

```dart
/// lib/features/mechanics/command_palette/command_palette_overlay.dart

class CommandPaletteOverlay extends StatefulWidget {
  final List<PaletteCommand> commands;
  final List<PaletteCommand> recentCommands;
  final void Function(PaletteCommand)? onExecute;
}

// Layout: Modal overlay, centered, max-width 500dp
// Search: Fuzzy match with debounce 150ms
// Navigation: Arrow keys + Enter, or tap
```

### Gestures

| Gesture | Action |
|---------|--------|
| 3-finger pull-down | Open palette |
| 3-finger pull-up | Close palette |
| Type | Filter commands |
| ↑↓ | Navigate |
| Enter | Execute |
| Esc | Close |

### Gesture Detection

```dart
// 3-finger gesture detection
class ThreeFingerGestureRecognizer extends MultiTapGestureRecognizer {
  @override
  void handleTapDown(PointerDownEvent event) {
    if (_pointers.length == 3) {
      // Track vertical movement for pull-down detection
    }
  }
}
```

---

## Mechanic 12: Voice + Gesture

### Services

```dart
/// lib/features/mechanics/voice_gesture/services/voice_recognition_service.dart

abstract class VoiceRecognitionService {
  Stream<String> get transcription;
  Stream<List<double>> get waveform;
  Stream<List<FilterTag>> get extractedFilters;

  Future<void> startListening();
  Future<void> stopListening();
  bool get isListening;
}

class FilterTag {
  final String label;
  final String filterType; // e.g., "property_type", "years"
  final dynamic value;
}
```

### Widget Specifications

```dart
/// lib/features/mechanics/voice_gesture/voice_gesture_panel.dart

class VoiceGesturePanel extends StatefulWidget {
  final VoiceRecognitionService service;
  final List<String> currentSelection; // Property IDs
  final void Function(List<FilterTag>)? onFiltersApplied;
}

/// lib/features/mechanics/voice_gesture/widgets/waveform_visualizer.dart

class WaveformVisualizer extends StatelessWidget {
  final Stream<List<double>> waveform;
  final double height; // default 40dp
  final Color color; // default brandBlue
}
```

### Voice-to-Filter Mapping

```dart
// Natural language to filter conversion
Map<String, FilterTag> _parseTranscription(String text) {
  final filters = <String, FilterTag>{};

  // Pattern: "keep only deeds"
  if (text.contains(RegExp(r'(keep|only|show)\s+(deeds|liens)', caseSensitive: false))) {
    final type = text.contains('deed') ? 'DEED' : 'LIEN';
    filters['type'] = FilterTag(label: type, filterType: 'property_type', value: type);
  }

  // Pattern: "3 years or more" / "3+ years"
  final yearMatch = RegExp(r'(\d+)\+?\s*years?', caseSensitive: false).firstMatch(text);
  if (yearMatch != null) {
    final years = int.parse(yearMatch.group(1)!);
    filters['years'] = FilterTag(label: '$years+ yr', filterType: 'min_years', value: years);
  }

  return filters;
}
```

---

## Mechanic 13: Map Layers

### Data Models

```dart
/// lib/features/mechanics/map_layers/models/map_layer.dart

enum MapLayerType {
  properties,
  ownerClusters,
  riskHeatmap,
  floodZones,
  schoolRatings,
  auctionVenues,
  walkability,
}

class MapLayer {
  final MapLayerType type;
  final String label;
  final IconData icon;
  final bool isEnabled;
  final double opacity;
  final int? visibleCount;
  final String? source; // e.g., "FEMA 2024"

  const MapLayer({...});
}

class PropertyMarkerData {
  final String propertyId;
  final double latitude;
  final double longitude;
  final Color color;
  final double? riskScore;
  final PropertyStage? stage;
}
```

### Widget Specifications

```dart
/// lib/features/mechanics/map_layers/map_layers_screen.dart

class MapLayersScreen extends StatefulWidget {
  final List<PropertyMarkerData> properties;
  final LatLngBounds initialBounds;
  final List<MapLayer> layers;
  final void Function(String propertyId)? onMarkerTap;
}

// Map SDK: google_maps_flutter or flutter_map (Mapbox)
// Layer rendering: Custom tile overlays for heatmap, polygons for zones
```

### Layer Implementation

```dart
// Risk heatmap using gradient
class RiskHeatmapLayer extends StatelessWidget {
  final List<PropertyMarkerData> properties;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HeatmapPainter(
        points: properties.map((p) => HeatmapPoint(
          lat: p.latitude,
          lng: p.longitude,
          intensity: p.riskScore ?? 0.5,
        )).toList(),
        gradient: [
          Colors.green.withOpacity(0.0),
          Colors.yellow.withOpacity(0.5),
          Colors.red.withOpacity(0.8),
        ],
      ),
    );
  }
}
```

---

## Mechanic 14: Tax Radar

### Data Models

```dart
/// lib/features/mechanics/tax_radar/models/counterparty.dart

enum CounterpartyType {
  owner,
  county,
  entity, // LLC, Trust, etc.
}

class Counterparty {
  final String id;
  final String name;
  final CounterpartyType type;
  final int dealCount;
  final double totalVolume;
  final DateTime lastInteraction;
  final RelationshipHealth health; // danger, neutral, success

  // Position calculated from recency + angle distribution
  double get distanceFromCenter {
    final daysSinceInteraction = DateTime.now().difference(lastInteraction).inDays;
    return min(1.0, daysSinceInteraction / 365); // 0 = recent, 1 = old
  }
}

enum RelationshipHealth { danger, neutral, success }
```

### Widget Specifications

```dart
/// lib/features/mechanics/tax_radar/widgets/radar_canvas.dart

class RadarCanvas extends StatefulWidget {
  final List<Counterparty> counterparties;
  final double portfolioValue;
  final int portfolioCount;
  final bool showSweepLine;
  final void Function(Counterparty)? onNodeTap;
}

// Layout: Center hub (user), spokes radiate outward
// Animation: Sweep line rotates at 6rpm (10s per revolution)
// Node size: proportional to log(dealCount)
```

### Activity Feed

```dart
class RadarActivity {
  final String counterpartyId;
  final String message;
  final DateTime timestamp;
  final ActivityType type; // newFiling, payment, statusChange
}

class ActivityFeed extends StatelessWidget {
  final Stream<RadarActivity> activities;
  final int maxVisible; // default 5
}
```

---

## Mechanic 15: Tax Graph

### Data Models

```dart
/// lib/features/mechanics/tax_graph/models/graph_node_data.dart

enum GraphNodeType {
  user,       // Blue, center
  property,   // Green
  owner,      // Orange
  county,     // Purple
  auction,    // Red
  payment,    // Cyan
  contract,   // Teal
}

class GraphNodeData {
  final String id;
  final GraphNodeType type;
  final String label;
  final Offset position; // Force-directed layout
  final Map<String, dynamic> data;
  final bool hasAnomaly;
}

/// lib/features/mechanics/tax_graph/models/graph_edge_data.dart

enum EdgeType {
  owns,
  listedIn,
  soldAt,
  paidTo,
  signedWith,
}

class GraphEdgeData {
  final String id;
  final String sourceId;
  final String targetId;
  final EdgeType type;
  final String? label; // e.g., "$13k"
  final bool highlighted;
}
```

### Widget Specifications

```dart
/// lib/features/mechanics/tax_graph/widgets/graph_canvas.dart

class GraphCanvas extends StatefulWidget {
  final List<GraphNodeData> nodes;
  final List<GraphEdgeData> edges;
  final List<GraphAnomaly> anomalies;
  final void Function(GraphNodeData)? onNodeTap;
  final void Function(GraphAnomaly)? onAnomalyTap;
}

// Layout: Force-directed graph (Fruchterman-Reingold algorithm)
// Interaction: Drag nodes, pinch to zoom, tap to highlight connections
```

### Force-Directed Layout

```dart
class ForceDirectedLayout {
  final double repulsion = 5000.0;
  final double attraction = 0.01;
  final double damping = 0.9;

  void step(List<GraphNodeData> nodes, List<GraphEdgeData> edges) {
    // Repulsion between all nodes
    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        final delta = nodes[j].position - nodes[i].position;
        final distance = delta.distance.clamp(10.0, double.infinity);
        final force = delta / distance * (repulsion / (distance * distance));
        nodes[i].velocity -= force;
        nodes[j].velocity += force;
      }
    }

    // Attraction along edges
    for (final edge in edges) {
      final source = nodes.firstWhere((n) => n.id == edge.sourceId);
      final target = nodes.firstWhere((n) => n.id == edge.targetId);
      final delta = target.position - source.position;
      final force = delta * attraction;
      source.velocity += force;
      target.velocity -= force;
    }

    // Apply velocity with damping
    for (final node in nodes) {
      node.position += node.velocity;
      node.velocity *= damping;
    }
  }
}
```

### Anomaly Detection

```dart
class GraphAnomaly {
  final String id;
  final String title;
  final String description;
  final List<String> involvedNodeIds;
  final AnomalyType type;
}

enum AnomalyType {
  sharedAddress,
  circularOwnership,
  rapidTransfers,
  unusualTiming,
}
```

---

## Dependencies

### Required Packages

```yaml
# pubspec.yaml additions

dependencies:
  # Map layers
  google_maps_flutter: ^2.5.0
  # OR
  flutter_map: ^6.0.0
  latlong2: ^0.9.0

  # Voice recognition
  speech_to_text: ^6.4.0

  # Graph layout
  graphview: ^1.2.0
  # OR custom force-directed implementation

  # Animations
  flutter_animate: ^4.3.0

  # Fuzzy search
  fuzzywuzzy: ^1.1.6
```

### API Endpoints Required

| Endpoint | Mechanic | Purpose |
|----------|----------|---------|
| `POST /ai/explain-field` | AI Loupe | Get field explanation |
| `GET /properties/:id/layers` | Layered Card | Get layer data |
| `GET /user/counterparties` | Tax Radar | Get counterparty network |
| `GET /properties/graph` | Tax Graph | Get graph nodes/edges |
| `GET /properties/anomalies` | Tax Graph | Get AI-detected anomalies |
| `POST /voice/transcribe` | Voice+Gesture | Stream transcription |

---

## Accessibility

### Requirements

| Mechanic | A11y Consideration |
|----------|-------------------|
| Layered Card | Semantic labels per layer, focus order |
| Orbit Favorites | Announce zone names on hover |
| Magnetic Groups | Cluster count announcements |
| AI Loupe | Explanation read aloud |
| Command Palette | Full keyboard navigation |
| Voice + Gesture | Visual-only fallback (type filters) |
| Map Layers | Alternative list view of properties |
| Tax Radar | Tabular counterparty list |
| Tax Graph | Node list with relationships |

### Implementation

```dart
Semantics(
  label: 'Layer 2: Tax parameters. Issue date, rate, expiration.',
  hint: 'Swipe down to expand',
  child: LayerCard(...),
)
```

---

## Performance Considerations

| Mechanic | Concern | Mitigation |
|----------|---------|------------|
| Magnetic Groups | Many dots = slow clustering | Batch updates, limit visible clusters |
| Map Layers | Tile loading | Cache tiles, progressive loading |
| Tax Graph | Force layout iterations | Run in isolate, limit iterations |
| Voice | Continuous streaming | Use efficient codec, buffer |
| AI Loupe | API latency | Cache explanations, show skeleton |

---

## Error Handling

### Graceful Degradation

```dart
// AI Loupe without AI service
if (!aiService.isAvailable) {
  return FieldExplanation(
    fieldName: fieldName,
    displayValue: fieldValue.toString(),
    explanation: 'AI explanation unavailable. Check connection.',
    tags: [],
    severity: ExplanationSeverity.info,
  );
}

// Voice without microphone permission
if (!await Permission.microphone.isGranted) {
  return _showTextInputFallback();
}
```

---

## Testing Strategy

### Unit Tests

- Model serialization/deserialization
- Clustering algorithms
- Force-directed layout convergence
- Fuzzy search scoring
- Voice-to-filter parsing

### Widget Tests

- Gesture detection (flick velocity, 3-finger)
- Layer stack animation states
- Command palette keyboard navigation
- Loupe positioning

### Integration Tests

- Full flow: Lasso → Voice → Filter → Result
- Graph rendering with real data
- Map layer toggle performance

---

## Approval

- [x] Reviewed by: Anton
- [x] Approved on: 2026-05-24
- [x] Notes: All 9 mechanics specified
