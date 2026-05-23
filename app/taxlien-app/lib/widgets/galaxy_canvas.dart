import 'package:flutter/material.dart';
import '../design/design.dart';
import 'galaxy_dot.dart';

/// A canvas for displaying galaxy-style property visualizations.
///
/// Supports a dot grid background, positioned property dots,
/// and lasso selection gestures.
class GalaxyCanvas extends StatefulWidget {
  const GalaxyCanvas({
    super.key,
    required this.dots,
    this.showGrid = true,
    this.onDotTap,
    this.onLassoComplete,
    this.onDotsSelected,
  });

  /// The dots to display on the canvas.
  final List<GalaxyDotData> dots;

  /// Whether to show the grid background pattern.
  final bool showGrid;

  /// Callback when a dot is tapped (provides dot index).
  final void Function(int index)? onDotTap;

  /// Callback when lasso selection completes (provides indices).
  final void Function(List<int> indices)? onLassoComplete;

  /// Callback when dots are selected via any mechanism.
  final void Function(List<String> ids)? onDotsSelected;

  @override
  State<GalaxyCanvas> createState() => _GalaxyCanvasState();
}

class _GalaxyCanvasState extends State<GalaxyCanvas> {
  final List<Offset> _lassoPoints = [];
  bool _isLassoing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppRadius.lg,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColors.surfaceDark2,
                  AppColors.surfaceDark,
                ]
              : [
                  const Color(0xFFF1F4F8),
                  const Color(0xFFF8F9FA),
                ],
        ),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.lg,
        child: GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: CustomPaint(
            painter: _GalaxyCanvasPainter(
              showGrid: widget.showGrid,
              isDark: isDark,
              lassoPoints: _lassoPoints,
            ),
            child: Stack(
              children: [
                for (var i = 0; i < widget.dots.length; i++)
                  _buildPositionedDot(i, widget.dots[i]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPositionedDot(int index, GalaxyDotData data) {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      bottom: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final x = constraints.maxWidth * (data.x / 100);
          final y = constraints.maxHeight * (data.y / 100);

          return Stack(
            children: [
              Positioned(
                left: x - data.size / 2,
                top: y - data.size / 2,
                child: GalaxyDot(
                  x: data.x,
                  y: data.y,
                  size: data.size,
                  color: data.color,
                  state: data.state,
                  onTap: widget.onDotTap != null
                      ? () => widget.onDotTap!(index)
                      : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isLassoing = true;
      _lassoPoints.clear();
      _lassoPoints.add(details.localPosition);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isLassoing) {
      setState(() {
        _lassoPoints.add(details.localPosition);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isLassoing && _lassoPoints.length > 2) {
      _completeLasso();
    }
    setState(() {
      _isLassoing = false;
      _lassoPoints.clear();
    });
  }

  void _completeLasso() {
    if (widget.onLassoComplete == null && widget.onDotsSelected == null) return;

    final selectedIndices = <int>[];
    final selectedIds = <String>[];

    for (var i = 0; i < widget.dots.length; i++) {
      final dot = widget.dots[i];
      // Convert dot percentage to approximate pixel position for containment check
      // This is a simplified check - real implementation would need canvas size
      if (_isPointInLasso(Offset(dot.x, dot.y))) {
        selectedIndices.add(i);
        if (dot.propertyId != null) {
          selectedIds.add(dot.propertyId!);
        }
      }
    }

    widget.onLassoComplete?.call(selectedIndices);
    widget.onDotsSelected?.call(selectedIds);
  }

  bool _isPointInLasso(Offset point) {
    if (_lassoPoints.length < 3) return false;

    // Simplified point-in-polygon test
    var inside = false;
    var j = _lassoPoints.length - 1;

    for (var i = 0; i < _lassoPoints.length; i++) {
      final xi = _lassoPoints[i].dx;
      final yi = _lassoPoints[i].dy;
      final xj = _lassoPoints[j].dx;
      final yj = _lassoPoints[j].dy;

      if (((yi > point.dy) != (yj > point.dy)) &&
          (point.dx < (xj - xi) * (point.dy - yi) / (yj - yi) + xi)) {
        inside = !inside;
      }
      j = i;
    }

    return inside;
  }
}

class _GalaxyCanvasPainter extends CustomPainter {
  _GalaxyCanvasPainter({
    required this.showGrid,
    required this.isDark,
    required this.lassoPoints,
  });

  final bool showGrid;
  final bool isDark;
  final List<Offset> lassoPoints;

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    if (lassoPoints.length > 1) {
      _drawLasso(canvas);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? AppColors.fg2Dark : AppColors.fg2).withOpacity(0.15)
      ..strokeWidth = 1;

    const spacing = 24.0;

    // Draw dot grid pattern
    for (var x = spacing; x < size.width; x += spacing) {
      for (var y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  void _drawLasso(Canvas canvas) {
    if (lassoPoints.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.brandBlue.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = AppColors.brandBlue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path()..moveTo(lassoPoints.first.dx, lassoPoints.first.dy);

    for (var i = 1; i < lassoPoints.length; i++) {
      path.lineTo(lassoPoints[i].dx, lassoPoints[i].dy);
    }

    // Close the path if we have enough points
    if (lassoPoints.length > 2) {
      path.close();
      canvas.drawPath(path, fillPaint);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GalaxyCanvasPainter oldDelegate) {
    return oldDelegate.showGrid != showGrid ||
        oldDelegate.isDark != isDark ||
        oldDelegate.lassoPoints.length != lassoPoints.length;
  }
}
