import 'package:flutter/material.dart';

import '../models/graph_node_data.dart';

/// A draggable node in the tax graph.
class GraphNode extends StatelessWidget {
  const GraphNode({
    super.key,
    required this.node,
    this.onTap,
    this.onDoubleTap,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
  });

  final GraphNodeData node;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onDragStart;
  final void Function(DragUpdateDetails details)? onDragUpdate;
  final VoidCallback? onDragEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = node.type;
    final size = node.size;

    return Positioned(
      left: node.position.dx - size / 2,
      top: node.position.dy - size / 2,
      child: GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onPanStart: onDragStart != null ? (_) => onDragStart!() : null,
        onPanUpdate: onDragUpdate,
        onPanEnd: onDragEnd != null ? (_) => onDragEnd!() : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: node.isSelected
                ? type.color
                : type.color.withValues(alpha: 0.9),
            border: Border.all(
              color: node.isSelected
                  ? Colors.white
                  : type.color.withValues(alpha: 0.3),
              width: node.isSelected ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: type.color.withValues(
                  alpha: node.isHighlighted ? 0.6 : 0.3,
                ),
                blurRadius: node.isHighlighted ? 16 : 8,
                spreadRadius: node.isHighlighted ? 2 : 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                type.icon,
                color: Colors.white,
                size: size * 0.35,
              ),
              if (size >= 50) ...[
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    _truncateLabel(node.label),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _truncateLabel(String label) {
    if (label.length <= 8) return label;
    return '${label.substring(0, 6)}...';
  }
}

/// A detailed tooltip for a graph node.
class GraphNodeTooltip extends StatelessWidget {
  const GraphNodeTooltip({
    super.key,
    required this.node,
    this.onViewDetails,
    this.onPin,
  });

  final GraphNodeData node;
  final VoidCallback? onViewDetails;
  final VoidCallback? onPin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = node.type;

    return Container(
      constraints: const BoxConstraints(maxWidth: 240),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: type.color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: type.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  type.icon,
                  color: type.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      node.label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (node.subtitle != null)
                      Text(
                        node.subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Type badge
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: type.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              type.label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: type.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Metadata
          if (node.metadata.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...node.metadata.entries.take(3).map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text(
                      '${entry.key}:',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: theme.textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],

          // Actions
          const SizedBox(height: 8),
          Row(
            children: [
              if (onPin != null)
                IconButton(
                  icon: Icon(
                    node.isFixed ? Icons.push_pin : Icons.push_pin_outlined,
                    size: 18,
                  ),
                  onPressed: onPin,
                  tooltip: node.isFixed ? 'Unpin' : 'Pin position',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              const Spacer(),
              if (onViewDetails != null)
                TextButton(
                  onPressed: onViewDetails,
                  child: const Text('View Details'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
