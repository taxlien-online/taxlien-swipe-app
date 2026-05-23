import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxlien_swipe_app/widgets/adaptive_scaffold.dart';
import 'package:taxlien_swipe_app/widgets/app_bottom_nav.dart';
import 'package:taxlien_swipe_app/design/design.dart';

void main() {
  final destinations = [
    const AdaptiveDestination(
      icon: Icons.blur_on_outlined,
      selectedIcon: Icons.blur_on,
      label: 'Galaxy',
    ),
    const AdaptiveDestination(
      icon: Icons.list_outlined,
      selectedIcon: Icons.list,
      label: 'List',
    ),
    const AdaptiveDestination(
      icon: Icons.bookmark_border,
      selectedIcon: Icons.bookmark,
      label: 'Saved',
    ),
    const AdaptiveDestination(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  group('AdaptiveScaffold', () {
    testWidgets('shows bottom nav on compact screens', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: AdaptiveScaffold(
            body: const Center(child: Text('Content')),
            destinations: destinations,
          ),
        ),
      );

      expect(find.byType(AppBottomNav), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('shows navigation rail on medium screens', (tester) async {
      tester.view.physicalSize = const Size(700, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: AdaptiveScaffold(
            body: const Center(child: Text('Content')),
            destinations: destinations,
          ),
        ),
      );

      // Should not show bottom nav
      expect(find.byType(AppBottomNav), findsNothing);
      expect(find.text('Content'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('shows sidebar on large screens', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: AdaptiveScaffold(
            body: const Center(child: Text('Content')),
            destinations: destinations,
          ),
        ),
      );

      // Should not show bottom nav
      expect(find.byType(AppBottomNav), findsNothing);
      expect(find.text('Content'), findsOneWidget);
      // Should show app name in sidebar
      expect(find.text('Deal Detective'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('calls onDestinationSelected when tab changes', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      int? selectedIndex;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: AdaptiveScaffold(
            body: const Center(child: Text('Content')),
            destinations: destinations,
            currentIndex: 0,
            onDestinationSelected: (index) => selectedIndex = index,
          ),
        ),
      );

      // Tap on List tab
      await tester.tap(find.text('List'));
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('works in dark mode', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: AdaptiveScaffold(
            body: const Center(child: Text('Content')),
            destinations: destinations,
          ),
        ),
      );

      expect(find.byType(AppBottomNav), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
