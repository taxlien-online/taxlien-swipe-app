import 'package:flutter/material.dart';

/// Types of relationships between properties.
enum RelationType {
  /// Same owner across properties
  sameOwner(
    label: 'Same Owner',
    icon: Icons.person,
    color: Color(0xFF7C3AED),
  ),

  /// Same street or block
  sameStreet(
    label: 'Same Street',
    icon: Icons.signpost,
    color: Color(0xFF2563EB),
  ),

  /// Same school district
  sameSchool(
    label: 'Same School',
    icon: Icons.school,
    color: Color(0xFF059669),
  ),

  /// Same zip code
  sameZip(
    label: 'Same ZIP',
    icon: Icons.local_post_office,
    color: Color(0xFF0891B2),
  ),

  /// Same tax status (delinquent, etc.)
  sameTaxStatus(
    label: 'Same Tax Status',
    icon: Icons.receipt_long,
    color: Color(0xFFDC2626),
  ),

  /// Similar assessed value
  similarValue(
    label: 'Similar Value',
    icon: Icons.attach_money,
    color: Color(0xFFD97706),
  ),

  /// Same auction date
  sameAuction(
    label: 'Same Auction',
    icon: Icons.gavel,
    color: Color(0xFFDB2777),
  );

  const RelationType({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

/// A property within a cluster.
class ClusteredProperty {
  const ClusteredProperty({
    required this.id,
    required this.address,
    required this.position,
    this.fviScore,
  });

  final String id;
  final String address;
  final Offset position;
  final double? fviScore;

  ClusteredProperty copyWith({
    String? id,
    String? address,
    Offset? position,
    double? fviScore,
  }) {
    return ClusteredProperty(
      id: id ?? this.id,
      address: address ?? this.address,
      position: position ?? this.position,
      fviScore: fviScore ?? this.fviScore,
    );
  }
}

/// A cluster of related properties.
class PropertyClusterData {
  const PropertyClusterData({
    required this.id,
    required this.relationType,
    required this.properties,
    required this.center,
    this.radius = 100.0,
    this.isExpanded = false,
  });

  final String id;
  final RelationType relationType;
  final List<ClusteredProperty> properties;
  final Offset center;
  final double radius;
  final bool isExpanded;

  int get count => properties.length;
  String get label => '${relationType.label} (${count})';

  PropertyClusterData copyWith({
    String? id,
    RelationType? relationType,
    List<ClusteredProperty>? properties,
    Offset? center,
    double? radius,
    bool? isExpanded,
  }) {
    return PropertyClusterData(
      id: id ?? this.id,
      relationType: relationType ?? this.relationType,
      properties: properties ?? this.properties,
      center: center ?? this.center,
      radius: radius ?? this.radius,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

/// State for magnetic groups visualization.
class MagneticGroupsState {
  const MagneticGroupsState({
    this.activeRelationType,
    this.clusters = const [],
    this.ungroupedProperties = const [],
    this.isAnimating = false,
  });

  final RelationType? activeRelationType;
  final List<PropertyClusterData> clusters;
  final List<ClusteredProperty> ungroupedProperties;
  final bool isAnimating;

  MagneticGroupsState copyWith({
    RelationType? activeRelationType,
    List<PropertyClusterData>? clusters,
    List<ClusteredProperty>? ungroupedProperties,
    bool? isAnimating,
  }) {
    return MagneticGroupsState(
      activeRelationType: activeRelationType ?? this.activeRelationType,
      clusters: clusters ?? this.clusters,
      ungroupedProperties: ungroupedProperties ?? this.ungroupedProperties,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}
