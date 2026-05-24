import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/graph_edge_data.dart';
import '../models/graph_node_data.dart';

/// Force-directed layout algorithm (Fruchterman-Reingold).
class ForceDirectedLayout {
  ForceDirectedLayout({
    required this.nodes,
    required this.edges,
    this.width = 800.0,
    this.height = 600.0,
    this.iterations = 100,
    this.coolingFactor = 0.95,
  }) {
    _temperature = math.sqrt(width * height) / 10;
    _k = math.sqrt((width * height) / nodes.length);
    _initialize();
  }

  final List<GraphNodeData> nodes;
  final List<GraphEdgeData> edges;
  final double width;
  final double height;
  final int iterations;
  final double coolingFactor;

  late double _temperature;
  late double _k; // Ideal edge length
  int _currentIteration = 0;

  /// Initialize random positions for nodes without positions.
  void _initialize() {
    final random = math.Random();

    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      if (node.position == Offset.zero && !node.isFixed) {
        final x = random.nextDouble() * width;
        final y = random.nextDouble() * height;
        nodes[i] = node.copyWith(position: Offset(x, y));
      }
    }
  }

  /// Run one step of the simulation.
  void step() {
    if (_currentIteration >= iterations || _temperature < 0.1) {
      return;
    }

    // Calculate repulsive forces between all pairs of nodes
    final forces = List<Offset>.filled(nodes.length, Offset.zero);

    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        final delta = nodes[i].position - nodes[j].position;
        final distance = delta.distance.clamp(0.1, double.infinity);
        final force = _repulsiveForce(distance);

        final normalized = delta / distance;
        final forceVector = normalized * force;

        forces[i] = forces[i] + forceVector;
        forces[j] = forces[j] - forceVector;
      }
    }

    // Calculate attractive forces along edges
    for (final edge in edges) {
      final sourceIndex = nodes.indexWhere((n) => n.id == edge.sourceId);
      final targetIndex = nodes.indexWhere((n) => n.id == edge.targetId);

      if (sourceIndex == -1 || targetIndex == -1) continue;

      final delta = nodes[sourceIndex].position - nodes[targetIndex].position;
      final distance = delta.distance.clamp(0.1, double.infinity);
      final force = _attractiveForce(distance);

      final normalized = delta / distance;
      final forceVector = normalized * force;

      forces[sourceIndex] = forces[sourceIndex] - forceVector;
      forces[targetIndex] = forces[targetIndex] + forceVector;
    }

    // Apply forces with temperature limiting
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i].isFixed) continue;

      final force = forces[i];
      final magnitude = force.distance;
      final limited = magnitude > _temperature ? _temperature : magnitude;

      if (magnitude > 0) {
        final normalized = force / magnitude;
        final displacement = normalized * limited;
        var newPosition = nodes[i].position + displacement;

        // Keep within bounds
        newPosition = Offset(
          newPosition.dx.clamp(50.0, width - 50),
          newPosition.dy.clamp(50.0, height - 50),
        );

        nodes[i] = nodes[i].copyWith(position: newPosition);
      }
    }

    // Cool down
    _temperature *= coolingFactor;
    _currentIteration++;
  }

  /// Run the full simulation.
  void runSimulation() {
    while (_currentIteration < iterations && _temperature > 0.1) {
      step();
    }
  }

  /// Reset the simulation.
  void reset() {
    _currentIteration = 0;
    _temperature = math.sqrt(width * height) / 10;
    _initialize();
  }

  /// Check if simulation is complete.
  bool get isComplete =>
      _currentIteration >= iterations || _temperature < 0.1;

  /// Get progress (0.0 to 1.0).
  double get progress => _currentIteration / iterations;

  // Repulsive force: k^2 / d
  double _repulsiveForce(double distance) {
    return (_k * _k) / distance;
  }

  // Attractive force: d^2 / k
  double _attractiveForce(double distance) {
    return (distance * distance) / _k;
  }
}

/// Utility for graph layout calculations.
class GraphLayoutUtils {
  /// Calculate the bounding box of all nodes.
  static Rect calculateBounds(List<GraphNodeData> nodes) {
    if (nodes.isEmpty) return Rect.zero;

    var minX = double.infinity;
    var minY = double.infinity;
    var maxX = double.negativeInfinity;
    var maxY = double.negativeInfinity;

    for (final node in nodes) {
      minX = node.position.dx < minX ? node.position.dx : minX;
      minY = node.position.dy < minY ? node.position.dy : minY;
      maxX = node.position.dx > maxX ? node.position.dx : maxX;
      maxY = node.position.dy > maxY ? node.position.dy : maxY;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  /// Calculate the center of all nodes.
  static Offset calculateCenter(List<GraphNodeData> nodes) {
    if (nodes.isEmpty) return Offset.zero;

    var sumX = 0.0;
    var sumY = 0.0;

    for (final node in nodes) {
      sumX += node.position.dx;
      sumY += node.position.dy;
    }

    return Offset(sumX / nodes.length, sumY / nodes.length);
  }

  /// Arrange nodes in a circle.
  static List<GraphNodeData> arrangeInCircle(
    List<GraphNodeData> nodes, {
    Offset center = const Offset(400, 300),
    double radius = 200,
  }) {
    final result = <GraphNodeData>[];

    for (var i = 0; i < nodes.length; i++) {
      final angle = (2 * math.pi * i) / nodes.length - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      result.add(nodes[i].copyWith(position: Offset(x, y)));
    }

    return result;
  }

  /// Arrange nodes in a hierarchical tree layout.
  static List<GraphNodeData> arrangeInTree(
    List<GraphNodeData> nodes,
    List<GraphEdgeData> edges, {
    String? rootId,
    Offset topLeft = const Offset(50, 50),
    double horizontalSpacing = 100,
    double verticalSpacing = 100,
  }) {
    if (nodes.isEmpty) return [];

    // Find root node
    final root = rootId != null
        ? nodes.firstWhere((n) => n.id == rootId, orElse: () => nodes.first)
        : nodes.first;

    // Build adjacency map
    final children = <String, List<String>>{};
    for (final edge in edges) {
      children.putIfAbsent(edge.sourceId, () => []).add(edge.targetId);
    }

    // BFS to assign levels
    final levels = <String, int>{};
    final queue = [root.id];
    levels[root.id] = 0;

    while (queue.isNotEmpty) {
      final nodeId = queue.removeAt(0);
      final level = levels[nodeId]!;

      for (final childId in children[nodeId] ?? []) {
        if (!levels.containsKey(childId)) {
          levels[childId] = level + 1;
          queue.add(childId);
        }
      }
    }

    // Group nodes by level
    final nodesByLevel = <int, List<String>>{};
    for (final entry in levels.entries) {
      nodesByLevel.putIfAbsent(entry.value, () => []).add(entry.key);
    }

    // Assign positions
    final result = <GraphNodeData>[];
    for (final node in nodes) {
      final level = levels[node.id] ?? 0;
      final nodesAtLevel = nodesByLevel[level] ?? [];
      final indexAtLevel = nodesAtLevel.indexOf(node.id);
      final totalAtLevel = nodesAtLevel.length;

      final x = topLeft.dx +
          (indexAtLevel + 0.5) * horizontalSpacing * (totalAtLevel > 1 ? 1 : 0) +
          horizontalSpacing / 2;
      final y = topLeft.dy + level * verticalSpacing;

      result.add(node.copyWith(position: Offset(x, y)));
    }

    return result;
  }
}
