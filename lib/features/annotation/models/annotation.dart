import 'package:flutter/material.dart';

enum AnnotationType {
  point,
  line,
  area,
}

class PropertyAnnotation {
  final String id;
  final String expertId;
  final Offset position; // Нормализованные координаты (0.0 - 1.0)
  final AnnotationType type;
  final String? comment;
  final String? voiceUrl;
  final List<String> tags;
  final DateTime createdAt;

  const PropertyAnnotation({
    required this.id,
    required this.expertId,
    required this.position,
    required this.type,
    this.comment,
    this.voiceUrl,
    this.tags = const [],
    required this.createdAt,
  });
}
