import 'package:flutter/material.dart';

import '../models/map_layer.dart';

/// A bottom sheet panel for managing map layers.
class LayerPanel extends StatelessWidget {
  const LayerPanel({
    super.key,
    required this.layers,
    this.onToggle,
    this.onOpacityChange,
    this.onClose,
  });

  final List<MapLayer> layers;
  final void Function(MapLayer layer)? onToggle;
  final void Function(MapLayer layer, double opacity)? onOpacityChange;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Separate markers and overlays
    final markerLayers = layers.where((l) => !l.type.isOverlay).toList();
    final overlayLayers = layers.where((l) => l.type.isOverlay).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Icon(
                Icons.layers,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Map Layers',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (onClose != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Marker layers section
          Text(
            'PROPERTY MARKERS',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          ...markerLayers.map((layer) => _buildLayerTile(context, layer)),

          // Overlay layers section
          if (overlayLayers.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'OVERLAYS',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            ...overlayLayers.map((layer) => _buildLayerTile(context, layer)),
          ],
        ],
      ),
    );
  }

  Widget _buildLayerTile(BuildContext context, MapLayer layer) {
    final theme = Theme.of(context);
    final type = layer.type;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Toggle
          Switch(
            value: layer.isVisible,
            onChanged: onToggle != null ? (_) => onToggle!(layer) : null,
            activeColor: type.color,
          ),

          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: type.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              type.icon,
              color: type.color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),

          // Label and count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (layer.count > 0 && !type.isOverlay)
                  Text(
                    '${layer.count} properties',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),

          // Opacity slider (for overlays)
          if (type.isOverlay && layer.isVisible)
            SizedBox(
              width: 100,
              child: Slider(
                value: layer.opacity,
                onChanged: onOpacityChange != null
                    ? (value) => onOpacityChange!(layer, value)
                    : null,
                activeColor: type.color,
              ),
            ),
        ],
      ),
    );
  }
}

/// A floating action button to toggle the layer panel.
class LayerPanelToggle extends StatelessWidget {
  const LayerPanelToggle({
    super.key,
    required this.isOpen,
    required this.activeLayerCount,
    this.onTap,
  });

  final bool isOpen;
  final int activeLayerCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton.small(
      onPressed: onTap,
      backgroundColor: isOpen
          ? theme.colorScheme.primary
          : theme.colorScheme.surface,
      child: Badge(
        label: Text(activeLayerCount.toString()),
        isLabelVisible: activeLayerCount > 0 && !isOpen,
        child: Icon(
          Icons.layers,
          color: isOpen
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.primary,
        ),
      ),
    );
  }
}
