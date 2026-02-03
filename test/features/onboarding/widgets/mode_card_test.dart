import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxlien_swipe_app/core/models/swipe_mode.dart';
import 'package:taxlien_swipe_app/features/onboarding/widgets/mode_card.dart';

void main() {
  group('ModeCard', () {
    Widget buildTestWidget({
      SwipeMode mode = SwipeMode.beginner,
      String title = 'Test Title',
      String description = 'Test Description',
      IconData icon = Icons.swipe,
      bool isSelected = false,
      VoidCallback? onTap,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ModeCard(
            mode: mode,
            title: title,
            description: description,
            icon: icon,
            isSelected: isSelected,
            onTap: onTap ?? () {},
          ),
        ),
      );
    }

    testWidgets('renders title and description', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          title: 'Beginner Mode',
          description: 'Simple swiping',
        ),
      );

      expect(find.text('Beginner Mode'), findsOneWidget);
      expect(find.text('Simple swiping'), findsOneWidget);
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(icon: Icons.swipe_right),
      );

      expect(find.byIcon(Icons.swipe_right), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(onTap: () => tapped = true),
      );

      await tester.tap(find.byType(ModeCard));
      expect(tapped, isTrue);
    });

    testWidgets('shows selected state with border', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(isSelected: true),
      );

      final card = tester.widget<Card>(find.byType(Card));
      final shape = card.shape as RoundedRectangleBorder;
      expect(shape.side, isNot(BorderSide.none));
    });

    testWidgets('unselected state has no border', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(isSelected: false),
      );

      final card = tester.widget<Card>(find.byType(Card));
      final shape = card.shape as RoundedRectangleBorder;
      expect(shape.side, BorderSide.none);
    });

    testWidgets('has higher elevation when selected', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(isSelected: true),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 4);
    });

    testWidgets('has lower elevation when not selected', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(isSelected: false),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 1);
    });

    testWidgets('starts animation on init', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(mode: SwipeMode.beginner),
      );

      // Pump a few frames to verify animation runs
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Animation should still be running (no errors)
      expect(find.byType(ModeCard), findsOneWidget);
    });
  });
}
