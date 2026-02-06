import 'package:flutter/foundation.dart';

/// Analytics abstraction for screen and event tracking.
/// Implement with Firebase (or no-op) per sdd-taxlien-swipe-app-firebaseanalytics.
abstract class AnalyticsService {
  void logScreenView(String screenName, {Map<String, Object?>? parameters});
  void logEvent(String name, {Map<String, Object?>? parameters});
  void setUserProperty(String name, String? value);
}

/// No-op implementation until Firebase is integrated.
class NoOpAnalyticsService implements AnalyticsService {
  @override
  void logScreenView(String screenName, {Map<String, Object?>? parameters}) {
    if (kDebugMode) {
      debugPrint('Analytics: screen_view $screenName $parameters');
    }
  }

  @override
  void logEvent(String name, {Map<String, Object?>? parameters}) {
    if (kDebugMode) {
      debugPrint('Analytics: event $name $parameters');
    }
  }

  @override
  void setUserProperty(String name, String? value) {
    if (kDebugMode) {
      debugPrint('Analytics: user_property $name=$value');
    }
  }
}
