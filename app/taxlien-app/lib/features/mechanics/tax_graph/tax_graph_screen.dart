import 'package:flutter/material.dart';

import 'models/graph_edge_data.dart';
import 'models/graph_node_data.dart';
import 'utils/force_directed_layout.dart';
import 'widgets/anomaly_panel.dart';
import 'widgets/graph_canvas.dart';
import 'widgets/graph_edge.dart';

/// A full-screen graph view showing property connections.
class TaxGraphScreen extends StatefulWidget {
  const TaxGraphScreen({
    super.key,
    this.initialState,
    this.propertyId,
  });

  final TaxGraphState? initialState;
  final String? propertyId;

  @override
  State<TaxGraphScreen> createState() => _TaxGraphScreenState();
}

class _TaxGraphScreenState extends State<TaxGraphScreen> {
  late TaxGraphState _state;
  bool _showAnomalies = true;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState ?? _generateSampleState();

    // Start simulation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _state = _state.copyWith(isSimulating: true);
        });

        // Stop after a few seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _state = _state.copyWith(isSimulating: false);
            });
          }
        });
      }
    });
  }

  TaxGraphState _generateSampleState() {
    final nodes = [
      const GraphNodeData(
        id: 'p1',
        type: GraphNodeType.property,
        label: '123 Main St',
        subtitle: 'Tax Lien Property',
        position: Offset(300, 300),
      ),
      const GraphNodeData(
        id: 'o1',
        type: GraphNodeType.owner,
        label: 'John Smith',
        subtitle: 'Individual',
        position: Offset(150, 200),
      ),
      const GraphNodeData(
        id: 'l1',
        type: GraphNodeType.lienHolder,
        label: 'County Tax',
        subtitle: '\$4,250 owed',
        position: Offset(450, 200),
      ),
      const GraphNodeData(
        id: 'b1',
        type: GraphNodeType.lender,
        label: 'First National',
        subtitle: 'Mortgage',
        position: Offset(450, 400),
      ),
      const GraphNodeData(
        id: 'p2',
        type: GraphNodeType.property,
        label: '456 Oak Ave',
        subtitle: 'Related Property',
        position: Offset(150, 400),
      ),
      const GraphNodeData(
        id: 'j1',
        type: GraphNodeType.jurisdiction,
        label: 'Harris County',
        position: Offset(300, 150),
      ),
      const GraphNodeData(
        id: 'a1',
        type: GraphNodeType.auction,
        label: 'June Auction',
        subtitle: '06/15/2024',
        position: Offset(500, 300),
      ),
    ];

    final edges = [
      const GraphEdgeData(
        id: 'e1',
        sourceId: 'o1',
        targetId: 'p1',
        type: EdgeType.owns,
      ),
      const GraphEdgeData(
        id: 'e2',
        sourceId: 'l1',
        targetId: 'p1',
        type: EdgeType.hasLien,
      ),
      const GraphEdgeData(
        id: 'e3',
        sourceId: 'b1',
        targetId: 'p1',
        type: EdgeType.financed,
      ),
      const GraphEdgeData(
        id: 'e4',
        sourceId: 'o1',
        targetId: 'p2',
        type: EdgeType.owns,
      ),
      const GraphEdgeData(
        id: 'e5',
        sourceId: 'p1',
        targetId: 'p2',
        type: EdgeType.sameOwner,
      ),
      const GraphEdgeData(
        id: 'e6',
        sourceId: 'p1',
        targetId: 'j1',
        type: EdgeType.locatedIn,
      ),
      const GraphEdgeData(
        id: 'e7',
        sourceId: 'p1',
        targetId: 'a1',
        type: EdgeType.scheduledFor,
      ),
    ];

    final anomalies = [
      const GraphAnomaly(
        id: 'an1',
        title: 'Multiple Liens Detected',
        description:
            'This property has both tax liens and mortgage encumbrances.',
        severity: AnomalySeverity.medium,
        affectedNodeIds: ['p1', 'l1', 'b1'],
        suggestedAction: 'Review lien positions',
      ),
      const GraphAnomaly(
        id: 'an2',
        title: 'Same Owner Pattern',
        description:
            'Owner has multiple properties with tax issues.',
        severity: AnomalySeverity.low,
        affectedNodeIds: ['o1', 'p1', 'p2'],
        suggestedAction: 'View owner portfolio',
      ),
    ];

    return TaxGraphState(
      nodes: nodes,
      edges: edges,
      anomalies: anomalies,
    );
  }

  void _onNodeTap(GraphNodeData node) {
    setState(() {
      _state = _state.copyWith(
        selectedNodeId: _state.selectedNodeId == node.id ? null : node.id,
      );
    });
  }

  void _onNodeDoubleTap(GraphNodeData node) {
    // Pin/unpin node
    setState(() {
      _state = _state.copyWith(
        nodes: _state.nodes.map((n) {
          if (n.id == node.id) {
            return n.copyWith(isFixed: !n.isFixed);
          }
          return n;
        }).toList(),
      );
    });
  }

  void _onNodeDrag(GraphNodeData node, Offset delta) {
    setState(() {
      _state = _state.copyWith(
        nodes: _state.nodes.map((n) {
          if (n.id == node.id) {
            return n.copyWith(
              position: n.position + delta,
              isFixed: true,
            );
          }
          return n;
        }).toList(),
      );
    });
  }

  void _onBackgroundTap() {
    setState(() {
      _state = _state.copyWith(
        selectedNodeId: null,
        selectedAnomalyId: null,
      );
    });
  }

  void _onAnomalySelect(GraphAnomaly anomaly) {
    setState(() {
      _state = _state.copyWith(
        selectedAnomalyId: anomaly.id,
        // Highlight affected nodes
        nodes: _state.nodes.map((n) {
          return n.copyWith(
            isHighlighted: anomaly.affectedNodeIds.contains(n.id),
          );
        }).toList(),
      );
    });
  }

  void _onAnomalyDismiss(GraphAnomaly anomaly) {
    setState(() {
      _state = _state.copyWith(
        anomalies: _state.anomalies.where((a) => a.id != anomaly.id).toList(),
        selectedAnomalyId: null,
        nodes: _state.nodes.map((n) => n.copyWith(isHighlighted: false)).toList(),
      );
    });
  }

  void _restartSimulation() {
    setState(() {
      _state = _state.copyWith(isSimulating: true);
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _state = _state.copyWith(isSimulating: false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection Graph'),
        actions: [
          IconButton(
            icon: Icon(
              _state.isSimulating ? Icons.stop : Icons.play_arrow,
            ),
            onPressed: _restartSimulation,
            tooltip: _state.isSimulating ? 'Stop' : 'Restart layout',
          ),
          IconButton(
            icon: Badge(
              label: Text(_state.anomalies.length.toString()),
              isLabelVisible: _state.anomalies.isNotEmpty,
              child: Icon(
                _showAnomalies ? Icons.warning : Icons.warning_amber,
              ),
            ),
            onPressed: () {
              setState(() {
                _showAnomalies = !_showAnomalies;
              });
            },
            tooltip: 'Toggle anomalies',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Graph canvas
          GraphCanvas(
            state: _state,
            onNodeTap: _onNodeTap,
            onNodeDoubleTap: _onNodeDoubleTap,
            onNodeDrag: _onNodeDrag,
            onBackgroundTap: _onBackgroundTap,
          ),

          // Legend
          Positioned(
            left: 16,
            top: 16,
            child: GraphEdgeLegend(
              edgeTypes: EdgeType.values.take(4).toList(),
            ),
          ),

          // Simulation indicator
          if (_state.isSimulating)
            Positioned(
              right: 16,
              top: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Arranging...',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Anomaly panel
          if (_showAnomalies && _state.anomalies.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: AnomalyPanel(
                anomalies: _state.anomalies,
                selectedAnomalyId: _state.selectedAnomalyId,
                onAnomalySelect: _onAnomalySelect,
                onDismiss: _onAnomalyDismiss,
              ),
            ),
        ],
      ),
    );
  }
}
