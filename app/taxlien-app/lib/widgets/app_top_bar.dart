import 'package:flutter/material.dart';
import '../design/design.dart';

/// A custom app bar with consistent styling.
///
/// Supports title, optional subtitle, leading widget, and action buttons.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.showDivider = false,
  });

  /// The title text.
  final String title;

  /// Optional subtitle displayed below the title.
  final String? subtitle;

  /// Optional leading widget (typically back button).
  final Widget? leading;

  /// Optional action buttons.
  final List<Widget>? actions;

  /// Whether to center the title.
  final bool centerTitle;

  /// Whether to show a bottom divider.
  final bool showDivider;

  @override
  Size get preferredSize => Size.fromHeight(
        subtitle != null ? kToolbarHeight + 10 : kToolbarHeight,
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDark : AppColors.bg,
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.lineDark : AppColors.line,
                  width: 1,
                ),
              )
            : null,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.sm),
              ],
              if (centerTitle) const Spacer(),
              Expanded(
                flex: centerTitle ? 0 : 1,
                child: Column(
                  crossAxisAlignment: centerTitle
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTypography.title.copyWith(
                        color: isDark ? AppColors.fg1Dark : AppColors.fg1,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.caption.copyWith(
                          color: isDark ? AppColors.fg2Dark : AppColors.fg2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (centerTitle) const Spacer(),
              if (actions != null) ...[
                const SizedBox(width: AppSpacing.sm),
                ...actions!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Creates a back button to use as leading widget.
  static Widget backButton(BuildContext context, {VoidCallback? onPressed}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: AppSizes.touchTarget,
        height: AppSizes.touchTarget,
        alignment: Alignment.center,
        child: Icon(
          Icons.arrow_back_ios_rounded,
          size: 20,
          color: isDark ? AppColors.fg1Dark : AppColors.fg1,
        ),
      ),
    );
  }

  /// Creates a close button to use as leading or action widget.
  static Widget closeButton(BuildContext context, {VoidCallback? onPressed}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: AppSizes.touchTarget,
        height: AppSizes.touchTarget,
        alignment: Alignment.center,
        child: Icon(
          Icons.close_rounded,
          size: 24,
          color: isDark ? AppColors.fg1Dark : AppColors.fg1,
        ),
      ),
    );
  }
}
