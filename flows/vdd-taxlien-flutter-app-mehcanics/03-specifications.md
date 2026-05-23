# Specifications: Tax Lien Spatial Intelligence

> Version: 2.0
> Status: DRAFT (updated with vendor flow analysis)
> Last Updated: 2026-05-18
> Requirements: [01-requirements.md](./01-requirements.md) (v2.0)
> Visual Mockups: [02-visual.md](./02-visual.md)

## Overview

This specification details the technical implementation of "Property Galaxy" - a spatial intelligence interface for tax lien discovery. The system replaces traditional list-based property browsing with an interactive 2D visualization where properties are objects in space that can be selected with gestures, filtered by rotating through dimensions, inspected via X-Ray mode, and queried through an AI copilot.

---

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| `lib/features/swipe/` | Modify | Add Galaxy view mode alongside existing swipe |
| `lib/features/galaxy/` | Create | New feature module for spatial visualization |
| `lib/core/models/` | Modify | Add spatial position models, selection state |
| `lib/core/design/` | Create | New design system tokens from VPN Client Pro |
| `lib/features/copilot/` | Create | AI Deal Copilot feature module |
| `pubspec.yaml` | Modify | Add new dependencies |
| `lib/core/navigation/` | Modify | Add routes for Galaxy, Copilot |

---

## Architecture

### Component Diagram

```
+-------------------------------------------------------------------+
|                        App Shell                                   |
|  +--------------------+  +-------------------------------------+  |
|  |   Bottom TabBar    |  |          TopBar + HUD               |  |
|  | [Galaxy][List][WL] |  | [Dimension: ROI] [AI] [X-Ray] [Menu]|  |
|  +--------------------+  +-------------------------------------+  |
+-------------------------------------------------------------------+
|                                                                   |
|  +-------------------------------------------------------------+  |
|  |                    GalaxyViewport                           |  |
|  |  +-------------------------------------------------------+  |  |
|  |  |              InteractiveViewer (Zoom/Pan)             |  |  |
|  |  |  +--------------------------------------------------+ |  |  |
|  |  |  |           PropertyClusterLayer                   | |  |  |
|  |  |  |   [PropertyPoint] [PropertyPoint] [Cluster]      | |  |  |
|  |  |  |   [PropertyPoint]        [PropertyCard]          | |  |  |
|  |  |  +--------------------------------------------------+ |  |  |
|  |  |  +--------------------------------------------------+ |  |  |
|  |  |  |           LassoSelectionLayer                    | |  |  |
|  |  |  |   (CustomPainter: draws lasso path)              | |  |  |
|  |  |  +--------------------------------------------------+ |  |  |
|  |  +-------------------------------------------------------+  |  |
|  +-------------------------------------------------------------+  |
|                                                                   |
|  +-------------------------------------------------------------+  |
|  |              SelectionFloatingPanel                         |  |
|  |  [12 selected] [Total: $456k] [Avg ROI: 14%] [Add][Export]  |  |
|  +-------------------------------------------------------------+  |
|                                                                   |
|  +-------------------------------------------------------------+  |
|  |              AICopilotSheet (DraggableScrollableSheet)      |  |
|  |  [Ask AI: "Find high ROI in Florida..."]  [MIC]             |  |
|  +-------------------------------------------------------------+  |
+-------------------------------------------------------------------+

State Management:
+-------------------+     +----------------------+     +------------------+
| GalaxyProvider    |<--->| SelectionProvider    |<--->| CopilotProvider  |
| - properties      |     | - selectedIds        |     | - queryHistory   |
| - dimension       |     | - lassoPath          |     | - currentQuery   |
| - zoomLevel       |     | - isLassoMode        |     | - suggestions    |
| - positions[]     |     | - selectionStats     |     | - isProcessing   |
+-------------------+     +----------------------+     +------------------+
         |
         v
+-------------------+
| DataRepository    |  (existing)
| - properties stream
| - filters
+-------------------+
```

### Data Flow

```
User Interaction          Provider              Repository/Service
      |                      |                        |
      |--[Pinch Zoom]------->|                        |
      |                      |--update zoomLevel----->|
      |                      |<--notify listeners-----|
      |<--rebuild viewport---|                        |
      |                      |                        |
      |--[Rotate 2 fingers]->|                        |
      |                      |--cycleDimension()----->|
      |                      |--recalcPositions()---->|
      |<--animate transition-|                        |
      |                      |                        |
      |--[Draw Lasso]------->|                        |
      |                      |--addLassoPoint()------>|
      |                      |--computeSelection()--->|
      |<--update selection---|                        |
      |                      |                        |
      |--[AI Query]--------->|                        |
      |                      |--sendToCopilot()------>|
      |                      |                        |--[Cloud API]
      |                      |<--filter properties----|
      |<--highlight results--|                        |
```

---

## Interfaces

### New Interfaces

```dart
/// lib/core/interfaces/spatial_visualization.dart

/// Represents a property's position in 2D visualization space
abstract class ISpatialPosition {
  double get x;
  double get y;
  double get radius; // Size based on value/risk
  Color get color;   // Color based on dimension
}

/// Manages dimension-based layouts
abstract class IDimensionLayout {
  String get dimensionName;
  List<SpatialPosition> calculatePositions(List<TaxLien> properties);
  Color getColorForProperty(TaxLien property);
  double getRadiusForProperty(TaxLien property);
}

/// Lasso selection gesture handler
abstract class ILassoGestureHandler {
  void onLassoStart(Offset point);
  void onLassoUpdate(Offset point);
  void onLassoEnd();
  bool isPointInLasso(Offset point);
  List<String> getSelectedPropertyIds();
}

/// AI Copilot query processor
abstract class ICopilotService {
  Future<CopilotResponse> processQuery(String query);
  List<String> getSuggestions(String partialQuery);
  Stream<CopilotResponse> streamResponse(String query);
}
```

### Modified Interfaces

```dart
/// lib/features/swipe/providers/swipe_provider.dart
/// Add view mode toggle

enum ViewMode { swipe, galaxy, list }

class SwipeProvider extends ChangeNotifier {
  // Existing fields...

  ViewMode _viewMode = ViewMode.swipe;
  ViewMode get viewMode => _viewMode;

  void setViewMode(ViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }
}
```

---

## Data Models

### New Types

