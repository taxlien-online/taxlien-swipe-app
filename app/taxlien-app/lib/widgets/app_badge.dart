import 'package:flutter/material.dart';
import '../design/design.dart';

/// Color tones for AppBadge.
enum BadgeTone {
  /// Red/danger tone for hot items.
  hot,

  /// Green/success tone for positive signals.
  good,

  /// Blue/info tone for informational badges.
  info,

  /// Orange/warning tone for caution items.
  warn,

  /// Purple tone for special/ethical markers.
  purple,

  /// Cyan tone for brand accent items.
  cyan,

  /// Gray/neutral tone.
  neutral,

  /// No background, just text.
  none,
}

/// A small badge/chip for displaying status or category labels.
///
/// Used for property stages, types, and status indicators.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.tone = BadgeTone.none,
    this.icon,
  });

  /// The badge label text.
  final String label;

  /// The color tone for the badge.
  final BadgeTone tone;

  /// Optional leading icon.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _getColors(isDark);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppRadius.pill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 10,
              color: colors.foreground,
            ),
            const SizedBox(width: 3),
          ],
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: colors.foreground,
                height: 1.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeColors _getColors(bool isDark) {
    final Color foreground;
    final Color background;

    switch (tone) {
      case BadgeTone.hot:
        foreground = AppColors.danger;
        background = AppColors.danger.withOpacity(0.12);
      case BadgeTone.good:
        foreground = AppColors.success;
        background = AppColors.success.withOpacity(0.12);
      case BadgeTone.info:
        foreground = AppColors.brandBlue;
        background = AppColors.brandBlue.withOpacity(0.12);
      case BadgeTone.warn:
        foreground = AppColors.warning;
        background = AppColors.warning.withOpacity(0.12);
      case BadgeTone.purple:
        foreground = AppColors.xrayEth;
        background = AppColors.xrayEth.withOpacity(0.12);
      case BadgeTone.cyan:
        foreground = AppColors.brandCyan;
        background = AppColors.brandCyan.withOpacity(0.12);
      case BadgeTone.neutral:
        foreground = isDark ? AppColors.fg2Dark : AppColors.fg2;
        background = isDark ? AppColors.surfaceDark2 : AppColors.disabled;
      case BadgeTone.none:
        foreground = isDark ? AppColors.fg1Dark : AppColors.fg1;
        background = Colors.transparent;
    }

    return _BadgeColors(foreground: foreground, background: background);
  }
}

class _BadgeColors {
  const _BadgeColors({required this.foreground, required this.background});
  final Color foreground;
  final Color background;
}
