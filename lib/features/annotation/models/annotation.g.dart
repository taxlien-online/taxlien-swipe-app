// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Annotation _$AnnotationFromJson(Map<String, dynamic> json) => Annotation(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      expertId: json['expertId'] as String,
      type: $enumDecode(_$AnnotationTypeEnumMap, json['type']),
      points: Annotation._pointsFromJson(json['points'] as List),
      comment: json['comment'] as String?,
      voiceUrl: json['voiceUrl'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AnnotationToJson(Annotation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'propertyId': instance.propertyId,
      'expertId': instance.expertId,
      'type': _$AnnotationTypeEnumMap[instance.type]!,
      'points': Annotation._pointsToJson(instance.points),
      'comment': instance.comment,
      'voiceUrl': instance.voiceUrl,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$AnnotationTypeEnumMap = {
  AnnotationType.point: 'point',
  AnnotationType.line: 'line',
  AnnotationType.area: 'area',
  AnnotationType.text: 'text',
};