```dart
/// lib/core/models/spatial_position.dart

import 'package:flutter/material.dart';

/// Position of a property in the galaxy visualization
class SpatialPosition {
  final String propertyId;
  final double x;          // Normalized 0.0-1.0
  final double y;          // Normalized 0.0-1.0
  final double radius;     // 8.0 - 48.0 based on value
  final Color color;       // Based on current dimension
  final double opacity;    // 0.0-1.0 for filtering/highlight

  const SpatialPosition({
    required this.propertyId,
    required this.x,
    required this.y,
    this.radius = 16.0,
    this.color = Colors.blue,
    this.opacity = 1.0,
  });

  SpatialPosition copyWith({
    String? propertyId,
    double? x,
    double? y,
    double? radius,
    Color? color,
    double? opacity,
  }) => SpatialPosition(
    propertyId: propertyId ?? this.propertyId,
    x: x ?? this.x,
    y: y ?? this.y,
    radius: radius ?? this.radius,
    color: color ?? this.color,
    opacity: opacity ?? this.opacity,
  );

  Offset toOffset(Size canvasSize) => Offset(
    x * canvasSize.width,
    y * canvasSize.height,
  );
}
```

```dart
/// lib/core/models/galaxy_dimension.dart

enum GalaxyDimension {
  // MVP Dimensions (7)
  date,         // X: auction_date timeline, Y: county spread
  county,       // Clustered by geographic proximity
  roi,          // X: expected_roi percentage, Y: estimated_value
  risk,         // X: risk_score (0-100), Y: redemption_probability
  stage,        // Columns: pre-auction, listed, otc, sold
  fvi,          // X: FVI score, Y: tax_amount
  type,         // Clustered by property_type (SFR, Land, Commercial, etc.)

  // Extended Dimensions (Post-MVP)
  priorYears,   // X: prior_years_owed (1-5+), Y: tax_amount
  exemptions,   // Clusters: homestead | veteran | senior | none
  ownerTenure,  // X: owner_tenure_years, Y: redemption_probability
  payback,      // X: payback_months, Y: expected_roi
  taxYear,      // X: tax_year, Y: county
}

extension GalaxyDimensionExt on GalaxyDimension {
  String get displayName => switch (this) {
    GalaxyDimension.date => 'Date',
    GalaxyDimension.county => 'County',
    GalaxyDimension.roi => 'ROI',
    GalaxyDimension.risk => 'Risk',
    GalaxyDimension.stage => 'Stage',
    GalaxyDimension.fvi => 'FVI',
    GalaxyDimension.type => 'Type',
    GalaxyDimension.priorYears => 'Prior Years',
    GalaxyDimension.exemptions => 'Exemptions',
    GalaxyDimension.ownerTenure => 'Tenure',
    GalaxyDimension.payback => 'Payback',
    GalaxyDimension.taxYear => 'Tax Year',
  };

  IconData get icon => switch (this) {
    GalaxyDimension.date => Icons.calendar_today,
    GalaxyDimension.county => Icons.map,
    GalaxyDimension.roi => Icons.trending_up,
    GalaxyDimension.risk => Icons.warning,
    GalaxyDimension.stage => Icons.layers,
    GalaxyDimension.fvi => Icons.star,
    GalaxyDimension.type => Icons.home,
    GalaxyDimension.priorYears => Icons.history,
    GalaxyDimension.exemptions => Icons.shield,
    GalaxyDimension.ownerTenure => Icons.person_pin,
    GalaxyDimension.payback => Icons.access_time,
    GalaxyDimension.taxYear => Icons.date_range,
  };

  /// Whether this dimension is available in MVP
  bool get isMvp => switch (this) {
    GalaxyDimension.date ||
    GalaxyDimension.county ||
    GalaxyDimension.roi ||
    GalaxyDimension.risk ||
    GalaxyDimension.stage ||
    GalaxyDimension.fvi ||
    GalaxyDimension.type => true,
    _ => false,
  };
}
```

### Dimension Layout Algorithms

