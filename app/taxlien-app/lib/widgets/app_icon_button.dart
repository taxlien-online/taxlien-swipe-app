import 'package:flutter/material.dart';
import '../design/design.dart';

/// Style variants for AppIconButton.
enum IconButtonVariant {
  /// Standard style with surface background.
  standard,

  /// Accent style with gradient background.
  accent,

  /// Active/danger style with red background.
  active,
}

/// A circular icon button with consistent sizing.
///
/// Used for actions like watchlist, share, close, etc.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.variant = IconButtonVariant.standard,
    this.onPressed,
    this.semanticLabel,
  });

  /// The icon to display.
  final IconData icon;

  /// The visual style variant.
  final IconButtonVariant variant;

  /// Callback when pressed. If null, button is disabled.
  final VoidCallback? onPressed;

  /// Accessibility label for screen readers.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = onPressed == null;

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: !isDisabled,
      child: GestureDetector(
        onTap: isDisabled ? null : onPressed,
        child: Container(
          width: AppSizes.iconButton,
          height: AppSizes.iconButton,
          decoration: _getDecoration(isDark, isDisabled),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 20,
            color: _getIconColor(isDark, isDisabled),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(bool isDark, bool isDisabled) {
    if (isDisabled) {
      return BoxDecoration(
        color: isDark ? AppColors.surfaceDark2 : AppColors.disabled,
        shape: BoxShape.circle,
      );
    }

    switch (variant) {
      case IconButtonVariant.standard:
        return BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: AppShadows.card,
        );
      case IconButtonVariant.accent:
        return const BoxDecoration(
          gradient: AppColors.brandGradient,
          shape: BoxShape.circle,
        );
      case IconButtonVariant.active:
        return const BoxDecoration(
          color: AppColors.danger,
          shape: BoxShape.circle,
        );
    }
  }

  Color _getIconColor(bool isDark, bool isDisabled) {
    if (isDisabled) {
      return isDark ? AppColors.fg2Dark : AppColors.fg2;
    }

    switch (variant) {
      case IconButtonVariant.standard:
        return isDark ? AppColors.fg1Dark : AppColors.fg1;
      case IconButtonVariant.accent:
      case IconButtonVariant.active:
        return Colors.white;
    }
  }
}
