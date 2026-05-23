import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:taxlien_swipe_app/core/models/marker.dart';

void main() {
  group('AnnotationMarker', () {
    group('factory constructors', () {
      test('point() creates point marker', () {
        final marker = AnnotationMarker.point(
          id: 'point-1',
          position: const Offset(100, 200),
          authorId: 'anton',
          comment: 'Interesting feature',
        );

        expect(marker.type, MarkerType.point);
        expect(marker.position, const Offset(100, 200));
        expect(marker.authorId, 'anton');
        expect(marker.comment, 'Interesting feature');
        expect(marker.endPosition, isNull);
        expect(marker.rect, isNull);
      });

      test('line() creates line marker', () {
        final marker = AnnotationMarker.line(
          id: 'line-1',
          start: const Offset(10, 20),
          end: const Offset(100, 200),
          authorId: 'khun_pho',
          comment: 'Roof crack',
        );

        expect(marker.type, MarkerType.line);
        expect(marker.position, const Offset(10, 20));
        expect(marker.endPosition, const Offset(100, 200));
        expect(marker.authorId, 'khun_pho');
        expect(marker.comment, 'Roof crack');
        expect(marker.rect, isNull);
      });

      test('box() creates box marker', () {
        final rect = const Rect.fromLTWH(50, 50, 200, 150);
        final marker = AnnotationMarker.box(
          id: 'box-1',
          rect: rect,
          authorId: 'denis',
          comment: 'Antique cabinet',
        );

        expect(marker.type, MarkerType.box);
        expect(marker.rect, rect);
        expect(marker.position, rect.topLeft);
        expect(marker.authorId, 'denis');
        expect(marker.comment, 'Antique cabinet');
      });
    });

    group('renderColor', () {
      test('returns red for anton', () {
        final marker = AnnotationMarker.point(
          id: 'test-1',
          position: const Offset(0, 0),
          authorId: 'anton',
        );

        expect(marker.renderColor, const Color(0xFFE53935));
      });

      test('returns blue for khun_pho', () {
        final marker = AnnotationMarker.point(
          id: 'test-2',
          position: const Offset(0, 0),
          authorId: 'khun_pho',
        );

        expect(marker.renderColor, const Color(0xFF1E88E5));
      });

      test('returns green for denis', () {
        final marker = AnnotationMarker.point(
          id: 'test-3',
          position: const Offset(0, 0),
          authorId: 'denis',
        );

        expect(marker.renderColor, const Color(0xFF43A047));
      });

      test('returns amber for miw', () {
        final marker = AnnotationMarker.point(
          id: 'test-4',
          position: const Offset(0, 0),
          authorId: 'miw',
        );

        expect(marker.renderColor, const Color(0xFFFFB300));
      });

      test('returns purple for unknown author', () {
        final marker = AnnotationMarker.point(
          id: 'test-5',
          position: const Offset(0, 0),
          authorId: 'guest',
        );

        expect(marker.renderColor, const Color(0xFF7E57C2));
      });

      test('uses custom color if provided', () {
        final marker = AnnotationMarker.point(
          id: 'test-6',
          position: const Offset(0, 0),
          authorId: 'anton',
          color: const Color(0xFF000000),
        );

        expect(marker.renderColor, const Color(0xFF000000));
      });
    });

    group('JSON serialization', () {
      test('toJson serializes point marker correctly', () {
        final marker = AnnotationMarker.point(
          id: 'json-point-1',
          position: const Offset(100, 200),
          authorId: 'anton',
          comment: 'Test comment',
          category: 'tech',
        );

        final json = marker.toJson();

        expect(json['id'], 'json-point-1');
        expect(json['type'], 'point');
        expect(json['positionX'], 100.0);
        expect(json['positionY'], 200.0);
        expect(json['authorId'], 'anton');
        expect(json['comment'], 'Test comment');
        expect(json['category'], 'tech');
      });

      test('toJson serializes line marker correctly', () {
        final marker = AnnotationMarker.line(
          id: 'json-line-1',
          start: const Offset(10, 20),
          end: const Offset(100, 200),
          authorId: 'khun_pho',
        );

        final json = marker.toJson();

        expect(json['type'], 'line');
        expect(json['positionX'], 10.0);
        expect(json['positionY'], 20.0);
        expect(json['endPositionX'], 100.0);
        expect(json['endPositionY'], 200.0);
      });

      test('toJson serializes box marker correctly', () {
        final marker = AnnotationMarker.box(
          id: 'json-box-1',
          rect: const Rect.fromLTWH(50, 60, 100, 80),
          authorId: 'denis',
        );

        final json = marker.toJson();

        expect(json['type'], 'box');
        expect(json['rectLeft'], 50.0);
        expect(json['rectTop'], 60.0);
        expect(json['rectWidth'], 100.0);
        expect(json['rectHeight'], 80.0);
      });

      test('fromJson deserializes point marker correctly', () {
        final json = {
          'id': 'test-id',
          'type': 'point',
          'positionX': 100.0,
          'positionY': 200.0,
          'authorId': 'anton',
          'comment': 'Test',
          'category': 'tech',
          'createdAt': DateTime.now().toIso8601String(),
        };

        final marker = AnnotationMarker.fromJson(json);

        expect(marker.id, 'test-id');
        expect(marker.type, MarkerType.point);
        expect(marker.position, const Offset(100.0, 200.0));
        expect(marker.authorId, 'anton');
        expect(marker.comment, 'Test');
        expect(marker.category, 'tech');
      });

      test('fromJson deserializes line marker correctly', () {
        final json = {
          'id': 'line-id',
          'type': 'line',
          'positionX': 10.0,
          'positionY': 20.0,
          'endPositionX': 100.0,
          'endPositionY': 200.0,
          'authorId': 'khun_pho',
          'createdAt': DateTime.now().toIso8601String(),
        };

        final marker = AnnotationMarker.fromJson(json);

        expect(marker.type, MarkerType.line);
        expect(marker.position, const Offset(10.0, 20.0));
        expect(marker.endPosition, const Offset(100.0, 200.0));
      });

      test('fromJson deserializes box marker correctly', () {
        final json = {
          'id': 'box-id',
          'type': 'box',
          'positionX': 50.0,
          'positionY': 60.0,
          'rectLeft': 50.0,
          'rectTop': 60.0,
          'rectWidth': 100.0,
          'rectHeight': 80.0,
          'authorId': 'denis',
          'createdAt': DateTime.now().toIso8601String(),
        };

        final marker = AnnotationMarker.fromJson(json);

        expect(marker.type, MarkerType.box);
        expect(marker.rect, const Rect.fromLTWH(50, 60, 100, 80));
      });
    });
  });
}
