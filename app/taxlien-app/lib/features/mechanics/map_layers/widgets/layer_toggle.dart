import 'package:flutter/material.dart';

import '../models/map_layer.dart';

/// A toggle chip for a map layer.
class LayerToggle extends StatelessWidget {
  const LayerToggle({
    super.key,
    required this.layer,
    this.onToggle,
  });

  final MapLayer layer;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = layer.type;

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: layer.isVisible
              ? type.color.withValues(alpha: 0.15)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: layer.isVisible
                ? type.color
                : theme.colorScheme.outlineVariant,
            width: layer.isVisible ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type.icon,
              size: 16,
              color: layer.isVisible
                  ? type.color
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              type.label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: layer.isVisible
                    ? type.color
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: layer.isVisible ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (layer.count > 0 && !type.isOverlay) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: layer.isVisible
                      ? type.color
                      : theme.colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  layer.count.toString(),
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

/// A row of layer toggle chips.
class LayerToggleRow extends StatelessWidget {
  const LayerToggleRow({
    super.key,
    required this.layers,
    this.onToggle,
  });

  final List<MapLayer> layers;
  final void Function(MapLayer layer)? onToggle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: layers.map((layer) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: LayerToggle(
              layer: layer,
              onToggle: onToggle != null ? () => onToggle!(layer) : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
