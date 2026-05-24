import 'package:flutter/material.dart';

import '../models/property_layer.dart';
import 'layer_card.dart';
import 'layer_content.dart';

/// A stack of layers with swipe-to-dig gesture.
class LayerStack extends StatefulWidget {
  const LayerStack({
    super.key,
    required this.layers,
    this.initialLayerIndex = 0,
    this.onLayerChange,
    this.onFieldTap,
    this.peekAmount = 40.0,
    this.stackOffset = 12.0,
  });

  final List<PropertyLayer> layers;
  final int initialLayerIndex;
  final void Function(int index)? onLayerChange;
  final void Function(String fieldName, String fieldValue)? onFieldTap;
  final double peekAmount;
  final double stackOffset;

  @override
  State<LayerStack> createState() => _LayerStackState();
}

class _LayerStackState extends State<LayerStack>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  late AnimationController _animationController;
  late Animation<double> _peekAnimation;
  double _dragOffset = 0.0;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialLayerIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _peekAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy;

    // Swipe down to dig deeper
    if (velocity > 300 || _dragOffset > widget.peekAmount) {
      if (_currentIndex < widget.layers.length - 1) {
        setState(() {
          _currentIndex++;
          _dragOffset = 0.0;
        });
        widget.onLayerChange?.call(_currentIndex);
      }
    }
    // Swipe up to go back
    else if (velocity < -300 || _dragOffset < -widget.peekAmount) {
      if (_currentIndex > 0) {
        setState(() {
          _currentIndex--;
          _dragOffset = 0.0;
        });
        widget.onLayerChange?.call(_currentIndex);
      }
    }

    // Reset drag offset with animation
    setState(() {
      _dragOffset = 0.0;
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.layers.isEmpty) {
      return const Center(
        child: Text('No layers available'),
      );
    }

    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: AnimatedBuilder(
        animation: _peekAnimation,
        builder: (context, child) {
          return Column(
            children: [
              // Stack of cards
              Expanded(
                flex: _isExpanded ? 1 : 2,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: _buildLayerStack(),
                ),
              ),

              // Expanded content
              if (_isExpanded)
                Expanded(
                  flex: 2,
                  child: AnimatedOpacity(
                    opacity: _peekAnimation.value,
                    duration: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: LayerContent(
                        layer: widget.layers[_currentIndex],
                        onFieldTap: widget.onFieldTap,
                      ),
                    ),
                  ),
                ),

              // Navigation dots
              _buildNavigationDots(),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildLayerStack() {
    final widgets = <Widget>[];

    // Show up to 3 cards in the stack
    final visibleCount = 3;
    final startIndex = _currentIndex;
    final endIndex =
        (startIndex + visibleCount).clamp(0, widget.layers.length);

    for (var i = endIndex - 1; i >= startIndex; i--) {
      final offset = (i - _currentIndex) * widget.stackOffset;
      final isTop = i == _currentIndex;

      widgets.add(
        Positioned(
          top: offset + (isTop ? _dragOffset.clamp(-20.0, 50.0) : 0),
          left: 16,
          right: 16,
          child: Transform.scale(
            scale: 1.0 - ((i - _currentIndex) * 0.05),
            alignment: Alignment.topCenter,
            child: LayerCard(
              layer: widget.layers[i],
              isTop: isTop,
              onTap: isTop ? _toggleExpanded : null,
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  Widget _buildNavigationDots() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.layers.length, (index) {
          final isActive = index == _currentIndex;
          final layer = widget.layers[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = index;
              });
              widget.onLayerChange?.call(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? layer.type.color
                    : layer.type.color.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }
}
