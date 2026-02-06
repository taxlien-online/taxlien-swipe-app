import 'package:flutter/material.dart';

import '../../../services/analytics_service.dart';
import 'firebase_analytics_service.dart';

/// Maps GoRouter route names to Firebase screen_view names (snake_case).
const Map<String, String> _routeToScreenName = {
  'home': 'home_screen',
  'details': 'property_details',
  'annotate': 'annotation_canvas',
  'family': 'family_board',
  'profile': 'profile',
  'onboarding_welcome': 'onboarding_welcome',
  'onboarding_mode': 'onboarding_mode',
  'onboarding_role': 'onboarding_role',
  'onboarding_geo': 'onboarding_geo',
  'onboarding_county': 'onboarding_county',
  'onboarding_tutorial': 'onboarding_tutorial',
  'onboarding_oauth': 'onboarding_oauth',
  'onboarding_ready': 'onboarding_ready',
};

/// NavigatorObserver that logs screen_view and updates Crashlytics last_screen.
class AnalyticsRouteObserver extends NavigatorObserver {
  AnalyticsRouteObserver(this._analytics);

  final AnalyticsService _analytics;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logRoute(route);
  }

  void _logRoute(Route<dynamic> route) {
    final name = route.settings.name;
    if (name == null || name.isEmpty) return;
    final screenName = _routeToScreenName[name] ?? name;
    _analytics.logScreenView(screenName);
    final analytics = _analytics;
    if (analytics is FirebaseAnalyticsServiceImpl) {
      analytics.setCrashlyticsKey('last_screen', screenName);
    }
  }
}
