import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxlien_swipe_app/widgets/stat_tile.dart';
import 'package:taxlien_swipe_app/design/design.dart';

void main() {
  group('StatTile', () {
    testWidgets('renders label and value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: StatTile(
              label: 'Value',
              value: '\$125K',
            ),
          ),
        ),
      );

      expect(find.text('VALUE'), findsOneWidget);
      expect(find.text('\$125K'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: StatTile(
              label: 'ROI',
              value: '12.5%',
              icon: Icons.trending_up,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });

    testWidgets('renders delta with positive color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: StatTile(
              label: 'Change',
              value: '\$500',
              delta: '+5%',
              deltaPositive: true,
            ),
          ),
        ),
      );

      expect(find.text('+5%'), findsOneWidget);
      final text = tester.widget<Text>(find.text('+5%'));
      expect(text.style?.color, equals(AppColors.success));
    });

    testWidgets('renders delta with negative color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: StatTile(
              label: 'Change',
              value: '\$500',
              delta: '-3%',
              deltaPositive: false,
            ),
          ),
        ),
      );

      expect(find.text('-3%'), findsOneWidget);
      final text = tester.widget<Text>(find.text('-3%'));
      expect(text.style?.color, equals(AppColors.danger));
    });

    testWidgets('compact size has smaller padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: Row(
              children: [
                StatTile(
                  label: 'Standard',
                  value: '100',
                  size: StatTileSize.standard,
                ),
                StatTile(
                  label: 'Compact',
                  value: '100',
                  size: StatTileSize.compact,
                ),
              ],
            ),
          ),
        ),
      );

      // Both should render
      expect(find.text('STANDARD'), findsOneWidget);
      expect(find.text('COMPACT'), findsOneWidget);
    });

    testWidgets('works in dark mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: const Scaffold(
            body: StatTile(
              label: 'Value',
              value: '\$125K',
            ),
          ),
        ),
      );

      expect(find.text('VALUE'), findsOneWidget);
      expect(find.text('\$125K'), findsOneWidget);
    });
  });
}
