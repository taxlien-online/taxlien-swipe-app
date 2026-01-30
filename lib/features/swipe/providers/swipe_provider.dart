import 'package:flutter/material.dart';
import '../../../core/models/expert_role.dart';
import '../../../core/models/property_card_data.dart';
import '../../../core/models/swipe_mode.dart';
import '../../../services/tax_lien_service.dart';

class SwipeProvider extends ChangeNotifier {
  final TaxLienService _service = TaxLienService();
  
  List<PropertyCardData> _properties = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  
  ExpertRole _currentRole = ExpertRole.guest;
  SwipeMode _swipeMode = SwipeMode.beginner;

  List<PropertyCardData> get properties => _properties;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  ExpertRole get currentRole => _currentRole;
  SwipeMode get swipeMode => _swipeMode;
  
  PropertyCardData? get currentProperty => 
      _properties.isNotEmpty && _currentIndex < _properties.length 
          ? _properties[_currentIndex] 
          : null;

  Future<void> loadProperties() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _properties = await _service.getPropertyCards();
      _currentIndex = 0;
    } catch (e) {
      debugPrint('Error loading properties: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextProperty() {
    if (_currentIndex < _properties.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousProperty() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void setRole(ExpertRole role) {
    _currentRole = role;
    notifyListeners();
  }

  void setSwipeMode(SwipeMode mode) {
    _swipeMode = mode;
    notifyListeners();
  }

  void handleLike(String propertyId) {
    debugPrint('Liked property: $propertyId');
    nextProperty();
  }

  void handlePass(String propertyId) {
    debugPrint('Passed property: $propertyId');
    nextProperty();
  }
}
