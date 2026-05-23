import 'package:flutter/material.dart';
import '../app_colors.dart';

/// X-Ray insight types for property analysis.
enum XRayInsightType {
  /// Warning - issues requiring attention (flood zone, delinquent, etc.)
  warning,

  /// Opportunity - positive signals (high ROI, quick payback, etc.)
  opportunity,

  /// Ethical - considerations for protected classes (veteran, senior, etc.)
  ethical,

  /// Info - neutral information (owner tenure, redemption probability, etc.)
  info,
}

/// Color and icon extensions for XRayInsightType.
extension XRayColorsExtension on XRayInsightType {
  /// Primary color for this insight type.
  Color get color => switch (this) {
        XRayInsightType.warning => AppColors.xrayWarn,
        XRayInsightType.opportunity => AppColors.xrayOpp,
        XRayInsightType.ethical => AppColors.xrayEth,
        XRayInsightType.info => AppColors.xrayInfo,
      };

  /// Background color for badges (12% opacity).
  Color get backgroundColor => color.withOpacity(0.12);

  /// Icon for this insight type.
  IconData get icon => switch (this) {
        XRayInsightType.warning => Icons.warning_amber_rounded,
        XRayInsightType.opportunity => Icons.trending_up_rounded,
        XRayInsightType.ethical => Icons.favorite_rounded,
        XRayInsightType.info => Icons.info_outline_rounded,
      };

  /// Prefix symbol for text display.
  String get prefix => switch (this) {
        XRayInsightType.warning => '!',
        XRayInsightType.opportunity => '*',
        XRayInsightType.ethical => '~',
        XRayInsightType.info => 'i',
      };
}

/// Model for an X-Ray insight.
class XRayInsight {
  const XRayInsight({
    required this.type,
    required this.message,
    this.details,
  });

  final XRayInsightType type;
  final String message;
  final String? details;

  Color get color => type.color;
  Color get backgroundColor => type.backgroundColor;
  IconData get icon => type.icon;
}