```dart
/// lib/features/galaxy/layouts/dimension_layouts.dart

import 'package:flutter/material.dart';
import '../../../core/models/tax_lien.dart';
import '../../../core/models/spatial_position.dart';
import '../../../core/design/app_colors.dart';

/// Base interface for dimension-specific layout calculations
abstract class DimensionLayout {
  GalaxyDimension get dimension;
  List<SpatialPosition> calculatePositions(List<TaxLien> properties);
  Color getColorForProperty(TaxLien property);
  double getRadiusForProperty(TaxLien property);
}

/// Date dimension: X = auction_date, Y = county spread
class DateDimensionLayout implements DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.date;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    if (properties.isEmpty) return [];

    // Find date range
    final dates = properties.map((p) => p.auctionDate).whereType<DateTime>();
    if (dates.isEmpty) return _randomLayout(properties);

    final minDate = dates.reduce((a, b) => a.isBefore(b) ? a : b);
    final maxDate = dates.reduce((a, b) => a.isAfter(b) ? a : b);
    final dateRange = maxDate.difference(minDate).inDays;

    // Group by county for Y-axis spread
    final countyIndices = <String, int>{};
    for (final p in properties) {
      countyIndices.putIfAbsent(p.county, () => countyIndices.length);
    }

    return properties.map((p) {
      final x = dateRange > 0 && p.auctionDate != null
          ? p.auctionDate!.difference(minDate).inDays / dateRange
          : 0.5;
      final countyIdx = countyIndices[p.county] ?? 0;
      final y = (countyIdx + 0.5) / countyIndices.length;

      return SpatialPosition(
        propertyId: p.id,
        x: x * 0.8 + 0.1, // 10% margin
        y: y * 0.8 + 0.1,
        color: getColorForProperty(p),
        radius: getRadiusForProperty(p),
      );
    }).toList();
  }

  @override
  Color getColorForProperty(TaxLien property) {
    // Color by urgency (days until auction)
    final daysUntil = property.auctionDate?.difference(DateTime.now()).inDays ?? 999;
    if (daysUntil <= 7) return AppColors.danger;
    if (daysUntil <= 30) return AppColors.warning;
    return AppColors.brandBlue;
  }

  @override
  double getRadiusForProperty(TaxLien property) {
    return _radiusFromValue(property.estimatedValue);
  }

  List<SpatialPosition> _randomLayout(List<TaxLien> properties) {
    return properties.asMap().entries.map((e) {
      return SpatialPosition(
        propertyId: e.value.id,
        x: (e.key % 10) / 10 * 0.8 + 0.1,
        y: (e.key ~/ 10) / (properties.length ~/ 10 + 1) * 0.8 + 0.1,
        color: getColorForProperty(e.value),
        radius: getRadiusForProperty(e.value),
      );
    }).toList();
  }
}

/// ROI dimension: X = expected_roi, Y = estimated_value
class RoiDimensionLayout implements DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.roi;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    if (properties.isEmpty) return [];

    // ROI range: typically 5% to 30%+
    const minRoi = 0.0;
    const maxRoi = 0.35; // 35% cap for visualization

    // Value range
    final values = properties.map((p) => p.estimatedValue).where((v) => v > 0);
    if (values.isEmpty) return [];
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final valueRange = maxValue - minValue;

    return properties.map((p) {
      final roi = p.expectedRoi ?? _calculateRoi(p);
      final x = ((roi - minRoi) / (maxRoi - minRoi)).clamp(0.0, 1.0);
      final y = valueRange > 0
          ? ((p.estimatedValue - minValue) / valueRange).clamp(0.0, 1.0)
          : 0.5;

      return SpatialPosition(
        propertyId: p.id,
        x: x * 0.8 + 0.1,
        y: (1 - y) * 0.8 + 0.1, // Invert Y so high value at top
        color: getColorForProperty(p),
        radius: getRadiusForProperty(p),
      );
    }).toList();
  }

  double _calculateRoi(TaxLien property) {
    if (property.taxAmount <= 0) return 0;
    return (property.estimatedValue - property.taxAmount) / property.taxAmount;
  }

  @override
  Color getColorForProperty(TaxLien property) {
    final roi = property.expectedRoi ?? _calculateRoi(property);
    if (roi >= 0.20) return AppColors.roiHigh;    // 20%+ = green
    if (roi >= 0.10) return AppColors.roiMedium;  // 10-20% = yellow
    return AppColors.roiLow;                       // <10% = red
  }

  @override
  double getRadiusForProperty(TaxLien property) {
    return _radiusFromValue(property.estimatedValue);
  }
}

/// Risk dimension: X = risk_score, Y = redemption_probability
class RiskDimensionLayout implements DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.risk;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    return properties.map((p) {
      // risk_score: 0-100 (higher = riskier)
      final riskScore = (p.riskScore ?? 50) / 100.0;
      // redemption_probability: 0-1 (higher = more likely to redeem)
      final redemptionProb = p.redemptionProbability ?? 0.5;

      return SpatialPosition(
        propertyId: p.id,
        x: riskScore * 0.8 + 0.1,
        y: (1 - redemptionProb) * 0.8 + 0.1, // Low redemption at top (opportunity)
        color: getColorForProperty(p),
        radius: getRadiusForProperty(p),
      );
    }).toList();
  }

  @override
  Color getColorForProperty(TaxLien property) {
    final riskScore = property.riskScore ?? 50;
    if (riskScore <= 30) return AppColors.riskLow;
    if (riskScore <= 70) return AppColors.riskMedium;
    return AppColors.riskHigh;
  }

  @override
  double getRadiusForProperty(TaxLien property) {
    // Size by tax_amount (investment size)
    return _radiusFromTaxAmount(property.taxAmount);
  }
}

/// Stage dimension: Columns by listing_stage
class StageDimensionLayout implements DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.stage;

  static const _stageOrder = ['pre-auction', 'listed', 'otc', 'sold'];
  static const _stageColors = {
    'pre-auction': AppColors.stagePreAuction,
    'listed': AppColors.stageListed,
    'otc': AppColors.stageOtc,
    'sold': AppColors.stageSold,
  };

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    // Group by stage
    final byStage = <String, List<TaxLien>>{};
    for (final p in properties) {
      final stage = p.listingStage ?? 'listed';
      byStage.putIfAbsent(stage, () => []).add(p);
    }

    final positions = <SpatialPosition>[];
    for (var stageIdx = 0; stageIdx < _stageOrder.length; stageIdx++) {
      final stage = _stageOrder[stageIdx];
      final stageProperties = byStage[stage] ?? [];

      // X position based on stage column
      final columnX = (stageIdx + 0.5) / _stageOrder.length;

      // Distribute properties vertically within column
      for (var i = 0; i < stageProperties.length; i++) {
        final p = stageProperties[i];
        final y = stageProperties.length > 1
            ? (i + 0.5) / stageProperties.length
            : 0.5;

        positions.add(SpatialPosition(
          propertyId: p.id,
          x: columnX * 0.8 + 0.1,
          y: y * 0.8 + 0.1,
          color: getColorForProperty(p),
          radius: getRadiusForProperty(p),
        ));
      }
    }
    return positions;
  }

  @override
  Color getColorForProperty(TaxLien property) {
    return _stageColors[property.listingStage] ?? AppColors.fg2;
  }

  @override
  double getRadiusForProperty(TaxLien property) {
    return _radiusFromValue(property.estimatedValue);
  }
}

/// Prior Years dimension: X = prior_years_owed, Y = tax_amount
class PriorYearsDimensionLayout implements DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.priorYears;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    // prior_years_owed: typically 1-5+
    const maxYears = 5.0;

    final taxAmounts = properties.map((p) => p.taxAmount).where((v) => v > 0);
    if (taxAmounts.isEmpty) return [];
    final minTax = taxAmounts.reduce((a, b) => a < b ? a : b);
    final maxTax = taxAmounts.reduce((a, b) => a > b ? a : b);
    final taxRange = maxTax - minTax;

    return properties.map((p) {
      final years = (p.priorYearsOwed ?? 1).clamp(1, 6);
      final x = (years - 1) / maxYears; // 1 year = 0, 5+ years = 1

      final y = taxRange > 0
          ? ((p.taxAmount - minTax) / taxRange).clamp(0.0, 1.0)
          : 0.5;

      return SpatialPosition(
        propertyId: p.id,
        x: x * 0.8 + 0.1,
        y: (1 - y) * 0.8 + 0.1,
        color: getColorForProperty(p),
        radius: getRadiusForProperty(p),
      );
    }).toList();
  }

  @override
  Color getColorForProperty(TaxLien property) {
    final years = property.priorYearsOwed ?? 1;
    if (years >= 4) return AppColors.danger;   // High distress
    if (years >= 2) return AppColors.warning;  // Moderate
    return AppColors.success;                   // Recent
  }

  @override
  double getRadiusForProperty(TaxLien property) {
    return _radiusFromTaxAmount(property.taxAmount);
  }
}

/// Exemptions dimension: Clusters by exemption type
class ExemptionsDimensionLayout implements DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.exemptions;

  static const _exemptionClusters = {
    'homestead': Offset(0.25, 0.25),
    'veteran': Offset(0.75, 0.25),
    'senior': Offset(0.25, 0.75),
    'disability': Offset(0.75, 0.75),
    'none': Offset(0.5, 0.5),
  };

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    // Group by primary exemption
    final byExemption = <String, List<TaxLien>>{};
    for (final p in properties) {
      final exemption = _getPrimaryExemption(p);
      byExemption.putIfAbsent(exemption, () => []).add(p);
    }

    final positions = <SpatialPosition>[];
    for (final entry in byExemption.entries) {
      final cluster = _exemptionClusters[entry.key] ?? const Offset(0.5, 0.5);

      // Spiral layout within cluster
      for (var i = 0; i < entry.value.length; i++) {
        final p = entry.value[i];
        final angle = i * 0.5;
        final radius = 0.02 + (i * 0.01).clamp(0.0, 0.15);

        positions.add(SpatialPosition(
          propertyId: p.id,
          x: (cluster.dx + radius * cos(angle)).clamp(0.1, 0.9),
          y: (cluster.dy + radius * sin(angle)).clamp(0.1, 0.9),
          color: getColorForProperty(p),
          radius: getRadiusForProperty(p),
        ));
      }
    }
    return positions;
  }

  String _getPrimaryExemption(TaxLien p) {
    if (p.hasHomesteadExemption == true) return 'homestead';
    if (p.hasVeteranExemption == true) return 'veteran';
    if (p.hasSeniorExemption == true) return 'senior';
    if (p.hasDisabilityExemption == true) return 'disability';
    return 'none';
  }

  @override
  Color getColorForProperty(TaxLien property) {
    // Properties with exemptions shown with distinct colors
    if (property.hasHomesteadExemption == true) return const Color(0xFF4CAF50);
    if (property.hasVeteranExemption == true) return const Color(0xFF2196F3);
    if (property.hasSeniorExemption == true) return const Color(0xFF9C27B0);
    if (property.hasDisabilityExemption == true) return const Color(0xFFFF9800);
    return AppColors.fg2;
  }

  @override
  double getRadiusForProperty(TaxLien property) {
    return _radiusFromValue(property.estimatedValue);
  }

  double cos(double x) => _cos(x);
  double sin(double x) => _sin(x);
}

// Utility functions
double _radiusFromValue(double value) {
  // Log scale: $10k = 12px, $100k = 24px, $1M = 36px
  if (value <= 0) return 12.0;
  return (8 + 4 * log(value / 10000 + 1)).clamp(8.0, 48.0);
}

double _radiusFromTaxAmount(double amount) {
  // $500 = 10px, $5k = 20px, $50k = 30px
  if (amount <= 0) return 10.0;
  return (6 + 4 * log(amount / 500 + 1)).clamp(6.0, 36.0);
}

double _cos(double x) => x.cos();
double _sin(double x) => x.sin();

extension on double {
  double cos() => import('dart:math').cos(this);
  double sin() => import('dart:math').sin(this);
}
```

