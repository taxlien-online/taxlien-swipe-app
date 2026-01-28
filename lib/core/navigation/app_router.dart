import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/swipe/screens/home_screen.dart';
import '../../features/details/screens/details_screen.dart';
import '../../features/annotation/screens/annotation_screen.dart';
import '../../features/family/screens/family_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
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
}