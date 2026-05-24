import 'package:flutter/material.dart';

/// Types of map layers available.
enum MapLayerType {
  /// Tax lien properties
  taxLiens(
    label: 'Tax Liens',
    icon: Icons.receipt_long,
    color: Color(0xFFDC2626),
  ),

  /// Bank-owned/REO properties
  bankOwned(
    label: 'Bank Owned',
    icon: Icons.account_balance,
    color: Color(0xFF2563EB),
  ),

  /// Pre-foreclosure properties
  preForeclosure(
    label: 'Pre-Foreclosure',
    icon: Icons.warning,
    color: Color(0xFFD97706),
  ),

  /// Auction properties
  auction(
    label: 'Auctions',
    icon: Icons.gavel,
    color: Color(0xFF7C3AED),
  ),

  /// User's saved/favorite properties
  favorites(
    label: 'Favorites',
    icon: Icons.star,
    color: Color(0xFFEAB308),
  ),

  /// School district boundaries
  schoolDistricts(
    label: 'School Districts',
    icon: Icons.school,
    color: Color(0xFF059669),
    isOverlay: true,
  ),

  /// Flood zones
  floodZones(
    label: 'Flood Zones',
    icon: Icons.water,
    color: Color(0xFF0891B2),
    isOverlay: true,
  ),

  /// Census tract boundaries
  censusTracts(
    label: 'Census Tracts',
    icon: Icons.grid_on,
    color: Color(0xFF6B7280),
    isOverlay: true,
  );

  const MapLayerType({
    required this.label,
    required this.icon,
    required this.color,
    this.isOverlay = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isOverlay;
}

/// A single map layer with its state.
class MapLayer {
  const MapLayer({
    required this.type,
    this.isVisible = true,
    this.opacity = 1.0,
    this.count = 0,
  });

  final MapLayerType type;
  final bool isVisible;
  final double opacity;
  final int count;

  MapLayer copyWith({
    MapLayerType? type,
    bool? isVisible,
    double? opacity,
    int? count,
  }) {
    return MapLayer(
      type: type ?? this.type,
      isVisible: isVisible ?? this.isVisible,
      opacity: opacity ?? this.opacity,
      count: count ?? this.count,
    );
  }
}

/// Data for a property marker on the map.
class PropertyMarkerData {
  const PropertyMarkerData({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.layerType,
    required this.address,
    this.fviScore,
    this.price,
    this.isSelected = false,
  });

  final String id;
  final double latitude;
  final double longitude;
  final MapLayerType layerType;
  final String address;
  final double? fviScore;
  final double? price;
  final bool isSelected;

  PropertyMarkerData copyWith({
    String? id,
    double? latitude,
    double? longitude,
    MapLayerType? layerType,
    String? address,
    double? fviScore,
    double? price,
    bool? isSelected,
  }) {
    return PropertyMarkerData(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      layerType: layerType ?? this.layerType,
      address: address ?? this.address,
      fviScore: fviScore ?? this.fviScore,
      price: price ?? this.price,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

/// State for the map layers screen.
class MapLayersState {
  const MapLayersState({
    this.layers = const [],
    this.markers = const [],
    this.selectedMarkerId,
    this.isLayerPanelOpen = false,
    this.centerLatitude = 39.8283,
    this.centerLongitude = -98.5795,
    this.zoomLevel = 4.0,
  });

  final List<MapLayer> layers;
  final List<PropertyMarkerData> markers;
  final String? selectedMarkerId;
  final bool isLayerPanelOpen;
  final double centerLatitude;
  final double centerLongitude;
  final double zoomLevel;

  List<PropertyMarkerData> get visibleMarkers {
    final visibleTypes = layers
        .where((l) => l.isVisible && !l.type.isOverlay)
        .map((l) => l.type)
        .toSet();
    return markers.where((m) => visibleTypes.contains(m.layerType)).toList();
  }

  PropertyMarkerData? get selectedMarker => selectedMarkerId != null
      ? markers.firstWhere(
          (m) => m.id == selectedMarkerId,
          orElse: () => markers.first,
        )
      : null;

  MapLayersState copyWith({
    List<MapLayer>? layers,
    List<PropertyMarkerData>? markers,
    String? selectedMarkerId,
    bool? isLayerPanelOpen,
    double? centerLatitude,
    double? centerLongitude,
    double? zoomLevel,
  }) {
    return MapLayersState(
      layers: layers ?? this.layers,
      markers: markers ?? this.markers,
      selectedMarkerId: selectedMarkerId ?? this.selectedMarkerId,
      isLayerPanelOpen: isLayerPanelOpen ?? this.isLayerPanelOpen,
      centerLatitude: centerLatitude ?? this.centerLatitude,
      centerLongitude: centerLongitude ?? this.centerLongitude,
      zoomLevel: zoomLevel ?? this.zoomLevel,
    );
  }

  /// Create initial state with all layer types.
  factory MapLayersState.initial() {
    return MapLayersState(
      layers: MapLayerType.values
          .map((type) => MapLayer(
                type: type,
                isVisible: type == MapLayerType.taxLiens,
              ))
          .toList(),
    );
  }
}
