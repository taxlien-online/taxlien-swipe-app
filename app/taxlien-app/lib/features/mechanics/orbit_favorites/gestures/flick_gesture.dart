import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/triage_board.dart';

/// Details about a directional flick gesture.
class DirectionalFlickDetails {
  const DirectionalFlickDetails({
    required this.zone,
    required this.velocity,
    required this.angle,
  });

  final TriageZone zone;
  final Velocity velocity;
  final double angle; // in degrees
}

/// Callback for directional flick events.
typedef DirectionalFlickCallback = void Function(DirectionalFlickDetails details);

/// Gesture recognizer for flick gestures that map to triage zones.
class DirectionalFlickGestureRecognizer extends OneSequenceGestureRecognizer {
  DirectionalFlickGestureRecognizer({
    this.onFlick,
    this.minVelocity = 500.0,
  });

  DirectionalFlickCallback? onFlick;
  final double minVelocity;

  Offset? _startPosition;
  final _velocityTracker = VelocityTracker.withKind(PointerDeviceKind.touch);

  @override
  void addPointer(PointerDownEvent event) {
    _startPosition = event.position;
    startTrackingPointer(event.pointer);
    resolve(GestureDisposition.accepted);
  }

  @override
  void handleEvent(PointerEvent event) {
    _velocityTracker.addPosition(event.timeStamp, event.position);

    if (event is PointerUpEvent && _startPosition != null) {
      _checkFlick(event);
      _startPosition = null;
    }
  }

  void _checkFlick(PointerUpEvent event) {
    final velocity = _velocityTracker.getVelocity();
    final speed = velocity.pixelsPerSecond.distance;

    if (speed >= minVelocity) {
      // Calculate angle from velocity
      final angle = math.atan2(
            velocity.pixelsPerSecond.dy,
            velocity.pixelsPerSecond.dx,
          ) *
          180 /
          math.pi;

      final zone = TriageZone.fromAngle(angle);

      onFlick?.call(DirectionalFlickDetails(
        zone: zone,
        velocity: velocity,
        angle: angle,
      ));
    }
  }

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  String get debugDescription => 'directional_flick';
}

/// A widget that detects directional flick gestures.
class DirectionalFlickDetector extends StatelessWidget {
  const DirectionalFlickDetector({
    super.key,
    required this.child,
    this.onFlick,
    this.onFlickToZone,
    this.minVelocity = 500.0,
  });

  final Widget child;
  final DirectionalFlickCallback? onFlick;
  final void Function(TriageZone zone)? onFlickToZone;
  final double minVelocity;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        DirectionalFlickGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<DirectionalFlickGestureRecognizer>(
          () => DirectionalFlickGestureRecognizer(minVelocity: minVelocity),
          (instance) {
            instance.onFlick = (details) {
              onFlick?.call(details);
              onFlickToZone?.call(details.zone);
            };
          },
        ),
      },
      child: child,
    );
  }
}