```dart
/// lib/core/models/lasso_selection.dart

import 'dart:ui';

class LassoSelection {
  final List<Offset> points;
  final bool isClockwise;
  final DateTime startTime;

  const LassoSelection({
    required this.points,
    required this.isClockwise,
    required this.startTime,
  });

  /// Check if point is inside lasso polygon
  bool containsPoint(Offset point) {
    if (points.length < 3) return false;

    int intersections = 0;
    for (int i = 0; i < points.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];

      if ((p1.dy <= point.dy && p2.dy > point.dy) ||
          (p2.dy <= point.dy && p1.dy > point.dy)) {
        final xIntersect = (point.dy - p1.dy) / (p2.dy - p1.dy) *
                           (p2.dx - p1.dx) + p1.dx;
        if (point.dx < xIntersect) {
          intersections++;
        }
      }
    }
    return intersections.isOdd;
  }

  /// Determine if lasso was drawn clockwise (select) or counter-clockwise (exclude)
  static bool isClockwiseDirection(List<Offset> points) {
    if (points.length < 3) return true;
    double sum = 0;
    for (int i = 0; i < points.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];
      sum += (p2.dx - p1.dx) * (p2.dy + p1.dy);
    }
    return sum > 0;
  }
}
```

```dart
/// lib/core/models/selection_stats.dart

class SelectionStats {
  final int count;
  final double totalValue;
  final double totalLienAmount;
  final double averageRoi;
  final double averageExpectedRoi;      // ML-predicted expected_roi
  final double averageRedemptionProb;   // Average redemption_probability
  final double averageRiskScore;        // Average risk_score (0-100)
  final int averagePaybackMonths;       // Average payback_months
  final Map<String, int> riskDistribution; // low, medium, high based on risk_score
  final Map<String, int> stageDistribution; // pre-auction, listed, otc, sold
  final Map<String, int> exemptionDistribution; // homestead, veteran, senior, none
  final Set<String> counties;
  final Set<String> propertyTypes;

  const SelectionStats({
    required this.count,
    required this.totalValue,
    required this.totalLienAmount,
    required this.averageRoi,
    required this.averageExpectedRoi,
    required this.averageRedemptionProb,
    required this.averageRiskScore,
    required this.averagePaybackMonths,
    required this.riskDistribution,
    required this.stageDistribution,
    required this.exemptionDistribution,
    required this.counties,
    required this.propertyTypes,
  });

  factory SelectionStats.empty() => const SelectionStats(
    count: 0,
    totalValue: 0,
    totalLienAmount: 0,
    averageRoi: 0,
    averageExpectedRoi: 0,
    averageRedemptionProb: 0,
    averageRiskScore: 0,
    averagePaybackMonths: 0,
    riskDistribution: {},
    stageDistribution: {},
    exemptionDistribution: {},
    counties: {},
    propertyTypes: {},
  );

  factory SelectionStats.fromProperties(List<TaxLien> properties) {
    if (properties.isEmpty) return SelectionStats.empty();

    double totalValue = 0;
    double totalLien = 0;
    double totalRoi = 0;
    double totalExpectedRoi = 0;
    double totalRedemptionProb = 0;
    double totalRiskScore = 0;
    int totalPaybackMonths = 0;
    int countWithExpectedRoi = 0;
    int countWithRedemption = 0;
    int countWithRisk = 0;
    int countWithPayback = 0;

    final riskDist = <String, int>{'low': 0, 'medium': 0, 'high': 0};
    final stageDist = <String, int>{};
    final exemptionDist = <String, int>{'homestead': 0, 'veteran': 0, 'senior': 0, 'none': 0};
    final counties = <String>{};
    final propertyTypes = <String>{};

    for (final p in properties) {
      totalValue += p.estimatedValue ?? 0;
      totalLien += p.taxAmount ?? 0;

      // Simple ROI calculation
      if ((p.taxAmount ?? 0) > 0) {
        final roi = ((p.estimatedValue ?? 0) - p.taxAmount!) / p.taxAmount! * 100;
        totalRoi += roi;
      }

      // ML-predicted expected_roi
      if (p.expectedRoi != null) {
        totalExpectedRoi += p.expectedRoi!;
        countWithExpectedRoi++;
      }

      // Redemption probability (inverse of foreclosure opportunity)
      if (p.redemptionProbability != null) {
        totalRedemptionProb += p.redemptionProbability!;
        countWithRedemption++;
      }

      // Risk score (0-100)
      if (p.riskScore != null) {
        totalRiskScore += p.riskScore!;
        countWithRisk++;

        // Risk distribution based on risk_score
        if (p.riskScore! <= 30) {
          riskDist['low'] = (riskDist['low'] ?? 0) + 1;
        } else if (p.riskScore! <= 70) {
          riskDist['medium'] = (riskDist['medium'] ?? 0) + 1;
        } else {
          riskDist['high'] = (riskDist['high'] ?? 0) + 1;
        }
      }

      // Payback months
      if (p.paybackMonths != null) {
        totalPaybackMonths += p.paybackMonths!;
        countWithPayback++;
      }

      // Stage distribution
      final stage = p.listingStage ?? 'listed';
      stageDist[stage] = (stageDist[stage] ?? 0) + 1;

      // Exemption distribution
      if (p.hasHomesteadExemption == true) {
        exemptionDist['homestead'] = (exemptionDist['homestead'] ?? 0) + 1;
      } else if (p.hasVeteranExemption == true) {
        exemptionDist['veteran'] = (exemptionDist['veteran'] ?? 0) + 1;
      } else if (p.hasSeniorExemption == true) {
        exemptionDist['senior'] = (exemptionDist['senior'] ?? 0) + 1;
      } else {
        exemptionDist['none'] = (exemptionDist['none'] ?? 0) + 1;
      }

      if (p.county != null) counties.add(p.county!);
      if (p.propertyType != null) propertyTypes.add(p.propertyType!);
    }

    return SelectionStats(
      count: properties.length,
      totalValue: totalValue,
      totalLienAmount: totalLien,
      averageRoi: properties.isNotEmpty ? totalRoi / properties.length : 0,
      averageExpectedRoi: countWithExpectedRoi > 0 ? totalExpectedRoi / countWithExpectedRoi : 0,
      averageRedemptionProb: countWithRedemption > 0 ? totalRedemptionProb / countWithRedemption : 0,
      averageRiskScore: countWithRisk > 0 ? totalRiskScore / countWithRisk : 0,
      averagePaybackMonths: countWithPayback > 0 ? (totalPaybackMonths / countWithPayback).round() : 0,
      riskDistribution: riskDist,
      stageDistribution: stageDist,
      exemptionDistribution: exemptionDist,
      counties: counties,
      propertyTypes: propertyTypes,
    );
  }

  /// Format total value for display
  String get formattedTotalValue => _formatCurrency(totalValue);

  /// Format lien amount for display
  String get formattedLienAmount => _formatCurrency(totalLienAmount);

  /// Summary text for floating panel
  String get summaryText {
    final parts = <String>[];
    parts.add('$count selected');
    parts.add(formattedLienAmount);
    if (averageExpectedRoi > 0) {
      parts.add('${(averageExpectedRoi * 100).toStringAsFixed(1)}% avg ROI');
    }
    return parts.join(' • ');
  }

  static String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}k';
    }
    return '\$${value.toStringAsFixed(0)}';
  }
}
```

