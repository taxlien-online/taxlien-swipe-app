import 'package:flutter/foundation.dart';
import '../../../core/models/expert_role.dart';
import '../../../core/models/swipe_mode.dart';
import '../../../core/models/user_preferences.dart';
import '../models/onboarding_state.dart';
import '../models/state_info.dart';
import '../services/onboarding_service.dart';

/// Provider for onboarding flow state management
class OnboardingProvider extends ChangeNotifier {
  final OnboardingService _service;

  OnboardingState _state = OnboardingState.initial();
  List<StateInfo> _availableStates = [];
  List<CountyInfo> _availableCounties = [];
  GeoStats? _geoStats;

  OnboardingProvider({OnboardingService? service})
      : _service = service ?? OnboardingService();

  // Getters
  OnboardingState get state => _state;
  List<StateInfo> get availableStates => _availableStates;
  List<CountyInfo> get availableCounties => _availableCounties;
  GeoStats? get geoStats => _geoStats;

  /// Initialize and load states
  Future<void> initialize() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      _availableStates = await _service.getStates();
      _state = _state.copyWith(isLoading: false);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
    notifyListeners();
  }

  /// Select swipe mode
  void selectMode(SwipeMode mode) {
    _state = _state.copyWith(selectedMode: mode);
    notifyListeners();
  }

  /// Select expert role
  void selectRole(ExpertRole role) {
    _state = _state.copyWith(selectedRole: role);
    notifyListeners();
  }

  /// Toggle state selection
  void toggleState(String stateCode) {
    final states = List<String>.from(_state.selectedStates);
    if (states.contains(stateCode)) {
      states.remove(stateCode);
    } else {
      states.add(stateCode);
    }
    _state = _state.copyWith(selectedStates: states, selectedCounties: []);
    notifyListeners();
  }

  /// Select search everywhere (clear all states)
  void selectSearchEverywhere() {
    _state = _state.copyWith(selectedStates: [], selectedCounties: []);
    notifyListeners();
  }

  /// Load counties for selected state
  Future<void> loadCounties(String stateCode) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      _availableCounties = await _service.getCounties(stateCode);
      _state = _state.copyWith(isLoading: false);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
    notifyListeners();
  }

  /// Toggle county selection
  void toggleCounty(String countyName) {
    final counties = List<String>.from(_state.selectedCounties);
    if (counties.contains(countyName)) {
      counties.remove(countyName);
    } else {
      counties.add(countyName);
    }
    _state = _state.copyWith(selectedCounties: counties);
    notifyListeners();
  }

  /// Select whole state (clear counties)
  void selectWholeState() {
    _state = _state.copyWith(selectedCounties: []);
    notifyListeners();
  }

  /// Advance tutorial progress
  void advanceTutorial() {
    _state = _state.copyWith(tutorialProgress: _state.tutorialProgress + 1);
    notifyListeners();
  }

  /// Reset tutorial progress
  void resetTutorial() {
    _state = _state.copyWith(tutorialProgress: 0);
    notifyListeners();
  }

  /// Load stats for ready screen
  Future<void> loadStats() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      _geoStats = await _service.getStats(
        _state.selectedStates,
        _state.selectedCounties,
      );
      _state = _state.copyWith(isLoading: false);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
    notifyListeners();
  }

  /// Complete onboarding and save preferences
  Future<void> completeOnboarding() async {
    final preferences = UserPreferences(
      userId: 'user',
      userName: 'User',
      swipeMode: _state.selectedMode ?? SwipeMode.beginner,
      role: _state.selectedRole ?? ExpertRole.guest,
      states: _state.selectedStates,
      counties: _state.selectedCounties,
      onboardingCompleted: true,
      onboardingCompletedAt: DateTime.now(),
    );

    await _service.completeOnboarding(preferences);
  }

  /// Skip onboarding with defaults
  Future<void> skipOnboarding() async {
    await _service.skipOnboarding();
  }

  /// Go to next step
  void nextStep() {
    _state = _state.copyWith(currentStep: _state.currentStep + 1);
    notifyListeners();
  }

  /// Go to previous step
  void previousStep() {
    if (_state.currentStep > 0) {
      _state = _state.copyWith(currentStep: _state.currentStep - 1);
      notifyListeners();
    }
  }

  /// Reset state
  void reset() {
    _state = OnboardingState.initial();
    _availableStates = [];
    _availableCounties = [];
    _geoStats = null;
    notifyListeners();
  }
}
