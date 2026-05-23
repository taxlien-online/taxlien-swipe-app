import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxlien_swipe_app/widgets/app_badge.dart';
import 'package:taxlien_swipe_app/design/design.dart';

void main() {
  group('AppBadge', () {
    testWidgets('renders label in uppercase', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: AppBadge(label: 'pre-auction'),
          ),
        ),
      );

      expect(find.text('PRE-AUCTION'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: AppBadge(
              label: 'Alert',
              icon: Icons.warning,
              tone: BadgeTone.warn,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('hot tone uses danger color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: AppBadge(
              label: 'Hot',
              tone: BadgeTone.hot,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(AppColors.danger.withOpacity(0.12)));
    });

    testWidgets('good tone uses success color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: AppBadge(
              label: 'Good',
              tone: BadgeTone.good,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(AppColors.success.withOpacity(0.12)));
    });

    testWidgets('truncates long labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: AppBadge(
              label: 'This is a very long label that should be truncated',
            ),
          ),
        ),
      );

      // Should render without overflow
      expect(find.byType(AppBadge), findsOneWidget);
    });

    testWidgets('works in dark mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: const Scaffold(
            body: AppBadge(
              label: 'Test',
              tone: BadgeTone.info,
            ),
          ),
        ),
      );

      expect(find.text('TEST'), findsOneWidget);
    });
  });
}
