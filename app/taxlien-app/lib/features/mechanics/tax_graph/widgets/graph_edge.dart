import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/graph_edge_data.dart';
import '../models/graph_node_data.dart';

/// Paints edges between nodes in the graph.
class GraphEdgePainter extends CustomPainter {
  GraphEdgePainter({
    required this.edges,
    required this.nodes,
    this.selectedNodeId,
    this.hoveredEdgeId,
  });

  final List<GraphEdgeData> edges;
  final List<GraphNodeData> nodes;
  final String? selectedNodeId;
  final String? hoveredEdgeId;

  @override
  void paint(Canvas canvas, Size size) {
    for (final edge in edges) {
      final sourceNode = nodes.firstWhere(
        (n) => n.id == edge.sourceId,
        orElse: () => nodes.first,
      );
      final targetNode = nodes.firstWhere(
        (n) => n.id == edge.targetId,
        orElse: () => nodes.first,
      );

      final isHighlighted = edge.isHighlighted ||
          edge.id == hoveredEdgeId ||
          edge.sourceId == selectedNodeId ||
          edge.targetId == selectedNodeId;

      _drawEdge(
        canvas,
        sourceNode.position,
        targetNode.position,
        edge,
        isHighlighted,
      );
    }
  }

  void _drawEdge(
    Canvas canvas,
    Offset start,
    Offset end,
    GraphEdgeData edge,
    bool isHighlighted,
  ) {
    final paint = Paint()
      ..color = edge.type.color.withValues(alpha: isHighlighted ? 1.0 : 0.5)
      ..strokeWidth = edge.thickness * (isHighlighted ? 1.5 : 1.0)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Create path
    final path = Path();
    path.moveTo(start.dx, start.dy);

    // Draw curved or straight line
    final midX = (start.dx + end.dx) / 2;
    final midY = (start.dy + end.dy) / 2;

    // Add slight curve for better visibility
    final perpX = -(end.dy - start.dy) * 0.1;
    final perpY = (end.dx - start.dx) * 0.1;

    path.quadraticBezierTo(
      midX + perpX,
      midY + perpY,
      end.dx,
      end.dy,
    );

    // Draw dashed or solid line
    if (edge.type.isDashed && edge.type.dashPattern != null) {
      _drawDashedPath(canvas, path, paint, edge.type.dashPattern!);
    } else {
      canvas.drawPath(path, paint);
    }

    // Draw arrow head
    _drawArrowHead(canvas, start, end, paint);

    // Draw label if present
    if (edge.label != null && isHighlighted) {
      _drawLabel(canvas, Offset(midX + perpX, midY + perpY), edge.label!);
    }
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint,
    List<double> dashPattern,
  ) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      var distance = 0.0;
      var draw = true;
      var patternIndex = 0;

      while (distance < metric.length) {
        final length = dashPattern[patternIndex % dashPattern.length];
        if (draw) {
          final extractPath = metric.extractPath(
            distance,
            math.min(distance + length, metric.length),
          );
          canvas.drawPath(extractPath, paint);
        }
        distance += length;
        draw = !draw;
        patternIndex++;
      }
    }
  }

  void _drawArrowHead(Canvas canvas, Offset start, Offset end, Paint paint) {
    const arrowSize = 8.0;
    final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);

    // Offset the arrow to not overlap with the node
    final arrowTip = Offset(
      end.dx - 20 * math.cos(angle),
      end.dy - 20 * math.sin(angle),
    );

    final path = Path();
    path.moveTo(arrowTip.dx, arrowTip.dy);
    path.lineTo(
      arrowTip.dx - arrowSize * math.cos(angle - math.pi / 6),
      arrowTip.dy - arrowSize * math.sin(angle - math.pi / 6),
    );
    path.moveTo(arrowTip.dx, arrowTip.dy);
    path.lineTo(
      arrowTip.dx - arrowSize * math.cos(angle + math.pi / 6),
      arrowTip.dy - arrowSize * math.sin(angle + math.pi / 6),
    );

    canvas.drawPath(path, paint);
  }

  void _drawLabel(Canvas canvas, Offset position, String label) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );

    textPainter.layout();

    // Draw background
    final bgRect = Rect.fromCenter(
      center: position,
      width: textPainter.width + 8,
      height: textPainter.height + 4,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(4)),
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );

    // Draw text
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant GraphEdgePainter oldDelegate) {
    return oldDelegate.edges != edges ||
        oldDelegate.nodes != nodes ||
        oldDelegate.selectedNodeId != selectedNodeId ||
        oldDelegate.hoveredEdgeId != hoveredEdgeId;
  }
}

/// A legend showing edge types.
class GraphEdgeLegend extends StatelessWidget {
  const GraphEdgeLegend({
    super.key,
    required this.edgeTypes,
  });

  final List<EdgeType> edgeTypes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Relationships',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...edgeTypes.map((type) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 2,
                      decoration: BoxDecoration(
                        color: type.color,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      type.label,
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
