import 'package:flutter/material.dart';
import '../../../../core/models/marker.dart';

class AnnotationCanvas extends StatefulWidget {
  final List<AnnotationMarker> markers;
  final Function(AnnotationMarker) onAddMarker;
  final Size imageSize; // Size of the image being annotated

  const AnnotationCanvas({
    super.key,
    required this.markers,
    required this.onAddMarker,
    required this.imageSize,
  });

  @override
State<AnnotationCanvas> createState() => _AnnotationCanvasState();
}

class _AnnotationCanvasState extends State<AnnotationCanvas> {
  // Current drawing state (e.g., for drawing a line or box)
  Offset? _startPoint;
  Offset? _currentPoint;
  MarkerType _currentMarkerType = MarkerType.point; // Default to point

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        // For point marker, create immediately
        if (_currentMarkerType == MarkerType.point) {
          final newMarker = AnnotationMarker(
            id: DateTime.now().toIso8601String(),
            position: details.localPosition,
            authorId: 'current_user_id', // Replace with actual user ID
            type: MarkerType.point,
            createdAt: DateTime.now(),
          );
          widget.onAddMarker(newMarker);
        } else {
          _startPoint = details.localPosition;
        }
      },
      onPanUpdate: (details) {
        if (_currentMarkerType == MarkerType.line || _currentMarkerType == MarkerType.box) {
          setState(() {
            _currentPoint = details.localPosition;
          });
        }
      },
      onPanEnd: (details) {
        if (_startPoint != null && _currentPoint != null) {
          final newMarker = AnnotationMarker(
            id: DateTime.now().toIso8601String(),
            position: _startPoint!,
            authorId: 'current_user_id', // Replace with actual user ID
            type: _currentMarkerType,
            createdAt: DateTime.now(),
            // For line/box, need to store end point or size
            // This is a simplified example, full implementation would store more data
          );
          widget.onAddMarker(newMarker);
        }
        _startPoint = null;
        _currentPoint = null;
      },
      onLongPressStart: (details) {
        // Show radial menu
        _showRadialMenu(details.localPosition);
      },
      child: CustomPaint(
        painter: _AnnotationPainter(
          markers: widget.markers,
          currentStartPoint: _startPoint,
          currentEndPoint: _currentPoint,
          currentMarkerType: _currentMarkerType,
        ),
        size: Size.infinite,
      ),
    );
  }

  void _showRadialMenu(Offset tapPosition) {
    // This is a placeholder for a radial menu.
    // A real implementation would use a package or custom painter
    // to show a circular menu around the tapPosition.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Annotation Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.circle),
                title: const Text('Point'),
                onTap: () {
                  setState(() => _currentMarkerType = MarkerType.point);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.show_chart),
                title: const Text('Line'),
                onTap: () {
                  setState(() => _currentMarkerType = MarkerType.line);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.square_foot),
                title: const Text('Box'),
                onTap: () {
                  setState(() => _currentMarkerType = MarkerType.box);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.comment),
                title: const Text('Add Comment'),
                onTap: () {
                  // Show text input for comment
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnnotationPainter extends CustomPainter {
  final List<AnnotationMarker> markers;
  final Offset? currentStartPoint;
  final Offset? currentEndPoint;
  final MarkerType currentMarkerType;

  _AnnotationPainter({
    required this.markers,
    this.currentStartPoint,
    this.currentEndPoint,
    required this.currentMarkerType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pointPaint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    final boxPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Draw existing markers
    for (var marker in markers) {
      switch (marker.type) {
        case MarkerType.point:
          canvas.drawPoints(PointMode.points, [marker.position], pointPaint);
          break;
        case MarkerType.line:
          // Need start/end points stored in marker
          // canvas.drawLine(marker.start, marker.end, linePaint);
          break;
        case MarkerType.box:
          // Need rect stored in marker
          // canvas.drawRect(marker.rect, boxPaint);
          break;
      }
    }

    // Draw current drawing action
    if (currentStartPoint != null && currentEndPoint != null) {
      switch (currentMarkerType) {
        case MarkerType.point:
          // Point is drawn on tapDown, not drag
          break;
        case MarkerType.line:
          canvas.drawLine(currentStartPoint!, currentEndPoint!, linePaint);
          break;
        case MarkerType.box:
          canvas.drawRect(
            Rect.fromPoints(currentStartPoint!, currentEndPoint!),
            boxPaint,
          );
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for simplicity in this example
  }
}
