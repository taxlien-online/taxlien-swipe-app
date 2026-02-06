import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../services/analytics_service.dart';

/// Firebase implementation of [AnalyticsService].
/// Use when Firebase is configured (google-services.json / GoogleService-Info.plist).
class FirebaseAnalyticsServiceImpl implements AnalyticsService {
  FirebaseAnalyticsServiceImpl({
    FirebaseAnalytics? analytics,
  }) : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  static const int _maxEventNameLength = 40;
  static const int _maxParamKeyLength = 40;
  static const int _maxParamValueLength = 100;

  @override
  void logScreenView(String screenName, {Map<String, Object?>? parameters}) {
    final name = _sanitizeName(screenName, _maxEventNameLength);
    _analytics.logScreenView(
      screenName: name,
      screenClass: name,
      parameters: _toFirebaseParams(parameters),
    );
  }

  @override
  void logEvent(String name, {Map<String, Object?>? parameters}) {
    final eventName = _sanitizeName(name, _maxEventNameLength);
    _analytics.logEvent(
      name: eventName,
      parameters: _toFirebaseParams(parameters),
    );
  }

  @override
  void setUserProperty(String name, String? value) {
    final key = _sanitizeName(name, _maxParamKeyLength);
    _analytics.setUserProperty(name: key, value: value);
  }

  /// Sets a custom key for Crashlytics (included in crash reports).
  void setCrashlyticsKey(String key, String value) {
    FirebaseCrashlytics.instance.setCustomKey(key, value);
  }

  Map<String, Object>? _toFirebaseParams(Map<String, Object?>? params) {
    if (params == null || params.isEmpty) return null;
    final out = <String, Object>{};
    for (final e in params.entries) {
      final k = _sanitizeName(e.key, _maxParamKeyLength);
      final v = e.value;
      if (v == null) continue;
      if (v is String && v.length <= _maxParamValueLength) {
        out[k] = v;
      } else if (v is num) {
        out[k] = v;
      } else {
        out[k] = v.toString().length > _maxParamValueLength
            ? v.toString().substring(0, _maxParamValueLength)
            : v.toString();
      }
    }
    return out.isEmpty ? null : out;
  }

  String _sanitizeName(String s, int maxLen) {
    final trimmed = s.replaceAll(RegExp(r'[^\w_]'), '_').trim();
    if (trimmed.length <= maxLen) return trimmed;
    return trimmed.substring(0, maxLen);
  }
}
