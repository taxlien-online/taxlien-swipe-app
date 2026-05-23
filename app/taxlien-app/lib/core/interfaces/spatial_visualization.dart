import 'package:flutter/material.dart';
import '../models/tax_lien_models.dart';
import '../models/spatial_position.dart';
import '../models/galaxy_dimension.dart';
import '../models/copilot_models.dart';

/// Manages dimension-based layouts for the Galaxy view
abstract class IDimensionLayout {
  /// The dimension this layout handles
  GalaxyDimension get dimension;

  /// Calculate positions for all properties in this dimension
  List<SpatialPosition> calculatePositions(List<TaxLien> properties);

  /// Get the color for a property in this dimension
  Color getColorForProperty(TaxLien property);

  /// Get the radius for a property in this dimension
  double getRadiusForProperty(TaxLien property);

  /// Get axis labels for this dimension
  String get xAxisLabel;
  String get yAxisLabel;
}

/// Lasso selection gesture handler interface
abstract class ILassoGestureHandler {
  /// Called when user starts drawing a lasso
  void onLassoStart(Offset point);

  /// Called as user drags to add points to lasso
  void onLassoUpdate(Offset point);

  /// Called when user lifts finger to complete lasso
  void onLassoEnd();

  /// Check if a point is inside the current lasso
  bool isPointInLasso(Offset point);

  /// Get IDs of properties selected by the lasso
  List<String> getSelectedPropertyIds();

  /// Cancel the current lasso without selecting
  void cancelLasso();

  /// Whether a lasso is currently being drawn
  bool get isDrawing;
}

/// AI Copilot query processor interface
abstract class ICopilotService {
  /// Process a natural language query and return matching properties
  Future<CopilotResponse> processQuery(String query);

  /// Get autocomplete suggestions for a partial query
  List<String> getSuggestions(String partialQuery);

  /// Stream response for real-time feedback
  Stream<CopilotResponse> streamResponse(String query);

  /// Get contextual suggestions based on current selection
  List<String> getContextualSuggestions({
    List<String>? selectedPropertyIds,
    String? currentCounty,
  });
}

/// Clustering service for grouping nearby properties
abstract class IClusteringService {
  /// Cluster properties based on their positions
  /// Returns a map of cluster ID to property IDs
  Map<String, List<String>> clusterProperties(
    List<SpatialPosition> positions,
    double minDistance,
  );

  /// Get the center position for a cluster
  SpatialPosition getClusterCenter(List<SpatialPosition> positions);

  /// Determine if clustering should be applied at current zoom level
  bool shouldCluster(double zoomLevel, int propertyCount);
}

/// X-Ray insight generator interface
abstract class IInsightGenerator {
  /// Generate all applicable insights for a property
  List<XRayInsight> generateInsights(TaxLien property);

  /// Generate insights for a selection of properties
  List<XRayInsight> generateSelectionInsights(List<TaxLien> properties);

  /// Get the most important insight for a property (for badge display)
  XRayInsight? getPrimaryInsight(TaxLien property);
}

/// Placeholder for XRayInsight since it's defined in models
/// Import from models in actual implementation
typedef XRayInsight = dynamic;

/// Galaxy viewport controller interface
abstract class IGalaxyController {
  /// Current zoom level (1.0 = default, 2.0 = 2x zoom)
  double get zoomLevel;

  /// Current pan offset
  Offset get panOffset;

  /// Current dimension being displayed
  GalaxyDimension get currentDimension;

  /// Animate to a specific zoom level
  Future<void> animateZoomTo(double zoom, {Duration? duration});

  /// Animate to center on a specific property
  Future<void> animateToCenterOn(String propertyId, {Duration? duration});

  /// Animate to fit all properties in view
  Future<void> animateToFitAll({Duration? duration});

  /// Change dimension with animation
  Future<void> changeDimension(GalaxyDimension dimension, {Duration? duration});

  /// Reset view to default state
  void resetView();
}

/// Property selection state interface
abstract class ISelectionState {
  /// Currently selected property IDs
  Set<String> get selectedIds;

  /// Whether any properties are selected
  bool get hasSelection;

  /// Number of selected properties
  int get selectionCount;

  /// Add property to selection
  void select(String propertyId);

  /// Remove property from selection
  void deselect(String propertyId);

  /// Toggle property selection
  void toggle(String propertyId);

  /// Select multiple properties
  void selectAll(Iterable<String> propertyIds);

  /// Clear all selections
  void clearSelection();

  /// Check if a property is selected
  bool isSelected(String propertyId);
}
