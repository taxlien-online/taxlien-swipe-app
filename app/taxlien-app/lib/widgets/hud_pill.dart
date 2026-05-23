import 'dart:ui';
import 'package:flutter/material.dart';
import '../design/design.dart';

/// A frosted-glass pill indicator for overlay HUD elements.
///
/// Used for status indicators overlaid on content like
/// "3 properties selected" or connection status.
class HudPill extends StatelessWidget {
  const HudPill({
    super.key,
    required this.label,
    this.dotColor,
    this.icon,
  });

  /// The label text.
  final String label;

  /// Optional colored dot indicator.
  final Color? dotColor;

  /// Optional leading icon (alternative to dot).
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.fg1Dark : AppColors.fg1;

    return ClipRRect(
      borderRadius: AppRadius.pill,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark.withOpacity(0.86)
                : AppColors.surface.withOpacity(0.86),
            borderRadius: AppRadius.pill,
            boxShadow: AppShadows.card,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dotColor != null) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ] else if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: textColor,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
