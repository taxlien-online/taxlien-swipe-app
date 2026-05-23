import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Risk level categories.
enum RiskLevel {
  /// Low risk (score 0-33)
  low,

  /// Medium risk (score 34-66)
  medium,

  /// High risk (score 67-100)
  high,
}

/// Color and label extensions for RiskLevel.
extension RiskColorsExtension on RiskLevel {
  /// Primary color for this risk level.
  Color get color => switch (this) {
        RiskLevel.low => AppColors.success,
        RiskLevel.medium => AppColors.warning,
        RiskLevel.high => AppColors.danger,
      };

  /// Background color for badges (12% opacity).
  Color get backgroundColor => color.withOpacity(0.12);

  /// Display label for this risk level.
  String get label => switch (this) {
        RiskLevel.low => 'LOW RISK',
        RiskLevel.medium => 'MED RISK',
        RiskLevel.high => 'HIGH RISK',
      };

  /// Short label for compact displays.
  String get shortLabel => switch (this) {
        RiskLevel.low => 'LOW',
        RiskLevel.medium => 'MED',
        RiskLevel.high => 'HIGH',
      };

  /// Icon for this risk level.
  IconData get icon => switch (this) {
        RiskLevel.low => Icons.check_circle_outline,
        RiskLevel.medium => Icons.warning_amber_outlined,
        RiskLevel.high => Icons.error_outline,
      };
}

/// Utilities for risk score colors.
abstract final class RiskColors {
  /// Returns interpolated color for risk score 0-100.
  ///
  /// - 0-33: Green (success) gradient
  /// - 34-66: Orange (warning) gradient
  /// - 67-100: Red (danger)
  static Color fromScore(double score) {
    final clamped = score.clamp(0, 100);
    if (clamped < 33) {
      return Color.lerp(AppColors.success, AppColors.warning, clamped / 33)!;
    } else if (clamped < 66) {
      return Color.lerp(
          AppColors.warning, AppColors.danger, (clamped - 33) / 33)!;
    } else {
      return AppColors.danger;
    }
  }

  /// Returns RiskLevel category for a score 0-100.
  static RiskLevel levelFromScore(double score) {
    if (score < 33) return RiskLevel.low;
    if (score < 66) return RiskLevel.medium;
    return RiskLevel.high;
  }

  /// Returns background color for score (12% opacity).
  static Color backgroundFromScore(double score) =>
      fromScore(score).withOpacity(0.12);
}
