import 'dart:io' show Platform;

/// Configurable thresholds for gesture detection.
///
/// These constants define timing and distance thresholds used by
/// gesture recognizers to determine gesture type and validity.
class GestureSettings {
  GestureSettings._();

  // ============================================
  // Timing thresholds
  // ============================================

  /// Duration required for long press activation.
  static const Duration longPressDuration = Duration(milliseconds: 500);

  /// Maximum time between taps for double-tap detection.
  static const Duration doubleTapTimeout = Duration(milliseconds: 300);

  /// Minimum duration for a gesture to be considered intentional.
  static const Duration minGestureDuration = Duration(milliseconds: 50);

  // ============================================
  // Distance thresholds (in logical pixels)
  // ============================================

  /// Maximum movement allowed while still counting as a tap.
  static const double tapSlop = 18.0;

  /// Minimum distance required to trigger a swipe.
  static const double swipeThreshold = 50.0;

  /// Minimum distance for lasso points sampling.
  static const double lassoPointDistance = 5.0;

  /// Maximum lasso points before simplification.
  static const int lassoSimplifyThreshold = 100;

  // ============================================
  // Velocity thresholds (in pixels per second)
  // ============================================

  /// Minimum velocity required for a flick gesture.
  static const double flickVelocity = 1000.0;

  /// Velocity for fast flick (e.g., for Orbit Favorites).
  static const double fastFlickVelocity = 1500.0;

  // ============================================
  // Directional thresholds
  // ============================================

  /// Ratio of primary/secondary axis for directional gestures.
  /// If dy/dx > this ratio, gesture is vertical.
  static const double directionalRatio = 1.5;

  // ============================================
  // Multi-touch thresholds
  // ============================================

  /// Minimum spread between pointers for multi-touch.
  static const double pointerSpreadMin = 20.0;

  /// Minimum scale change to trigger zoom callback.
  static const double minScaleChange = 0.01;

  /// Minimum rotation change (radians) to trigger rotation callback.
  static const double minRotationChange = 0.01;

  // ============================================
  // Platform-specific adjustments
  // ============================================

  /// Scroll delta multiplier (mouse scrolls in "lines", touch in pixels).
  static double get scrollMultiplier {
    if (Platform.isMacOS) return 1.0;
    if (Platform.isWindows) return 3.0;
    if (Platform.isLinux) return 3.0;
    return 1.0; // iOS/Android
  }

  /// Whether force touch is potentially available.
  static bool get mayHaveForceTouch => Platform.isMacOS;

  /// Whether trackpad gestures are likely available.
  static bool get mayHaveTrackpad =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;
}
