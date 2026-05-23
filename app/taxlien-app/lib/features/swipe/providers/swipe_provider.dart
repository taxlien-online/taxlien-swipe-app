import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../core/models/expert_role.dart';
import '../../../core/models/tax_lien_models.dart';
import '../../../core/models/swipe_mode.dart';
import '../../../core/repositories/data_repository.dart';
import '../../../services/sync_manager.dart';
import '../../../services/analytics_service.dart';
import '../../../core/config/env_config.dart';
import '../../analytics/facebook_app_events_service.dart';
import '../../tutorial/services/tutorial_service.dart';
import '../../tutorial/services/achievement_service.dart';

class SwipeProvider extends ChangeNotifier {
  final IDataRepository _dataRepository;
  final SyncManager _syncManager;
  final AnalyticsService? _analytics;
  final FacebookAppEventsService? _fbEvents;
  final TutorialService? _tutorial;
  final AchievementService? _achievement;
  StreamSubscription? _propertiesSubscription;

  List<TaxLien> _properties = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  
  ExpertRole _currentRole = ExpertRole.guest;
  SwipeMode _swipeMode = SwipeMode.beginner;

  List<TaxLien> get properties => _properties;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  ExpertRole get currentRole => _currentRole;
  SwipeMode get swipeMode => _swipeMode;
  
  TaxLien? get currentProperty => 
      _properties.isNotEmpty && _currentIndex < _properties.length 
          ? _properties[_currentIndex] 
          : null;

  SwipeProvider({
    required IDataRepository dataRepository,
    required SyncManager syncManager,
    AnalyticsService? analytics,
    FacebookAppEventsService? fbEvents,
    TutorialService? tutorial,
    AchievementService? achievement,
  })  : _dataRepository = dataRepository,
        _syncManager = syncManager,
        _analytics = analytics,
        _fbEvents = fbEvents,
        _tutorial = tutorial,
        _achievement = achievement {
    _propertiesSubscription = _dataRepository.getPropertiesStream('default_filter_context').listen((newProperties) {
      _properties = newProperties;
      if (_properties.isEmpty && !_isLoading) {
        // Handle no more properties case
        debugPrint('SwipeProvider: No properties in cache. Attempting prefetch.');
        _syncManager.triggerPrefetchIfNeeded();
      }
      notifyListeners();
    });
  }

  Future<void> loadProperties() async {
    _isLoading = true;
    notifyListeners();
    // Data will be loaded via stream subscription
    // Ensure initial prefetch is triggered if needed
    await _syncManager.triggerPrefetchIfNeeded();
    _isLoading = false; // Set to false after initial check, stream will handle updates
    notifyListeners();
  }

  void nextProperty() {
    if (_currentIndex < _properties.length - 1) {
      _currentIndex++;
      // Proactively trigger prefetch when a certain threshold is reached
      if ((_properties.length - _currentIndex) < EnvConfig.offlineBatchSize / 2) {
        _syncManager.triggerPrefetchIfNeeded();
      }
      notifyListeners();
    } else if (_currentIndex == _properties.length - 1 && _properties.isNotEmpty) {
      // User swiped last available property, check for more
      _syncManager.triggerPrefetchIfNeeded();
      // If still no more, then show empty state (handled by UI observing _properties)
    }
  }

  void previousProperty() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void setCurrentIndex(int index) {
    if (index >= 0 && index < _properties.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void setRole(ExpertRole role) {
    _currentRole = role;
    // TODO: When filter context is properly implemented, this should trigger a new stream from DataRepository
    notifyListeners();
  }

  void setSwipeMode(SwipeMode mode) {
    _swipeMode = mode;
    notifyListeners();
  }

  Future<void> handleLike(String propertyId) async {
    debugPrint('Liked property: $propertyId');
    final property = currentProperty?.id == propertyId ? currentProperty : null;
    final fp = property?.foreclosureProbability;
    final fviVal = property?.fvi?.totalIndex;
    _analytics?.logEvent('swipe_action', parameters: {
      'direction': 'like',
      'property_id': propertyId,
      if (fp != null) 'foreclosure_prob': fp,
    });
    _analytics?.logEvent('property_liked', parameters: {
      'property_id': propertyId,
      if (fviVal != null) 'fvi_score': fviVal,
      if (property?.taxAmount != null) 'tax_amount': property!.taxAmount,
    });
    _fbEvents?.logAddToWishlist(propertyId, price: property?.taxAmount);
    _fbEvents?.logSwipeRight(propertyId, foreclosureProb: fp, fvi: fviVal);
    await _dataRepository.queueAction('LIKE', {'propertyId': propertyId});
    await _dataRepository.updatePropertyLikedStatus(propertyId, true);
    await _tutorial?.incrementSwipes();
    await _tutorial?.incrementLikes();
    final stats = await _tutorial?.getStats();
    if (stats != null) await _achievement?.checkAndUnlock(stats);
    nextProperty();
  }

  Future<void> handlePass(String propertyId) async {
    debugPrint('Passed property: $propertyId');
    final property = currentProperty?.id == propertyId ? currentProperty : null;
    final fp = property?.foreclosureProbability;
    _analytics?.logEvent('swipe_action', parameters: {
      'direction': 'pass',
      'property_id': propertyId,
      if (fp != null) 'foreclosure_prob': fp,
    });
    _analytics?.logEvent('property_passed', parameters: {'property_id': propertyId});
    _fbEvents?.logSwipeLeft(propertyId, foreclosureProb: fp);
    await _dataRepository.queueAction('PASS', {'propertyId': propertyId});
    await _tutorial?.incrementSwipes();
    final stats = await _tutorial?.getStats();
    if (stats != null) await _achievement?.checkAndUnlock(stats);
    nextProperty();
  }

  @override
  void dispose() {
    _propertiesSubscription?.cancel();
    super.dispose();
  }
}
