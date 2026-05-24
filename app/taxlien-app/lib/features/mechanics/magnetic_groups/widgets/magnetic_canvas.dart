import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/relationship.dart';
import 'property_cluster.dart';

/// A canvas showing magnetic groupings of properties.
class MagneticCanvas extends StatefulWidget {
  const MagneticCanvas({
    super.key,
    required this.state,
    this.onClusterTap,
    this.onClusterExpand,
    this.onPropertyTap,
    this.onRelationTypeChange,
  });

  final MagneticGroupsState state;
  final void Function(PropertyClusterData cluster)? onClusterTap;
  final void Function(PropertyClusterData cluster)? onClusterExpand;
  final void Function(ClusteredProperty property)? onPropertyTap;
  final void Function(RelationType? type)? onRelationTypeChange;

  @override
  State<MagneticCanvas> createState() => _MagneticCanvasState();
}

class _MagneticCanvasState extends State<MagneticCanvas>
    with TickerProviderStateMixin {
  late AnimationController _clusteringController;
  late Animation<double> _clusteringAnimation;

  @override
  void initState() {
    super.initState();
    _clusteringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _clusteringAnimation = CurvedAnimation(
      parent: _clusteringController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void didUpdateWidget(MagneticCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.isAnimating && !oldWidget.state.isAnimating) {
      _clusteringController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _clusteringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Relation type selector
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: _buildRelationSelector(),
        ),

        // Canvas
        Expanded(
          child: AnimatedBuilder(
            animation: _clusteringAnimation,
            builder: (context, child) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Stack(
                  children: [
                    // Connection lines
                    CustomPaint(
                      size: Size.infinite,
                      painter: _ClusterConnectionPainter(
                        clusters: widget.state.clusters,
                        animationValue: _clusteringAnimation.value,
                      ),
                    ),

                    // Clusters
                    ...widget.state.clusters.map((cluster) {
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        left: cluster.center.dx - cluster.radius,
                        top: cluster.center.dy - cluster.radius,
                        child: cluster.isExpanded
                            ? ExpandedPropertyCluster(
                                cluster: cluster,
                                onPropertyTap: widget.onPropertyTap,
                                onCollapse: () =>
                                    widget.onClusterTap?.call(cluster),
                              )
                            : PropertyCluster(
                                cluster: cluster,
                                onTap: () => widget.onClusterTap?.call(cluster),
                                onExpand: () =>
                                    widget.onClusterExpand?.call(cluster),
                              ),
                      );
                    }),

                    // Ungrouped properties
                    ...widget.state.ungroupedProperties.map((property) {
                      return Positioned(
                        left: property.position.dx - 20,
                        top: property.position.dy - 20,
                        child: GestureDetector(
                          onTap: () => widget.onPropertyTap?.call(property),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.home,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRelationSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // All option
          _buildSelectorChip(
            label: 'All',
            isSelected: widget.state.activeRelationType == null,
            onTap: () => widget.onRelationTypeChange?.call(null),
          ),
          const SizedBox(width: 8),

          // Relation types
          ...RelationType.values.map((type) {
            final count = widget.state.clusters
                .where((c) => c.relationType == type)
                .fold(0, (sum, c) => sum + c.count);

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildSelectorChip(
                label: type.label,
                icon: type.icon,
                color: type.color,
                count: count,
                isSelected: widget.state.activeRelationType == type,
                onTap: () => widget.onRelationTypeChange?.call(type),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSelectorChip({
    required String label,
    IconData? icon,
    Color? color,
    int? count,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? effectiveColor.withValues(alpha: 0.2)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? effectiveColor
                : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? effectiveColor
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? effectiveColor
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? effectiveColor
                      : theme.colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClusterConnectionPainter extends CustomPainter {
  _ClusterConnectionPainter({
    required this.clusters,
    required this.animationValue,
  });

  final List<PropertyClusterData> clusters;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    for (final cluster in clusters) {
      final paint = Paint()
        ..color = cluster.relationType.color.withValues(
          alpha: 0.2 * animationValue,
        )
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      // Draw lines from cluster center to each property
      for (final property in cluster.properties) {
        final start = cluster.center;
        final end = Offset.lerp(start, property.position, animationValue)!;

        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ClusterConnectionPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.clusters != clusters;
  }
}
