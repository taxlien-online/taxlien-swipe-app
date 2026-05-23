import 'package:flutter/material.dart';
import 'tutorial_card.dart';

/// Animated hint overlay showing swipe direction
class SwipeHintOverlay extends StatefulWidget {
  final SwipeDirection direction;
  final String hint;

  const SwipeHintOverlay({
    super.key,
    required this.direction,
    required this.hint,
  });

  @override
  State<SwipeHintOverlay> createState() => _SwipeHintOverlayState();
}

class _SwipeHintOverlayState extends State<SwipeHintOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHorizontal =
        widget.direction == SwipeDirection.left || widget.direction == SwipeDirection.right;
    final isPositive =
        widget.direction == SwipeDirection.right || widget.direction == SwipeDirection.down;

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final offset = isHorizontal
              ? Offset(isPositive ? _animation.value : -_animation.value, 0)
              : Offset(0, isPositive ? _animation.value : -_animation.value);

          return Transform.translate(
            offset: offset + _getBaseOffset(),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.direction == SwipeDirection.left)
                    const Icon(Icons.arrow_back, color: Colors.white),
                  Text(
                    widget.hint,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  if (widget.direction == SwipeDirection.right)
                    const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Offset _getBaseOffset() {
    switch (widget.direction) {
      case SwipeDirection.left:
        return const Offset(-180, 0);
      case SwipeDirection.right:
        return const Offset(180, 0);
      case SwipeDirection.up:
        return const Offset(0, -180);
      case SwipeDirection.down:
        return const Offset(0, 180);
    }
  }
}
