import 'package:flutter/material.dart';

/// Types of counterparties in the tax radar.
enum CounterpartyType {
  /// Tax authority (county, state)
  taxAuthority(
    label: 'Tax Authority',
    icon: Icons.account_balance,
    color: Color(0xFFDC2626),
  ),

  /// Competing bidder at auctions
  bidder(
    label: 'Bidder',
    icon: Icons.person,
    color: Color(0xFFD97706),
  ),

  /// Property owner
  owner(
    label: 'Owner',
    icon: Icons.home,
    color: Color(0xFF7C3AED),
  ),

  /// Title company
  titleCompany(
    label: 'Title Company',
    icon: Icons.business,
    color: Color(0xFF2563EB),
  ),

  /// Attorney/Legal
  attorney(
    label: 'Attorney',
    icon: Icons.gavel,
    color: Color(0xFF059669),
  ),

  /// Real estate agent
  agent(
    label: 'Agent',
    icon: Icons.badge,
    color: Color(0xFF0891B2),
  ),

  /// Lender/Bank
  lender(
    label: 'Lender',
    icon: Icons.credit_card,
    color: Color(0xFFDB2777),
  );

  const CounterpartyType({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

/// Health status of a relationship.
enum RelationshipHealth {
  /// Good standing, active relationship
  good(color: Color(0xFF059669), label: 'Good'),

  /// Some issues, needs attention
  warning(color: Color(0xFFD97706), label: 'Warning'),

  /// Critical issues, requires action
  critical(color: Color(0xFFDC2626), label: 'Critical'),

  /// Unknown/no relationship history
  unknown(color: Color(0xFF6B7280), label: 'Unknown');

  const RelationshipHealth({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;
}

/// An activity item in the relationship feed.
class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.description,
    required this.timestamp,
    this.icon,
    this.propertyId,
  });

  final String id;
  final String description;
  final DateTime timestamp;
  final IconData? icon;
  final String? propertyId;
}

/// A counterparty in the tax radar.
class Counterparty {
  const Counterparty({
    required this.id,
    required this.name,
    required this.type,
    required this.angle,
    required this.distance,
    this.health = RelationshipHealth.unknown,
    this.interactionCount = 0,
    this.lastActivity,
    this.recentActivities = const [],
  });

  final String id;
  final String name;
  final CounterpartyType type;
  final double angle; // Position on radar in degrees
  final double distance; // 0.0 (center) to 1.0 (edge)
  final RelationshipHealth health;
  final int interactionCount;
  final DateTime? lastActivity;
  final List<ActivityItem> recentActivities;

  /// Size of the node based on interaction count.
  double get nodeSize {
    if (interactionCount == 0) return 30.0;
    if (interactionCount < 5) return 40.0;
    if (interactionCount < 20) return 50.0;
    return 60.0;
  }

  Counterparty copyWith({
    String? id,
    String? name,
    CounterpartyType? type,
    double? angle,
    double? distance,
    RelationshipHealth? health,
    int? interactionCount,
    DateTime? lastActivity,
    List<ActivityItem>? recentActivities,
  }) {
    return Counterparty(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      angle: angle ?? this.angle,
      distance: distance ?? this.distance,
      health: health ?? this.health,
      interactionCount: interactionCount ?? this.interactionCount,
      lastActivity: lastActivity ?? this.lastActivity,
      recentActivities: recentActivities ?? this.recentActivities,
    );
  }
}

/// State for the tax radar view.
class TaxRadarState {
  const TaxRadarState({
    this.counterparties = const [],
    this.selectedCounterpartyId,
    this.sweepAngle = 0.0,
    this.isScanning = false,
    this.filterTypes = const {},
  });

  final List<Counterparty> counterparties;
  final String? selectedCounterpartyId;
  final double sweepAngle;
  final bool isScanning;
  final Set<CounterpartyType> filterTypes;

  Counterparty? get selectedCounterparty => selectedCounterpartyId != null
      ? counterparties.firstWhere(
          (c) => c.id == selectedCounterpartyId,
          orElse: () => counterparties.first,
        )
      : null;

  List<Counterparty> get visibleCounterparties {
    if (filterTypes.isEmpty) return counterparties;
    return counterparties
        .where((c) => filterTypes.contains(c.type))
        .toList();
  }

  TaxRadarState copyWith({
    List<Counterparty>? counterparties,
    String? selectedCounterpartyId,
    double? sweepAngle,
    bool? isScanning,
    Set<CounterpartyType>? filterTypes,
  }) {
    return TaxRadarState(
      counterparties: counterparties ?? this.counterparties,
      selectedCounterpartyId:
          selectedCounterpartyId ?? this.selectedCounterpartyId,
      sweepAngle: sweepAngle ?? this.sweepAngle,
      isScanning: isScanning ?? this.isScanning,
      filterTypes: filterTypes ?? this.filterTypes,
    );
  }
}
