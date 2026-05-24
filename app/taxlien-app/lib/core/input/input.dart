/// Unified input handling system for Tax Lien App.
///
/// Provides gesture detection, platform adapters, and input mode tracking
/// for touchscreen, trackpad, and mouse input.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:taxlien_swipe_app/core/input/input.dart';
///
/// UnifiedGestureDetector(
///   onTap: () => selectItem(),
///   onFlick: (details) => handleFlick(details),
///   onThreeFingerUpdate: (details) {
///     if (details.panDelta!.dy > 50) openCommandPalette();
///   },
///   child: MyCanvas(),
/// )
/// ```
///
/// ## Gesture Recognizers
///
/// - [FlickRecognizer] - Velocity-based flick gestures
/// - [DirectionalSwipeRecognizer] - Up/down/left/right swipes
/// - [LassoRecognizer] - Free-form selection
/// - [MultiTouchRecognizer] - 2/3/4 finger gestures
///
/// ## Platform Adapters
///
/// - [TouchAdapter] - iOS/Android touch input
/// - [TrackpadAdapter] - macOS/laptop trackpad
/// - [MouseAdapter] - Desktop mouse input
///
/// ## Widgets
///
/// - [UnifiedGestureDetector] - All-in-one gesture handling
/// - [HoverBuilder] - Hover state tracking
/// - [CursorRegion] - Dynamic cursor changes
/// - [KeyboardShortcutWrapper] - Keyboard shortcut handling
/// - [ArrowKeyNavigator] - List navigation with arrow keys
library;

// Providers
export 'providers/providers.dart';

// Recognizers
export 'recognizers/recognizers.dart';

// Adapters
export 'adapters/adapters.dart';

// Widgets
export 'widgets/widgets.dart';