```dart
/// lib/core/models/copilot_models.dart

class CopilotQuery {
  final String text;
  final DateTime timestamp;
  final List<String>? contextPropertyIds; // Selected properties for context

  const CopilotQuery({
    required this.text,
    required this.timestamp,
    this.contextPropertyIds,
  });
}

class CopilotResponse {
  final String query;
  final List<String> matchingPropertyIds;
  final String? explanation;
  final Map<String, dynamic>? appliedFilters;
  final bool success;
  final String? error;

  const CopilotResponse({
    required this.query,
    required this.matchingPropertyIds,
    this.explanation,
    this.appliedFilters,
    this.success = true,
    this.error,
  });
}
```

```dart
/// lib/core/models/xray_insight.dart

enum XRayInsightType {
  warning,       // Issues/problems (red)
  opportunity,   // Good opportunities (green)
  ethical,       // Ethical considerations (purple)
  informational, // Neutral data insights (blue)
  stale,         // Outdated data (yellow)
}

enum XRayInsightCategory {
  risk,         // Risk-related warnings
  financial,    // Financial opportunities
  location,     // Location/neighborhood data
  owner,        // Owner-related information
  compliance,   // Ethical/compliance considerations
  data,         // Data quality/staleness
}

class XRayInsight {
  final XRayInsightType type;
  final XRayInsightCategory category;
  final String title;
  final String description;
  final String? field;         // Which data field this relates to
  final double? confidence;    // 0.0-1.0 ML/AI confidence
  final String? actionHint;    // Suggested action for user
  final Map<String, dynamic>? metadata; // Additional insight data

  const XRayInsight({
    required this.type,
    required this.category,
    required this.title,
    required this.description,
    this.field,
    this.confidence,
    this.actionHint,
    this.metadata,
  });

  Color get color => switch (type) {
    XRayInsightType.warning => const Color(0xFFE5484D),
    XRayInsightType.opportunity => const Color(0xFF1FB67A),
    XRayInsightType.ethical => const Color(0xFF9C27B0),
    XRayInsightType.informational => const Color(0xFF005BEA),
    XRayInsightType.stale => const Color(0xFFFFB020),
  };

  IconData get icon => switch (type) {
    XRayInsightType.warning => Icons.warning_rounded,
    XRayInsightType.opportunity => Icons.star_rounded,
    XRayInsightType.ethical => Icons.shield_rounded,
    XRayInsightType.informational => Icons.info_rounded,
    XRayInsightType.stale => Icons.update_rounded,
  };

  /// Priority for display ordering (lower = show first)
  int get priority => switch (type) {
    XRayInsightType.warning => 1,
    XRayInsightType.ethical => 2,
    XRayInsightType.opportunity => 3,
    XRayInsightType.informational => 4,
    XRayInsightType.stale => 5,
  };
}
```

### X-Ray Insight Generator

