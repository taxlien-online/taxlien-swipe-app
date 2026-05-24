import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Builder widget that tracks hover state.
///
/// Use this to add hover effects to widgets on desktop/trackpad.
/// On touch devices, hover is not triggered.
///
/// Example:
/// ```dart
/// HoverBuilder(
///   cursor: SystemMouseCursors.click,
///   builder: (context, isHovered) {
///     return Container(
///       color: isHovered ? Colors.blue.shade100 : Colors.white,
///       child: Text('Hover me'),
///     );
///   },
/// )
/// ```
class HoverBuilder extends StatefulWidget {
  /// Builder function that receives hover state.
  final Widget Function(BuildContext context, bool isHovered) builder;

  /// Called when mouse enters the region.
  final VoidCallback? onEnter;

  /// Called when mouse exits the region.
  final VoidCallback? onExit;

  /// Cursor to show when hovering.
  final MouseCursor cursor;

  /// Whether to track hover on this widget.
  final bool enabled;

  const HoverBuilder({
    super.key,
    required this.builder,
    this.onEnter,
    this.onExit,
    this.cursor = SystemMouseCursors.basic,
    this.enabled = true,
  });

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.builder(context, false);
    }

    return MouseRegion(
      cursor: widget.cursor,
      onEnter: _onEnter,
      onExit: _onExit,
      child: widget.builder(context, _isHovered),
    );
  }

  void _onEnter(PointerEnterEvent event) {
    if (!_isHovered) {
      setState(() => _isHovered = true);
      widget.onEnter?.call();
    }
  }

  void _onExit(PointerExitEvent event) {
    if (_isHovered) {
      setState(() => _isHovered = false);
      widget.onExit?.call();
    }
  }
}

/// Widget that changes cursor based on state.
///
/// Example:
/// ```dart
/// CursorRegion(
///   cursor: isDragging
///     ? SystemMouseCursors.grabbing
///     : SystemMouseCursors.grab,
///   child: DraggableWidget(),
/// )
/// ```
class CursorRegion extends StatelessWidget {
  /// The cursor to display.
  final MouseCursor cursor;

  /// The child widget.
  final Widget child;

  /// Whether the cursor region is active.
  final bool enabled;

  const CursorRegion({
    super.key,
    required this.cursor,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return MouseRegion(
      cursor: cursor,
      child: child,
    );
  }
}
