import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/property_card_data.dart';
import '../../../core/models/marker.dart'; // Import AnnotationMarker
import 'annotation_canvas.dart'; // Import AnnotationCanvas

class PropertyCardAdvanced extends StatefulWidget {
  final PropertyCardData property;
  final Widget? topOverlay; // For HUD elements
  final Widget? bottomOverlay; // For action buttons
  final bool isAnnotationMode;
  final List<AnnotationMarker> markers;
  final Function(AnnotationMarker) onAddMarker;
  final String mainImageUrl; // The selected main image based on role

  const PropertyCardAdvanced({
    super.key,
    required this.property,
    this.topOverlay,
    this.bottomOverlay,
    this.isAnnotationMode = false,
    this.markers = const [],
    required this.onAddMarker,
    required this.mainImageUrl,
  });

  @override
  State<PropertyCardAdvanced> createState() => _PropertyCardAdvancedState();
}

class _PropertyCardAdvancedState extends State<PropertyCardAdvanced> {
  int _currentPhotoIndex = 0;

  void _cyclePhoto() {
    if (widget.property.imageUrls.isEmpty) return;
    setState(() {
      _currentPhotoIndex = (_currentPhotoIndex + 1) % widget.property.imageUrls.length;
    });
  }

  String get _currentImageUrl {
    if (widget.property.imageUrls.isEmpty) return widget.mainImageUrl;
    // If cycling has occurred, use the cycled index; otherwise use mainImageUrl
    if (_currentPhotoIndex == 0) return widget.mainImageUrl;
    return widget.property.imageUrls[_currentPhotoIndex];
  }

  Widget _buildPhotoIndicators(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == _currentPhotoIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 10 : 6,
          height: isActive ? 10 : 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.5),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoCount = widget.property.imageUrls.length;

    return GestureDetector(
      onDoubleTap: _cyclePhoto,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.2),
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
              imageUrl: _currentImageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[300]),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            
            // Annotation Canvas
            if (widget.isAnnotationMode)
              Positioned.fill(
                child: AnnotationCanvas(
                  markers: widget.markers,
                  onAddMarker: widget.onAddMarker,
                  imageSize: MediaQuery.of(context).size, // Pass actual image size for proper scaling if needed
                ),
              ),

            // Gradients for overlays
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha:0.4),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha:0.4),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),

            // Top Overlay (HUD)
            if (widget.topOverlay != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: widget.topOverlay!,
              ),
            
            // Photo Indicators (dots)
            if (photoCount > 1)
              Positioned(
                bottom: widget.bottomOverlay != null ? 80 : 16,
                left: 0,
                right: 0,
                child: _buildPhotoIndicators(photoCount),
              ),

            // Bottom Overlay (Actions)
            if (widget.bottomOverlay != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: widget.bottomOverlay!,
              ),
          ],
        ),
      ),
    );
  }
}

