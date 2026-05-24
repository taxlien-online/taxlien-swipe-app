import 'package:flutter/material.dart';

import '../models/relationship.dart';

/// A badge showing a relation type with count.
class RelationBadge extends StatelessWidget {
  const RelationBadge({
    super.key,
    required this.relationType,
    this.count,
    this.isSelected = false,
    this.onTap,
  });

  final RelationType relationType;
  final int? count;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? relationType.color
              : relationType.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: relationType.color,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              relationType.icon,
              size: 16,
              color: isSelected ? Colors.white : relationType.color,
            ),
            const SizedBox(width: 6),
            Text(
              relationType.label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? Colors.white : relationType.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.3)
                      : relationType.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected ? Colors.white : relationType.color,
                    fontWeight: FontWeight.bold,
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

/// A row of relation badges for filtering.
class RelationBadgeRow extends StatelessWidget {
  const RelationBadgeRow({
    super.key,
    required this.relationTypes,
    this.selectedType,
    this.counts = const {},
    this.onSelect,
  });

  final List<RelationType> relationTypes;
  final RelationType? selectedType;
  final Map<RelationType, int> counts;
  final void Function(RelationType? type)? onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // "All" option
          GestureDetector(
            onTap: () => onSelect?.call(null),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: selectedType == null
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'All',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: selectedType == null
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          // Relation type badges
          ...relationTypes.map((type) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: RelationBadge(
                  relationType: type,
                  count: counts[type],
                  isSelected: selectedType == type,
                  onTap: () => onSelect?.call(type),
                ),
              )),
        ],
      ),
    );
  }
}
