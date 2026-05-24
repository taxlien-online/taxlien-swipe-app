import 'package:flutter/material.dart';

import '../models/relationship.dart';

/// A visual cluster of related properties.
class PropertyCluster extends StatelessWidget {
  const PropertyCluster({
    super.key,
    required this.cluster,
    this.onTap,
    this.onExpand,
  });

  final PropertyClusterData cluster;
  final VoidCallback? onTap;
  final VoidCallback? onExpand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onExpand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: cluster.radius * 2,
        height: cluster.radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: cluster.relationType.color.withValues(alpha: 0.1),
          border: Border.all(
            color: cluster.relationType.color.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Cluster label in center
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cluster.relationType.icon,
                    color: cluster.relationType.color,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cluster.count}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: cluster.relationType.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    cluster.relationType.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cluster.relationType.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Expand indicator
            if (!cluster.isExpanded)
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: cluster.relationType.color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.unfold_more,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// An expanded cluster showing individual properties.
class ExpandedPropertyCluster extends StatelessWidget {
  const ExpandedPropertyCluster({
    super.key,
    required this.cluster,
    this.onPropertyTap,
    this.onCollapse,
  });

  final PropertyClusterData cluster;
  final void Function(ClusteredProperty property)? onPropertyTap;
  final VoidCallback? onCollapse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cluster.relationType.color.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                cluster.relationType.icon,
                color: cluster.relationType.color,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  cluster.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onCollapse,
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Property list
          ...cluster.properties.map((property) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: cluster.relationType.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.home,
                    size: 16,
                    color: cluster.relationType.color,
                  ),
                ),
                title: Text(
                  property.address,
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: property.fviScore != null
                    ? Text(
                        'FVI ${property.fviScore!.toStringAsFixed(0)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      )
                    : null,
                onTap: () => onPropertyTap?.call(property),
              )),
        ],
      ),
    );
  }
}
