import 'package:flutter/material.dart';

import 'models/relationship.dart';
import 'widgets/magnetic_canvas.dart';

/// A full-screen view for exploring magnetic property groups.
class MagneticGroupsScreen extends StatefulWidget {
  const MagneticGroupsScreen({
    super.key,
    this.initialState,
  });

  final MagneticGroupsState? initialState;

  @override
  State<MagneticGroupsScreen> createState() => _MagneticGroupsScreenState();
}

class _MagneticGroupsScreenState extends State<MagneticGroupsScreen> {
  late MagneticGroupsState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState ?? _generateSampleState();
  }

  MagneticGroupsState _generateSampleState() {
    return MagneticGroupsState(
      clusters: [
        PropertyClusterData(
          id: '1',
          relationType: RelationType.sameOwner,
          properties: [
            const ClusteredProperty(
              id: 'p1',
              address: '123 Main St',
              position: Offset(200, 200),
              fviScore: 85,
            ),
            const ClusteredProperty(
              id: 'p2',
              address: '125 Main St',
              position: Offset(250, 180),
              fviScore: 78,
            ),
            const ClusteredProperty(
              id: 'p3',
              address: '456 Oak Ave',
              position: Offset(220, 240),
              fviScore: 82,
            ),
          ],
          center: const Offset(225, 200),
          radius: 80,
        ),
        PropertyClusterData(
          id: '2',
          relationType: RelationType.sameStreet,
          properties: [
            const ClusteredProperty(
              id: 'p4',
              address: '100 Pine Rd',
              position: Offset(400, 300),
              fviScore: 72,
            ),
            const ClusteredProperty(
              id: 'p5',
              address: '102 Pine Rd',
              position: Offset(420, 280),
              fviScore: 69,
            ),
          ],
          center: const Offset(410, 290),
          radius: 60,
        ),
        PropertyClusterData(
          id: '3',
          relationType: RelationType.sameAuction,
          properties: [
            const ClusteredProperty(
              id: 'p6',
              address: '789 Elm Ct',
              position: Offset(150, 400),
              fviScore: 91,
            ),
            const ClusteredProperty(
              id: 'p7',
              address: '321 Maple Ln',
              position: Offset(180, 420),
              fviScore: 88,
            ),
            const ClusteredProperty(
              id: 'p8',
              address: '654 Birch Dr',
              position: Offset(130, 380),
              fviScore: 79,
            ),
            const ClusteredProperty(
              id: 'p9',
              address: '987 Cedar Blvd',
              position: Offset(200, 390),
              fviScore: 84,
            ),
          ],
          center: const Offset(165, 400),
          radius: 100,
        ),
      ],
      ungroupedProperties: [
        const ClusteredProperty(
          id: 'u1',
          address: '999 Lone Rd',
          position: Offset(350, 150),
          fviScore: 65,
        ),
      ],
    );
  }

  void _onClusterTap(PropertyClusterData cluster) {
    setState(() {
      _state = _state.copyWith(
        clusters: _state.clusters.map((c) {
          if (c.id == cluster.id) {
            return c.copyWith(isExpanded: !c.isExpanded);
          }
          return c;
        }).toList(),
      );
    });
  }

  void _onClusterExpand(PropertyClusterData cluster) {
    setState(() {
      _state = _state.copyWith(
        clusters: _state.clusters.map((c) {
          if (c.id == cluster.id) {
            return c.copyWith(isExpanded: true);
          }
          return c;
        }).toList(),
      );
    });
  }

  void _onPropertyTap(ClusteredProperty property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPropertySheet(property),
    );
  }

  void _onRelationTypeChange(RelationType? type) {
    setState(() {
      _state = _state.copyWith(
        activeRelationType: type,
        isAnimating: true,
      );
    });

    // Stop animation after delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _state = _state.copyWith(isAnimating: false);
        });
      }
    });
  }

  Widget _buildPropertySheet(ClusteredProperty property) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.address,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (property.fviScore != null)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getFviColor(property.fviScore!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'FVI ${property.fviScore!.toStringAsFixed(0)}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }

  Color _getFviColor(double score) {
    if (score >= 80) return const Color(0xFF059669);
    if (score >= 60) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magnetic Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Magnetic Groups'),
                  content: const Text(
                    'Properties are automatically grouped by relationships. '
                    'Tap a group to see details, or filter by relationship type.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: MagneticCanvas(
        state: _state,
        onClusterTap: _onClusterTap,
        onClusterExpand: _onClusterExpand,
        onPropertyTap: _onPropertyTap,
        onRelationTypeChange: _onRelationTypeChange,
      ),
    );
  }
}
