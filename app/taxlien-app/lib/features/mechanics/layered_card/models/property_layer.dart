import 'package:flutter/material.dart';

/// Types of property layers available for inspection.
enum PropertyLayerType {
  /// Tax & lien information
  tax(
    label: 'Tax',
    icon: Icons.receipt_long,
    color: Color(0xFF2563EB),
  ),

  /// Owner and deed information
  owner(
    label: 'Owner',
    icon: Icons.person,
    color: Color(0xFF7C3AED),
  ),

  /// Market valuation and comparables
  market(
    label: 'Market',
    icon: Icons.trending_up,
    color: Color(0xFF059669),
  ),

  /// Property condition and improvements
  condition(
    label: 'Condition',
    icon: Icons.home_work,
    color: Color(0xFFD97706),
  ),

  /// Legal encumbrances and liens
  legal(
    label: 'Legal',
    icon: Icons.gavel,
    color: Color(0xFFDC2626),
  ),

  /// Neighborhood and location data
  location(
    label: 'Location',
    icon: Icons.location_on,
    color: Color(0xFF0891B2),
  );

  const PropertyLayerType({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

/// A single layer of property information.
class PropertyLayer {
  const PropertyLayer({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.fields,
    this.isExpanded = false,
  });

  final PropertyLayerType type;
  final String title;
  final String subtitle;
  final Map<String, String> fields;
  final bool isExpanded;

  PropertyLayer copyWith({
    PropertyLayerType? type,
    String? title,
    String? subtitle,
    Map<String, String>? fields,
    bool? isExpanded,
  }) {
    return PropertyLayer(
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      fields: fields ?? this.fields,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

/// State for the layered card stack.
class LayeredCardState {
  const LayeredCardState({
    required this.layers,
    this.currentLayerIndex = 0,
    this.peekOffset = 0.0,
  });

  final List<PropertyLayer> layers;
  final int currentLayerIndex;
  final double peekOffset;

  PropertyLayer? get currentLayer =>
      currentLayerIndex < layers.length ? layers[currentLayerIndex] : null;

  bool get canDigDeeper => currentLayerIndex < layers.length - 1;
  bool get canGoBack => currentLayerIndex > 0;

  LayeredCardState copyWith({
    List<PropertyLayer>? layers,
    int? currentLayerIndex,
    double? peekOffset,
  }) {
    return LayeredCardState(
      layers: layers ?? this.layers,
      currentLayerIndex: currentLayerIndex ?? this.currentLayerIndex,
      peekOffset: peekOffset ?? this.peekOffset,
    );
  }
}
