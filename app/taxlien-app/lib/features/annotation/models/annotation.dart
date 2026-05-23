import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'annotation.g.dart';

enum AnnotationType { point, line, area, text }

@JsonSerializable()
class Annotation {
  final String id;
  final String propertyId;
  final String expertId;
  final AnnotationType type;
  
  @JsonKey(fromJson: _pointsFromJson, toJson: _pointsToJson)
  final List<Offset> points; // Normalized 0.0 to 1.0
  
  final String? comment;
  final String? voiceUrl;
  final List<String> tags;
  final DateTime createdAt;

  Annotation({
    required this.id,
    required this.propertyId,
    required this.expertId,
    required this.type,
    required this.points,
    this.comment,
    this.voiceUrl,
    this.tags = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Annotation.fromJson(Map<String, dynamic> json) => _$AnnotationFromJson(json);
  Map<String, dynamic> toJson() => _$AnnotationToJson(this);

  static List<Offset> _pointsFromJson(List<dynamic> json) {
    return json.map((p) => Offset(p['x'] as double, p['y'] as double)).toList();
  }

  static List<dynamic> _pointsToJson(List<Offset> points) {
    return points.map((p) => {'x': p.dx, 'y': p.dy}).toList();
  }
}