import 'package:flutter/material.dart';

/// Position of a property in the galaxy visualization
/// Coordinates are normalized 0.0-1.0 for dimension-independent layout
class SpatialPosition {
  final String propertyId;
  final double x; // Normalized 0.0-1.0
  final double y; // Normalized 0.0-1.0
  final double radius; // 8.0 - 48.0 based on value
  final Color color; // Based on current dimension
  final double opacity; // 0.0-1.0 for filtering/highlight

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
  }) =>
      SpatialPosition(
        propertyId: propertyId ?? this.propertyId,
        x: x ?? this.x,
        y: y ?? this.y,
        radius: radius ?? this.radius,
        color: color ?? this.color,
        opacity: opacity ?? this.opacity,
      );

  /// Convert normalized coordinates to canvas offset
  Offset toOffset(Size canvasSize) => Offset(
        x * canvasSize.width,
        y * canvasSize.height,
      );

  /// Create from canvas offset (inverse of toOffset)
  static SpatialPosition fromOffset(
    Offset offset,
    Size canvasSize,
    String propertyId, {
    double radius = 16.0,
    Color color = Colors.blue,
  }) {
    return SpatialPosition(
      propertyId: propertyId,
      x: (offset.dx / canvasSize.width).clamp(0.0, 1.0),
      y: (offset.dy / canvasSize.height).clamp(0.0, 1.0),
      radius: radius,
      color: color,
    );
  }

  /// Check if a point (in normalized coordinates) is within this position's radius
  bool containsPoint(Offset point, Size canvasSize) {
    final center = toOffset(canvasSize);
    final distance = (point - center).distance;
    return distance <= radius;
  }

  /// Distance to another position in normalized space
  double distanceTo(SpatialPosition other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return (dx * dx + dy * dy).sqrt();
  }

  /// Interpolate between two positions for animation
  static SpatialPosition lerp(
    SpatialPosition a,
    SpatialPosition b,
    double t,
  ) {
    return SpatialPosition(
      propertyId: a.propertyId,
      x: a.x + (b.x - a.x) * t,
      y: a.y + (b.y - a.y) * t,
      radius: a.radius + (b.radius - a.radius) * t,
      color: Color.lerp(a.color, b.color, t) ?? a.color,
      opacity: a.opacity + (b.opacity - a.opacity) * t,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpatialPosition &&
          runtimeType == other.runtimeType &&
          propertyId == other.propertyId &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => Object.hash(propertyId, x, y);

  @override
  String toString() =>
      'SpatialPosition($propertyId, x: ${x.toStringAsFixed(3)}, y: ${y.toStringAsFixed(3)})';
}

extension DoubleExtension on double {
  double sqrt() => this >= 0 ? this.toDouble().sqrt() : 0;
}

extension DoubleSqrt on double {
  double sqrt() {
    if (this < 0) return 0;
    return _sqrt(this);
  }
}

double _sqrt(double x) {
  if (x == 0) return 0;
  double guess = x / 2;
  for (int i = 0; i < 20; i++) {
    guess = (guess + x / guess) / 2;
  }
  return guess;
}
