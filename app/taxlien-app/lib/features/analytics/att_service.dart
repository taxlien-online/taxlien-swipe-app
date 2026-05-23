import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

import '../../../core/config/env_config.dart';

/// App Tracking Transparency (ATT) service for iOS 14.5+.
/// Requests tracking permission before Facebook events can use IDFA.
class AttService {
  static final AttService _instance = AttService._();
  static AttService get instance => _instance;

  AttService._();

  final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();

  /// Request tracking authorization on iOS. No-op on other platforms.
  /// Call before any Facebook tracking. Configures Facebook SDK based on result.
  Future<void> requestTrackingPermission() async {
    if (!Platform.isIOS) return;
    if (!EnvConfig.isFacebookEnabled) return;

    try {
      final status = await AppTrackingTransparency.requestTrackingAuthorization();

      if (kDebugMode) {
        debugPrint('ATT status: $status');
      }

      // Configure Facebook SDK based on ATT result
      final enabled = status == TrackingStatus.authorized ||
          status == TrackingStatus.notDetermined;
      await _facebookAppEvents.setAdvertiserTracking(enabled: enabled);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('ATT request error: $e\n$st');
      }
    }
  }

  /// Returns current tracking status (iOS only).
  Future<TrackingStatus> getTrackingStatus() async {
    if (!Platform.isIOS) return TrackingStatus.notSupported;
    return AppTrackingTransparency.trackingAuthorizationStatus;
  }
}
