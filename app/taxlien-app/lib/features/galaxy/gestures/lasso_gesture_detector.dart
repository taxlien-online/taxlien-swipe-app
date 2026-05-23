import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/models/spatial_position.dart';
import '../../../core/design/app_spacing.dart';

/// Custom gesture detector for lasso selection
/// Activated by long press, then drag to draw lasso path
class LassoGestureDetector extends StatefulWidget {
  final Widget child;
  final List<SpatialPosition> positions;
  final void Function(Offset point)? onLassoStart;
  final void Function(Offset point)? onLassoUpdate;
  final void Function(List<String> selectedIds, bool isClockwise)? onLassoComplete;
  final VoidCallback? onLassoCancel;
  final bool enabled;

  const LassoGestureDetector({
    super.key,
    required this.child,
    required this.positions,
    this.onLassoStart,
    this.onLassoUpdate,
    this.onLassoComplete,
    this.onLassoCancel,
    this.enabled = true,
  });

  @override
  State<LassoGestureDetector> createState() => _LassoGestureDetectorState();
}

class _LassoGestureDetectorState extends State<LassoGestureDetector> {
  bool _isDrawing = false;
  final List<Offset> _lassoPoints = [];
  Offset? _lastPoint;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return GestureDetector(
      onLongPressStart: _handleLongPressStart,
      onLongPressMoveUpdate: _handleLongPressMoveUpdate,
      onLongPressEnd: _handleLongPressEnd,
      onLongPressCancel: _handleCancel,
      child: widget.child,
    );
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    _isDrawing = true;
    _lassoPoints.clear();
    _lassoPoints.add(details.localPosition);
    _lastPoint = details.localPosition;

    HapticFeedback.mediumImpact();
    widget.onLassoStart?.call(details.localPosition);
  }

  void _handleLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (!_isDrawing) return;

    final point = details.localPosition;

    // Only add point if moved enough (reduce noise)
    if (_lastPoint != null) {
      final distance = (point - _lastPoint!).distance;
      if (distance < AppSpacing.galaxyLassoTolerance) return;
    }

    _lassoPoints.add(point);
    _lastPoint = point;

    widget.onLassoUpdate?.call(point);
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    if (!_isDrawing) return;
    _isDrawing = false;

    if (_lassoPoints.length < 3) {
      _handleCancel();
      return;
    }

    // Close the lasso
    _lassoPoints.add(_lassoPoints.first);

    // Determine direction
    final isClockwise = _isClockwiseDirection(_lassoPoints);

    // Find selected properties
    final selectedIds = _findEnclosedProperties();

    HapticFeedback.lightImpact();
    widget.onLassoComplete?.call(selectedIds, isClockwise);

    _lassoPoints.clear();
    _lastPoint = null;
  }

  void _handleCancel() {
    _isDrawing = false;
    _lassoPoints.clear();
    _lastPoint = null;
    widget.onLassoCancel?.call();
  }

  bool _isClockwiseDirection(List<Offset> points) {
    if (points.length < 3) return true;
    double sum = 0;
    for (int i = 0; i < points.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];
      sum += (p2.dx - p1.dx) * (p2.dy + p1.dy);
    }
    return sum > 0;
  }

  List<String> _findEnclosedProperties() {
    final selected = <String>[];

    for (final pos in widget.positions) {
      // We need canvas size to convert, but since lasso points are in local coordinates
      // and we're comparing against the same coordinate system, we can use a simple approach
      // In practice, this would need the actual canvas size
      if (_isPointInPolygon(Offset(pos.x * 400, pos.y * 800), _lassoPoints)) {
        selected.add(pos.propertyId);
      }
    }

    return selected;
  }

  bool _isPointInPolygon(Offset point, List<Offset> polygon) {
    if (polygon.length < 3) return false;

    int intersections = 0;
    for (int i = 0; i < polygon.length; i++) {
      final p1 = polygon[i];
      final p2 = polygon[(i + 1) % polygon.length];

      if ((p1.dy <= point.dy && p2.dy > point.dy) ||
          (p2.dy <= point.dy && p1.dy > point.dy)) {
        final xIntersect =
            (point.dy - p1.dy) / (p2.dy - p1.dy) * (p2.dx - p1.dx) + p1.dx;
        if (point.dx < xIntersect) {
          intersections++;
        }
      }
    }
    return intersections.isOdd;
  }
}

/// Mixin to add lasso selection capability to a widget
mixin LassoSelectionMixin<T extends StatefulWidget> on State<T> {
  final List<Offset> lassoPoints = [];
  bool isDrawingLasso = false;

  void startLasso(Offset point) {
    setState(() {
      isDrawingLasso = true;
      lassoPoints.clear();
      lassoPoints.add(point);
    });
  }

  void updateLasso(Offset point) {
    if (!isDrawingLasso) return;
    setState(() {
      lassoPoints.add(point);
    });
  }

  void completeLasso() {
    if (!isDrawingLasso || lassoPoints.length < 3) {
      cancelLasso();
      return;
    }

    setState(() {
      isDrawingLasso = false;
      // Close the polygon
      if (lassoPoints.first != lassoPoints.last) {
        lassoPoints.add(lassoPoints.first);
      }
    });

    onLassoComplete(lassoPoints);
    lassoPoints.clear();
  }

  void cancelLasso() {
    setState(() {
      isDrawingLasso = false;
      lassoPoints.clear();
    });
  }

  /// Override to handle lasso completion
  void onLassoComplete(List<Offset> polygon);
}