```dart
/// lib/features/xray/services/insight_generator.dart

import '../../../core/models/tax_lien.dart';
import '../../../core/models/xray_insight.dart';

class XRayInsightGenerator {
  /// Generate all applicable insights for a property
  List<XRayInsight> generateInsights(TaxLien property) {
    final insights = <XRayInsight>[];

    // Warning insights
    insights.addAll(_generateWarningInsights(property));

    // Opportunity insights
    insights.addAll(_generateOpportunityInsights(property));

    // Ethical insights
    insights.addAll(_generateEthicalInsights(property));

    // Informational insights
    insights.addAll(_generateInformationalInsights(property));

    // Data staleness insights
    insights.addAll(_generateDataInsights(property));

    // Sort by priority
    insights.sort((a, b) => a.priority.compareTo(b.priority));

    return insights;
  }

  List<XRayInsight> _generateWarningInsights(TaxLien p) {
    final insights = <XRayInsight>[];

    // High redemption probability warning
    if ((p.redemptionProbability ?? 0) > 0.7) {
      insights.add(XRayInsight(
        type: XRayInsightType.warning,
        category: XRayInsightCategory.risk,
        title: 'High Redemption Risk',
        description: '${(p.redemptionProbability! * 100).toStringAsFixed(0)}% probability owner will redeem',
        field: 'redemption_probability',
        confidence: p.redemptionProbability,
        actionHint: 'Consider lower-risk alternatives',
      ));
    }

    // Flood zone warning
    if (p.floodZone != null && p.floodZone != 'X' && p.floodZone != 'C') {
      insights.add(XRayInsight(
        type: XRayInsightType.warning,
        category: XRayInsightCategory.location,
        title: 'Flood Zone: ${p.floodZone}',
        description: 'Property is in FEMA flood zone, may require insurance',
        field: 'flood_zone',
        actionHint: 'Factor flood insurance into ROI calculation',
      ));
    }

    // Multi-year delinquency
    if ((p.priorYearsOwed ?? 0) >= 3) {
      insights.add(XRayInsight(
        type: XRayInsightType.warning,
        category: XRayInsightCategory.risk,
        title: 'Multi-Year Delinquency',
        description: '${p.priorYearsOwed} years of unpaid taxes',
        field: 'prior_years_owed',
        actionHint: 'May indicate severe financial distress',
      ));
    }

    // High risk score
    if ((p.riskScore ?? 0) > 70) {
      insights.add(XRayInsight(
        type: XRayInsightType.warning,
        category: XRayInsightCategory.risk,
        title: 'High Risk Score',
        description: 'Risk score: ${p.riskScore}/100',
        field: 'risk_score',
        confidence: (p.riskScore ?? 0) / 100,
      ));
    }

    // Low school rating (property value risk)
    if ((p.schoolRating ?? 10) < 4) {
      insights.add(XRayInsight(
        type: XRayInsightType.warning,
        category: XRayInsightCategory.location,
        title: 'Low School Rating',
        description: 'School district rated ${p.schoolRating}/10',
        field: 'school_rating',
        actionHint: 'May affect resale value',
      ));
    }

    return insights;
  }

  List<XRayInsight> _generateOpportunityInsights(TaxLien p) {
    final insights = <XRayInsight>[];

    // High expected ROI
    if ((p.expectedRoi ?? 0) > 0.18) {
      insights.add(XRayInsight(
        type: XRayInsightType.opportunity,
        category: XRayInsightCategory.financial,
        title: 'High ROI Potential',
        description: '${(p.expectedRoi! * 100).toStringAsFixed(1)}% expected return',
        field: 'expected_roi',
        confidence: 0.85,
      ));
    }

    // Quick payback
    if ((p.paybackMonths ?? 999) <= 12) {
      insights.add(XRayInsight(
        type: XRayInsightType.opportunity,
        category: XRayInsightCategory.financial,
        title: 'Quick Payback',
        description: '${p.paybackMonths} month estimated payback period',
        field: 'payback_months',
      ));
    }

    // High WalkScore (desirable location)
    if ((p.walkScore ?? 0) >= 70) {
      insights.add(XRayInsight(
        type: XRayInsightType.opportunity,
        category: XRayInsightCategory.location,
        title: 'Very Walkable',
        description: 'Walk Score: ${p.walkScore} - desirable location',
        field: 'walk_score',
      ));
    }

    // Low redemption probability
    if ((p.redemptionProbability ?? 1) < 0.3) {
      insights.add(XRayInsight(
        type: XRayInsightType.opportunity,
        category: XRayInsightCategory.financial,
        title: 'Low Redemption Risk',
        description: 'Only ${(p.redemptionProbability! * 100).toStringAsFixed(0)}% redemption probability',
        field: 'redemption_probability',
        confidence: 1 - p.redemptionProbability!,
      ));
    }

    // OTC available (no auction competition)
    if (p.listingStage == 'otc') {
      insights.add(XRayInsight(
        type: XRayInsightType.opportunity,
        category: XRayInsightCategory.financial,
        title: 'Over-the-Counter',
        description: 'No auction competition - direct purchase available',
        field: 'listing_stage',
      ));
    }

    // Recent Zillow value increase
    if ((p.zillowPriceChange30d ?? 0) > 0.02) {
      insights.add(XRayInsight(
        type: XRayInsightType.opportunity,
        category: XRayInsightCategory.financial,
        title: 'Value Trending Up',
        description: '+${(p.zillowPriceChange30d! * 100).toStringAsFixed(1)}% in 30 days',
        field: 'zillow_price_change_30d',
      ));
    }

    return insights;
  }

  List<XRayInsight> _generateEthicalInsights(TaxLien p) {
    final insights = <XRayInsight>[];

    // Homestead exemption (owner-occupied)
    if (p.hasHomesteadExemption == true) {
      insights.add(XRayInsight(
        type: XRayInsightType.ethical,
        category: XRayInsightCategory.compliance,
        title: 'Owner-Occupied Home',
        description: 'Homestead exemption indicates primary residence',
        field: 'has_homestead_exemption',
        actionHint: 'Consider ethical implications',
        metadata: {'exemption_type': 'homestead'},
      ));
    }

    // Veteran owner
    if (p.hasVeteranExemption == true) {
      insights.add(XRayInsight(
        type: XRayInsightType.ethical,
        category: XRayInsightCategory.compliance,
        title: 'Veteran Owner',
        description: 'Property owner is a military veteran',
        field: 'has_veteran_exemption',
        actionHint: 'VA may have assistance programs',
        metadata: {'exemption_type': 'veteran'},
      ));
    }

    // Senior owner
    if (p.hasSeniorExemption == true) {
      insights.add(XRayInsight(
        type: XRayInsightType.ethical,
        category: XRayInsightCategory.compliance,
        title: 'Senior Owner',
        description: 'Property owner qualifies for senior exemption',
        field: 'has_senior_exemption',
        actionHint: 'May have fixed income constraints',
        metadata: {'exemption_type': 'senior'},
      ));
    }

    // Disability exemption
    if (p.hasDisabilityExemption == true) {
      insights.add(XRayInsight(
        type: XRayInsightType.ethical,
        category: XRayInsightCategory.compliance,
        title: 'Disability Exemption',
        description: 'Owner has disability-based tax exemption',
        field: 'has_disability_exemption',
        actionHint: 'Consider accessibility if property acquired',
        metadata: {'exemption_type': 'disability'},
      ));
    }

    // No heirs flag
    if (p.noKnownHeirs == true) {
      insights.add(XRayInsight(
        type: XRayInsightType.ethical,
        category: XRayInsightCategory.compliance,
        title: 'No Known Heirs',
        description: 'Property may be from deceased owner without heirs',
        field: 'no_known_heirs',
        actionHint: 'Title search recommended',
      ));
    }

    return insights;
  }

  List<XRayInsight> _generateInformationalInsights(TaxLien p) {
    final insights = <XRayInsight>[];

    // Long owner tenure (stable neighborhood)
    if ((p.ownerTenureYears ?? 0) >= 10) {
      insights.add(XRayInsight(
        type: XRayInsightType.informational,
        category: XRayInsightCategory.owner,
        title: 'Long-Term Owner',
        description: 'Owner has held property for ${p.ownerTenureYears}+ years',
        field: 'owner_tenure_years',
      ));
    }

    // Property type info
    if (p.propertyType != null) {
      insights.add(XRayInsight(
        type: XRayInsightType.informational,
        category: XRayInsightCategory.location,
        title: 'Property Type',
        description: p.propertyType!,
        field: 'property_type',
      ));
    }

    // Lot size
    if ((p.lotSizeSqft ?? 0) > 0) {
      final acres = p.lotSizeSqft! / 43560;
      insights.add(XRayInsight(
        type: XRayInsightType.informational,
        category: XRayInsightCategory.location,
        title: 'Lot Size',
        description: acres >= 1
            ? '${acres.toStringAsFixed(2)} acres'
            : '${p.lotSizeSqft} sqft',
        field: 'lot_size_sqft',
      ));
    }

    // Year built
    if (p.yearBuilt != null) {
      final age = DateTime.now().year - p.yearBuilt!;
      insights.add(XRayInsight(
        type: XRayInsightType.informational,
        category: XRayInsightCategory.location,
        title: 'Built ${p.yearBuilt}',
        description: '$age years old',
        field: 'year_built',
      ));
    }

    return insights;
  }

  List<XRayInsight> _generateDataInsights(TaxLien p) {
    final insights = <XRayInsight>[];

    // Stale Zillow data
    if (p.zillowLastUpdated != null) {
      final daysSinceUpdate = DateTime.now().difference(p.zillowLastUpdated!).inDays;
      if (daysSinceUpdate > 30) {
        insights.add(XRayInsight(
          type: XRayInsightType.stale,
          category: XRayInsightCategory.data,
          title: 'Stale Valuation',
          description: 'Zillow data is $daysSinceUpdate days old',
          field: 'zillow_last_updated',
          actionHint: 'Request fresh valuation',
        ));
      }
    }

    // Missing critical data
    if (p.estimatedValue == null || p.estimatedValue == 0) {
      insights.add(XRayInsight(
        type: XRayInsightType.stale,
        category: XRayInsightCategory.data,
        title: 'Missing Valuation',
        description: 'No estimated value available',
        field: 'estimated_value',
        actionHint: 'Requires manual research',
      ));
    }

    return insights;
  }
}
```

