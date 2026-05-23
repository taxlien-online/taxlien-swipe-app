import 'dart:ui';

/// Represents a lasso selection path drawn by the user
class LassoSelection {
  final List<Offset> points;
  final bool isClockwise;
  final DateTime startTime;

  const LassoSelection({
    required this.points,
    required this.isClockwise,
    required this.startTime,
  });

  /// Create a new lasso with a starting point
  factory LassoSelection.start(Offset point) {
    return LassoSelection(
      points: [point],
      isClockwise: true,
      startTime: DateTime.now(),
    );
  }

  /// Add a point to the lasso path
  LassoSelection addPoint(Offset point) {
    final newPoints = [...points, point];
    return LassoSelection(
      points: newPoints,
      isClockwise: isClockwiseDirection(newPoints),
      startTime: startTime,
    );
  }

  /// Close the lasso (add starting point to end)
  LassoSelection close() {
    if (points.length < 3) return this;
    if (points.first == points.last) return this;
    return LassoSelection(
      points: [...points, points.first],
      isClockwise: isClockwise,
      startTime: startTime,
    );
  }

  /// Check if point is inside lasso polygon using ray casting
  bool containsPoint(Offset point) {
    if (points.length < 3) return false;

    int intersections = 0;
    for (int i = 0; i < points.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];

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

  /// Check if the lasso area is large enough to be valid
  bool get isValid {
    if (points.length < 3) return false;
    final area = calculateArea();
    return area > 100; // Minimum 100 square pixels
  }

  /// Calculate the area of the lasso polygon
  double calculateArea() {
    if (points.length < 3) return 0;

    double area = 0;
    for (int i = 0; i < points.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];
      area += (p1.dx * p2.dy) - (p2.dx * p1.dy);
    }
    return (area / 2).abs();
  }

  /// Get the bounding box of the lasso
  Rect get boundingBox {
    if (points.isEmpty) return Rect.zero;

    double minX = points.first.dx;
    double maxX = points.first.dx;
    double minY = points.first.dy;
    double maxY = points.first.dy;

    for (final point in points) {
      if (point.dx < minX) minX = point.dx;
      if (point.dx > maxX) maxX = point.dx;
      if (point.dy < minY) minY = point.dy;
      if (point.dy > maxY) maxY = point.dy;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
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

  /// Duration since lasso started
  Duration get duration => DateTime.now().difference(startTime);

  /// Simplify the path by removing points that are too close together
  LassoSelection simplify(double tolerance) {
    if (points.length < 3) return this;

    final simplified = <Offset>[points.first];
    for (int i = 1; i < points.length - 1; i++) {
      final distance = (points[i] - simplified.last).distance;
      if (distance >= tolerance) {
        simplified.add(points[i]);
      }
    }
    simplified.add(points.last);

    return LassoSelection(
      points: simplified,
      isClockwise: isClockwise,
      startTime: startTime,
    );
  }

  @override
  String toString() =>
      'LassoSelection(${points.length} points, clockwise: $isClockwise)';
}

/// Mode for how lasso selection interacts with existing selection
enum LassoMode {
  /// Replace existing selection
  replace,

  /// Add to existing selection (clockwise)
  add,

  /// Remove from existing selection (counter-clockwise)
  subtract,

  /// Toggle selection (select unselected, deselect selected)
  toggle,
}
