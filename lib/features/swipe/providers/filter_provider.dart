import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/filter_options.dart';
import '../../../services/analytics_service.dart';
import '../../analytics/facebook_app_events_service.dart';

const String _kFilterPreferencesKey = 'filter_options';

class FilterProvider extends ChangeNotifier {
  FilterProvider({
    AnalyticsService? analytics,
    FacebookAppEventsService? fbEvents,
  })  : _analytics = analytics,
        _fbEvents = fbEvents;

  final AnalyticsService? _analytics;
  final FacebookAppEventsService? _fbEvents;
  FilterOptions _filter = const FilterOptions();
  bool _isLoading = false;

  FilterOptions get filter => _filter;
  bool get isLoading => _isLoading;

  set filter(FilterOptions value) {
    _filter = value;
    notifyListeners();
  }

  Future<void> loadFromPreferences() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_kFilterPreferencesKey);
      if (jsonStr != null) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>?;
        if (map != null) _filter = FilterOptions.fromJson(map);
      }
    } catch (e) {
      debugPrint('FilterProvider: failed to load filter: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kFilterPreferencesKey, jsonEncode(_filter.toJson()));
    } catch (e) {
      debugPrint('FilterProvider: failed to save filter: $e');
    }
  }

  void setFilter(FilterOptions options) {
    final oldForeclosureOn = _filter.minForeclosureScore > 0;
    final newForeclosureOn = options.minForeclosureScore > 0;
    final newValue = options.toJson().toString();
    final searchString = newValue.length > 200 ? '${newValue.substring(0, 200)}...' : newValue;
    _filter = options;
    _analytics?.logEvent('filter_changed', parameters: {
      'filter_snapshot': searchString,
    });
    _fbEvents?.logSearch(searchString);
    if (oldForeclosureOn != newForeclosureOn) {
      _fbEvents?.logForeclosureFilterToggled(newForeclosureOn);
    }
    notifyListeners();
  }

  /// Call when user toggles foreclosure filter (e.g. Miw).
  void logForeclosureFilterToggled(bool enabled) {
    _analytics?.logEvent('foreclosure_filter_toggled', parameters: {'enabled': enabled});
    _fbEvents?.logForeclosureFilterToggled(enabled);
  }
}
