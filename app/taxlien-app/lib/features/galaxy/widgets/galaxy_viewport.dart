import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/spatial_position.dart';
import '../../../core/models/galaxy_dimension.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_durations.dart';
import '../providers/galaxy_provider.dart';
import '../painters/property_point_painter.dart';
import '../services/clustering_service.dart';
import 'selection_provider.dart';

/// Main viewport widget for Galaxy visualization
class GalaxyViewport extends StatefulWidget {
  final void Function(String propertyId)? onPropertyTap;
  final void Function(String propertyId)? onPropertyDoubleTap;
  final void Function(String propertyId)? onPropertyLongPress;
  final bool enableClustering;
  final bool showAxisLabels;

  const GalaxyViewport({
    super.key,
    this.onPropertyTap,
    this.onPropertyDoubleTap,
    this.onPropertyLongPress,
    this.enableClustering = true,
    this.showAxisLabels = true,
  });

  @override
  State<GalaxyViewport> createState() => _GalaxyViewportState();
}

class _GalaxyViewportState extends State<GalaxyViewport>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late AnimationController _transitionController;
  final ClusteringService _clusteringService = ClusteringService();

  double _currentZoom = 1.0;
  ClusterResult? _clusterResult;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      vsync: this,
      duration: AppDurations.dimensionTransition,
    );
    _transitionController.addListener(_onTransitionUpdate);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  void _onTransitionUpdate() {
    final galaxyProvider = context.read<GalaxyProvider>();
    galaxyProvider.updateTransitionProgress(_transitionController.value);
  }

  void _onInteractionUpdate(ScaleUpdateDetails details) {
    final matrix = _transformationController.value;
    final scale = matrix.getMaxScaleOnAxis();
    if (scale != _currentZoom) {
      setState(() {
        _currentZoom = scale;
      });
      context.read<GalaxyProvider>().setZoomLevel(scale);
    }
  }

  void _handleTapUp(TapUpDetails details, Size size) {
    final galaxyProvider = context.read<GalaxyProvider>();
    final selectionProvider = context.read<SelectionProvider>();

    // Transform tap position to canvas coordinates
    final matrix = _transformationController.value;
    final inverseMatrix = Matrix4.inverted(matrix);
    final localPosition = MatrixUtils.transformPoint(
      inverseMatrix,
      details.localPosition,
    );

    // Find property at position
    final positions = _getDisplayPositions(galaxyProvider);
    for (final pos in positions) {
      final offset = pos.toOffset(size);
      final distance = (localPosition - offset).distance;
      if (distance <= pos.radius) {
        // Check if this is a cluster
        final clusterMembers =
            _clusterResult?.clusterMembers[pos.propertyId];
        if (clusterMembers != null && clusterMembers.length > 1) {
          // Zoom into cluster
          _zoomToCluster(pos, size);
        } else {
          // Single property tap
          if (widget.onPropertyTap != null) {
            widget.onPropertyTap!(pos.propertyId);
          } else {
            // Default: toggle selection
            selectionProvider.toggle(pos.propertyId);
          }
        }
        return;
      }
    }

    // Tap on empty space - clear selection if not in lasso mode
    if (!selectionProvider.isLassoMode) {
      // Optional: clear selection on empty tap
      // selectionProvider.clearSelection();
    }
  }

  void _handleDoubleTap(TapDownDetails details, Size size) {
    // Double tap to zoom
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    final targetScale = currentScale < 2.0 ? 2.5 : 1.0;

    final position = details.localPosition;
    final matrix = _transformationController.value.clone();

    // Calculate new matrix for zoom
    final focalPoint = position;
    final scaleFactor = targetScale / currentScale;

    matrix.translate(focalPoint.dx, focalPoint.dy);
    matrix.scale(scaleFactor);
    matrix.translate(-focalPoint.dx, -focalPoint.dy);

    // Animate to new transform
    _animateToMatrix(matrix);
  }

  void _zoomToCluster(SpatialPosition cluster, Size size) {
    final offset = cluster.toOffset(size);
    final matrix = Matrix4.identity();

    // Zoom to 3x centered on cluster
    const targetZoom = 3.0;
    matrix.translate(
      size.width / 2 - offset.dx * targetZoom,
      size.height / 2 - offset.dy * targetZoom,
    );
    matrix.scale(targetZoom);

    _animateToMatrix(matrix);
  }

  void _animateToMatrix(Matrix4 target) {
    final begin = _transformationController.value;
    final animation = Matrix4Tween(begin: begin, end: target).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Curves.easeOutCubic,
      ),
    );

    void listener() {
      _transformationController.value = animation.value;
    }

    animation.addListener(listener);
    _transitionController.forward(from: 0).then((_) {
      animation.removeListener(listener);
    });
  }

  List<SpatialPosition> _getDisplayPositions(GalaxyProvider provider) {
    final positions = provider.isTransitioning
        ? provider.getInterpolatedPositions()
        : provider.positions;

    // Apply clustering if enabled
    if (widget.enableClustering &&
        _clusteringService.shouldCluster(_currentZoom, positions.length)) {
      _clusterResult = _clusteringService.clusterPositions(
        positions,
        customMinDistance: 0.03 / _currentZoom,
      );
      return _clusterResult!.positions;
    }

    _clusterResult = null;
    return positions;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GalaxyProvider, SelectionProvider>(
      builder: (context, galaxyProvider, selectionProvider, child) {
        if (galaxyProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (galaxyProvider.properties.isEmpty) {
          return _buildEmptyState();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            final displayPositions = _getDisplayPositions(galaxyProvider);

            return GestureDetector(
              onTapUp: (details) => _handleTapUp(details, size),
              onDoubleTapDown: (details) => _handleDoubleTap(details, size),
              child: InteractiveViewer(
                transformationController: _transformationController,
                onInteractionUpdate: _onInteractionUpdate,
                minScale: 0.5,
                maxScale: 5.0,
                boundaryMargin: const EdgeInsets.all(100),
                child: Stack(
                  children: [
                    // Background
                    Container(
                      width: size.width,
                      height: size.height,
                      color: AppColors.bg,
                    ),

                    // Axis labels
                    if (widget.showAxisLabels)
                      CustomPaint(
                        size: size,
                        painter: AxisPainter(
                          xLabel: galaxyProvider.dimension.xAxisLabel,
                          yLabel: galaxyProvider.dimension.yAxisLabel,
                          showGrid: _currentZoom > 1.5,
                        ),
                      ),

                    // Property points
                    CustomPaint(
                      size: size,
                      painter: PropertyPointPainter(
                        positions: displayPositions,
                        selectedIds: selectionProvider.selectedIds,
                        highlightedIds: selectionProvider.highlightedIds,
                        zoomLevel: _currentZoom,
                        clusterCounts: _clusterResult?.clusterCounts,
                      ),
                    ),

                    // Lasso selection layer
                    if (selectionProvider.isLassoMode &&
                        selectionProvider.currentLasso != null)
                      CustomPaint(
                        size: size,
                        painter: LassoPainter(
                          points: selectionProvider.currentLasso!.points,
                          isClosing: false,
                          isClockwise:
                              selectionProvider.currentLasso!.isClockwise,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.scatter_plot_outlined,
            size: 64,
            color: AppColors.fg2,
          ),
          const SizedBox(height: 16),
          Text(
            'No properties to display',
            style: TextStyle(
              color: AppColors.fg2,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              color: AppColors.fg3,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dimension indicator widget showing current dimension
class DimensionIndicator extends StatelessWidget {
  final GalaxyDimension dimension;
  final VoidCallback? onTap;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const DimensionIndicator({
    super.key,
    required this.dimension,
    this.onTap,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onPrevious != null)
            GestureDetector(
              onTap: onPrevious,
              child: const Icon(Icons.chevron_left, size: 20),
            ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(dimension.icon, size: 18, color: AppColors.brandBlue),
                const SizedBox(width: 6),
                Text(
                  dimension.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (onNext != null)
            GestureDetector(
              onTap: onNext,
              child: const Icon(Icons.chevron_right, size: 20),
            ),
        ],
      ),
    );
  }
}
