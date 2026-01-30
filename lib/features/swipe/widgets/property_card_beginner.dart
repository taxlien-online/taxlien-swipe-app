import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/property_card_data.dart';
import 'dart:math' as math;

class PropertyCardBeginner extends StatefulWidget {
  final PropertyCardData property;
  final VoidCallback onLike;
  final VoidCallback onPass;

  const PropertyCardBeginner({
    super.key,
    required this.property,
    required this.onLike,
    required this.onPass,
  });

  @override
  State<PropertyCardBeginner> createState() => _PropertyCardBeginnerState();
}

class _PropertyCardBeginnerState extends State<PropertyCardBeginner> {
  int _currentPhotoIndex = 0;
  bool _isFlipped = false;

  void _cyclePhoto() {
    setState(() {
      _currentPhotoIndex = (_currentPhotoIndex + 1) % widget.property.imageUrls.length;
    });
  }

  void _toggleFlip() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      onDoubleTap: _cyclePhoto,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotate = Tween(begin: math.pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (context, child) {
              final isUnder = (ValueKey(_isFlipped) != child!.key);
              final tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
              final rotationValue = isUnder ? math.min(rotate.value, math.pi / 2) : rotate.value;
              
              return Transform(
                transform: Matrix4.rotationY(rotationValue)..setEntry(3, 0, tilt),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: _isFlipped ? _buildBackCard() : _buildFrontCard(),
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      key: const ValueKey(false),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Main Photo
          CachedNetworkImage(
            imageUrl: widget.property.imageUrls[_currentPhotoIndex],
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey[300]),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          
          // Bottom Gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          
          // Top Badges
          Positioned(
            top: 20,
            left: 20,
            child: _buildBadge(
              'FVI: ${widget.property.fvi}', 
              Colors.greenAccent[700]!,
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: _buildBadge(
              'ROI: ${widget.property.roi}x', 
              Colors.orangeAccent[700]!,
            ),
          ),
          
          // Reassurance Bridge
          if (widget.property.expertReassurance != null)
            Positioned(
              top: 80,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
                ),
                child: Text(
                  widget.property.expertReassurance!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          
          // Bottom Info
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.property.address}, ${widget.property.city}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lien Cost: \$${widget.property.lienCost.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.white),
                      onPressed: () {
                        // Show financial breakdown
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      key: const ValueKey(true),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Quick Facts',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 40),
          _buildFactRow(Icons.home, 'Type', 'Single Family'),
          _buildFactRow(Icons.square_foot, 'Lot Size', '0.25 Acres'),
          _buildFactRow(Icons.calendar_today, 'Auction Date', 'Feb 10, 2026'),
          const Spacer(),
          const Text('Tap to flip back', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFactRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 15),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.blueAccent)),
        ],
      ),
    );
  }
}