---

## Design System Implementation

### Flutter Design Tokens

```dart
/// lib/core/design/app_colors.dart

import 'package:flutter/material.dart';

/// Design tokens from VPN Client Pro design system
/// Adapted for Tax Lien domain
class AppColors {
  AppColors._();

  // Brand
  static const brandCyan = Color(0xFF00C6FB);
  static const brandBlue = Color(0xFF005BEA);
  static const brandGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [brandCyan, brandBlue],
  );
  static const brandGradientSoft = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE6F8FF), Color(0xFFE6EEFD)],
  );

  // Light theme neutrals
  static const bg = Color(0xFFF8F9FA);
  static const surface = Color(0xFFFFFFFF);
  static const fg1 = Color(0xFF303F49);
  static const fg2 = Color(0xFFB6B6B6);
  static const fg3 = Color(0xFFA2A2A2);
  static const line = Color(0x199CB2C2); // 10% opacity
  static const disabled = Color(0xFFE0E0E0);

  // Dark theme neutrals
  static const bgDark = Color(0xFF0F1419);
  static const surfaceDark = Color(0xFF1A2129);
  static const surfaceDark2 = Color(0xFF222B33);
  static const fg1Dark = Color(0xFFE7ECEF);
  static const switchTrackDark = Color(0xFF3A4750);

  // Semantic
  static const success = Color(0xFF1FB67A);
  static const warning = Color(0xFFFFB020);
  static const danger = Color(0xFFE5484D);

  // Domain-specific (Tax Lien)
  static const roiHigh = success;
  static const roiMedium = warning;
  static const roiLow = danger;

  static const riskLow = success;
  static const riskMedium = warning;
  static const riskHigh = danger;

  static const stageListed = brandBlue;
  static const stageOtc = Color(0xFFFF9800);
  static const stagePreAuction = Color(0xFF9C27B0);
  static const stageSold = fg2;

  // Selection colors
  static const selected = brandCyan;
  static const lassoStroke = brandBlue;
  static const xrayOverlay = Color(0x40005BEA);
}
```

```dart
/// lib/core/design/app_typography.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get timer => GoogleFonts.inter(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: -0.01,
  );

  static TextStyle get title => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.15,
  );

  static TextStyle get screenTitle => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle get body => GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static TextStyle get button => GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.0,
  );

  static TextStyle get secondary => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static TextStyle get label => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.0,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );
}
```

```dart
/// lib/core/design/app_spacing.dart

class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  static const double pageGutter = 30;
  static const double rowGutter = 14;
}
```

```dart
/// lib/core/design/app_radius.dart

import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 10;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 999;

  static BorderRadius get cardRadius => BorderRadius.circular(md);
  static BorderRadius get buttonRadius => BorderRadius.circular(pill);
}
```

```dart
/// lib/core/design/app_shadows.dart

import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get card => [
    BoxShadow(
      color: const Color(0xFF9CB2C2).withOpacity(0.10),
      blurRadius: 32,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get cardStrong => [
    BoxShadow(
      color: const Color(0xFF9CB2C2).withOpacity(0.22),
      blurRadius: 24,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get modal => [
    BoxShadow(
      color: const Color(0xFF142332).withOpacity(0.20),
      blurRadius: 48,
      offset: const Offset(0, 12),
    ),
  ];
}
```

