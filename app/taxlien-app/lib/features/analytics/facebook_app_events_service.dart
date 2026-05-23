/// Marketing analytics service for Facebook App Events.
/// Separate from product analytics (Firebase). Implements standard and custom
/// events for attribution and audience building.
abstract class FacebookAppEventsService {
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters});

  Future<void> setUserProperty(String name, dynamic value);

  // Standard events for marketing attribution
  Future<void> logCompleteRegistration();
  Future<void> logSearch(String searchString);
  Future<void> logViewContent(String propertyId, {double? price});
  Future<void> logAddToWishlist(String propertyId, {double? price});
  Future<void> logInitiateCheckout(String propertyId, double amount);
  Future<void> logPurchase(String propertyId, double amount);

  // Custom Deal Detective events
  Future<void> logSwipeLeft(String propertyId, {double? foreclosureProb});
  Future<void> logSwipeRight(String propertyId,
      {double? foreclosureProb, double? fvi});
  Future<void> logAnnotationAdded(String propertyId, String expertRole);
  Future<void> logForeclosureFilterToggled(bool enabled);
  Future<void> logModeSwitch(String newMode);
}
