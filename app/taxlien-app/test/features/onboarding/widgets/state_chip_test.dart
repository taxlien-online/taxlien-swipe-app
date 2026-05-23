import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxlien_swipe_app/features/onboarding/models/state_info.dart';
import 'package:taxlien_swipe_app/features/onboarding/widgets/state_chip.dart';
import '../../../helpers/app_localization.dart';

void main() {
  group('StateChip', () {
    const testState = StateInfo(
      code: 'AZ',
      name: 'Arizona',
      type: 'Tax Lien',
      interestRate: 16,
      nextAuction: 'Feb 2026',
      totalLiens: 45000,
      foreclosureCandidates: 3200,
    );

    Widget buildTestWidget({
      StateInfo stateInfo = testState,
      bool isSelected = false,
      VoidCallback? onTap,
    }) {
      return wrapWithMaterialApp(
        child: Scaffold(
          body: StateChip(
            stateInfo: stateInfo,
            isSelected: isSelected,
            onTap: onTap ?? () {},
          ),
        ),
      );
    }

    testWidgets('renders state name', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Arizona'), findsOneWidget);
    });

    testWidgets('shows state code when not selected', (tester) async {
      await tester.pumpWidget(buildTestWidget(isSelected: false));

      expect(find.text('AZ'), findsOneWidget);
    });

    testWidgets('shows check icon when selected', (tester) async {
      await tester.pumpWidget(buildTestWidget(isSelected: true));

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(buildTestWidget(onTap: () => tapped = true));

      await tester.tap(find.byType(FilterChip));
      expect(tapped, isTrue);
    });

    testWidgets('is a FilterChip', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(FilterChip), findsOneWidget);
    });

    testWidgets('reflects selected state in FilterChip', (tester) async {
      await tester.pumpWidget(buildTestWidget(isSelected: true));

      final chip = tester.widget<FilterChip>(find.byType(FilterChip));
      expect(chip.selected, isTrue);
    });
  });
}
