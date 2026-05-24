import 'package:flutter/material.dart';

/// Triage zone types for property categorization.
enum TriageZone {
  /// Top priority - immediate action required
  hot(
    label: 'Hot',
    icon: Icons.local_fire_department,
    color: Color(0xFFDC2626),
    angle: -90, // Top
  ),

  /// Worth investigating further
  maybe(
    label: 'Maybe',
    icon: Icons.help_outline,
    color: Color(0xFFD97706),
    angle: 0, // Right
  ),

  /// Not interested, skip
  pass(
    label: 'Pass',
    icon: Icons.close,
    color: Color(0xFF6B7280),
    angle: 180, // Left
  ),

  /// Save for later review
  later(
    label: 'Later',
    icon: Icons.schedule,
    color: Color(0xFF2563EB),
    angle: 90, // Bottom
  );

  const TriageZone({
    required this.label,
    required this.icon,
    required this.color,
    required this.angle,
  });

  final String label;
  final IconData icon;
  final Color color;
  final double angle; // Degrees from right (0 = right, 90 = down, etc.)

  /// Get zone from flick angle in degrees.
  static TriageZone fromAngle(double angle) {
    // Normalize angle to 0-360
    angle = angle % 360;
    if (angle < 0) angle += 360;

    // Map to zones (45-degree sectors centered on each zone)
    if (angle >= 315 || angle < 45) return TriageZone.maybe; // Right
    if (angle >= 45 && angle < 135) return TriageZone.later; // Bottom
    if (angle >= 135 && angle < 225) return TriageZone.pass; // Left
    return TriageZone.hot; // Top (225-315)
  }
}

/// A property card in the triage queue.
class TriageCard {
  const TriageCard({
    required this.id,
    required this.address,
    required this.fviScore,
    this.thumbnailUrl,
    this.zone,
  });

  final String id;
  final String address;
  final double fviScore;
  final String? thumbnailUrl;
  final TriageZone? zone;

  TriageCard copyWith({
    String? id,
    String? address,
    double? fviScore,
    String? thumbnailUrl,
    TriageZone? zone,
  }) {
    return TriageCard(
      id: id ?? this.id,
      address: address ?? this.address,
      fviScore: fviScore ?? this.fviScore,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      zone: zone ?? this.zone,
    );
  }
}

/// State for the triage board.
class TriageBoard {
  const TriageBoard({
    this.queue = const [],
    this.categorized = const {},
  });

  /// Cards waiting to be triaged.
  final List<TriageCard> queue;

  /// Cards organized by zone.
  final Map<TriageZone, List<TriageCard>> categorized;

  TriageCard? get currentCard => queue.isNotEmpty ? queue.first : null;
  int get remainingCount => queue.length;

  int countForZone(TriageZone zone) => categorized[zone]?.length ?? 0;

  TriageBoard addToZone(TriageCard card, TriageZone zone) {
    final newQueue = List<TriageCard>.from(queue)..remove(card);
    final newCategorized = Map<TriageZone, List<TriageCard>>.from(categorized);
    final zoneList = List<TriageCard>.from(newCategorized[zone] ?? []);
    zoneList.add(card.copyWith(zone: zone));
    newCategorized[zone] = zoneList;

    return TriageBoard(
      queue: newQueue,
      categorized: newCategorized,
    );
  }

  TriageBoard copyWith({
    List<TriageCard>? queue,
    Map<TriageZone, List<TriageCard>>? categorized,
  }) {
    return TriageBoard(
      queue: queue ?? this.queue,
      categorized: categorized ?? this.categorized,
    );
  }
}
