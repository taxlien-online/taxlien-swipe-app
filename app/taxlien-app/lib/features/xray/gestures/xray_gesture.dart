import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/design/app_durations.dart';

/// Gesture detector for activating X-Ray mode
/// Two-finger swipe down to activate, swipe up to deactivate
class XRayGestureDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onActivate;
  final VoidCallback? onDeactivate;
  final bool isActive;
  final bool enabled;

  const XRayGestureDetector({
    super.key,
    required this.child,
    this.onActivate,
    this.onDeactivate,
    this.isActive = false,
    this.enabled = true,
  });

  @override
  State<XRayGestureDetector> createState() => _XRayGestureDetectorState();
}

class _XRayGestureDetectorState extends State<XRayGestureDetector> {
  final Map<int, Offset> _activePointers = {};
  Offset? _startPosition1;
  Offset? _startPosition2;
  bool _gestureStarted = false;

  static const double _activationThreshold = 50.0;

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

  void _handlePointerDown(PointerDownEvent event) {
    _activePointers[event.pointer] = event.localPosition;

    if (_activePointers.length == 2) {
      final positions = _activePointers.values.toList();
      _startPosition1 = positions[0];
      _startPosition2 = positions[1];
      _gestureStarted = true;
    }
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!_activePointers.containsKey(event.pointer)) return;
    _activePointers[event.pointer] = event.localPosition;

    if (!_gestureStarted || _activePointers.length != 2) return;
    if (_startPosition1 == null || _startPosition2 == null) return;

    final positions = _activePointers.values.toList();
    final current1 = positions[0];
    final current2 = positions[1];

    // Calculate vertical movement for both fingers
    final delta1 = current1.dy - _startPosition1!.dy;
    final delta2 = current2.dy - _startPosition2!.dy;

    // Both fingers should move in same direction
    if ((delta1 > 0) != (delta2 > 0)) return;

    final avgDelta = (delta1 + delta2) / 2;

    if (avgDelta > _activationThreshold && !widget.isActive) {
      // Swipe down - activate
      _triggerActivate();
    } else if (avgDelta < -_activationThreshold && widget.isActive) {
      // Swipe up - deactivate
      _triggerDeactivate();
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    _activePointers.remove(event.pointer);
    if (_activePointers.length < 2) {
      _resetGesture();
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _activePointers.remove(event.pointer);
    if (_activePointers.length < 2) {
      _resetGesture();
    }
  }

  void _triggerActivate() {
    _resetGesture();
    HapticFeedback.mediumImpact();
    widget.onActivate?.call();
  }

  void _triggerDeactivate() {
    _resetGesture();
    HapticFeedback.lightImpact();
    widget.onDeactivate?.call();
  }

  void _resetGesture() {
    _gestureStarted = false;
    _startPosition1 = null;
    _startPosition2 = null;
  }
}

/// Visual feedback widget for X-Ray activation
class XRayActivationIndicator extends StatefulWidget {
  final bool isActive;
  final bool isActivating;

  const XRayActivationIndicator({
    super.key,
    required this.isActive,
    this.isActivating = false,
  });

  @override
  State<XRayActivationIndicator> createState() => _XRayActivationIndicatorState();
}

class _XRayActivationIndicatorState extends State<XRayActivationIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.xrayActivate,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(XRayActivationIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
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
      animation: _animation,
      builder: (context, child) {
        if (_animation.value == 0) return const SizedBox.shrink();

        return Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.cyan.withOpacity(0.5 * _animation.value),
                  width: 3,
                ),
              ),
              child: CustomPaint(
                painter: _ScanLinePainter(
                  progress: _animation.value,
                  isActive: widget.isActive,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ScanLinePainter extends CustomPainter {
  final double progress;
  final bool isActive;

  _ScanLinePainter({required this.progress, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isActive) return;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.cyan.withOpacity(0.3),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 100));

    final y = (progress * 2 % 1) * size.height;
    canvas.drawRect(
      Rect.fromLTWH(0, y - 50, size.width, 100),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ScanLinePainter oldDelegate) =>
      progress != oldDelegate.progress || isActive != oldDelegate.isActive;
}
