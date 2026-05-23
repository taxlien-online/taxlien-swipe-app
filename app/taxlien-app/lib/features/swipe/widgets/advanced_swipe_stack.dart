import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/swipe_provider.dart';
import 'property_card_advanced.dart';
import '../../../core/models/property_card_data.dart';
import '../../../core/models/expert_role.dart';
import '../../../core/models/marker.dart';
import '../views/context_view.dart';
import '../views/details_view.dart';

class AdvancedSwipeStack extends StatefulWidget {
  final List<PropertyCardData> properties;
  final int currentIndex;
  final Function(String) onLike;
  final Function(String) onPass;
  final Function(int) onPageChanged;

  const AdvancedSwipeStack({
    super.key,
    required this.properties,
    required this.currentIndex,
    required this.onLike,
    required this.onPass,
    required this.onPageChanged,
  });

  @override
  State<AdvancedSwipeStack> createState() => _AdvancedSwipeStackState();
}

class _AdvancedSwipeStackState extends State<AdvancedSwipeStack> {
  late PageController _pageController;
  final GlobalKey _centerKey = GlobalKey();
  
  // Controls the horizontal movement for Context/Details views
  double _horizontalDragOffset = 0.0;
  bool _showContext = false;
  bool _showDetails = false;

  // Annotation mode
  bool _isAnnotationMode = false;
  List<AnnotationMarker> _currentPropertyMarkers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  void didUpdateWidget(covariant AdvancedSwipeStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _pageController.page?.round()) {
      _pageController.jumpToPage(widget.currentIndex);
      // Reset annotation mode when changing property
      _isAnnotationMode = false;
      _currentPropertyMarkers = []; // Load markers for new property if available
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getMainImageUrl(PropertyCardData property, ExpertRole role) {
    // Implement role-based image selection here
    // Default to the first image if no specific category is found or role is guest
    String? imageUrl;

    // Prioritize specific image categories based on role
    switch (role) {
      case ExpertRole.builder:
        imageUrl = property.imageCategories.entries.firstWhere(
          (entry) => entry.value == 'roof' || entry.value == 'exterior',
          orElse: () => MapEntry('', ''),
        ).key;
        break;
      case ExpertRole.inventor:
        imageUrl = property.imageCategories.entries.firstWhere(
          (entry) => entry.value == 'garage' || entry.value == 'lab' || entry.value == 'interior_science',
          orElse: () => MapEntry('', ''),
        ).key;
        break;
      case ExpertRole.restorer:
        imageUrl = property.imageCategories.entries.firstWhere(
          (entry) => entry.value == 'interior_furniture' || entry.value == 'interior',
          orElse: () => MapEntry('', ''),
        ).key;
        break;
      case ExpertRole.caregiver:
        imageUrl = property.imageCategories.entries.firstWhere(
          (entry) => entry.value == 'exterior' || entry.value == 'yard' || entry.value == 'neighborhood',
          orElse: () => MapEntry('', ''),
        ).key;
        break;
      case ExpertRole.lifestyle:
        imageUrl = property.imageCategories.entries.firstWhere(
          (entry) => entry.value == 'exterior' || entry.value == 'balcony' || entry.value == 'view',
          orElse: () => MapEntry('', ''),
        ).key;
        break;
      case ExpertRole.explorer:
        imageUrl = property.imageCategories.entries.firstWhere(
          (entry) => entry.value == 'backyard' || entry.value == 'playground' || entry.value == 'park',
          orElse: () => MapEntry('', ''),
        ).key;
        break;
      case ExpertRole.businessman:
      case ExpertRole.guest:
      default:
        // Default for businessman and guest, or if no specific image is found
        imageUrl = property.imageCategories.entries.firstWhere(
          (entry) => entry.value == 'exterior',
          orElse: () => MapEntry('', ''),
        ).key;
        break;
    }

    // Fallback to the first image if no specific image category was found
    return imageUrl?.isNotEmpty == true ? imageUrl! : property.imageUrls.first;
  }

  Widget _buildTopHUD(ExpertRole role, PropertyCardData property) {
    // This will be dynamic based on role
    String primaryMetric = '';
    String secondaryMetrics = '';

    switch (role) {
      case ExpertRole.businessman:
        primaryMetric = 'ROI: ${property.roi.toStringAsFixed(1)}%';
        secondaryMetrics = 'Risk: ${property.roleMetrics['businessman']?['risk'] ?? 'N/A'}';
        break;
      case ExpertRole.builder:
        primaryMetric = 'Structure: ${property.roleMetrics['builder']?['structure'] ?? 'N/A'}';
        secondaryMetrics = 'Roof Age: ${property.roleMetrics['builder']?['roof_age'] ?? 'N/A'}';
        break;
      case ExpertRole.inventor:
        primaryMetric = 'Rarity: ${property.roleMetrics['inventor']?['rarity_score'] ?? 'N/A'}';
        secondaryMetrics = 'Authenticity: ${property.roleMetrics['inventor']?['authenticity'] ?? 'N/A'}';
        break;
      // Add more cases for other roles
      default:
        primaryMetric = 'FVI: ${property.fvi.toStringAsFixed(1)}';
        secondaryMetrics = 'Karma: ${property.karmaScore.toStringAsFixed(1)}';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black.withValues(alpha: 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHudBadge(primaryMetric, Colors.green),
          if (property.hasBridgePotential)
            _buildBridgeBadge(property.bridgeRoles),
          _buildHudBadge(secondaryMetrics, Colors.blue),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Show financial breakdown
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBridgeBadge(List<String> roles) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.link, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            'BRIDGE',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHudBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _buildBottomActionButtons(PropertyCardData property) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black.withValues(alpha: 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 36),
            onPressed: () => widget.onPass(property.id),
          ),
          IconButton(
            icon: Icon(
              _isAnnotationMode ? Icons.brush : Icons.brush_outlined,
              color: _isAnnotationMode ? Colors.amber : Colors.blue,
              size: 36,
            ),
            onPressed: () {
              setState(() {
                _isAnnotationMode = !_isAnnotationMode;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.green, size: 36),
            onPressed: () => widget.onLike(property.id),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final swipeProvider = Provider.of<SwipeProvider>(context);
    final ExpertRole currentRole = swipeProvider.currentRole;

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.properties.length,
      onPageChanged: widget.onPageChanged,
      itemBuilder: (context, index) {
        final property = widget.properties[index];
        final currentMainImageUrl = _getMainImageUrl(property, currentRole);

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _horizontalDragOffset += details.primaryDelta!;
              _showContext = _horizontalDragOffset > 50; // Threshold to show context peek
              _showDetails = _horizontalDragOffset < -50; // Threshold to show details peek
            });
          },
          onHorizontalDragEnd: (details) {
            if (_horizontalDragOffset > MediaQuery.of(context).size.width / 3) {
              // Swipe right to show context fully
              setState(() {
                _showContext = true;
                _showDetails = false;
                _horizontalDragOffset = MediaQuery.of(context).size.width; // Snap to full
              });
            } else if (_horizontalDragOffset < -MediaQuery.of(context).size.width / 3) {
              // Swipe left to show details fully
              setState(() {
                _showDetails = true;
                _showContext = false;
                _horizontalDragOffset = -MediaQuery.of(context).size.width; // Snap to full
              });
            } else {
              // Snap back to center
              setState(() {
                _horizontalDragOffset = 0.0;
                _showContext = false;
                _showDetails = false;
              });
            }
          },
          onDoubleTap: () {
            // Cycle photo for visual inspection
            // This needs to be implemented inside PropertyCardAdvanced
            debugPrint('Double tap on Advanced Card');
          },
          child: Stack(
            key: _centerKey, // Key to make sure the center card is always present
            children: [
              // Context View (Appears on right side when dragged right)
              if (_showContext)
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(math.max(0, _horizontalDragOffset), 0),
                    child: ContextView(propertyId: property.id),
                  ),
                ),
              // Details View (Appears on left side when dragged left)
              if (_showDetails)
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(math.min(0, _horizontalDragOffset), 0),
                    child: DetailsView(propertyId: property.id),
                  ),
                ),

              // Main Advanced Property Card
              Transform.translate(
                offset: Offset(_horizontalDragOffset, 0),
                child: PropertyCardAdvanced(
                  property: property,
                  topOverlay: _buildTopHUD(currentRole, property),
                  bottomOverlay: _buildBottomActionButtons(property),
                  isAnnotationMode: _isAnnotationMode,
                  markers: _currentPropertyMarkers,
                  mainImageUrl: currentMainImageUrl,
                  onAddMarker: (marker) {
                    setState(() {
                      _currentPropertyMarkers = [..._currentPropertyMarkers, marker];
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
