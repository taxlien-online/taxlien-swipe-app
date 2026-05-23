import 'package:flutter/material.dart';
import '../../../core/models/marker.dart';

/// Canvas for expert annotations on property photos
///
/// Supports three annotation types:
/// - Point: Single tap to mark specific details
/// - Line: Drag to draw lines (cracks, measurements)
/// - Box: Drag to draw rectangles (furniture, cars, areas)
class AnnotationCanvas extends StatefulWidget {
  final List<AnnotationMarker> markers;
  final Function(AnnotationMarker) onAddMarker;
  final Size imageSize;
  final String authorId;

  const AnnotationCanvas({
    super.key,
    required this.markers,
    required this.onAddMarker,
    required this.imageSize,
    this.authorId = 'current_user',
  });

  @override
  State<AnnotationCanvas> createState() => _AnnotationCanvasState();
}

class _AnnotationCanvasState extends State<AnnotationCanvas> {
  Offset? _startPoint;
  Offset? _currentPoint;
  MarkerType _currentMarkerType = MarkerType.point;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onLongPressStart: (details) => _showMarkerTypeMenu(details.localPosition),
      child: CustomPaint(
        painter: _AnnotationPainter(
          markers: widget.markers,
          currentStartPoint: _startPoint,
          currentEndPoint: _currentPoint,
          currentMarkerType: _currentMarkerType,
          authorId: widget.authorId,
        ),
        size: Size.infinite,
      ),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    if (_currentMarkerType == MarkerType.point) {
      final marker = AnnotationMarker.point(
        id: _generateId(),
        position: details.localPosition,
        authorId: widget.authorId,
      );
      widget.onAddMarker(marker);
    }
  }

  void _handlePanStart(DragStartDetails details) {
    if (_currentMarkerType != MarkerType.point) {
      setState(() {
        _startPoint = details.localPosition;
        _currentPoint = details.localPosition;
      });
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_startPoint != null) {
      setState(() {
        _currentPoint = details.localPosition;
      });
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_startPoint != null && _currentPoint != null) {
      final marker = _createMarkerFromDrag();
      if (marker != null) {
        widget.onAddMarker(marker);
      }
    }
    setState(() {
      _startPoint = null;
      _currentPoint = null;
    });
  }

  AnnotationMarker? _createMarkerFromDrag() {
    if (_startPoint == null || _currentPoint == null) return null;

    final id = _generateId();

    switch (_currentMarkerType) {
      case MarkerType.line:
        return AnnotationMarker.line(
          id: id,
          start: _startPoint!,
          end: _currentPoint!,
          authorId: widget.authorId,
        );
      case MarkerType.box:
        return AnnotationMarker.box(
          id: id,
          rect: Rect.fromPoints(_startPoint!, _currentPoint!),
          authorId: widget.authorId,
        );
      case MarkerType.point:
        return null; // Points are created on tap, not drag
    }
  }

  String _generateId() {
    return '${widget.authorId}_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _showMarkerTypeMenu(Offset position) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MarkerTypeSelector(
        currentType: _currentMarkerType,
        onTypeSelected: (type) {
          setState(() => _currentMarkerType = type);
          Navigator.pop(context);
        },
        onCommentRequested: () {
          Navigator.pop(context);
          _showCommentDialog(position);
        },
      ),
    );
  }

  void _showCommentDialog(Offset position) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'What do you see?',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final marker = AnnotationMarker.point(
                  id: _generateId(),
                  position: position,
                  authorId: widget.authorId,
                  comment: controller.text,
                );
                widget.onAddMarker(marker);
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _MarkerTypeSelector extends StatelessWidget {
  final MarkerType currentType;
  final Function(MarkerType) onTypeSelected;
  final VoidCallback onCommentRequested;

  const _MarkerTypeSelector({
    required this.currentType,
    required this.onTypeSelected,
    required this.onCommentRequested,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Annotation Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          _buildOption(
            context,
            icon: Icons.location_on,
            label: 'Point',
            description: 'Mark a specific detail',
            type: MarkerType.point,
          ),
          _buildOption(
            context,
            icon: Icons.show_chart,
            label: 'Line',
            description: 'Draw a line (cracks, edges)',
            type: MarkerType.line,
          ),
          _buildOption(
            context,
            icon: Icons.crop_square,
            label: 'Box',
            description: 'Highlight an area',
            type: MarkerType.box,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.comment, color: Colors.orange),
            title: const Text('Add Comment'),
            subtitle: const Text('Mark with text note'),
            onTap: onCommentRequested,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required MarkerType type,
  }) {
    final isSelected = currentType == type;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(description),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () => onTypeSelected(type),
    );
  }
}

