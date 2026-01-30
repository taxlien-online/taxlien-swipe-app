import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../../core/models/expert_role.dart';
import '../../../core/models/tax_lien_models.dart'; // Use TaxLien instead of PropertyCardData
import '../../../core/models/swipe_mode.dart';
import '../../../core/repositories/data_repository.dart'; // New Import
import '../../../services/sync_manager.dart'; // New Import

class SwipeProvider extends ChangeNotifier {
  final IDataRepository _dataRepository;
  final SyncManager _syncManager;
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
  }) : _dataRepository = dataRepository, _syncManager = syncManager {
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
    await _dataRepository.queueAction('LIKE', {'propertyId': propertyId});
    await _dataRepository.updatePropertyLikedStatus(propertyId, true); // Mark as liked in DB
    nextProperty();
  }

  Future<void> handlePass(String propertyId) async {
    debugPrint('Passed property: $propertyId');
    await _dataRepository.queueAction('PASS', {'propertyId': propertyId});
    nextProperty();
  }

  @override
  void dispose() {
    _propertiesSubscription?.cancel();
    super.dispose();
  }
}
