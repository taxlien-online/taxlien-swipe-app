import 'package:flutter/material.dart';

import '../models/graph_edge_data.dart';
import '../models/graph_node_data.dart';
import '../utils/force_directed_layout.dart';
import 'graph_edge.dart';
import 'graph_node.dart';

/// A canvas showing a force-directed graph of connections.
class GraphCanvas extends StatefulWidget {
  const GraphCanvas({
    super.key,
    required this.state,
    this.onNodeTap,
    this.onNodeDoubleTap,
    this.onNodeDrag,
    this.onBackgroundTap,
  });

  final TaxGraphState state;
  final void Function(GraphNodeData node)? onNodeTap;
  final void Function(GraphNodeData node)? onNodeDoubleTap;
  final void Function(GraphNodeData node, Offset delta)? onNodeDrag;
  final VoidCallback? onBackgroundTap;

  @override
  State<GraphCanvas> createState() => _GraphCanvasState();
}

class _GraphCanvasState extends State<GraphCanvas>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformController;
  late AnimationController _simulationController;
  ForceDirectedLayout? _layout;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
    _simulationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _layout = ForceDirectedLayout(
      nodes: widget.state.nodes,
      edges: widget.state.edges,
    );

    if (widget.state.isSimulating) {
      _startSimulation();
    }
  }

  @override
  void didUpdateWidget(GraphCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update layout if nodes/edges changed
    if (widget.state.nodes != oldWidget.state.nodes ||
        widget.state.edges != oldWidget.state.edges) {
      _layout = ForceDirectedLayout(
        nodes: widget.state.nodes,
        edges: widget.state.edges,
      );
    }

    // Start/stop simulation
    if (widget.state.isSimulating && !oldWidget.state.isSimulating) {
      _startSimulation();
    } else if (!widget.state.isSimulating && oldWidget.state.isSimulating) {
      _simulationController.stop();
    }
  }

  void _startSimulation() {
    _simulationController.repeat();
  }

  @override
  void dispose() {
    _transformController.dispose();
    _simulationController.dispose();
    super.dispose();
  }

  void _handleNodeDrag(GraphNodeData node, DragUpdateDetails details) {
    widget.onNodeDrag?.call(node, details.delta / widget.state.scale);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onBackgroundTap,
      child: InteractiveViewer(
        transformationController: _transformController,
        minScale: 0.1,
        maxScale: 4.0,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        child: AnimatedBuilder(
          animation: _simulationController,
          builder: (context, child) {
            // Run simulation step
            if (widget.state.isSimulating && _layout != null) {
              _layout!.step();
            }

            return Stack(
              children: [
                // Background grid
                CustomPaint(
                  size: Size.infinite,
                  painter: _GridPainter(),
                ),

                // Edges
                CustomPaint(
                  size: Size.infinite,
                  painter: GraphEdgePainter(
                    edges: widget.state.edges,
                    nodes: widget.state.nodes,
                    selectedNodeId: widget.state.selectedNodeId,
                  ),
                ),

                // Nodes
                ...widget.state.nodes.map((node) {
                  return GraphNode(
                    node: node.copyWith(
                      isSelected: node.id == widget.state.selectedNodeId,
                      isHighlighted: _isNodeHighlighted(node),
                    ),
                    onTap: () => widget.onNodeTap?.call(node),
                    onDoubleTap: () => widget.onNodeDoubleTap?.call(node),
                    onDragUpdate: (details) => _handleNodeDrag(node, details),
                  );
                }),

                // Selected node tooltip
                if (widget.state.selectedNode != null)
                  Positioned(
                    left: widget.state.selectedNode!.position.dx +
                        widget.state.selectedNode!.size / 2 +
                        10,
                    top: widget.state.selectedNode!.position.dy -
                        widget.state.selectedNode!.size / 2,
                    child: GraphNodeTooltip(
                      node: widget.state.selectedNode!,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _isNodeHighlighted(GraphNodeData node) {
    final selectedId = widget.state.selectedNodeId;
    if (selectedId == null) return false;

    // Highlight connected nodes
    return widget.state.connectedNodeIds(selectedId).contains(node.id);
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    const spacing = 50.0;

    // Vertical lines
    for (var x = 0.0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (var y = 0.0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}

/// A minimap showing the graph overview.
class GraphMinimap extends StatelessWidget {
  const GraphMinimap({
    super.key,
    required this.nodes,
    required this.viewportRect,
    this.size = const Size(150, 100),
    this.onTap,
  });

  final List<GraphNodeData> nodes;
  final Rect viewportRect;
  final Size size;
  final void Function(Offset position)? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: CustomPaint(
          size: size,
          painter: _MinimapPainter(
            nodes: nodes,
            viewportRect: viewportRect,
          ),
        ),
      ),
    );
  }
}

class _MinimapPainter extends CustomPainter {
  _MinimapPainter({
    required this.nodes,
    required this.viewportRect,
  });

  final List<GraphNodeData> nodes;
  final Rect viewportRect;

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isEmpty) return;

    // Calculate bounds
    var minX = double.infinity;
    var minY = double.infinity;
    var maxX = double.negativeInfinity;
    var maxY = double.negativeInfinity;

    for (final node in nodes) {
      minX = node.position.dx < minX ? node.position.dx : minX;
      minY = node.position.dy < minY ? node.position.dy : minY;
      maxX = node.position.dx > maxX ? node.position.dx : maxX;
      maxY = node.position.dy > maxY ? node.position.dy : maxY;
    }

    final boundsWidth = maxX - minX + 100;
    final boundsHeight = maxY - minY + 100;
    final scaleX = size.width / boundsWidth;
    final scaleY = size.height / boundsHeight;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    // Draw nodes
    for (final node in nodes) {
      final x = (node.position.dx - minX + 50) * scale;
      final y = (node.position.dy - minY + 50) * scale;

      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()..color = node.type.color,
      );
    }

    // Draw viewport rect
    final vpLeft = (viewportRect.left - minX + 50) * scale;
    final vpTop = (viewportRect.top - minY + 50) * scale;
    final vpWidth = viewportRect.width * scale;
    final vpHeight = viewportRect.height * scale;

    canvas.drawRect(
      Rect.fromLTWH(vpLeft, vpTop, vpWidth, vpHeight),
      Paint()
        ..color = Colors.blue.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );

    canvas.drawRect(
      Rect.fromLTWH(vpLeft, vpTop, vpWidth, vpHeight),
      Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _MinimapPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.viewportRect != viewportRect;
  }
}
