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
    setState(() {
      _currentPhotoIndex = (_currentPhotoIndex + 1) % widget.property.imageUrls.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _cyclePhoto, // Handle double tap for photo cycling
      child: Container(
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
              imageUrl: widget.mainImageUrl, // Use the passed main image
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
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
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

