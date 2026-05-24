import 'package:flutter/material.dart';

/// Types of nodes in the tax graph.
enum GraphNodeType {
  /// A property (central focus)
  property(
    label: 'Property',
    icon: Icons.home,
    color: Color(0xFF2563EB),
  ),

  /// An owner (person or entity)
  owner(
    label: 'Owner',
    icon: Icons.person,
    color: Color(0xFF7C3AED),
  ),

  /// A lien holder
  lienHolder(
    label: 'Lien Holder',
    icon: Icons.receipt_long,
    color: Color(0xFFDC2626),
  ),

  /// A lender/bank
  lender(
    label: 'Lender',
    icon: Icons.account_balance,
    color: Color(0xFF059669),
  ),

  /// A legal entity (LLC, Trust)
  entity(
    label: 'Entity',
    icon: Icons.business,
    color: Color(0xFFD97706),
  ),

  /// A county/jurisdiction
  jurisdiction(
    label: 'Jurisdiction',
    icon: Icons.location_city,
    color: Color(0xFF0891B2),
  ),

  /// An auction event
  auction(
    label: 'Auction',
    icon: Icons.gavel,
    color: Color(0xFFDB2777),
  );

  const GraphNodeType({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

/// A node in the tax graph.
class GraphNodeData {
  const GraphNodeData({
    required this.id,
    required this.type,
    required this.label,
    this.subtitle,
    this.position = Offset.zero,
    this.velocity = Offset.zero,
    this.isFixed = false,
    this.isSelected = false,
    this.isHighlighted = false,
    this.metadata = const {},
  });

  final String id;
  final GraphNodeType type;
  final String label;
  final String? subtitle;
  final Offset position;
  final Offset velocity;
  final bool isFixed;
  final bool isSelected;
  final bool isHighlighted;
  final Map<String, dynamic> metadata;

  /// Node size based on type.
  double get size {
    switch (type) {
      case GraphNodeType.property:
        return 60.0;
      case GraphNodeType.owner:
      case GraphNodeType.entity:
        return 50.0;
      case GraphNodeType.lienHolder:
      case GraphNodeType.lender:
        return 45.0;
      case GraphNodeType.jurisdiction:
      case GraphNodeType.auction:
        return 40.0;
    }
  }

  GraphNodeData copyWith({
    String? id,
    GraphNodeType? type,
    String? label,
    String? subtitle,
    Offset? position,
    Offset? velocity,
    bool? isFixed,
    bool? isSelected,
    bool? isHighlighted,
    Map<String, dynamic>? metadata,
  }) {
    return GraphNodeData(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      subtitle: subtitle ?? this.subtitle,
      position: position ?? this.position,
      velocity: velocity ?? this.velocity,
      isFixed: isFixed ?? this.isFixed,
      isSelected: isSelected ?? this.isSelected,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      metadata: metadata ?? this.metadata,
    );
  }
}
