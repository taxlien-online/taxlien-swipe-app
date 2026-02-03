import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxlien_swipe_app/features/onboarding/widgets/skip_button.dart';

void main() {
  group('SkipButton', () {
    testWidgets('renders "Пропустить" text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkipButton(onSkip: () {}),
          ),
        ),
      );

      expect(find.text('Пропустить'), findsOneWidget);
    });

    testWidgets('calls onSkip when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkipButton(onSkip: () => tapped = true),
          ),
        ),
      );

      await tester.tap(find.byType(SkipButton));
      expect(tapped, isTrue);
    });

    testWidgets('is a TextButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkipButton(onSkip: () {}),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
    });
  });
}
