import 'marker.dart';

class PropertyCardData {
  final String id;
  final String address;
  final String city;
  final String state;
  final double estimatedValue;
  final double lienCost;
  final double totalCost; // Including fees
  final double roi; // e.g. 0.18 for 18% or multiplier
  final double fvi; // Family Value Index 0-10
  final double karmaScore; // -1.0 to 1.0
  
  final List<String> imageUrls;
  final Map<String, String> imageCategories; // e.g. {"url1": "roof", "url2": "lawn"}
  
  final List<AnnotationMarker> markers;
  
  final String? expertReassurance; // "Khun Pho: Structure is solid"
  
  // Specific metrics for different roles
  final Map<String, dynamic> roleMetrics; 

  PropertyCardData({
    required this.id,
    required this.address,
    required this.city,
    required this.state,
    required this.estimatedValue,
    required this.lienCost,
    required this.totalCost,
    required this.roi,
    required this.fvi,
    required this.karmaScore,
    required this.imageUrls,
    this.imageCategories = const {},
    this.markers = const [],
    this.expertReassurance,
    this.roleMetrics = const {},
  });
}
