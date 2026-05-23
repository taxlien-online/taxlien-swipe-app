import 'package:flutter/material.dart';
import '../design/design.dart';

/// Size variants for StatTile.
enum StatTileSize {
  /// Standard size with full padding and gap.
  standard,

  /// Compact size with reduced padding.
  compact,
}

/// A tile displaying a labeled statistic with optional icon and delta.
///
/// Used in property cards and dashboards to show metrics like
/// value, ROI, tax owed, etc.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.delta,
    this.deltaPositive,
    this.accentColor,
    this.size = StatTileSize.standard,
  });

  /// The label describing the statistic.
  final String label;

  /// The value to display (formatted string).
  final String value;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional change indicator (e.g., "+5%", "-$200").
  final String? delta;

  /// Whether the delta is positive (green) or negative (red).
  /// If null, delta uses neutral color.
  final bool? deltaPositive;

  /// Accent color for the icon and optional value tint.
  final Color? accentColor;

  /// Size variant affecting padding and spacing.
  final StatTileSize size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.fg2Dark : AppColors.fg2;
    final valueColor = isDark ? AppColors.fg1Dark : AppColors.fg1;

    final isCompact = size == StatTileSize.compact;
    final padding = isCompact
        ? const EdgeInsets.all(AppSpacing.xs)
        : const EdgeInsets.all(AppSpacing.sm);
    final gap = isCompact ? AppSpacing.xxs : AppSpacing.xs;

    return Container(
      constraints: isCompact
          ? const BoxConstraints(minWidth: 80)
          : const BoxConstraints(),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label row with optional icon
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: accentColor ?? labelColor,
                ),
                const SizedBox(width: AppSpacing.xxs),
              ],
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    color: labelColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: gap),
          // Value row with optional delta
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: AppTypography.label.copyWith(
                    color: accentColor ?? valueColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (delta != null) ...[
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  delta!,
                  style: AppTypography.caption.copyWith(
                    color: _deltaColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color get _deltaColor {
    if (deltaPositive == null) return AppColors.fg2;
    return deltaPositive! ? AppColors.success : AppColors.danger;
  }
}
