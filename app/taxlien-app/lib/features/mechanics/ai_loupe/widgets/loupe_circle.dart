import 'package:flutter/material.dart';

/// A circular magnifier overlay.
class LoupeCircle extends StatelessWidget {
  const LoupeCircle({
    super.key,
    required this.position,
    this.radius = 60.0,
    this.borderColor,
    this.isLoading = false,
    this.magnification = 1.5,
  });

  final Offset position;
  final double radius;
  final Color? borderColor;
  final bool isLoading;
  final double magnification;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = borderColor ?? theme.colorScheme.primary;

    return Positioned(
      left: position.dx - radius,
      top: position.dy - radius,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            children: [
              // Magnified content would go here
              Container(
                color: theme.colorScheme.surface.withValues(alpha: 0.9),
              ),
              // Loading indicator
              if (isLoading)
                Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  ),
                ),
              // Crosshairs
              if (!isLoading) ...[
                Center(
                  child: Container(
                    width: 1,
                    height: radius * 0.5,
                    color: color.withValues(alpha: 0.5),
                  ),
                ),
                Center(
                  child: Container(
                    width: radius * 0.5,
                    height: 1,
                    color: color.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A loupe with animated appearance.
class AnimatedLoupeCircle extends StatefulWidget {
  const AnimatedLoupeCircle({
    super.key,
    required this.position,
    this.radius = 60.0,
    this.borderColor,
    this.isLoading = false,
    this.isVisible = true,
  });

  final Offset position;
  final double radius;
  final Color? borderColor;
  final bool isLoading;
  final bool isVisible;

  @override
  State<AnimatedLoupeCircle> createState() => _AnimatedLoupeCircleState();
}

class _AnimatedLoupeCircleState extends State<AnimatedLoupeCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedLoupeCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
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
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: LoupeCircle(
              position: widget.position,
              radius: widget.radius,
              borderColor: widget.borderColor,
              isLoading: widget.isLoading,
            ),
          ),
        );
      },
    );
  }
}
