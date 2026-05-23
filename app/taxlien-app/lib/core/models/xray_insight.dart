import 'package:flutter/material.dart';
import '../design/app_colors.dart';

/// Types of X-Ray insights
enum XRayInsightType {
  warning, // Issues/problems (red)
  opportunity, // Good opportunities (green)
  ethical, // Ethical considerations (purple)
  informational, // Neutral data insights (blue)
  stale, // Outdated data (yellow)
}

/// Categories for organizing insights
enum XRayInsightCategory {
  risk, // Risk-related warnings
  financial, // Financial opportunities
  location, // Location/neighborhood data
  owner, // Owner-related information
  compliance, // Ethical/compliance considerations
  data, // Data quality/staleness
}

/// A single insight generated from property analysis
class XRayInsight {
  final XRayInsightType type;
  final XRayInsightCategory category;
  final String title;
  final String description;
  final String? field; // Which data field this relates to
  final double? confidence; // 0.0-1.0 ML/AI confidence
  final String? actionHint; // Suggested action for user
  final Map<String, dynamic>? metadata; // Additional insight data

  const XRayInsight({
    required this.type,
    required this.category,
    required this.title,
    required this.description,
    this.field,
    this.confidence,
    this.actionHint,
    this.metadata,
  });

  Color get color => switch (type) {
        XRayInsightType.warning => AppColors.insightWarning,
        XRayInsightType.opportunity => AppColors.insightOpportunity,
        XRayInsightType.ethical => AppColors.insightEthical,
        XRayInsightType.informational => AppColors.insightInfo,
        XRayInsightType.stale => AppColors.insightStale,
      };

  IconData get icon => switch (type) {
        XRayInsightType.warning => Icons.warning_rounded,
        XRayInsightType.opportunity => Icons.star_rounded,
        XRayInsightType.ethical => Icons.shield_rounded,
        XRayInsightType.informational => Icons.info_rounded,
        XRayInsightType.stale => Icons.update_rounded,
      };

  /// Priority for display ordering (lower = show first)
  int get priority => switch (type) {
        XRayInsightType.warning => 1,
        XRayInsightType.ethical => 2,
        XRayInsightType.opportunity => 3,
        XRayInsightType.informational => 4,
        XRayInsightType.stale => 5,
      };

  /// Whether this insight should be highlighted prominently
  bool get isHighPriority => type == XRayInsightType.warning || type == XRayInsightType.ethical;

  /// Confidence as a percentage string
  String? get confidenceText {
    if (confidence == null) return null;
    return '${(confidence! * 100).toStringAsFixed(0)}%';
  }

  @override
  String toString() => 'XRayInsight($type: $title)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is XRayInsight &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          title == other.title &&
          field == other.field;

  @override
  int get hashCode => Object.hash(type, title, field);
}

/// Extension to sort insights by priority
extension XRayInsightListExt on List<XRayInsight> {
  /// Sort insights by priority (warnings first)
  List<XRayInsight> sortedByPriority() {
    return [...this]..sort((a, b) => a.priority.compareTo(b.priority));
  }

  /// Filter to only high-priority insights
  List<XRayInsight> highPriorityOnly() {
    return where((i) => i.isHighPriority).toList();
  }

  /// Group insights by category
  Map<XRayInsightCategory, List<XRayInsight>> groupByCategory() {
    final result = <XRayInsightCategory, List<XRayInsight>>{};
    for (final insight in this) {
      result.putIfAbsent(insight.category, () => []).add(insight);
    }
    return result;
  }

  /// Get count by type
  Map<XRayInsightType, int> countByType() {
    final result = <XRayInsightType, int>{};
    for (final insight in this) {
      result[insight.type] = (result[insight.type] ?? 0) + 1;
    }
    return result;
  }
}