---

## Behavior Specifications

### Happy Path: Galaxy Exploration

1. User opens app → Galaxy view loads with properties as points
2. User pinches to zoom → Clusters expand to individual cards
3. User taps property → Property detail card appears
4. User two-finger rotates → Dimension changes (e.g., ROI → County)
5. User draws lasso → Selected properties highlight
6. User taps "Add to Watchlist" → Properties saved

### Happy Path: AI Copilot Query

1. User taps AI button → Copilot sheet slides up
2. User types "high ROI in Florida" → Suggestions appear
3. User taps send → Loading indicator shows
4. AI returns results → Galaxy highlights matching properties
5. Floating panel shows selection stats

### Happy Path: X-Ray Mode

1. User views property card
2. User swipes down with two fingers → X-Ray overlay activates
3. Insights highlight on card (warnings red, opportunities green)
4. User taps insight → Detailed explanation appears
5. User swipes up → X-Ray deactivates

### Edge Cases

| Case | Trigger | Expected Behavior |
|------|---------|-------------------|
| Empty dataset | No properties match filters | Show empty state with "No properties found" |
| 10,000+ properties | Large dataset | Use clustering, render max 500 points |
| Lasso too small | Area < 10px | Ignore, don't create selection |
| AI query timeout | Network delay > 10s | Show error, allow retry |
| Counter-clockwise lasso | User draws CCW | Exclude from existing selection |
| Two-finger on single property | Accidental gesture | Require minimum separation of 50px |
| Zoom out max | User keeps pinching out | Clamp at min scale (all properties visible) |
| Zoom in max | User keeps pinching in | Clamp at max scale (single property fills 50% screen) |

### Error Handling

| Error | Cause | Response |
|-------|-------|----------|
| Network error | API unreachable | Show cached data, "Offline mode" badge |
| AI service error | Copilot API fails | "AI unavailable. Try again later." |
| Invalid lasso | Path intersects itself | Auto-close at first intersection |
| Dimension calculation OOM | Too many properties | Fall back to sampling (show 1000 representative) |
| Image load fail | CDN error | Show placeholder with property initials |

---

## Dependencies

### Requires

- `lib/core/repositories/data_repository.dart` (existing)
- `lib/features/swipe/providers/swipe_provider.dart` (existing)
- `lib/core/models/tax_lien_models.dart` (existing)
- Firebase Authentication (existing)
- Network connectivity

### New Package Dependencies

```yaml
# pubspec.yaml additions
dependencies:
  # Spatial visualization
  flutter_map: ^6.0.0           # For clustering algorithms reference
  latlong2: ^0.9.0              # Coordinate math utilities

  # Gesture detection
  gesture_x_detector: ^1.1.1    # Multi-touch gesture detection

  # Animation
  flutter_animate: ^4.2.0+1     # Already present, for dimension transitions

  # AI Copilot
  speech_to_text: ^6.6.0        # Voice input

  # Clustering (optional, can implement custom)
  supercluster: ^3.0.0          # Point clustering algorithm
```

### Blocks

- Family Board sharing (depends on selection)
- Property comparison feature (depends on selection)
- Export functionality (depends on selection stats)

---

## Integration Points

### External Systems

| System | Integration |
|--------|-------------|
| Tax Lien API | Existing `TaxLienService` - no changes |
| AI Copilot API | New endpoint: `POST /detective/copilot/query` |
| Analytics | Extend existing Firebase events |

### Internal Systems

| System | Integration |
|--------|-------------|
| SwipeProvider | Add `viewMode` toggle |
| DataRepository | Use existing `getPropertiesStream()` |
| Navigation | Add `/galaxy` route |
| Watchlist | Reuse existing add-to-watchlist flow |
| Annotation | Launch from Galaxy selected property |

---

## New Routes

```dart
/// lib/core/navigation/app_router.dart additions

GoRoute(
  path: '/galaxy',
  name: 'galaxy',
  builder: (context, state) => const GalaxyScreen(),
),
GoRoute(
  path: '/property/:id/xray',
  name: 'xray',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return XRayScreen(propertyId: id);
  },
),
```

---

## Testing Strategy

### Unit Tests

- [ ] `SpatialPosition` - coordinate calculations
- [ ] `LassoSelection.containsPoint()` - polygon hit testing
- [ ] `LassoSelection.isClockwiseDirection()` - direction detection
- [ ] `SelectionStats.fromProperties()` - statistics calculation
- [ ] `GalaxyDimension` layout algorithms
- [ ] `XRayInsight` generation from property data

### Integration Tests

- [ ] Galaxy loads properties from repository
- [ ] Lasso selection updates SelectionProvider
- [ ] Dimension rotation preserves selection
- [ ] AI Copilot query returns filtered results
- [ ] X-Ray mode activates/deactivates correctly

### Manual Verification

- [ ] Pinch-to-zoom feels smooth (60fps)
- [ ] Lasso drawing is responsive
- [ ] Two-finger rotation gesture doesn't conflict with zoom
- [ ] Property cards are legible at all zoom levels
- [ ] Selection floating panel doesn't block important content
- [ ] AI Copilot suggestions are helpful
- [ ] X-Ray insights are accurate

---

## Performance Considerations

### Galaxy Rendering (Target: 60fps with 500+ properties)

1. **Clustering**: Properties closer than 20px combine into clusters
2. **Viewport culling**: Only render visible properties + 10% margin
3. **Level-of-detail**: At low zoom, show dots; at high zoom, show mini-cards
4. **Canvas rendering**: Use CustomPainter for points, not Widgets
5. **Lazy loading**: Load property details on demand

### Memory Management

1. **Image caching**: Limit to 100 most recent property images
2. **Position caching**: Recalculate only on dimension change
3. **Selection limit**: Max 500 selected properties at once

---

## Migration / Rollout

### Phase 1: Foundation
- Design system tokens
- Basic Galaxy view with static positions

### Phase 2: Gestures
- Pinch-to-zoom
- Lasso selection
- Two-finger dimension rotation

### Phase 3: Intelligence
- X-Ray mode
- AI Copilot integration

### Phase 4: Polish
- Animations and transitions
- Performance optimization
- Accessibility

---

## Open Design Questions

- [x] Which clustering algorithm? → Use DBSCAN-inspired approach
- [x] AI Copilot: cloud or local? → Cloud API for MVP
- [ ] Should X-Ray insights be cached or computed on-demand?
- [ ] Voice input language support (English only for MVP?)

---

## Approval

- [ ] Reviewed by: Anton
- [ ] Approved on: [pending]
- [ ] Notes: [any conditions or clarifications]
