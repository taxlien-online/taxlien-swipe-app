import 'package:flutter/material.dart';
import '../design/design.dart';

/// Toast notification types.
enum ToastType {
  /// Success message with green accent.
  success,

  /// Error message with red accent.
  error,

  /// Warning message with orange accent.
  warning,

  /// Informational message with blue accent.
  info,
}

/// Extension methods for ToastType.
extension ToastTypeExtension on ToastType {
  /// The accent color for this toast type.
  Color get color => switch (this) {
        ToastType.success => AppColors.success,
        ToastType.error => AppColors.danger,
        ToastType.warning => AppColors.warning,
        ToastType.info => AppColors.brandBlue,
      };

  /// The icon for this toast type.
  IconData get icon => switch (this) {
        ToastType.success => Icons.check_circle_rounded,
        ToastType.error => Icons.error_rounded,
        ToastType.warning => Icons.warning_rounded,
        ToastType.info => Icons.info_rounded,
      };
}

/// An in-app toast notification widget.
///
/// Use [AppToast.show] to display a toast from anywhere in the app.
class AppToast extends StatelessWidget {
  const AppToast({
    super.key,
    required this.message,
    this.type = ToastType.info,
    this.action,
    this.actionLabel,
    this.onAction,
  });

  /// The message to display.
  final String message;

  /// The type/severity of the toast.
  final ToastType type;

  /// Optional action icon.
  final IconData? action;

  /// Optional action button label.
  final String? actionLabel;

  /// Callback when action is tapped.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: AppRadius.md,
        boxShadow: AppShadows.modal,
        border: Border(
          left: BorderSide(
            color: type.color,
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            type.icon,
            size: 20,
            color: type.color,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.body.copyWith(
                color: isDark ? AppColors.fg1Dark : AppColors.fg1,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actionLabel != null || action != null) ...[
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: onAction,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: action != null
                    ? Icon(
                        action,
                        size: 20,
                        color: type.color,
                      )
                    : Text(
                        actionLabel!,
                        style: TextStyle(
                          color: type.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Shows a toast notification.
  ///
  /// The toast appears at the bottom of the screen and auto-dismisses
  /// after [duration] (default 4 seconds).
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _ToastOverlay(
        message: message,
        type: type,
        actionLabel: actionLabel,
        onAction: () {
          entry.remove();
          onAction?.call();
        },
        onDismiss: () => entry.remove(),
        duration: duration,
      ),
    );

    overlay.insert(entry);
  }
}

class _ToastOverlay extends StatefulWidget {
  const _ToastOverlay({
    required this.message,
    required this.type,
    this.actionLabel,
    this.onAction,
    required this.onDismiss,
    required this.duration,
  });

  final String message;
  final ToastType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onDismiss;
  final Duration duration;

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      left: 0,
      right: 0,
      bottom: bottomPadding + AppSpacing.lg,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dy > 0) {
                _dismiss();
              }
            },
            child: AppToast(
              message: widget.message,
              type: widget.type,
              actionLabel: widget.actionLabel,
              onAction: widget.onAction,
            ),
          ),
        ),
      ),
    );
  }
}
