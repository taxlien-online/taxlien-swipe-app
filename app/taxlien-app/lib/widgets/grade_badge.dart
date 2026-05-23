import 'package:flutter/material.dart';
import '../design/design.dart';

/// Size variants for GradeBadge.
enum GradeBadgeSize {
  /// Small: 20x20
  sm,

  /// Medium: 28x28 (default)
  md,

  /// Large: 36x36
  lg,
}

/// A circular badge displaying an FVI grade (A+ through F).
///
/// Colors indicate quality:
/// - A+, A: Green (success)
/// - B: Cyan (brand)
/// - C: Orange (warning)
/// - D: Red (danger)
/// - F: Dark red
class GradeBadge extends StatelessWidget {
  const GradeBadge({
    super.key,
    required this.grade,
    this.size = GradeBadgeSize.md,
  });

  /// The grade letter (A+, A, B, C, D, F).
  final String grade;

  /// The size variant.
  final GradeBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final dimension = _dimension;
    final fontSize = _fontSize;
    final color = _gradeColor;

    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        grade,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.0,
        ),
      ),
    );
  }

  double get _dimension => switch (size) {
        GradeBadgeSize.sm => 20,
        GradeBadgeSize.md => 28,
        GradeBadgeSize.lg => 36,
      };

  double get _fontSize => switch (size) {
        GradeBadgeSize.sm => 10,
        GradeBadgeSize.md => 13,
        GradeBadgeSize.lg => 16,
      };

  Color get _gradeColor {
    final normalized = grade.toUpperCase().trim();
    return switch (normalized) {
      'A+' || 'A' => AppColors.success,
      'B+' || 'B' => AppColors.brandCyan,
      'C+' || 'C' => AppColors.warning,
      'D+' || 'D' => AppColors.danger,
      'F' => const Color(0xFFB91C1C), // Dark red
      _ => AppColors.fg2, // Unknown grade
    };
  }
}
