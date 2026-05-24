import 'package:flutter/material.dart';

/// Types of edges (relationships) in the tax graph.
enum EdgeType {
  /// Ownership relationship
  owns(
    label: 'Owns',
    color: Color(0xFF7C3AED),
    dashPattern: null,
  ),

  /// Lien relationship
  hasLien(
    label: 'Has Lien',
    color: Color(0xFFDC2626),
    dashPattern: null,
  ),

  /// Mortgage/loan relationship
  financed(
    label: 'Financed By',
    color: Color(0xFF059669),
    dashPattern: null,
  ),

  /// Same owner relationship (between properties)
  sameOwner(
    label: 'Same Owner',
    color: Color(0xFF2563EB),
    dashPattern: [5, 5],
  ),

  /// Transfer/sale relationship
  transferredTo(
    label: 'Transferred To',
    color: Color(0xFFD97706),
    dashPattern: null,
  ),

  /// Located in (jurisdiction)
  locatedIn(
    label: 'Located In',
    color: Color(0xFF6B7280),
    dashPattern: [2, 3],
  ),

  /// Scheduled for auction
  scheduledFor(
    label: 'Scheduled For',
    color: Color(0xFFDB2777),
    dashPattern: null,
  ),

  /// Related entity (LLC connections, etc.)
  relatedTo(
    label: 'Related To',
    color: Color(0xFF0891B2),
    dashPattern: [8, 4],
  );

  const EdgeType({
    required this.label,
    required this.color,
    this.dashPattern,
  });

  final String label;
  final Color color;
  final List<double>? dashPattern;

  bool get isDashed => dashPattern != null;
}

/// An edge (relationship) in the tax graph.
class GraphEdgeData {
  const GraphEdgeData({
    required this.id,
    required this.sourceId,
    required this.targetId,
    required this.type,
    this.label,
    this.weight = 1.0,
    this.isHighlighted = false,
    this.metadata = const {},
  });

  final String id;
  final String sourceId;
  final String targetId;
  final EdgeType type;
  final String? label;
  final double weight;
  final bool isHighlighted;
  final Map<String, dynamic> metadata;

  /// Edge thickness based on weight.
  double get thickness => 1.0 + (weight * 2.0);

  GraphEdgeData copyWith({
    String? id,
    String? sourceId,
    String? targetId,
    EdgeType? type,
    String? label,
    double? weight,
    bool? isHighlighted,
    Map<String, dynamic>? metadata,
  }) {
    return GraphEdgeData(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      targetId: targetId ?? this.targetId,
      type: type ?? this.type,
      label: label ?? this.label,
      weight: weight ?? this.weight,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Severity levels for graph anomalies.
enum AnomalySeverity {
  /// Low priority, informational
  low(color: Color(0xFF2563EB), label: 'Low'),

  /// Medium priority, worth investigating
  medium(color: Color(0xFFD97706), label: 'Medium'),

  /// High priority, requires attention
  high(color: Color(0xFFDC2626), label: 'High');

  const AnomalySeverity({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;
}

/// An anomaly detected in the graph.
class GraphAnomaly {
  const GraphAnomaly({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.affectedNodeIds,
    this.suggestedAction,
  });

  final String id;
  final String title;
  final String description;
  final AnomalySeverity severity;
  final List<String> affectedNodeIds;
  final String? suggestedAction;
}

/// State for the tax graph view.
class TaxGraphState {
  const TaxGraphState({
    this.nodes = const [],
    this.edges = const [],
    this.anomalies = const [],
    this.selectedNodeId,
    this.hoveredNodeId,
    this.selectedAnomalyId,
    this.scale = 1.0,
    this.offset = Offset.zero,
    this.isSimulating = false,
  });

  final List<GraphNodeData> nodes;
  final List<GraphEdgeData> edges;
  final List<GraphAnomaly> anomalies;
  final String? selectedNodeId;
  final String? hoveredNodeId;
  final String? selectedAnomalyId;
  final double scale;
  final Offset offset;
  final bool isSimulating;

  GraphNodeData? get selectedNode => selectedNodeId != null
      ? nodes.firstWhere(
          (n) => n.id == selectedNodeId,
          orElse: () => nodes.first,
        )
      : null;

  GraphAnomaly? get selectedAnomaly => selectedAnomalyId != null
      ? anomalies.firstWhere(
          (a) => a.id == selectedAnomalyId,
          orElse: () => anomalies.first,
        )
      : null;

  /// Get all edges connected to a node.
  List<GraphEdgeData> edgesForNode(String nodeId) {
    return edges
        .where((e) => e.sourceId == nodeId || e.targetId == nodeId)
        .toList();
  }

  /// Get all connected node IDs for a given node.
  Set<String> connectedNodeIds(String nodeId) {
    final connected = <String>{};
    for (final edge in edges) {
      if (edge.sourceId == nodeId) connected.add(edge.targetId);
      if (edge.targetId == nodeId) connected.add(edge.sourceId);
    }
    return connected;
  }

  TaxGraphState copyWith({
    List<GraphNodeData>? nodes,
    List<GraphEdgeData>? edges,
    List<GraphAnomaly>? anomalies,
    String? selectedNodeId,
    String? hoveredNodeId,
    String? selectedAnomalyId,
    double? scale,
    Offset? offset,
    bool? isSimulating,
  }) {
    return TaxGraphState(
      nodes: nodes ?? this.nodes,
      edges: edges ?? this.edges,
      anomalies: anomalies ?? this.anomalies,
      selectedNodeId: selectedNodeId ?? this.selectedNodeId,
      hoveredNodeId: hoveredNodeId ?? this.hoveredNodeId,
      selectedAnomalyId: selectedAnomalyId ?? this.selectedAnomalyId,
      scale: scale ?? this.scale,
      offset: offset ?? this.offset,
      isSimulating: isSimulating ?? this.isSimulating,
    );
  }
}
