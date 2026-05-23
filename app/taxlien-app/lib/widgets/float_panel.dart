import 'package:flutter/material.dart';
import '../design/design.dart';

/// A floating panel for overlaid content like property previews or actions.
///
/// Positioned absolutely over other content with a surface background,
/// rounded corners, and modal shadow.
class FloatPanel extends StatelessWidget {
  const FloatPanel({
    super.key,
    required this.child,
    this.onDismiss,
  });

  /// The panel content.
  final Widget child;

  /// Optional callback when panel should be dismissed.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.rowGutter),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: AppRadius.lg,
          boxShadow: AppShadows.modal,
        ),
        child: child,
      ),
    );
  }

  /// Shows the panel as a modal bottom sheet.
  static Future<T?> showAsBottomSheet<T>(
    BuildContext context, {
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: FloatPanel(child: child),
      ),
    );
  }

  /// Shows the panel as an overlay positioned at the given offset.
  static OverlayEntry showAsOverlay(
    BuildContext context, {
    required Widget child,
    required Offset position,
    VoidCallback? onDismiss,
  }) {
    final overlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss barrier
          Positioned.fill(
            child: GestureDetector(
              onTap: onDismiss,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
          // Panel
          Positioned(
            left: position.dx,
            top: position.dy,
            child: FloatPanel(
              onDismiss: onDismiss,
              child: child,
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlay);
    return overlay;
  }
}
