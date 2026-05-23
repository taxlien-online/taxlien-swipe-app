import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/models/tax_lien_models.dart';
import '../../../core/models/spatial_position.dart';
import '../../../core/models/galaxy_dimension.dart';
import '../layouts/dimension_layout.dart';

/// State management for Galaxy visualization
class GalaxyProvider extends ChangeNotifier {
  // Properties data
  List<TaxLien> _properties = [];
  List<TaxLien> get properties => _properties;

  // Spatial positions (calculated from properties + dimension)
  List<SpatialPosition> _positions = [];
  List<SpatialPosition> get positions => _positions;

  // Previous positions for animation interpolation
  List<SpatialPosition> _previousPositions = [];
  List<SpatialPosition> get previousPositions => _previousPositions;

  // Current dimension
  GalaxyDimension _dimension = GalaxyDimension.roi;
  GalaxyDimension get dimension => _dimension;

  // Zoom and pan state
  double _zoomLevel = 1.0;
  double get zoomLevel => _zoomLevel;

  Offset _panOffset = Offset.zero;
  Offset get panOffset => _panOffset;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Animation state
  bool _isTransitioning = false;
  bool get isTransitioning => _isTransitioning;
  double _transitionProgress = 1.0;
  double get transitionProgress => _transitionProgress;

  // Layout calculator
  DimensionLayout? _currentLayout;

  // Property ID to position lookup for fast access
  final Map<String, SpatialPosition> _positionMap = {};

  /// Set properties and recalculate positions
  void setProperties(List<TaxLien> properties) {
    _properties = properties;
    _recalculatePositions();
    notifyListeners();
  }

  /// Add properties incrementally
  void addProperties(List<TaxLien> newProperties) {
    _properties = [..._properties, ...newProperties];
    _recalculatePositions();
    notifyListeners();
  }

  /// Update a single property
  void updateProperty(TaxLien property) {
    final index = _properties.indexWhere((p) => p.id == property.id);
    if (index >= 0) {
      _properties[index] = property;
      _recalculatePositions();
      notifyListeners();
    }
  }

  /// Change the current dimension with optional animation
  Future<void> setDimension(GalaxyDimension dimension, {bool animate = true}) async {
    if (_dimension == dimension) return;

    if (animate) {
      _previousPositions = List.from(_positions);
      _isTransitioning = true;
      _transitionProgress = 0.0;
      notifyListeners();
    }

    _dimension = dimension;
    _currentLayout = DimensionLayoutFactory.create(dimension);
    _recalculatePositions();

    if (!animate) {
      notifyListeners();
    }
  }

  /// Cycle to next dimension (for rotation gesture)
  Future<void> nextDimension({bool animate = true}) async {
    await setDimension(_dimension.next, animate: animate);
  }

  /// Cycle to previous dimension
  Future<void> previousDimension({bool animate = true}) async {
    await setDimension(_dimension.previous, animate: animate);
  }

  /// Update transition progress (called by animation controller)
  void updateTransitionProgress(double progress) {
    _transitionProgress = progress;
    if (progress >= 1.0) {
      _isTransitioning = false;
      _previousPositions = [];
    }
    notifyListeners();
  }

  /// Get interpolated positions for animation
  List<SpatialPosition> getInterpolatedPositions() {
    if (!_isTransitioning || _previousPositions.isEmpty) {
      return _positions;
    }

    return _positions.map((newPos) {
      final oldPos = _previousPositions.firstWhere(
        (p) => p.propertyId == newPos.propertyId,
        orElse: () => newPos,
      );
      return SpatialPosition.lerp(oldPos, newPos, _transitionProgress);
    }).toList();
  }

  /// Set zoom level
  void setZoomLevel(double zoom) {
    _zoomLevel = zoom.clamp(0.5, 5.0);
    notifyListeners();
  }

  /// Set pan offset
  void setPanOffset(Offset offset) {
    _panOffset = offset;
    notifyListeners();
  }

  /// Reset view to default
  void resetView() {
    _zoomLevel = 1.0;
    _panOffset = Offset.zero;
    notifyListeners();
  }

  /// Get position for a specific property
  SpatialPosition? getPositionForProperty(String propertyId) {
    return _positionMap[propertyId];
  }

  /// Get property at a screen position
  TaxLien? getPropertyAtPosition(Offset screenPosition, Size canvasSize) {
    for (final position in _positions) {
      if (position.containsPoint(screenPosition, canvasSize)) {
        return _properties.firstWhere(
          (p) => p.id == position.propertyId,
          orElse: () => _properties.first,
        );
      }
    }
    return null;
  }

  /// Get properties within a region
  List<TaxLien> getPropertiesInRegion(Rect region, Size canvasSize) {
    final result = <TaxLien>[];
    for (final position in _positions) {
      final offset = position.toOffset(canvasSize);
      if (region.contains(offset)) {
        final property = _properties.firstWhere(
          (p) => p.id == position.propertyId,
          orElse: () => _properties.first,
        );
        result.add(property);
      }
    }
    return result;
  }

  /// Recalculate positions based on current dimension
  void _recalculatePositions() {
    if (_properties.isEmpty) {
      _positions = [];
      _positionMap.clear();
      return;
    }

    _currentLayout ??= DimensionLayoutFactory.create(_dimension);
    _positions = _currentLayout!.calculatePositions(_properties);

    // Build lookup map
    _positionMap.clear();
    for (final pos in _positions) {
      _positionMap[pos.propertyId] = pos;
    }
  }

  /// Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Filter properties (returns filtered list without modifying state)
  List<TaxLien> filterProperties({
    String? county,
    String? stage,
    double? minRoi,
    double? maxRoi,
    double? minRisk,
    double? maxRisk,
  }) {
    return _properties.where((p) {
      if (county != null && p.county != county) return false;
      if (stage != null && p.listingStage != stage) return false;
      if (minRoi != null && (p.expectedRoi ?? 0) < minRoi) return false;
      if (maxRoi != null && (p.expectedRoi ?? 1) > maxRoi) return false;
      if (minRisk != null && (p.riskScore ?? 0) < minRisk) return false;
      if (maxRisk != null && (p.riskScore ?? 100) > maxRisk) return false;
      return true;
    }).toList();
  }

  /// Highlight specific properties (update their opacity)
  void highlightProperties(Set<String> propertyIds) {
    _positions = _positions.map((pos) {
      final isHighlighted = propertyIds.isEmpty || propertyIds.contains(pos.propertyId);
      return pos.copyWith(opacity: isHighlighted ? 1.0 : 0.3);
    }).toList();
    notifyListeners();
  }

  /// Clear highlighting
  void clearHighlight() {
    _positions = _positions.map((pos) => pos.copyWith(opacity: 1.0)).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    _properties = [];
    _positions = [];
    _positionMap.clear();
    super.dispose();
  }
}
