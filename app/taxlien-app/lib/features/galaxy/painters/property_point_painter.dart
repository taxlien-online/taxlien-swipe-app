import 'package:flutter/material.dart';
import '../../../core/models/spatial_position.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_typography.dart';

/// High-performance CustomPainter for rendering property points
class PropertyPointPainter extends CustomPainter {
  final List<SpatialPosition> positions;
  final Set<String> selectedIds;
  final Set<String> highlightedIds;
  final double zoomLevel;
  final bool showLabels;
  final Map<String, int>? clusterCounts; // propertyId -> count for clusters

  PropertyPointPainter({
    required this.positions,
    this.selectedIds = const {},
    this.highlightedIds = const {},
    this.zoomLevel = 1.0,
    this.showLabels = false,
    this.clusterCounts,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (positions.isEmpty) return;

    // Paint in layers: regular points, then selected, then highlighted
    final regularPositions = <SpatialPosition>[];
    final selectedPositions = <SpatialPosition>[];
    final highlightedPositions = <SpatialPosition>[];

    for (final pos in positions) {
      if (highlightedIds.contains(pos.propertyId)) {
        highlightedPositions.add(pos);
      } else if (selectedIds.contains(pos.propertyId)) {
        selectedPositions.add(pos);
      } else {
        regularPositions.add(pos);
      }
    }

    // Draw regular points
    for (final pos in regularPositions) {
      _drawPoint(canvas, size, pos, PointState.normal);
    }

    // Draw selected points
    for (final pos in selectedPositions) {
      _drawPoint(canvas, size, pos, PointState.selected);
    }

    // Draw highlighted points (from AI query results)
    for (final pos in highlightedPositions) {
      _drawPoint(canvas, size, pos, PointState.highlighted);
    }
  }

  void _drawPoint(Canvas canvas, Size size, SpatialPosition pos, PointState state) {
    final offset = pos.toOffset(size);
    final radius = pos.radius * (zoomLevel > 2 ? 1.0 : 0.8 + zoomLevel * 0.1);
    final clusterCount = clusterCounts?[pos.propertyId];
    final isCluster = clusterCount != null && clusterCount > 1;

    // Determine colors based on state
    Color fillColor = pos.color.withOpacity(pos.opacity);
    Color strokeColor = Colors.white;
    double strokeWidth = 1.5;

    switch (state) {
      case PointState.selected:
        strokeColor = AppColors.selected;
        strokeWidth = 3.0;
        break;
      case PointState.highlighted:
        fillColor = pos.color;
        strokeColor = AppColors.brandCyan;
        strokeWidth = 2.5;
        break;
      case PointState.normal:
        break;
    }

    // Draw shadow for larger points
    if (radius > 16) {
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(offset + const Offset(0, 2), radius, shadowPaint);
    }

    // Draw fill
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(offset, radius, fillPaint);

    // Draw stroke
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(offset, radius, strokePaint);

    // Draw cluster count badge
    if (isCluster) {
      _drawClusterBadge(canvas, offset, radius, clusterCount);
    }

    // Draw selection ring animation placeholder
    if (state == PointState.selected) {
      _drawSelectionRing(canvas, offset, radius);
    }
  }

  void _drawClusterBadge(Canvas canvas, Offset center, double radius, int count) {
    final badgeRadius = radius * 0.4;
    final badgeCenter = center + Offset(radius * 0.6, -radius * 0.6);

    // Badge background
    final badgePaint = Paint()
      ..color = AppColors.brandBlue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(badgeCenter, badgeRadius, badgePaint);

    // Badge border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(badgeCenter, badgeRadius, borderPaint);

    // Badge text
    final textSpan = TextSpan(
      text: count > 99 ? '99+' : count.toString(),
      style: AppTypography.clusterCount.copyWith(
        fontSize: badgeRadius * 0.9,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      badgeCenter - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  void _drawSelectionRing(Canvas canvas, Offset center, double radius) {
    final ringPaint = Paint()
      ..color = AppColors.selected.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius + 4, ringPaint);
  }

  @override
  bool shouldRepaint(PropertyPointPainter oldDelegate) {
    return positions != oldDelegate.positions ||
        selectedIds != oldDelegate.selectedIds ||
        highlightedIds != oldDelegate.highlightedIds ||
        zoomLevel != oldDelegate.zoomLevel ||
        showLabels != oldDelegate.showLabels;
  }

  @override
  bool? hitTest(Offset position) {
    // Enable hit testing for the entire canvas
    return true;
  }
}

enum PointState {
  normal,
  selected,
  highlighted,
}

/// Painter for the lasso selection path
class LassoPainter extends CustomPainter {
  final List<Offset> points;
  final bool isClosing;
  final bool isClockwise;

  LassoPainter({
    required this.points,
    this.isClosing = false,
    this.isClockwise = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    if (isClosing || points.length > 3) {
      path.close();

      // Fill
      final fillPaint = Paint()
        ..color = isClockwise
            ? AppColors.lassoFill
            : AppColors.danger.withOpacity(0.1)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }

    // Stroke
    final strokePaint = Paint()
      ..color = isClockwise ? AppColors.lassoStroke : AppColors.danger
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);

    // Draw dots at vertices
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = isClockwise ? AppColors.lassoStroke : AppColors.danger
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Start dot (larger)
    canvas.drawCircle(points.first, 6, dotPaint);
    canvas.drawCircle(points.first, 6, dotBorderPaint);

    // End dot
    if (points.length > 1) {
      canvas.drawCircle(points.last, 4, dotPaint);
      canvas.drawCircle(points.last, 4, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(LassoPainter oldDelegate) {
    return points != oldDelegate.points ||
        isClosing != oldDelegate.isClosing ||
        isClockwise != oldDelegate.isClockwise;
  }
}

/// Painter for dimension axis labels and grid
class AxisPainter extends CustomPainter {
  final String xLabel;
  final String yLabel;
  final bool showGrid;

  AxisPainter({
    required this.xLabel,
    required this.yLabel,
    this.showGrid = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final labelStyle = AppTypography.caption.copyWith(
      color: AppColors.fg3,
    );

    // X-axis label (bottom center)
    if (xLabel.isNotEmpty) {
      final xTextSpan = TextSpan(text: xLabel, style: labelStyle);
      final xTextPainter = TextPainter(
        text: xTextSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      xTextPainter.paint(
        canvas,
        Offset(
          (size.width - xTextPainter.width) / 2,
          size.height - xTextPainter.height - 8,
        ),
      );
    }

    // Y-axis label (left center, rotated)
    if (yLabel.isNotEmpty) {
      final yTextSpan = TextSpan(text: yLabel, style: labelStyle);
      final yTextPainter = TextPainter(
        text: yTextSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(16, (size.height + yTextPainter.width) / 2);
      canvas.rotate(-1.5708); // -90 degrees
      yTextPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    // Grid lines (optional)
    if (showGrid) {
      final gridPaint = Paint()
        ..color = AppColors.line
        ..strokeWidth = 0.5;

      // Vertical lines
      for (int i = 1; i < 4; i++) {
        final x = size.width * i / 4;
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      }

      // Horizontal lines
      for (int i = 1; i < 4; i++) {
        final y = size.height * i / 4;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }
  }

  @override
  bool shouldRepaint(AxisPainter oldDelegate) {
    return xLabel != oldDelegate.xLabel ||
        yLabel != oldDelegate.yLabel ||
        showGrid != oldDelegate.showGrid;
  }
}
