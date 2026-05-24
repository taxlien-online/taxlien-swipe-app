import 'package:flutter/material.dart';

import 'gestures/long_press_drag.dart';
import 'services/ai_explanation_service.dart';
import 'widgets/explanation_panel.dart';
import 'widgets/loupe_circle.dart';

/// An overlay widget that adds AI loupe functionality to any child.
class AILoupeOverlay extends StatefulWidget {
  const AILoupeOverlay({
    super.key,
    required this.child,
    this.explanationService,
    this.enabled = true,
    this.loupeRadius = 60.0,
    this.onFieldDetected,
  });

  final Widget child;
  final AIExplanationService? explanationService;
  final bool enabled;
  final double loupeRadius;
  final void Function(String? fieldName)? onFieldDetected;

  @override
  State<AILoupeOverlay> createState() => _AILoupeOverlayState();
}

class _AILoupeOverlayState extends State<AILoupeOverlay> {
  late final AIExplanationService _service;
  AILoupeState _state = const AILoupeState();

  @override
  void initState() {
    super.initState();
    _service = widget.explanationService ?? StubAIExplanationService();
  }

  void _onLongPressStart(LongPressDragDetails details) {
    setState(() {
      _state = _state.copyWith(
        isActive: true,
        position: details.localPosition,
      );
    });

    // Simulate field detection
    _detectFieldAtPosition(details.localPosition);
  }

  void _onLongPressDrag(LongPressDragDetails details) {
    setState(() {
      _state = _state.copyWith(position: details.localPosition);
    });

    // Debounce field detection during drag
    _detectFieldAtPosition(details.localPosition);
  }

  void _onLongPressEnd() {
    // Keep panel visible for a moment before hiding
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _state.isActive) {
        setState(() {
          _state = const AILoupeState();
        });
      }
    });
  }

  Future<void> _detectFieldAtPosition(Offset position) async {
    // In a real implementation, this would use hit testing to find
    // which field is under the loupe. For now, we'll simulate it.
    final fieldName = _simulateFieldDetection(position);

    if (fieldName != null && fieldName != _state.targetField) {
      widget.onFieldDetected?.call(fieldName);

      setState(() {
        _state = _state.copyWith(
          targetField: fieldName,
          isLoading: true,
          explanation: null,
        );
      });

      try {
        final explanation = await _service.explainField(
          fieldName: fieldName,
          fieldValue: _getFieldValue(fieldName),
        );

        if (mounted) {
          setState(() {
            _state = _state.copyWith(
              explanation: explanation,
              isLoading: false,
            );
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _state = _state.copyWith(
              isLoading: false,
              error: e.toString(),
            );
          });
        }
      }
    }
  }

  String? _simulateFieldDetection(Offset position) {
    // Simulate field detection based on position
    // In reality, this would use render box hit testing
    final y = position.dy;

    if (y < 100) return 'FVI Score';
    if (y < 200) return 'Assessed Value';
    if (y < 300) return 'Tax Owed';
    if (y < 400) return 'Redemption Period';
    return 'Lien Position';
  }

  String _getFieldValue(String fieldName) {
    // Return sample values
    switch (fieldName) {
      case 'FVI Score':
        return '85';
      case 'Assessed Value':
        return '\$210,000';
      case 'Tax Owed':
        return '\$4,250';
      case 'Redemption Period':
        return '2 years';
      case 'Lien Position':
        return '1st Position';
      default:
        return 'N/A';
    }
  }

  void _closeExplanation() {
    setState(() {
      _state = const AILoupeState();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Stack(
      children: [
        // Child with long-press gesture
        LongPressDragDetector(
          onLongPressStart: _onLongPressStart,
          onLongPressDrag: _onLongPressDrag,
          onLongPressEnd: _onLongPressEnd,
          child: widget.child,
        ),

        // Loupe circle
        if (_state.isActive)
          LoupeCircle(
            position: _state.position,
            radius: widget.loupeRadius,
            isLoading: _state.isLoading,
          ),

        // Explanation panel
        if (_state.explanation != null)
          Positioned(
            left: _calculatePanelX(_state.position),
            top: _state.position.dy + widget.loupeRadius + 20,
            child: ExplanationPanel(
              explanation: _state.explanation!,
              onClose: _closeExplanation,
            ),
          ),

        // Loading skeleton
        if (_state.isLoading && _state.explanation == null)
          Positioned(
            left: _calculatePanelX(_state.position),
            top: _state.position.dy + widget.loupeRadius + 20,
            child: const ExplanationPanelSkeleton(),
          ),
      ],
    );
  }

  double _calculatePanelX(Offset loupePosition) {
    final screenWidth = MediaQuery.of(context).size.width;
    const panelWidth = 280.0;

    var x = loupePosition.dx - panelWidth / 2;

    // Keep panel within screen bounds
    x = x.clamp(16.0, screenWidth - panelWidth - 16);

    return x;
  }
}
