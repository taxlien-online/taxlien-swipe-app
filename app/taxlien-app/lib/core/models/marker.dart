import 'dart:ui';

enum MarkerType { point, box, line }

/// Expert annotation marker for Deal Detective
///
/// Experts can annotate photos with:
/// - Points: Single tap to mark a specific detail
/// - Lines: Draw a line between two points (e.g., to show cracks, measurements)
/// - Boxes: Draw a rectangle around an area of interest (e.g., furniture, car)
class AnnotationMarker {
  final String id;

  /// Start position (for all types) or single position (for point)
  final Offset position;

  /// End position for lines, null for points
  final Offset? endPosition;

  /// Rectangle bounds for box type, null for point/line
  final Rect? rect;

  /// Author ID (e.g., 'anton', 'khun_pho', 'denis')
  final String authorId;

  /// Category of annotation (e.g., 'vintage_car', 'roof_damage', 'antique_furniture')
  final String? category;

  /// Free-form comment
  final String? comment;

  /// Type of marker
  final MarkerType type;

  /// When the marker was created
  final DateTime createdAt;

  /// Color for rendering (optional, can be determined by author/category)
  final Color? color;

  const AnnotationMarker({
    required this.id,
    required this.position,
    this.endPosition,
    this.rect,
    required this.authorId,
    this.category,
    this.comment,
    required this.type,
    required this.createdAt,
    this.color,
  });

  /// Create a point marker
  factory AnnotationMarker.point({
    required String id,
    required Offset position,
    required String authorId,
    String? category,
    String? comment,
    Color? color,
  }) {
    return AnnotationMarker(
      id: id,
      position: position,
      authorId: authorId,
      category: category,
      comment: comment,
      type: MarkerType.point,
      createdAt: DateTime.now(),
      color: color,
    );
  }

  /// Create a line marker
  factory AnnotationMarker.line({
    required String id,
    required Offset start,
    required Offset end,
    required String authorId,
    String? category,
    String? comment,
    Color? color,
  }) {
    return AnnotationMarker(
      id: id,
      position: start,
      endPosition: end,
      authorId: authorId,
      category: category,
      comment: comment,
      type: MarkerType.line,
      createdAt: DateTime.now(),
      color: color,
    );
  }

  /// Create a box marker
  factory AnnotationMarker.box({
    required String id,
    required Rect rect,
    required String authorId,
    String? category,
    String? comment,
    Color? color,
  }) {
    return AnnotationMarker(
      id: id,
      position: rect.topLeft,
      rect: rect,
      authorId: authorId,
      category: category,
      comment: comment,
      type: MarkerType.box,
      createdAt: DateTime.now(),
      color: color,
    );
  }

  AnnotationMarker copyWith({
    String? id,
    Offset? position,
    Offset? endPosition,
    Rect? rect,
    String? authorId,
    String? category,
    String? comment,
    MarkerType? type,
    DateTime? createdAt,
    Color? color,
  }) {
    return AnnotationMarker(
      id: id ?? this.id,
      position: position ?? this.position,
      endPosition: endPosition ?? this.endPosition,
      rect: rect ?? this.rect,
      authorId: authorId ?? this.authorId,
      category: category ?? this.category,
      comment: comment ?? this.comment,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
    );
  }

  /// Get the color to use for rendering this marker
  Color get renderColor {
    if (color != null) return color!;

    // Default colors by author
    switch (authorId.toLowerCase()) {
      case 'anton':
        return const Color(0xFFE53935); // Red - inventor/tech
      case 'khun_pho':
        return const Color(0xFF1E88E5); // Blue - construction
      case 'denis':
        return const Color(0xFF43A047); // Green - furniture
      case 'miw':
        return const Color(0xFFFFB300); // Amber - aesthetic
      case 'vasilisa':
        return const Color(0xFFAB47BC); // Purple - toys
      default:
        return const Color(0xFF757575); // Grey
    }
  }

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': {'dx': position.dx, 'dy': position.dy},
      if (endPosition != null) 'endPosition': {'dx': endPosition!.dx, 'dy': endPosition!.dy},
      if (rect != null) 'rect': {
        'left': rect!.left,
        'top': rect!.top,
        'right': rect!.right,
        'bottom': rect!.bottom,
      },
      'authorId': authorId,
      if (category != null) 'category': category,
      if (comment != null) 'comment': comment,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      if (color != null) 'color': color!.toARGB32(),
    };
  }

  /// Create from JSON
  factory AnnotationMarker.fromJson(Map<String, dynamic> json) {
    final posJson = json['position'] as Map<String, dynamic>;
    final endPosJson = json['endPosition'] as Map<String, dynamic>?;
    final rectJson = json['rect'] as Map<String, dynamic>?;

    return AnnotationMarker(
      id: json['id'] as String,
      position: Offset(posJson['dx'] as double, posJson['dy'] as double),
      endPosition: endPosJson != null
          ? Offset(endPosJson['dx'] as double, endPosJson['dy'] as double)
          : null,
      rect: rectJson != null
          ? Rect.fromLTRB(
              rectJson['left'] as double,
              rectJson['top'] as double,
              rectJson['right'] as double,
              rectJson['bottom'] as double,
            )
          : null,
      authorId: json['authorId'] as String,
      category: json['category'] as String?,
      comment: json['comment'] as String?,
      type: MarkerType.values.byName(json['type'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      color: json['color'] != null ? Color(json['color'] as int) : null,
    );
  }
}
