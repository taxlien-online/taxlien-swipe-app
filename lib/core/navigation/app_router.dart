import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/swipe/screens/home_screen.dart';
import '../../features/details/screens/details_screen.dart';
import '../../features/annotation/screens/annotation_screen.dart';
import '../../features/family/screens/family_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/onboarding/screens/mode_selection_screen.dart';
import '../../features/onboarding/screens/role_selection_screen.dart';
import '../../features/onboarding/screens/geography_screen.dart';
import '../../features/onboarding/screens/county_selection_screen.dart';
import '../../features/onboarding/screens/tutorial_screen.dart';
import '../../features/onboarding/screens/ready_screen.dart';
import '../../features/onboarding/screens/oauth_screen.dart';
import '../../features/onboarding/services/onboarding_service.dart';

class AppRouter {
  static final _onboardingService = OnboardingService();
  static GoRouter? _router;

  static GoRouter get router => _router!;

  /// Creates the app router. Must be called once before using [router].
  static GoRouter createRouter({List<NavigatorObserver>? observers}) {
    _router = GoRouter(
      initialLocation: '/',
      observers: observers ?? [],
      redirect: (context, state) async {
        final loc = state.matchedLocation;
        if (loc == '/' || loc.isEmpty) {
          final show = await _onboardingService.shouldShowOnboarding();
          if (show) return '/onboarding/welcome';
        }
        return null;
      },
      routes: [
      // Onboarding routes
      GoRoute(
        path: '/onboarding/welcome',
        name: 'onboarding_welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding/mode',
        name: 'onboarding_mode',
        builder: (context, state) => const ModeSelectionScreen(),
      ),
      GoRoute(
        path: '/onboarding/role',
        name: 'onboarding_role',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/onboarding/geo',
        name: 'onboarding_geo',
        builder: (context, state) => const GeographyScreen(),
      ),
      GoRoute(
        path: '/onboarding/county',
        name: 'onboarding_county',
        builder: (context, state) {
          final stateCode = state.uri.queryParameters['state'] ?? 'AZ';
          return CountySelectionScreen(stateCode: stateCode);
        },
      ),
      GoRoute(
        path: '/onboarding/tutorial',
        name: 'onboarding_tutorial',
        builder: (context, state) => const TutorialScreen(),
      ),
      GoRoute(
        path: '/onboarding/oauth',
        name: 'onboarding_oauth',
        builder: (context, state) => const OAuthScreen(),
      ),
      GoRoute(
        path: '/onboarding/ready',
        name: 'onboarding_ready',
        builder: (context, state) => const ReadyScreen(),
      ),
      // Main app routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const SwipeHomeScreen(),
      ),
      GoRoute(
        path: '/property/:state/:county/:id',
        name: 'details',
        builder: (context, state) {
          final stateParam = state.pathParameters['state']!;
          final countyParam = state.pathParameters['county']!;
          final idParam = state.pathParameters['id']!;
          return PropertyDetailsScreen(
            propertyId: idParam,
            stateCode: stateParam,
            countyName: countyParam,
          );
        },
      ),
      GoRoute(
        path: '/annotate/:id',
        name: 'annotate',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AnnotationScreen(propertyId: id);
        },
      ),
      GoRoute(
        path: '/family',
        name: 'family',
        builder: (context, state) => const FamilyBoardScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    );
    return _router!;
  }
}