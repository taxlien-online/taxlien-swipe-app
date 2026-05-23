import 'package:flutter/material.dart';
import '../../../core/models/spatial_position.dart';
import '../../../core/design/app_durations.dart';

/// Controller for animating dimension transitions
class DimensionTransitionController {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isInitialized = false;

  void initialize(TickerProvider vsync) {
    _controller = AnimationController(
      vsync: vsync,
      duration: AppDurations.dimensionTransition,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _isInitialized = true;
  }

  void dispose() {
    if (_isInitialized) {
      _controller.dispose();
    }
  }

  double get value => _isInitialized ? _animation.value : 1.0;
  bool get isAnimating => _isInitialized && _controller.isAnimating;

  void addListener(VoidCallback listener) {
    if (_isInitialized) {
      _animation.addListener(listener);
    }
  }

  void removeListener(VoidCallback listener) {
    if (_isInitialized) {
      _animation.removeListener(listener);
    }
  }

  Future<void> animate() async {
    if (!_isInitialized) return;
    _controller.reset();
    await _controller.forward();
  }

  /// Interpolate positions during transition
  List<SpatialPosition> interpolatePositions(
    List<SpatialPosition> from,
    List<SpatialPosition> to,
  ) {
    if (!_isInitialized || from.isEmpty || to.isEmpty) {
      return to;
    }

    final t = _animation.value;
    return to.map((toPos) {
      final fromPos = from.firstWhere(
        (p) => p.propertyId == toPos.propertyId,
        orElse: () => toPos,
      );
      return SpatialPosition.lerp(fromPos, toPos, t);
    }).toList();
  }
}

/// Widget that animates property positions during dimension change
class DimensionTransitionBuilder extends StatefulWidget {
  final List<SpatialPosition> positions;
  final Widget Function(BuildContext, List<SpatialPosition>) builder;

  const DimensionTransitionBuilder({
    super.key,
    required this.positions,
    required this.builder,
  });

  @override
  State<DimensionTransitionBuilder> createState() =>
      _DimensionTransitionBuilderState();
}

class _DimensionTransitionBuilderState extends State<DimensionTransitionBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<SpatialPosition> _previousPositions = [];
  List<SpatialPosition> _currentPositions = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.dimensionTransition,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _currentPositions = widget.positions;
  }

  @override
  void didUpdateWidget(DimensionTransitionBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.positions != oldWidget.positions) {
      _previousPositions = _currentPositions;
      _currentPositions = widget.positions;
      _controller.forward(from: 0);
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
      builder: (context, _) {
        final positions = _interpolate();
        return widget.builder(context, positions);
      },
    );
  }

  List<SpatialPosition> _interpolate() {
    if (_previousPositions.isEmpty) return _currentPositions;

    final t = _animation.value;
    return _currentPositions.map((current) {
      final previous = _previousPositions.firstWhere(
        (p) => p.propertyId == current.propertyId,
        orElse: () => current,
      );
      return SpatialPosition.lerp(previous, current, t);
    }).toList();
  }
}

/// Animated label that fades during dimension change
class AnimatedDimensionLabel extends StatelessWidget {
  final String label;
  final Duration duration;

  const AnimatedDimensionLabel({
    super.key,
    required this.label,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        label,
        key: ValueKey(label),
      ),
    );
  }
}
