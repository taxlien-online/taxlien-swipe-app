import 'package:flutter/material.dart';

import '../services/voice_recognition_service.dart';

/// A tag chip displaying an extracted filter from voice input.
class FilterTagWidget extends StatelessWidget {
  const FilterTagWidget({
    super.key,
    required this.tag,
    this.onRemove,
    this.onTap,
  });

  final FilterTag tag;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: tag.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: tag.color.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category icon
            Icon(
              _getIconForCategory(tag.category),
              size: 14,
              color: tag.color,
            ),
            const SizedBox(width: 6),

            // Display text
            Text(
              tag.display,
              style: theme.textTheme.labelMedium?.copyWith(
                color: tag.color,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Confidence indicator (if not 100%)
            if (tag.confidence < 0.9) ...[
              const SizedBox(width: 4),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: tag.color.withValues(alpha: tag.confidence),
                  shape: BoxShape.circle,
                ),
              ),
            ],

            // Remove button
            if (onRemove != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: tag.color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'price':
      case 'value':
        return Icons.attach_money;
      case 'location':
      case 'county':
      case 'state':
        return Icons.location_on;
      case 'type':
      case 'property':
        return Icons.home;
      case 'fvi':
      case 'score':
        return Icons.speed;
      case 'date':
      case 'auction':
        return Icons.event;
      default:
        return Icons.label;
    }
  }
}

/// A row of filter tags with animation.
class FilterTagRow extends StatelessWidget {
  const FilterTagRow({
    super.key,
    required this.tags,
    this.onRemove,
    this.onTagTap,
    this.onClearAll,
  });

  final List<FilterTag> tags;
  final void Function(FilterTag tag)? onRemove;
  final void Function(FilterTag tag)? onTagTap;
  final VoidCallback? onClearAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
                  .map((tag) => FilterTagWidget(
                        tag: tag,
                        onRemove: onRemove != null ? () => onRemove!(tag) : null,
                        onTap: onTagTap != null ? () => onTagTap!(tag) : null,
                      ))
                  .toList(),
            ),
          ),
          if (onClearAll != null && tags.length > 1)
            TextButton.icon(
              onPressed: onClearAll,
              icon: const Icon(Icons.clear_all, size: 18),
              label: Text(
                'Clear',
                style: theme.textTheme.labelSmall,
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }
}
