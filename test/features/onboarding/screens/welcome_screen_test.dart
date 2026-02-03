import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:taxlien_swipe_app/features/onboarding/screens/welcome_screen.dart';
import 'package:taxlien_swipe_app/features/onboarding/widgets/skip_button.dart';

void main() {
  group('WelcomeScreen', () {
    late GoRouter router;
    String? lastRoute;

    setUp(() {
      lastRoute = null;
      router = GoRouter(
        initialLocation: '/onboarding/welcome',
        routes: [
          GoRoute(
            path: '/onboarding/welcome',
            builder: (context, state) => const WelcomeScreen(),
          ),
          GoRoute(
            path: '/onboarding/mode',
            builder: (context, state) {
              lastRoute = '/onboarding/mode';
              return const Scaffold(body: Text('Mode Screen'));
            },
          ),
          GoRoute(
            path: '/',
            builder: (context, state) {
              lastRoute = '/';
              return const Scaffold(body: Text('Home'));
            },
          ),
        ],
      );
    });

    Widget buildTestWidget() {
      return MaterialApp.router(
        routerConfig: router,
      );
    }

    testWidgets('renders title "DEAL DETECTIVE"', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('DEAL DETECTIVE'), findsOneWidget);
    });

    testWidgets('renders subtitle', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(
        find.text('Найдите foreclosure properties\nпо лучшей цене'),
        findsOneWidget,
      );
    });

    testWidgets('renders skip button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(SkipButton), findsOneWidget);
    });

    testWidgets('renders "Начать настройку" button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Начать настройку'), findsOneWidget);
    });

    testWidgets('renders "Я уже знаю как свайпать" link', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Я уже знаю как свайпать'), findsOneWidget);
    });

    testWidgets('navigates to mode screen when "Начать настройку" tapped',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Начать настройку'));
      await tester.pumpAndSettle();

      expect(lastRoute, '/onboarding/mode');
    });

    testWidgets('navigates to home when skip button tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.byType(SkipButton));
      await tester.pumpAndSettle();

      expect(lastRoute, '/');
    });

    testWidgets('navigates to home when "Я уже знаю" tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Я уже знаю как свайпать'));
      await tester.pumpAndSettle();

      expect(lastRoute, '/');
    });

    testWidgets('renders logo icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.home_work_outlined), findsOneWidget);
    });

    testWidgets('renders "или" divider', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('или'), findsOneWidget);
    });
  });
}
