import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/design/app_spacing.dart';

/// Gesture detector for two-finger rotation to change dimension
/// Rotate clockwise -> next dimension
/// Rotate counter-clockwise -> previous dimension
class DimensionWheelGesture extends StatefulWidget {
  final Widget child;
  final VoidCallback? onNextDimension;
  final VoidCallback? onPreviousDimension;
  final void Function(double rotation)? onRotationUpdate;
  final bool enabled;
  final double rotationThreshold; // Degrees needed to trigger dimension change

  const DimensionWheelGesture({
    super.key,
    required this.child,
    this.onNextDimension,
    this.onPreviousDimension,
    this.onRotationUpdate,
    this.enabled = true,
    this.rotationThreshold = 45.0, // 45 degrees to switch
  });

  @override
  State<DimensionWheelGesture> createState() => _DimensionWheelGestureState();
}

class _DimensionWheelGestureState extends State<DimensionWheelGesture> {
  double _accumulatedRotation = 0;
  double? _lastRotation;
  Offset? _finger1Start;
  Offset? _finger2Start;
  bool _isRotating = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: widget.child,
    );
  }

  final Map<int, Offset> _activePointers = {};

  void _handlePointerDown(PointerDownEvent event) {
    _activePointers[event.pointer] = event.localPosition;

    if (_activePointers.length == 2) {
      // Two fingers detected, start rotation tracking
      final pointers = _activePointers.values.toList();
      _finger1Start = pointers[0];
      _finger2Start = pointers[1];

      // Check minimum finger separation
      final distance = (_finger1Start! - _finger2Start!).distance;
      if (distance < AppSpacing.galaxyMinFingerSeparation) {
        _resetRotation();
        return;
      }

      _isRotating = true;
      _lastRotation = _calculateRotation(pointers[0], pointers[1]);
      _accumulatedRotation = 0;

      HapticFeedback.selectionClick();
    }
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!_activePointers.containsKey(event.pointer)) return;
    _activePointers[event.pointer] = event.localPosition;

    if (!_isRotating || _activePointers.length != 2) return;

    final pointers = _activePointers.values.toList();
    final currentRotation = _calculateRotation(pointers[0], pointers[1]);

    if (_lastRotation != null) {
      var delta = currentRotation - _lastRotation!;

      // Handle wraparound
      if (delta > 180) delta -= 360;
      if (delta < -180) delta += 360;

      _accumulatedRotation += delta;
      widget.onRotationUpdate?.call(_accumulatedRotation);

      // Check if threshold reached
      if (_accumulatedRotation >= widget.rotationThreshold) {
        // Clockwise rotation -> next dimension
        widget.onNextDimension?.call();
        HapticFeedback.mediumImpact();
        _accumulatedRotation = 0;
      } else if (_accumulatedRotation <= -widget.rotationThreshold) {
        // Counter-clockwise -> previous dimension
        widget.onPreviousDimension?.call();
        HapticFeedback.mediumImpact();
        _accumulatedRotation = 0;
      }
    }

    _lastRotation = currentRotation;
  }

  void _handlePointerUp(PointerUpEvent event) {
    _activePointers.remove(event.pointer);
    if (_activePointers.length < 2) {
      _resetRotation();
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _activePointers.remove(event.pointer);
    if (_activePointers.length < 2) {
      _resetRotation();
    }
  }

  void _resetRotation() {
    _isRotating = false;
    _lastRotation = null;
    _finger1Start = null;
    _finger2Start = null;
    _accumulatedRotation = 0;
  }

  double _calculateRotation(Offset p1, Offset p2) {
    final angle = math.atan2(p2.dy - p1.dy, p2.dx - p1.dx);
    return angle * 180 / math.pi;
  }
}

/// Visual indicator for rotation gesture feedback
class RotationIndicator extends StatelessWidget {
  final double rotation;
  final double threshold;
  final bool isActive;

  const RotationIndicator({
    super.key,
    required this.rotation,
    required this.threshold,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) return const SizedBox.shrink();

    final progress = (rotation.abs() / threshold).clamp(0.0, 1.0);
    final isClockwise = rotation > 0;

    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black54,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Progress arc
            CustomPaint(
              size: const Size(80, 80),
              painter: _ArcPainter(
                progress: progress,
                isClockwise: isClockwise,
              ),
            ),
            // Center icon
            Icon(
              isClockwise ? Icons.rotate_right : Icons.rotate_left,
              color: Colors.white,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final bool isClockwise;

  _ArcPainter({required this.progress, required this.isClockwise});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Background circle
    final bgPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final startAngle = -math.pi / 2;
    final sweepAngle = progress * math.pi / 2 * (isClockwise ? 1 : -1);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) =>
      progress != oldDelegate.progress || isClockwise != oldDelegate.isClockwise;
}