class _AnnotationPainter extends CustomPainter {
  final List<AnnotationMarker> markers;
  final Offset? currentStartPoint;
  final Offset? currentEndPoint;
  final MarkerType currentMarkerType;
  final String authorId;

  _AnnotationPainter({
    required this.markers,
    this.currentStartPoint,
    this.currentEndPoint,
    required this.currentMarkerType,
    required this.authorId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw existing markers
    for (final marker in markers) {
      _drawMarker(canvas, marker);
    }

    // Draw current drawing action (preview)
    if (currentStartPoint != null && currentEndPoint != null) {
      _drawCurrentAction(canvas);
    }
  }

  void _drawMarker(Canvas canvas, AnnotationMarker marker) {
    final color = marker.renderColor;

    switch (marker.type) {
      case MarkerType.point:
        _drawPoint(canvas, marker.position, color, marker.comment);
        break;
      case MarkerType.line:
        if (marker.endPosition != null) {
          _drawLine(canvas, marker.position, marker.endPosition!, color);
        }
        break;
      case MarkerType.box:
        if (marker.rect != null) {
          _drawBox(canvas, marker.rect!, color, marker.comment);
        }
        break;
    }
  }

  void _drawPoint(Canvas canvas, Offset position, Color color, String? comment) {
    // Outer circle
    final outerPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, 20, outerPaint);

    // Inner dot
    final innerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, 8, innerPaint);

    // Comment indicator
    if (comment != null && comment.isNotEmpty) {
      final commentPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(position + const Offset(12, -12), 6, commentPaint);

      final borderPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(position + const Offset(12, -12), 6, borderPaint);

      // Draw "..." text
      final textPainter = TextPainter(
        text: TextSpan(
          text: '•••',
          style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, position + const Offset(7, -17));
    }
  }

  void _drawLine(Canvas canvas, Offset start, Offset end, Color color) {
    final linePaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    canvas.drawLine(start, end, linePaint);

    // Draw endpoints
    final endpointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(start, 6, endpointPaint);
    canvas.drawCircle(end, 6, endpointPaint);
  }

  void _drawBox(Canvas canvas, Rect rect, Color color, String? comment) {
    // Fill
    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, fillPaint);

    // Border
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRect(rect, borderPaint);

    // Corner handles
    final handlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    const handleSize = 8.0;
    canvas.drawCircle(rect.topLeft, handleSize / 2, handlePaint);
    canvas.drawCircle(rect.topRight, handleSize / 2, handlePaint);
    canvas.drawCircle(rect.bottomLeft, handleSize / 2, handlePaint);
    canvas.drawCircle(rect.bottomRight, handleSize / 2, handlePaint);
  }

  void _drawCurrentAction(Canvas canvas) {
    // Preview color (semi-transparent)
    const previewColor = Color(0x80FFFFFF);

    switch (currentMarkerType) {
      case MarkerType.point:
        break; // Points don't have drag preview
      case MarkerType.line:
        _drawLine(canvas, currentStartPoint!, currentEndPoint!, previewColor);
        break;
      case MarkerType.box:
        final rect = Rect.fromPoints(currentStartPoint!, currentEndPoint!);
        _drawBox(canvas, rect, previewColor, null);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _AnnotationPainter oldDelegate) {
    return markers != oldDelegate.markers ||
        currentStartPoint != oldDelegate.currentStartPoint ||
        currentEndPoint != oldDelegate.currentEndPoint ||
        currentMarkerType != oldDelegate.currentMarkerType;
  }
}
