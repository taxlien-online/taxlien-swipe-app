import 'package:flutter/material.dart';
import '../design/design.dart';

/// Visual states for a GalaxyDot.
enum GalaxyDotState {
  /// Default state with solid circle.
  normal,

  /// Selected state with outer ring.
  selected,

  /// Hovered state with glow effect.
  hovered,

  /// Watchlisted state with halo.
  watchlisted,
}

/// A single dot on the galaxy visualization representing a property.
///
/// Position is given as percentages (0-100) for responsive layouts.
/// Size can vary based on property value or other metrics.
class GalaxyDot extends StatelessWidget {
  const GalaxyDot({
    super.key,
    required this.x,
    required this.y,
    this.size = 8,
    this.color,
    this.state = GalaxyDotState.normal,
    this.onTap,
  });

  /// X position as percentage (0-100).
  final double x;

  /// Y position as percentage (0-100).
  final double y;

  /// Dot diameter (4-16 typically based on value).
  final double size;

  /// Dot color (defaults to brand blue).
  final Color? color;

  /// Visual state of the dot.
  final GalaxyDotState state;

  /// Callback when dot is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dotColor = color ?? AppColors.brandBlue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: _totalSize,
        height: _totalSize,
        child: Center(
          child: _buildDot(dotColor),
        ),
      ),
    );
  }

  double get _totalSize {
    // Extra space for rings/glows
    return switch (state) {
      GalaxyDotState.normal => size,
      GalaxyDotState.selected => size + 8,
      GalaxyDotState.hovered => size + 12,
      GalaxyDotState.watchlisted => size + 10,
    };
  }

  Widget _buildDot(Color dotColor) {
    return switch (state) {
      GalaxyDotState.normal => _normalDot(dotColor),
      GalaxyDotState.selected => _selectedDot(dotColor),
      GalaxyDotState.hovered => _hoveredDot(dotColor),
      GalaxyDotState.watchlisted => _watchlistedDot(dotColor),
    };
  }

  Widget _normalDot(Color dotColor) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _selectedDot(Color dotColor) {
    return Container(
      width: size + 8,
      height: size + 8,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: dotColor.withOpacity(0.5),
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: dotColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _hoveredDot(Color dotColor) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: dotColor.withOpacity(0.5),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _watchlistedDot(Color dotColor) {
    return Container(
      width: size + 10,
      height: size + 10,
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: dotColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Data model for a dot in the galaxy visualization.
class GalaxyDotData {
  const GalaxyDotData({
    required this.id,
    required this.x,
    required this.y,
    this.size = 8,
    this.color,
    this.state = GalaxyDotState.normal,
    this.propertyId,
  });

  final String id;
  final double x;
  final double y;
  final double size;
  final Color? color;
  final GalaxyDotState state;
  final String? propertyId;
}
