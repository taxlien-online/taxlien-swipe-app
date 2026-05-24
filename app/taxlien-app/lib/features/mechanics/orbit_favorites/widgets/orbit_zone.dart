import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/triage_board.dart';

/// A radial zone in the orbit triage UI.
class OrbitZone extends StatelessWidget {
  const OrbitZone({
    super.key,
    required this.zone,
    required this.count,
    this.isActive = false,
    this.radius = 60.0,
    this.onTap,
  });

  final TriageZone zone;
  final int count;
  final bool isActive;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? zone.color.withValues(alpha: 0.2)
              : theme.colorScheme.surface,
          border: Border.all(
            color: isActive ? zone.color : zone.color.withValues(alpha: 0.3),
            width: isActive ? 3 : 2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: zone.color.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              zone.icon,
              color: zone.color,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              zone.label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: zone.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: zone.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Paints the orbit zones layout.
class OrbitZonesPainter extends CustomPainter {
  OrbitZonesPainter({
    required this.zones,
    required this.activeZone,
    required this.centerRadius,
    required this.zoneRadius,
  });

  final List<TriageZone> zones;
  final TriageZone? activeZone;
  final double centerRadius;
  final double zoneRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw concentric circles
    for (var i = 1; i <= 3; i++) {
      paint.color = Colors.grey.withValues(alpha: 0.2);
      canvas.drawCircle(center, centerRadius + (zoneRadius * i * 0.3), paint);
    }

    // Draw zone sectors
    for (final zone in zones) {
      final startAngle = (zone.angle - 45) * math.pi / 180;
      final sweepAngle = 90 * math.pi / 180;

      paint
        ..color = zone == activeZone
            ? zone.color.withValues(alpha: 0.3)
            : zone.color.withValues(alpha: 0.1)
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: centerRadius + zoneRadius),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant OrbitZonesPainter oldDelegate) {
    return oldDelegate.activeZone != activeZone;
  }
}
