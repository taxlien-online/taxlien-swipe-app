import 'package:flutter/material.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_typography.dart';

/// Empty state when no properties to display
class GalaxyEmptyState extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onAction;
  final String? actionLabel;
  final EmptyStateType type;

  const GalaxyEmptyState({
    super.key,
    this.title,
    this.message,
    this.onAction,
    this.actionLabel,
    this.type = EmptyStateType.noData,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            SizedBox(height: AppSpacing.lg),
            Text(
              title ?? _defaultTitle,
              style: AppTypography.screenTitle.copyWith(color: AppColors.fg1),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              message ?? _defaultMessage,
              style: AppTypography.secondary.copyWith(color: AppColors.fg2),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandBlue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final iconData = switch (type) {
      EmptyStateType.noData => Icons.scatter_plot_outlined,
      EmptyStateType.noSelection => Icons.touch_app_outlined,
      EmptyStateType.noMatches => Icons.search_off,
      EmptyStateType.error => Icons.error_outline,
      EmptyStateType.loading => Icons.hourglass_empty,
      EmptyStateType.offline => Icons.cloud_off,
    };

    final color = switch (type) {
      EmptyStateType.error => AppColors.danger,
      EmptyStateType.offline => AppColors.warning,
      _ => AppColors.fg2,
    };

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 40, color: color),
    );
  }

  String get _defaultTitle => switch (type) {
        EmptyStateType.noData => 'No Properties',
        EmptyStateType.noSelection => 'No Selection',
        EmptyStateType.noMatches => 'No Matches',
        EmptyStateType.error => 'Something Went Wrong',
        EmptyStateType.loading => 'Loading...',
        EmptyStateType.offline => 'You\'re Offline',
      };

  String get _defaultMessage => switch (type) {
        EmptyStateType.noData =>
          'There are no properties to display. Try adjusting your filters.',
        EmptyStateType.noSelection =>
          'Tap a property to select it, or draw a lasso to select multiple.',
        EmptyStateType.noMatches =>
          'No properties match your search criteria. Try different keywords.',
        EmptyStateType.error =>
          'We couldn\'t load the data. Please try again.',
        EmptyStateType.loading =>
          'Please wait while we load your properties...',
        EmptyStateType.offline =>
          'Connect to the internet to see the latest properties.',
      };
}

enum EmptyStateType {
  noData,
  noSelection,
  noMatches,
  error,
  loading,
  offline,
}

/// Loading state with animated placeholder
class GalaxyLoadingState extends StatefulWidget {
  final String? message;

  const GalaxyLoadingState({super.key, this.message});

  @override
  State<GalaxyLoadingState> createState() => _GalaxyLoadingStateState();
}

class _GalaxyLoadingStateState extends State<GalaxyLoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(100, 100),
                painter: _LoadingPainter(progress: _controller.value),
              );
            },
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            widget.message ?? 'Loading properties...',
            style: AppTypography.secondary.copyWith(color: AppColors.fg2),
          ),
        ],
      ),
    );
  }
}

class _LoadingPainter extends CustomPainter {
  final double progress;

  _LoadingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw orbiting dots
    for (int i = 0; i < 8; i++) {
      final angle = (progress * 2 * 3.14159) + (i * 3.14159 / 4);
      final radius = 30.0;
      final dotSize = 4.0 + (((i + progress * 8) % 8) / 8 * 4);
      final opacity = 0.3 + (((i + progress * 8) % 8) / 8 * 0.7);

      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      final paint = Paint()
        ..color = AppColors.brandBlue.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), dotSize, paint);
    }
  }

  double cos(double x) => _cos(x);
  double sin(double x) => _sin(x);

  @override
  bool shouldRepaint(_LoadingPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

double _cos(double x) {
  // Taylor series approximation
  x = x % (2 * 3.14159);
  double result = 1;
  double term = 1;
  for (int i = 1; i <= 10; i++) {
    term *= -x * x / (2 * i * (2 * i - 1));
    result += term;
  }
  return result;
}

double _sin(double x) {
  x = x % (2 * 3.14159);
  double result = x;
  double term = x;
  for (int i = 1; i <= 10; i++) {
    term *= -x * x / (2 * i * (2 * i + 1));
    result += term;
  }
  return result;
}

/// Error state with retry option
class GalaxyErrorState extends StatelessWidget {
  final String? error;
  final VoidCallback? onRetry;

  const GalaxyErrorState({
    super.key,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return GalaxyEmptyState(
      type: EmptyStateType.error,
      message: error,
      onAction: onRetry,
      actionLabel: 'Retry',
    );
  }
}

/// Offline state
class GalaxyOfflineState extends StatelessWidget {
  final VoidCallback? onRetry;

  const GalaxyOfflineState({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return GalaxyEmptyState(
      type: EmptyStateType.offline,
      onAction: onRetry,
      actionLabel: 'Retry',
    );
  }
}
