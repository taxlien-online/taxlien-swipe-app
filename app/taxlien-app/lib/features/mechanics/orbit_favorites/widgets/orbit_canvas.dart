import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/triage_board.dart';
import 'flick_card.dart';
import 'orbit_zone.dart';

/// A canvas for the orbit triage UI with radial zones.
class OrbitCanvas extends StatefulWidget {
  const OrbitCanvas({
    super.key,
    required this.board,
    this.onFlick,
    this.onCardTap,
    this.onZoneTap,
    this.centerRadius = 100.0,
    this.zoneRadius = 80.0,
  });

  final TriageBoard board;
  final void Function(TriageCard card, TriageZone zone)? onFlick;
  final void Function(TriageCard card)? onCardTap;
  final void Function(TriageZone zone)? onZoneTap;
  final double centerRadius;
  final double zoneRadius;

  @override
  State<OrbitCanvas> createState() => _OrbitCanvasState();
}

class _OrbitCanvasState extends State<OrbitCanvas>
    with TickerProviderStateMixin {
  TriageZone? _activeZone;
  Offset? _flickDirection;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onCardFlick(TriageZone zone, Velocity velocity) {
    final card = widget.board.currentCard;
    if (card != null) {
      widget.onFlick?.call(card, zone);
    }
  }

  void _updateActiveZone(Offset? direction) {
    if (direction == null) {
      setState(() {
        _activeZone = null;
        _flickDirection = null;
      });
      return;
    }

    final angle = math.atan2(direction.dy, direction.dx) * 180 / math.pi;
    setState(() {
      _activeZone = TriageZone.fromAngle(angle);
      _flickDirection = direction;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final center = Offset(size.width / 2, size.height / 2);

        return Stack(
          children: [
            // Background with zones
            CustomPaint(
              size: size,
              painter: OrbitZonesPainter(
                zones: TriageZone.values,
                activeZone: _activeZone,
                centerRadius: widget.centerRadius,
                zoneRadius: widget.zoneRadius,
              ),
            ),

            // Zone widgets
            ...TriageZone.values.map((zone) {
              final angle = zone.angle * math.pi / 180;
              final distance = widget.centerRadius + widget.zoneRadius + 20;
              final position = Offset(
                center.dx + distance * math.cos(angle) - widget.zoneRadius / 2,
                center.dy + distance * math.sin(angle) - widget.zoneRadius / 2,
              );

              return Positioned(
                left: position.dx,
                top: position.dy,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: zone == _activeZone ? _pulseAnimation.value : 1.0,
                      child: OrbitZone(
                        zone: zone,
                        count: widget.board.countForZone(zone),
                        isActive: zone == _activeZone,
                        radius: widget.zoneRadius / 2,
                        onTap: () => widget.onZoneTap?.call(zone),
                      ),
                    );
                  },
                ),
              );
            }),

            // Center card
            if (widget.board.currentCard != null)
              Positioned(
                left: center.dx - 80,
                top: center.dy - 100,
                child: Listener(
                  onPointerMove: (event) {
                    _updateActiveZone(event.delta);
                  },
                  onPointerUp: (_) {
                    _updateActiveZone(null);
                  },
                  child: FlickCard(
                    card: widget.board.currentCard!,
                    onFlick: _onCardFlick,
                    onTap: () =>
                        widget.onCardTap?.call(widget.board.currentCard!),
                  ),
                ),
              ),

            // Remaining count indicator
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    '${widget.board.remainingCount} remaining',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
