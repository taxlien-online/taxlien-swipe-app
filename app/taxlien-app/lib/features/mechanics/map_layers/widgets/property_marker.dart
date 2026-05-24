import 'package:flutter/material.dart';

import '../models/map_layer.dart';

/// A custom marker for a property on the map.
class PropertyMarker extends StatelessWidget {
  const PropertyMarker({
    super.key,
    required this.marker,
    this.size = 32.0,
    this.onTap,
  });

  final PropertyMarkerData marker;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = marker.layerType.color;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: marker.isSelected ? color : color.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: marker.isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: marker.isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
            if (marker.isSelected)
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 12,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Center(
          child: Icon(
            marker.layerType.icon,
            color: Colors.white,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}

/// A cluster marker showing multiple properties.
class ClusterMarker extends StatelessWidget {
  const ClusterMarker({
    super.key,
    required this.count,
    required this.layerType,
    this.size = 40.0,
    this.onTap,
  });

  final int count;
  final MapLayerType layerType;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = layerType.color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            count > 99 ? '99+' : count.toString(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// Marker info card shown when a marker is selected.
class MarkerInfoCard extends StatelessWidget {
  const MarkerInfoCard({
    super.key,
    required this.marker,
    this.onClose,
    this.onViewDetails,
  });

  final PropertyMarkerData marker;
  final VoidCallback? onClose;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = marker.layerType.color;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  marker.layerType.icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marker.layerType.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      marker.address,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (onClose != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),

          // Stats
          const SizedBox(height: 12),
          Row(
            children: [
              if (marker.fviScore != null) ...[
                _buildStat(
                  context,
                  'FVI',
                  marker.fviScore!.toStringAsFixed(0),
                  _getFviColor(marker.fviScore!),
                ),
                const SizedBox(width: 16),
              ],
              if (marker.price != null)
                _buildStat(
                  context,
                  'Price',
                  '\$${_formatPrice(marker.price!)}',
                  theme.colorScheme.primary,
                ),
            ],
          ),

          // Actions
          if (onViewDetails != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onViewDetails,
                child: const Text('View Details'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getFviColor(double score) {
    if (score >= 80) return const Color(0xFF059669);
    if (score >= 60) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    }
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return price.toStringAsFixed(0);
  }
}
