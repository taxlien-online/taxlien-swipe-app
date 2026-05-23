import 'package:flutter/material.dart';

enum SwipeDirection { left, right, up, down }

/// Demo card for tutorial with swipe detection
class TutorialCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function(SwipeDirection) onSwipe;

  const TutorialCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onSwipe,
  });

  @override
  State<TutorialCard> createState() => _TutorialCardState();
}

class _TutorialCardState extends State<TutorialCard> {
  Offset _dragOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _dragOffset += details.delta;
        });
      },
      onPanEnd: (details) {
        _handleSwipe();
        setState(() {
          _dragOffset = Offset.zero;
        });
      },
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: _dragOffset.dx * 0.001,
          child: Container(
            width: 280,
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Image placeholder
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.home,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                // Info section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.subtitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSwipe() {
    const threshold = 80.0;

    if (_dragOffset.dx.abs() > _dragOffset.dy.abs()) {
      // Horizontal swipe
      if (_dragOffset.dx > threshold) {
        widget.onSwipe(SwipeDirection.right);
      } else if (_dragOffset.dx < -threshold) {
        widget.onSwipe(SwipeDirection.left);
      }
    } else {
      // Vertical swipe
      if (_dragOffset.dy > threshold) {
        widget.onSwipe(SwipeDirection.down);
      } else if (_dragOffset.dy < -threshold) {
        widget.onSwipe(SwipeDirection.up);
      }
    }
  }
}
