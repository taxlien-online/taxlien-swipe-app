import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

import '../../../core/config/env_config.dart';
import 'facebook_app_events_service.dart';

/// Implementation of FacebookAppEventsService using facebook_app_events plugin.
class FacebookAppEventsServiceImpl implements FacebookAppEventsService {
  final FacebookAppEvents _plugin;
  final bool _enabled;

  FacebookAppEventsServiceImpl({
    FacebookAppEvents? plugin,
    bool? enabled,
  })  : _plugin = plugin ?? FacebookAppEvents(),
        _enabled = enabled ?? EnvConfig.isFacebookEnabled;

  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    if (!_enabled) return;
    try {
      await _plugin.logEvent(name: name, parameters: parameters);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('FacebookAppEvents.logEvent error: $e\n$st');
      }
    }
  }

  @override
  Future<void> setUserProperty(String name, dynamic value) async {
    if (!_enabled) return;
    try {
      await _plugin.setUserData(
        email: name == 'email' ? value?.toString() : null,
        firstName: name == 'firstName' ? value?.toString() : null,
        lastName: name == 'lastName' ? value?.toString() : null,
        city: name == 'city' ? value?.toString() : null,
        state: name == 'state' ? value?.toString() : null,
        zip: name == 'zip' ? value?.toString() : null,
        country: name == 'country' ? value?.toString() : null,
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('FacebookAppEvents.setUserData error: $e\n$st');
      }
    }
  }

  @override
  Future<void> logCompleteRegistration() async {
    if (!_enabled) return;
    try {
      await _plugin.logCompletedRegistration();
    } catch (e, st) {
      if (kDebugMode) debugPrint('Facebook logCompleteRegistration: $e\n$st');
    }
  }

  @override
  Future<void> logSearch(String searchString) async {
    if (!_enabled) return;
    try {
      await _plugin.logEvent(
        name: 'Search',
        parameters: {'search_string': searchString},
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('Facebook logSearch: $e\n$st');
    }
  }

  @override
  Future<void> logViewContent(String propertyId, {double? price}) async {
    if (!_enabled) return;
    try {
      await _plugin.logViewContent(
        id: propertyId,
        type: 'property',
        currency: 'USD',
        price: price,
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('Facebook logViewContent: $e\n$st');
    }
  }

  @override
  Future<void> logAddToWishlist(String propertyId, {double? price}) async {
    if (!_enabled) return;
    try {
      await _plugin.logAddToWishlist(
        id: propertyId,
        type: 'property',
        currency: 'USD',
        price: price ?? 0,
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('Facebook logAddToWishlist: $e\n$st');
    }
  }

  @override
  Future<void> logInitiateCheckout(String propertyId, double amount) async {
    if (!_enabled) return;
    try {
      await _plugin.logInitiatedCheckout(
        totalPrice: amount,
        currency: 'USD',
        contentType: 'property',
        contentId: propertyId,
        numItems: 1,
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('Facebook logInitiateCheckout: $e\n$st');
    }
  }

  @override
  Future<void> logPurchase(String propertyId, double amount) async {
    if (!_enabled) return;
    try {
      await _plugin.logPurchase(
        amount: amount,
        currency: 'USD',
        parameters: {'content_id': propertyId},
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('Facebook logPurchase: $e\n$st');
    }
  }

  @override
  Future<void> logSwipeLeft(String propertyId, {double? foreclosureProb}) async {
    if (!_enabled) return;
    try {
      final params = <String, dynamic>{'property_id': propertyId};
      if (foreclosureProb != null) params['foreclosure_prob'] = foreclosureProb;
      await _plugin.logEvent(name: 'dd_swipe_left', parameters: params);
    } catch (e, st) {
      if (kDebugMode) debugPrint('Facebook logSwipeLeft: $e\n$st');
    }
  }

  @override
  Future<void> logSwipeRight(String propertyId,
      {double? foreclosureProb, double? fvi}) async {
    if (!_enabled) return;
    try {
      final params = <String, dynamic>{'property_id': propertyId};
      if (foreclosureProb != null) params['foreclosure_prob'] = foreclosureProb;
      if (fvi != null) params['fvi'] = fvi;
      await _plugin.logEvent(name: 'dd_swipe_right', parameters: params);
    } catch (e, st) {
      if (kDebugMode) debugPrint('Facebook logSwipeRight: $e\n$st');
    }
  }

  @override
  Future<void> logAnnotationAdded(String propertyId, String expertRole) async {
    if (!_enabled) return;
    try {
      await _plugin.logEvent(
        name: 'dd_annotation_added',
        parameters: {'property_id': propertyId, 'expert_role': expertRole},
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('Facebook logAnnotationAdded: $e\n$st');
    }
  }

  @override
  Future<void> logForeclosureFilterToggled(bool enabled) async {
    if (!_enabled) return;
    try {
      await _plugin.logEvent(
        name: 'dd_foreclosure_filter_on',
        parameters: {'enabled': enabled},
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('Facebook logForeclosureFilterToggled: $e\n$st');
    }
  }

  @override
  Future<void> logModeSwitch(String newMode) async {
    if (!_enabled) return;
    try {
      await _plugin.logEvent(
        name: 'dd_mode_switch',
        parameters: {'new_mode': newMode},
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('Facebook logModeSwitch: $e\n$st');
    }
  }
}
