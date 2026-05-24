import 'package:flutter/material.dart';

import 'models/map_layer.dart';
import 'widgets/layer_panel.dart';
import 'widgets/layer_toggle.dart';
import 'widgets/property_marker.dart';

/// A full-screen map view with toggleable property layers.
class MapLayersScreen extends StatefulWidget {
  const MapLayersScreen({
    super.key,
    this.initialState,
  });

  final MapLayersState? initialState;

  @override
  State<MapLayersScreen> createState() => _MapLayersScreenState();
}

class _MapLayersScreenState extends State<MapLayersScreen> {
  late MapLayersState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState ?? _generateSampleState();
  }

  MapLayersState _generateSampleState() {
    return MapLayersState(
      layers: [
        const MapLayer(type: MapLayerType.taxLiens, isVisible: true, count: 45),
        const MapLayer(type: MapLayerType.bankOwned, count: 12),
        const MapLayer(type: MapLayerType.preForeclosure, count: 23),
        const MapLayer(type: MapLayerType.auction, count: 8),
        const MapLayer(type: MapLayerType.favorites, count: 5),
        const MapLayer(type: MapLayerType.schoolDistricts),
        const MapLayer(type: MapLayerType.floodZones),
      ],
      markers: [
        const PropertyMarkerData(
          id: '1',
          latitude: 30.2672,
          longitude: -97.7431,
          layerType: MapLayerType.taxLiens,
          address: '123 Main St, Austin, TX',
          fviScore: 85,
          price: 125000,
        ),
        const PropertyMarkerData(
          id: '2',
          latitude: 30.2750,
          longitude: -97.7400,
          layerType: MapLayerType.taxLiens,
          address: '456 Oak Ave, Austin, TX',
          fviScore: 72,
          price: 98000,
        ),
        const PropertyMarkerData(
          id: '3',
          latitude: 30.2600,
          longitude: -97.7500,
          layerType: MapLayerType.bankOwned,
          address: '789 Pine Rd, Austin, TX',
          fviScore: 91,
          price: 215000,
        ),
      ],
      centerLatitude: 30.2672,
      centerLongitude: -97.7431,
      zoomLevel: 12,
    );
  }

  void _toggleLayer(MapLayer layer) {
    setState(() {
      _state = _state.copyWith(
        layers: _state.layers.map((l) {
          if (l.type == layer.type) {
            return l.copyWith(isVisible: !l.isVisible);
          }
          return l;
        }).toList(),
      );
    });
  }

  void _updateLayerOpacity(MapLayer layer, double opacity) {
    setState(() {
      _state = _state.copyWith(
        layers: _state.layers.map((l) {
          if (l.type == layer.type) {
            return l.copyWith(opacity: opacity);
          }
          return l;
        }).toList(),
      );
    });
  }

  void _selectMarker(PropertyMarkerData marker) {
    setState(() {
      _state = _state.copyWith(
        selectedMarkerId: marker.id,
        markers: _state.markers.map((m) {
          return m.copyWith(isSelected: m.id == marker.id);
        }).toList(),
      );
    });
  }

  void _clearSelection() {
    setState(() {
      _state = _state.copyWith(
        selectedMarkerId: null,
        markers: _state.markers.map((m) {
          return m.copyWith(isSelected: false);
        }).toList(),
      );
    });
  }

  void _toggleLayerPanel() {
    setState(() {
      _state = _state.copyWith(isLayerPanelOpen: !_state.isLayerPanelOpen);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeLayerCount = _state.layers.where((l) => l.isVisible).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Layers'),
      ),
      body: Stack(
        children: [
          // Map placeholder (would use google_maps_flutter in production)
          Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: CustomPaint(
              size: Size.infinite,
              painter: _MapPlaceholderPainter(),
            ),
          ),

          // Markers
          ..._state.visibleMarkers.map((marker) {
            // Convert lat/lng to screen position (simplified)
            final x = (marker.longitude + 98) * 500 + 50;
            final y = (31 - marker.latitude) * 500 + 50;

            return Positioned(
              left: x,
              top: y,
              child: PropertyMarker(
                marker: marker,
                onTap: () => _selectMarker(marker),
              ),
            );
          }),

          // Layer toggles (top)
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: LayerToggleRow(
              layers: _state.layers.where((l) => !l.type.isOverlay).toList(),
              onToggle: _toggleLayer,
            ),
          ),

          // Layer panel toggle (bottom right)
          Positioned(
            right: 16,
            bottom: _state.selectedMarker != null ? 200 : 100,
            child: LayerPanelToggle(
              isOpen: _state.isLayerPanelOpen,
              activeLayerCount: activeLayerCount,
              onTap: _toggleLayerPanel,
            ),
          ),

          // Selected marker info card
          if (_state.selectedMarker != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MarkerInfoCard(
                marker: _state.selectedMarker!,
                onClose: _clearSelection,
                onViewDetails: () {
                  // Navigate to property details
                  Navigator.pop(context, _state.selectedMarker!.id);
                },
              ),
            ),

          // Layer panel
          if (_state.isLayerPanelOpen)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: LayerPanel(
                layers: _state.layers,
                onToggle: _toggleLayer,
                onOpacityChange: _updateLayerOpacity,
                onClose: _toggleLayerPanel,
              ),
            ),
        ],
      ),
    );
  }
}

class _MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw grid
    const spacing = 40.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw some fake roads
    final roadPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.2, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.6, 0),
      Offset(size.width * 0.6, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
