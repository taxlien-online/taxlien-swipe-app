import 'package:flutter/material.dart';

import '../models/property_layer.dart';

/// Expanded content view for a property layer.
class LayerContent extends StatelessWidget {
  const LayerContent({
    super.key,
    required this.layer,
    this.onFieldTap,
  });

  final PropertyLayer layer;
  final void Function(String fieldName, String fieldValue)? onFieldTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: layer.type.color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                layer.type.icon,
                color: layer.type.color,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                layer.type.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: layer.type.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Fields
          ...layer.fields.entries.map((entry) => _buildField(
                context,
                entry.key,
                entry.value,
              )),
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context, String name, String value) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onFieldTap != null ? () => onFieldTap!(name, value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.end,
              ),
            ),
            if (onFieldTap != null) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.help_outline,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
