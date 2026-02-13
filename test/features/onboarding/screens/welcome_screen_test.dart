import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxlien_swipe_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:taxlien_swipe_app/features/onboarding/screens/welcome_screen.dart';
import 'package:taxlien_swipe_app/features/onboarding/widgets/skip_button.dart';
import 'package:taxlien_swipe_app/l10n/app_localizations.dart';
import 'package:taxlien_swipe_app/services/analytics_service.dart';
import '../../../helpers/app_localization.dart';

void main() {
  group('WelcomeScreen', () {
    late GoRouter router;
    String? lastRoute;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
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
      return MultiProvider(
        providers: [
          Provider<AnalyticsService>(create: (_) => NoOpAnalyticsService()),
          ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ],
        child: MaterialApp.router(
          locale: kTestLocaleEn,
          localizationsDelegates: kTestLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      );
    }

    testWidgets('renders title "DEAL DETECTIVE"', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('DEAL DETECTIVE'), findsOneWidget);
    });

    testWidgets('renders subtitle', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(
        find.text('Find foreclosure properties\nat the best price'),
        findsOneWidget,
      );
    });

    testWidgets('renders skip button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(SkipButton), findsOneWidget);
    });

    testWidgets('renders "Start setup" button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Start setup'), findsOneWidget);
    });

    testWidgets('renders "I already know how to swipe" link', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('I already know how to swipe'), findsOneWidget);
    });

    testWidgets('navigates to mode screen when "Start setup" tapped', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Start setup'));
      await tester.pumpAndSettle();

      expect(lastRoute, '/onboarding/mode');
    });

    testWidgets('navigates to home when skip button tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(); // allow initState postFrameCallback

      await tester.tap(find.byType(SkipButton));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(lastRoute, '/');
    });

    testWidgets('navigates to home when "I already know how to swipe" tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(); // allow initState postFrameCallback

      await tester.tap(find.text('I already know how to swipe'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(lastRoute, '/');
    });

    testWidgets('renders logo icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.home_work_outlined), findsOneWidget);
    });

    testWidgets('renders "or" divider', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('or'), findsOneWidget);
    });
  });
}
