import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animated waveform visualizer for voice input.
class WaveformVisualizer extends StatefulWidget {
  const WaveformVisualizer({
    super.key,
    required this.audioLevel,
    this.barCount = 20,
    this.barWidth = 3.0,
    this.barSpacing = 2.0,
    this.minHeight = 4.0,
    this.maxHeight = 40.0,
    this.color,
    this.isActive = true,
  });

  final double audioLevel;
  final int barCount;
  final double barWidth;
  final double barSpacing;
  final double minHeight;
  final double maxHeight;
  final Color? color;
  final bool isActive;

  @override
  State<WaveformVisualizer> createState() => _WaveformVisualizerState();
}

class _WaveformVisualizerState extends State<WaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> _barHeights;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _barHeights = List.generate(widget.barCount, (_) => widget.minHeight);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(_updateBars);

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(WaveformVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
        setState(() {
          _barHeights =
              List.generate(widget.barCount, (_) => widget.minHeight);
        });
      }
    }
  }

  void _updateBars() {
    if (!widget.isActive) return;

    setState(() {
      for (var i = 0; i < _barHeights.length; i++) {
        // Create wave-like effect with audio level influence
        final baseHeight = widget.minHeight +
            (widget.maxHeight - widget.minHeight) *
                widget.audioLevel *
                (_random.nextDouble() * 0.5 + 0.5);

        // Smooth transition
        _barHeights[i] =
            _barHeights[i] + (baseHeight - _barHeights[i]) * 0.3;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor = widget.color ?? theme.colorScheme.primary;

    return SizedBox(
      height: widget.maxHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.barCount, (index) {
          return Container(
            width: widget.barWidth,
            height: _barHeights[index],
            margin: EdgeInsets.symmetric(horizontal: widget.barSpacing / 2),
            decoration: BoxDecoration(
              color: barColor.withValues(
                alpha: 0.5 + (_barHeights[index] / widget.maxHeight) * 0.5,
              ),
              borderRadius: BorderRadius.circular(widget.barWidth / 2),
            ),
          );
        }),
      ),
    );
  }
}

/// A circular waveform visualizer.
class CircularWaveformVisualizer extends StatefulWidget {
  const CircularWaveformVisualizer({
    super.key,
    required this.audioLevel,
    this.radius = 40.0,
    this.lineCount = 24,
    this.color,
    this.isActive = true,
  });

  final double audioLevel;
  final double radius;
  final int lineCount;
  final Color? color;
  final bool isActive;

  @override
  State<CircularWaveformVisualizer> createState() =>
      _CircularWaveformVisualizerState();
}

class _CircularWaveformVisualizerState extends State<CircularWaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(CircularWaveformVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
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
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.radius * 2, widget.radius * 2),
          painter: _CircularWaveformPainter(
            audioLevel: widget.audioLevel,
            lineCount: widget.lineCount,
            color: color,
            phase: _controller.value * 2 * math.pi,
            isActive: widget.isActive,
          ),
        );
      },
    );
  }
}

class _CircularWaveformPainter extends CustomPainter {
  _CircularWaveformPainter({
    required this.audioLevel,
    required this.lineCount,
    required this.color,
    required this.phase,
    required this.isActive,
  });

  final double audioLevel;
  final int lineCount;
  final Color color;
  final double phase;
  final bool isActive;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final innerRadius = radius * 0.6;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < lineCount; i++) {
      final angle = (i / lineCount) * 2 * math.pi;

      // Calculate line length based on audio level and wave
      final waveOffset = math.sin(angle * 3 + phase) * 0.3;
      final levelFactor = isActive ? (audioLevel + waveOffset).clamp(0.0, 1.0) : 0.3;
      final lineLength = innerRadius + (radius - innerRadius) * levelFactor;

      final startX = center.dx + innerRadius * math.cos(angle);
      final startY = center.dy + innerRadius * math.sin(angle);
      final endX = center.dx + lineLength * math.cos(angle);
      final endY = center.dy + lineLength * math.sin(angle);

      paint.color = color.withValues(alpha: 0.3 + levelFactor * 0.7);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularWaveformPainter oldDelegate) {
    return oldDelegate.audioLevel != audioLevel ||
        oldDelegate.phase != phase ||
        oldDelegate.isActive != isActive;
  }
}
