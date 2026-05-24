import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/triage_board.dart';

/// A draggable card for the orbit triage UI.
class FlickCard extends StatefulWidget {
  const FlickCard({
    super.key,
    required this.card,
    this.onFlick,
    this.onTap,
    this.size = const Size(160, 200),
  });

  final TriageCard card;
  final void Function(TriageZone zone, Velocity velocity)? onFlick;
  final VoidCallback? onTap;
  final Size size;

  @override
  State<FlickCard> createState() => _FlickCardState();
}

class _FlickCardState extends State<FlickCard>
    with SingleTickerProviderStateMixin {
  Offset _position = Offset.zero;
  double _rotation = 0.0;
  late AnimationController _animationController;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position += details.delta;
      // Rotate based on horizontal movement
      _rotation = (_position.dx / 200).clamp(-0.3, 0.3);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;
    final speed = velocity.distance;

    // Flick threshold: 500 px/s
    if (speed > 500) {
      // Calculate angle from velocity
      final angle =
          math.atan2(velocity.dy, velocity.dx) * 180 / math.pi;
      final zone = TriageZone.fromAngle(angle);

      widget.onFlick?.call(zone, details.velocity);
      return;
    }

    // Snap back to center
    _positionAnimation = Tween<Offset>(
      begin: _position,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _rotationAnimation = Tween<double>(
      begin: _rotation,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward(from: 0.0).then((_) {
      setState(() {
        _position = Offset.zero;
        _rotation = 0.0;
      });
    });

    _animationController.addListener(() {
      setState(() {
        _position = _positionAnimation.value;
        _rotation = _rotationAnimation.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Transform.translate(
      offset: _position,
      child: Transform.rotate(
        angle: _rotation,
        child: GestureDetector(
          onTap: widget.onTap,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Container(
            width: widget.size.width,
            height: widget.size.height,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Thumbnail
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: widget.card.thumbnailUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              widget.card.thumbnailUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.home,
                            size: 40,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                  ),
                ),
                // Info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.card.address,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getFviColor(widget.card.fviScore),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'FVI ${widget.card.fviScore.toStringAsFixed(0)}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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

  Color _getFviColor(double score) {
    if (score >= 80) return const Color(0xFF059669);
    if (score >= 60) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }
}
