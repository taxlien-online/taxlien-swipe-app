import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/models/spatial_position.dart';
import '../../../core/design/app_spacing.dart';

/// DBSCAN-inspired clustering service for grouping nearby properties
class ClusteringService {
  /// Minimum distance between points to be considered separate (in normalized coords)
  final double minDistance;

  /// Minimum zoom level at which clustering is disabled
  final double clusterDisableZoom;

  ClusteringService({
    this.minDistance = 0.03, // 3% of canvas
    this.clusterDisableZoom = 2.5,
  });

  /// Determine if clustering should be applied
  bool shouldCluster(double zoomLevel, int propertyCount) {
    if (zoomLevel >= clusterDisableZoom) return false;
    if (propertyCount < 10) return false;
    return true;
  }

  /// Cluster positions based on proximity
  /// Returns clustered positions where clusters are represented by a single position
  ClusterResult clusterPositions(
    List<SpatialPosition> positions, {
    double? customMinDistance,
  }) {
    if (positions.isEmpty) {
      return ClusterResult(
        positions: [],
        clusterCounts: {},
        clusterMembers: {},
      );
    }

    final distance = customMinDistance ?? minDistance;
    final clusters = <List<SpatialPosition>>[];
    final visited = <int>{};

    for (int i = 0; i < positions.length; i++) {
      if (visited.contains(i)) continue;

      final cluster = <SpatialPosition>[positions[i]];
      visited.add(i);

      // Find all nearby points
      for (int j = i + 1; j < positions.length; j++) {
        if (visited.contains(j)) continue;

        if (_distance(positions[i], positions[j]) < distance) {
          cluster.add(positions[j]);
          visited.add(j);
        }
      }

      clusters.add(cluster);
    }

    // Expand clusters to include transitive neighbors
    final expandedClusters = _expandClusters(clusters, positions, distance);

    // Create result
    final resultPositions = <SpatialPosition>[];
    final clusterCounts = <String, int>{};
    final clusterMembers = <String, List<String>>{};

    for (final cluster in expandedClusters) {
      if (cluster.length == 1) {
        // Single point, no clustering
        resultPositions.add(cluster.first);
      } else {
        // Create cluster representative
        final center = _calculateClusterCenter(cluster);
        final representative = SpatialPosition(
          propertyId: cluster.first.propertyId, // Use first property as representative
          x: center.dx,
          y: center.dy,
          radius: _calculateClusterRadius(cluster),
          color: _calculateClusterColor(cluster),
          opacity: 1.0,
        );
        resultPositions.add(representative);
        clusterCounts[representative.propertyId] = cluster.length;
        clusterMembers[representative.propertyId] =
            cluster.map((p) => p.propertyId).toList();
      }
    }

    return ClusterResult(
      positions: resultPositions,
      clusterCounts: clusterCounts,
      clusterMembers: clusterMembers,
    );
  }

  /// Expand clusters to include transitive neighbors
  List<List<SpatialPosition>> _expandClusters(
    List<List<SpatialPosition>> initialClusters,
    List<SpatialPosition> allPositions,
    double distance,
  ) {
    // Simple implementation: merge overlapping clusters
    final result = <List<SpatialPosition>>[];
    final used = <int>{};

    for (int i = 0; i < initialClusters.length; i++) {
      if (used.contains(i)) continue;

      final merged = List<SpatialPosition>.from(initialClusters[i]);
      used.add(i);

      bool didMerge;
      do {
        didMerge = false;
        for (int j = 0; j < initialClusters.length; j++) {
          if (used.contains(j)) continue;

          // Check if any point in cluster j is close to any point in merged
          bool shouldMerge = false;
          outer:
          for (final p1 in merged) {
            for (final p2 in initialClusters[j]) {
              if (_distance(p1, p2) < distance * 1.5) {
                shouldMerge = true;
                break outer;
              }
            }
          }

          if (shouldMerge) {
            merged.addAll(initialClusters[j]);
            used.add(j);
            didMerge = true;
          }
        }
      } while (didMerge);

      result.add(merged);
    }

    return result;
  }

  double _distance(SpatialPosition a, SpatialPosition b) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  Offset _calculateClusterCenter(List<SpatialPosition> cluster) {
    double sumX = 0, sumY = 0;
    for (final pos in cluster) {
      sumX += pos.x;
      sumY += pos.y;
    }
    return Offset(sumX / cluster.length, sumY / cluster.length);
  }

  double _calculateClusterRadius(List<SpatialPosition> cluster) {
    // Base radius + scaling based on cluster size
    final baseRadius = cluster.map((p) => p.radius).reduce(math.max);
    final sizeBonus = math.log(cluster.length + 1) * 4;
    return (baseRadius + sizeBonus).clamp(
      AppSpacing.galaxyPointMinRadius,
      AppSpacing.galaxyPointMaxRadius,
    );
  }

  Color _calculateClusterColor(List<SpatialPosition> cluster) {
    // Use the most common color in the cluster
    final colorCounts = <Color, int>{};
    for (final pos in cluster) {
      colorCounts[pos.color] = (colorCounts[pos.color] ?? 0) + 1;
    }

    Color? mostCommon;
    int maxCount = 0;
    for (final entry in colorCounts.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        mostCommon = entry.key;
      }
    }

    return mostCommon ?? cluster.first.color;
  }

  /// Get all property IDs that belong to a cluster
  List<String> getClusterMembers(
    String representativeId,
    ClusterResult result,
  ) {
    return result.clusterMembers[representativeId] ?? [representativeId];
  }

  /// Find which cluster (if any) contains a given property
  String? findClusterForProperty(
    String propertyId,
    ClusterResult result,
  ) {
    for (final entry in result.clusterMembers.entries) {
      if (entry.value.contains(propertyId)) {
        return entry.key;
      }
    }
    return null;
  }
}

/// Result of clustering operation
class ClusterResult {
  /// Positions after clustering (clusters represented by single position)
  final List<SpatialPosition> positions;

  /// Map of cluster representative ID to cluster size
  final Map<String, int> clusterCounts;

  /// Map of cluster representative ID to member property IDs
  final Map<String, List<String>> clusterMembers;

  const ClusterResult({
    required this.positions,
    required this.clusterCounts,
    required this.clusterMembers,
  });

  /// Total number of properties (including those in clusters)
  int get totalPropertyCount {
    int count = 0;
    for (final pos in positions) {
      count += clusterCounts[pos.propertyId] ?? 1;
    }
    return count;
  }

  /// Number of clusters (groups with >1 property)
  int get clusterCount => clusterCounts.length;

  /// Number of unclustered single properties
  int get singleCount => positions.length - clusterCount;
}

/// Extension to apply clustering to a list of positions
extension ClusteringExtension on List<SpatialPosition> {
  ClusterResult cluster({
    double minDistance = 0.03,
    double zoomLevel = 1.0,
  }) {
    final service = ClusteringService(minDistance: minDistance);
    if (!service.shouldCluster(zoomLevel, length)) {
      return ClusterResult(
        positions: this,
        clusterCounts: {},
        clusterMembers: {},
      );
    }
    return service.clusterPositions(this);
  }
}
