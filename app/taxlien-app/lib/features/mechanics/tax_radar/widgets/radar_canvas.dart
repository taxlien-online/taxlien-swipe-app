import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/counterparty.dart';
import 'counterparty_node.dart';

/// A radar-style canvas showing counterparties around a central hub.
class RadarCanvas extends StatefulWidget {
  const RadarCanvas({
    super.key,
    required this.state,
    this.onCounterpartyTap,
    this.onSweepComplete,
    this.ringCount = 3,
  });

  final TaxRadarState state;
  final void Function(Counterparty counterparty)? onCounterpartyTap;
  final VoidCallback? onSweepComplete;
  final int ringCount;

  @override
  State<RadarCanvas> createState() => _RadarCanvasState();
}

class _RadarCanvasState extends State<RadarCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _sweepController;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    if (widget.state.isScanning) {
      _startSweep();
    }
  }

  @override
  void didUpdateWidget(RadarCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.isScanning && !oldWidget.state.isScanning) {
      _startSweep();
    } else if (!widget.state.isScanning && oldWidget.state.isScanning) {
      _sweepController.stop();
    }
  }

  void _startSweep() {
    _sweepController.repeat().then((_) {
      widget.onSweepComplete?.call();
    });
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final center = Offset(size.width / 2, size.height / 2);
        final maxRadius = math.min(size.width, size.height) / 2 - 40;

        return Stack(
          children: [
            // Radar background
            AnimatedBuilder(
              animation: _sweepController,
              builder: (context, child) {
                return CustomPaint(
                  size: size,
                  painter: _RadarPainter(
                    ringCount: widget.ringCount,
                    sweepAngle: _sweepController.value * 2 * math.pi,
                    isScanning: widget.state.isScanning,
                  ),
                );
              },
            ),

            // Center hub (user)
            Positioned(
              left: center.dx - 30,
              top: center.dy - 30,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.5),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),

            // Counterparty nodes
            ...widget.state.visibleCounterparties.map((counterparty) {
              final angle = counterparty.angle * math.pi / 180;
              final distance = maxRadius * counterparty.distance;
              final position = Offset(
                center.dx + distance * math.cos(angle),
                center.dy + distance * math.sin(angle),
              );

              return Positioned(
                left: position.dx - counterparty.nodeSize / 2,
                top: position.dy - counterparty.nodeSize / 2,
                child: CounterpartyNode(
                  counterparty: counterparty,
                  isSelected:
                      counterparty.id == widget.state.selectedCounterpartyId,
                  onTap: () => widget.onCounterpartyTap?.call(counterparty),
                ),
              );
            }),

            // Selected counterparty tooltip
            if (widget.state.selectedCounterparty != null)
              Positioned(
                left: 16,
                bottom: 16,
                right: 16,
                child: CounterpartyTooltip(
                  counterparty: widget.state.selectedCounterparty!,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({
    required this.ringCount,
    required this.sweepAngle,
    required this.isScanning,
  });

  final int ringCount;
  final double sweepAngle;
  final bool isScanning;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2 - 40;

    // Draw grid rings
    final ringPaint = Paint()
      ..color = Colors.green.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 1; i <= ringCount; i++) {
      final radius = maxRadius * (i / ringCount);
      canvas.drawCircle(center, radius, ringPaint);
    }

    // Draw cross lines
    canvas.drawLine(
      Offset(center.dx - maxRadius, center.dy),
      Offset(center.dx + maxRadius, center.dy),
      ringPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - maxRadius),
      Offset(center.dx, center.dy + maxRadius),
      ringPaint,
    );

    // Draw sweep line if scanning
    if (isScanning) {
      final sweepPaint = Paint()
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: sweepAngle - 0.5,
          endAngle: sweepAngle,
          colors: [
            Colors.green.withValues(alpha: 0.0),
            Colors.green.withValues(alpha: 0.3),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

      canvas.drawCircle(center, maxRadius, sweepPaint);

      // Draw sweep line
      final linePaint = Paint()
        ..color = Colors.green.withValues(alpha: 0.8)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final endX = center.dx + maxRadius * math.cos(sweepAngle);
      final endY = center.dy + maxRadius * math.sin(sweepAngle);
      canvas.drawLine(center, Offset(endX, endY), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.isScanning != isScanning;
  }
}
