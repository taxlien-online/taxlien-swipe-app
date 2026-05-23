import 'package:flutter/material.dart';
import '../design/design.dart';

/// Style variants for CtaButton.
enum CtaButtonVariant {
  /// Primary style with gradient background and glow.
  primary,

  /// Ghost style with surface background.
  ghost,
}

/// Size variants for CtaButton.
enum CtaButtonSize {
  /// Standard size with full padding.
  standard,

  /// Small size with reduced padding.
  small,
}

/// A call-to-action button with gradient or ghost styling.
///
/// Used for primary actions like "Save Property", "Start Search", etc.
class CtaButton extends StatelessWidget {
  const CtaButton({
    super.key,
    required this.label,
    this.icon,
    this.variant = CtaButtonVariant.primary,
    this.size = CtaButtonSize.standard,
    this.onPressed,
  });

  /// The button label text.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// The visual style variant.
  final CtaButtonVariant variant;

  /// The size variant.
  final CtaButtonSize size;

  /// Callback when pressed. If null, button is disabled.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = onPressed == null;
    final isSmall = size == CtaButtonSize.small;

    final verticalPadding = isSmall ? 6.0 : 14.0;
    final horizontalPadding = isSmall ? 10.0 : 18.0;
    final fontSize = isSmall ? 11.0 : 17.0;
    final iconSize = isSmall ? 14.0 : 20.0;

    final decoration = _getDecoration(isDark, isDisabled);
    final textColor = _getTextColor(isDark, isDisabled);

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        decoration: decoration,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: iconSize,
                color: textColor,
              ),
              SizedBox(width: isSmall ? 4 : 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: textColor,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(bool isDark, bool isDisabled) {
    const radius = BorderRadius.all(Radius.circular(12));

    if (isDisabled) {
      return BoxDecoration(
        color: isDark ? AppColors.surfaceDark2 : AppColors.disabled,
        borderRadius: radius,
      );
    }

    switch (variant) {
      case CtaButtonVariant.primary:
        return BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: radius,
          boxShadow: AppShadows.ctaGlow(AppColors.brandBlue),
        );
      case CtaButtonVariant.ghost:
        return BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: radius,
          boxShadow: AppShadows.card,
        );
    }
  }

  Color _getTextColor(bool isDark, bool isDisabled) {
    if (isDisabled) {
      return isDark ? AppColors.fg2Dark : AppColors.fg2;
    }

    switch (variant) {
      case CtaButtonVariant.primary:
        return Colors.white;
      case CtaButtonVariant.ghost:
        return isDark ? AppColors.fg1Dark : AppColors.fg1;
    }
  }
}
