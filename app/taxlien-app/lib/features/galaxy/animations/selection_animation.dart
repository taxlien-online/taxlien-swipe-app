import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_durations.dart';

/// Painter for selection pulse effect on selected properties
class SelectionPulsePainter extends CustomPainter {
  final List<Offset> selectedPositions;
  final double animationValue;
  final double baseRadius;

  SelectionPulsePainter({
    required this.selectedPositions,
    required this.animationValue,
    this.baseRadius = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final position in selectedPositions) {
      _drawPulse(canvas, position);
    }
  }

  void _drawPulse(Canvas canvas, Offset center) {
    // Outer pulse ring
    final pulseRadius = baseRadius + (animationValue * 15);
    final pulseOpacity = (1 - animationValue) * 0.4;

    final pulsePaint = Paint()
      ..color = AppColors.selected.withOpacity(pulseOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, pulseRadius, pulsePaint);

    // Inner glow
    final glowPaint = Paint()
      ..color = AppColors.selected.withOpacity(0.1 + (animationValue * 0.1))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, baseRadius + 4, glowPaint);
  }

  @override
  bool shouldRepaint(SelectionPulsePainter oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
        selectedPositions != oldDelegate.selectedPositions;
  }
}

/// Widget that adds pulse animation to selected items
class SelectionPulseOverlay extends StatefulWidget {
  final List<Offset> selectedPositions;
  final double baseRadius;
  final bool enabled;

  const SelectionPulseOverlay({
    super.key,
    required this.selectedPositions,
    this.baseRadius = 20.0,
    this.enabled = true,
  });

  @override
  State<SelectionPulseOverlay> createState() => _SelectionPulseOverlayState();
}

class _SelectionPulseOverlayState extends State<SelectionPulseOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.selectionPulse,
    )..repeat();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || widget.selectedPositions.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return CustomPaint(
          painter: SelectionPulsePainter(
            selectedPositions: widget.selectedPositions,
            animationValue: _animation.value,
            baseRadius: widget.baseRadius,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Animated checkmark for selection feedback
class SelectionCheckmark extends StatefulWidget {
  final bool isSelected;
  final double size;

  const SelectionCheckmark({
    super.key,
    required this.isSelected,
    this.size = 24.0,
  });

  @override
  State<SelectionCheckmark> createState() => _SelectionCheckmarkState();
}

class _SelectionCheckmarkState extends State<SelectionCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(SelectionCheckmark oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: AppColors.selected,
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              painter: _CheckmarkPainter(progress: _checkAnimation.value),
            ),
          ),
        );
      },
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;

  _CheckmarkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Checkmark points
    final start = Offset(centerX - 5, centerY);
    final mid = Offset(centerX - 1, centerY + 4);
    final end = Offset(centerX + 6, centerY - 4);

    path.moveTo(start.dx, start.dy);

    if (progress < 0.5) {
      // First half: draw to mid point
      final t = progress * 2;
      final x = start.dx + (mid.dx - start.dx) * t;
      final y = start.dy + (mid.dy - start.dy) * t;
      path.lineTo(x, y);
    } else {
      // Second half: draw to end point
      path.lineTo(mid.dx, mid.dy);
      final t = (progress - 0.5) * 2;
      final x = mid.dx + (end.dx - mid.dx) * t;
      final y = mid.dy + (end.dy - mid.dy) * t;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

/// Ripple effect when tapping a property
class PropertyTapRipple extends StatefulWidget {
  final Offset position;
  final VoidCallback? onComplete;

  const PropertyTapRipple({
    super.key,
    required this.position,
    this.onComplete,
  });

  @override
  State<PropertyTapRipple> createState() => _PropertyTapRippleState();
}

class _PropertyTapRippleState extends State<PropertyTapRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward().then((_) => widget.onComplete?.call());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _RipplePainter(
            center: widget.position,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _RipplePainter extends CustomPainter {
  final Offset center;
  final double progress;

  _RipplePainter({required this.center, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = 50 * progress;
    final opacity = (1 - progress) * 0.3;

    final paint = Paint()
      ..color = AppColors.brandBlue.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) =>
      progress != oldDelegate.progress || center != oldDelegate.center;
}
