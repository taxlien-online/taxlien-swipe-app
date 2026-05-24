import 'package:flutter/material.dart';

import '../models/graph_edge_data.dart';

/// A panel showing detected anomalies in the graph.
class AnomalyPanel extends StatelessWidget {
  const AnomalyPanel({
    super.key,
    required this.anomalies,
    this.selectedAnomalyId,
    this.onAnomalySelect,
    this.onDismiss,
    this.onAction,
  });

  final List<GraphAnomaly> anomalies;
  final String? selectedAnomalyId;
  final void Function(GraphAnomaly anomaly)? onAnomalySelect;
  final void Function(GraphAnomaly anomaly)? onDismiss;
  final void Function(GraphAnomaly anomaly)? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (anomalies.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: const Color(0xFF059669),
            ),
            const SizedBox(width: 12),
            Text(
              'No anomalies detected',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF059669),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Anomalies Detected',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    anomalies.length.toString(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Anomaly list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: anomalies.length,
              itemBuilder: (context, index) {
                final anomaly = anomalies[index];
                final isSelected = anomaly.id == selectedAnomalyId;

                return AnomalyListItem(
                  anomaly: anomaly,
                  isSelected: isSelected,
                  onTap: onAnomalySelect != null
                      ? () => onAnomalySelect!(anomaly)
                      : null,
                  onDismiss:
                      onDismiss != null ? () => onDismiss!(anomaly) : null,
                  onAction: onAction != null ? () => onAction!(anomaly) : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A single anomaly item in the list.
class AnomalyListItem extends StatelessWidget {
  const AnomalyListItem({
    super.key,
    required this.anomaly,
    this.isSelected = false,
    this.onTap,
    this.onDismiss,
    this.onAction,
  });

  final GraphAnomaly anomaly;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severity = anomaly.severity;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: isSelected
            ? severity.color.withValues(alpha: 0.1)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Severity indicator
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: severity.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // Title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              anomaly.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Severity badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: severity.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              severity.label,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: severity.color,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        anomaly.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Affected nodes indicator
            if (anomaly.affectedNodeIds.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Icon(
                      Icons.link,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    Text(
                      '${anomaly.affectedNodeIds.length} nodes',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Actions
            if (anomaly.suggestedAction != null || onDismiss != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    if (onAction != null && anomaly.suggestedAction != null)
                      TextButton(
                        onPressed: onAction,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(anomaly.suggestedAction!),
                      ),
                    const Spacer(),
                    if (onDismiss != null)
                      TextButton(
                        onPressed: onDismiss,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Dismiss'),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
