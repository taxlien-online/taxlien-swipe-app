import 'package:flutter/material.dart';

import '../models/property_layer.dart';

/// A single layer card displaying property information.
class LayerCard extends StatelessWidget {
  const LayerCard({
    super.key,
    required this.layer,
    this.isTop = false,
    this.offset = 0.0,
    this.onTap,
  });

  final PropertyLayer layer;
  final bool isTop;
  final double offset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Transform.translate(
      offset: Offset(0, offset),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: layer.type.color.withValues(alpha: isTop ? 1.0 : 0.3),
              width: isTop ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isTop ? 0.15 : 0.08),
                blurRadius: isTop ? 20 : 10,
                offset: Offset(0, isTop ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with type indicator
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: layer.type.color.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: layer.type.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        layer.type.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            layer.type.label,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: layer.type.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            layer.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isTop)
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                  ],
                ),
              ),
              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  layer.subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
