import 'dart:math';
import 'package:flutter/gestures.dart';
import '../providers/gesture_settings.dart';

/// Phase of a lasso gesture.
enum LassoPhase {
  /// Gesture just started.
  start,

  /// Gesture is in progress, points being added.
  update,

  /// Gesture completed normally.
  end,

  /// Gesture was cancelled.
  cancel,
}

/// Details about a lasso gesture.
class LassoDetails {
  /// All points in the lasso path.
  final List<Offset> points;

  /// Bounding rectangle of the lasso.
  final Rect bounds;

  /// Current phase of the gesture.
  final LassoPhase phase;

  const LassoDetails({
    required this.points,
    required this.bounds,
    required this.phase,
  });

  /// Check if a point is inside the lasso polygon.
  ///
  /// Uses ray casting algorithm for point-in-polygon test.
  bool containsPoint(Offset point) {
    if (points.length < 3) return false;

    var inside = false;
    var j = points.length - 1;

    for (var i = 0; i < points.length; i++) {
      final xi = points[i].dx;
      final yi = points[i].dy;
      final xj = points[j].dx;
      final yj = points[j].dy;

      if (((yi > point.dy) != (yj > point.dy)) &&
          (point.dx < (xj - xi) * (point.dy - yi) / (yj - yi) + xi)) {
        inside = !inside;
      }
      j = i;
    }

    return inside;
  }

  /// Check if a rectangle intersects with the lasso.
  bool intersectsRect(Rect rect) {
    // Quick bounds check first
    if (!bounds.overlaps(rect)) return false;

    // Check if any corner is inside
    final corners = [
      rect.topLeft,
      rect.topRight,
      rect.bottomLeft,
      rect.bottomRight,
    ];

    for (final corner in corners) {
      if (containsPoint(corner)) return true;
    }

    // Check if lasso center is inside rect
    final center = Offset(
      points.map((p) => p.dx).reduce((a, b) => a + b) / points.length,
      points.map((p) => p.dy).reduce((a, b) => a + b) / points.length,
    );
    if (rect.contains(center)) return true;

    return false;
  }
}

/// Callback for lasso gesture events.
typedef LassoCallback = void Function(LassoDetails details);

/// Recognizes lasso (free-form selection) gestures.
///
/// Tracks a continuous path drawn by the user and provides
/// point-in-polygon testing for selection.
///
/// Example:
/// ```dart
/// RawGestureDetector(
///   gestures: {
///     LassoRecognizer: GestureRecognizerFactoryWithHandlers<LassoRecognizer>(
///       () => LassoRecognizer(),
///       (recognizer) {
///         recognizer.onLassoUpdate = (details) {
///           setState(() => _lassoPath = details.points);
///         };
///         recognizer.onLassoEnd = (details) {
///           final selected = items.where(
///             (item) => details.containsPoint(item.position),
///           ).toList();
///         };
///       },
///     ),
///   },
///   child: MyCanvas(),
/// )
/// ```
class LassoRecognizer extends OneSequenceGestureRecognizer {
  /// Called when lasso gesture starts.
  LassoCallback? onLassoStart;

  /// Called as lasso path is drawn.
  LassoCallback? onLassoUpdate;

  /// Called when lasso gesture completes.
  LassoCallback? onLassoEnd;

  /// Called when lasso gesture is cancelled.
  LassoCallback? onLassoCancel;

  /// Minimum distance between sampled points.
  final double minPointDistance;

  /// Maximum points before path simplification.
  final int simplifyThreshold;

  LassoRecognizer({
    this.onLassoStart,
    this.onLassoUpdate,
    this.onLassoEnd,
    this.onLassoCancel,
    this.minPointDistance = GestureSettings.lassoPointDistance,
    this.simplifyThreshold = GestureSettings.lassoSimplifyThreshold,
  });

  final List<Offset> _points = [];
  bool _isActive = false;

  @override
  void addPointer(PointerDownEvent event) {
    _points.clear();
    _points.add(event.localPosition);
    _isActive = true;
    startTrackingPointer(event.pointer, transform: event.transform);

    onLassoStart?.call(_createDetails(LassoPhase.start));
  }

  @override
  void handleEvent(PointerEvent event) {
    if (!_isActive) return;

    if (event is PointerMoveEvent) {
      final lastPoint = _points.last;
      final newPoint = event.localPosition;

      // Only add point if moved enough (reduce density)
      if ((newPoint - lastPoint).distance >= minPointDistance) {
        _points.add(newPoint);

        // Simplify if too many points
        if (_points.length > simplifyThreshold) {
          _simplifyPath();
        }

        onLassoUpdate?.call(_createDetails(LassoPhase.update));
      }
    } else if (event is PointerUpEvent) {
      _closePath();
      onLassoEnd?.call(_createDetails(LassoPhase.end));
      resolve(GestureDisposition.accepted);
      _isActive = false;
    } else if (event is PointerCancelEvent) {
      onLassoCancel?.call(_createDetails(LassoPhase.cancel));
      resolve(GestureDisposition.rejected);
      _isActive = false;
      _points.clear();
    }
  }

  void _closePath() {
    if (_points.length > 2) {
      // Close the loop by adding first point at end
      _points.add(_points.first);
    }
  }

  void _simplifyPath() {
    // Simple approach: keep every other point
    // Could use Ramer-Douglas-Peucker for better results
    final simplified = <Offset>[];
    for (var i = 0; i < _points.length; i += 2) {
      simplified.add(_points[i]);
    }
    // Always keep the last point
    if (_points.isNotEmpty && simplified.last != _points.last) {
      simplified.add(_points.last);
    }
    _points.clear();
    _points.addAll(simplified);
  }

  LassoDetails _createDetails(LassoPhase phase) {
    return LassoDetails(
      points: List.unmodifiable(_points),
      bounds: _calculateBounds(),
      phase: phase,
    );
  }

  Rect _calculateBounds() {
    if (_points.isEmpty) return Rect.zero;

    var minX = double.infinity;
    var minY = double.infinity;
    var maxX = double.negativeInfinity;
    var maxY = double.negativeInfinity;

    for (final point in _points) {
      minX = min(minX, point.dx);
      minY = min(minY, point.dy);
      maxX = max(maxX, point.dx);
      maxY = max(maxY, point.dy);
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _points.clear();
    _isActive = false;
  }

  @override
  String get debugDescription => 'lasso';
}
