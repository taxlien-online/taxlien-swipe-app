import 'package:flutter/foundation.dart';

enum MarkerType { point, box, line }

class AnnotationMarker {
  final String id;
  final Offset position;
  final String authorId;
  final String? category;
  final String? comment;
  final MarkerType type;
  final DateTime createdAt;

  AnnotationMarker({
    required this.id,
    required this.position,
    required this.authorId,
    this.category,
    this.comment,
    required this.type,
    required this.createdAt,
  });
}
