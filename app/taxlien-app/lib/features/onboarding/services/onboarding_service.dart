// ignore_for_file: unused_field

import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/user_preferences.dart';
import '../../../core/models/expert_role.dart';
import '../../../core/models/swipe_mode.dart';
import '../models/state_info.dart';
import 'geolocation_service.dart';

/// Service for managing onboarding flow
class OnboardingService {
  final GeolocationService _geoService = GeolocationService();

  // API configuration (placeholder for actual gateway)
  // When _useApi is true, uncomment API calls and use _apiBaseUrl
  static const String _apiBaseUrl = 'https://api.taxlien.online/v1';
  static const bool _useApi = false; // Toggle for API vs mock data
  static const _keyOnboardingCompleted = 'onboarding_completed';
  static const _keySwipeMode = 'swipe_mode';
  static const _keyRole = 'role';
  static const _keyStates = 'states';
  static const _keyCounties = 'counties';

  /// Check if should show onboarding
  Future<bool> shouldShowOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_keyOnboardingCompleted) ?? false);
  }

  /// Complete onboarding with user preferences
  Future<void> completeOnboarding(UserPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
    await prefs.setString(_keySwipeMode, preferences.swipeMode.name);
    await prefs.setString(_keyRole, preferences.role.name);
    await prefs.setStringList(_keyStates, preferences.states);
    await prefs.setStringList(_keyCounties, preferences.counties);
  }

  /// Skip onboarding with defaults
  Future<void> skipOnboarding() async {
    final defaults = UserPreferences.defaults();
    await completeOnboarding(defaults);
  }

  /// Load saved preferences
  Future<UserPreferences?> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool(_keyOnboardingCompleted) ?? false;
    if (!completed) return null;

    final modeStr = prefs.getString(_keySwipeMode);
    final roleStr = prefs.getString(_keyRole);
    final states = prefs.getStringList(_keyStates) ?? [];
    final counties = prefs.getStringList(_keyCounties) ?? [];

    return UserPreferences(
      userId: 'user',
      userName: 'User',
      swipeMode: SwipeMode.values.firstWhere(
        (m) => m.name == modeStr,
        orElse: () => SwipeMode.beginner,
      ),
      role: ExpertRole.values.firstWhere(
        (r) => r.name == roleStr,
        orElse: () => ExpertRole.guest,
      ),
      states: states,
      counties: counties,
      onboardingCompleted: true,
    );
  }

  /// Get list of available states
  Future<List<StateInfo>> getStates() async {
    if (_useApi) {
      // TODO: Implement actual API call
      // final response = await http.get(Uri.parse('$_apiBaseUrl/states'));
      // return _parseStates(response);
    }
    return _mockStates;
  }

  /// Auto-detect user location and return nearby state
  Future<LocationResult?> detectUserLocation() async {
    return _geoService.getCurrentLocation();
  }

  /// Check if location permission is available
  Future<bool> isLocationAvailable() async {
    return _geoService.isLocationAvailable();
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    return _geoService.requestPermission();
  }

  /// Get nearby states based on location
  Future<List<StateInfo>> getNearbyStates(double lat, double lng) async {
    if (_useApi) {
      // TODO: Implement actual API call
      // final response = await http.get(
      //   Uri.parse('$_apiBaseUrl/states/nearby?lat=$lat&lng=$lng'),
      // );
      // return _parseStates(response);
    }

    // Try to get state from coordinates
    final stateCode = await _geoService.getStateFromCoordinates(lat, lng);
    if (stateCode != null) {
      // Return detected state first, then popular states
      final detected = _mockStates.where((s) => s.code == stateCode).toList();
      final others = _mockStates.where((s) => s.code != stateCode).take(2);
      return [...detected, ...others];
    }

    // Fallback to popular states
    return _mockStates.take(3).toList();
  }

  /// Get counties for a state
  Future<List<CountyInfo>> getCounties(String stateCode) async {
    if (_useApi) {
      // TODO: Implement actual API call
      // final response = await http.get(
      //   Uri.parse('$_apiBaseUrl/states/$stateCode/counties'),
      // );
      // return _parseCounties(response);
    }
    return _mockCounties[stateCode] ?? [];
  }

  /// Get statistics for selected geography
  Future<GeoStats> getStats(List<String> states, List<String> counties) async {
    if (_useApi) {
      // TODO: Implement actual API call
      // final params = {'states': states.join(','), 'counties': counties.join(',')};
      // final response = await http.get(Uri.parse('$_apiBaseUrl/stats').replace(queryParameters: params));
      // return _parseStats(response);
    }

    // Calculate mock stats based on selected geography
    int totalLiens = 0;
    int foreclosures = 0;

    if (states.isEmpty) {
      // "Search everywhere" - sum all
      for (final state in _mockStates) {
        totalLiens += state.totalLiens;
        foreclosures += state.foreclosureCandidates;
      }
    } else if (counties.isEmpty) {
      // Whole states selected
      for (final code in states) {
        final state = _mockStates.where((s) => s.code == code).firstOrNull;
        if (state != null) {
          totalLiens += state.totalLiens;
          foreclosures += state.foreclosureCandidates;
        }
      }
    } else {
      // Specific counties selected
      for (final countyName in counties) {
        for (final countyList in _mockCounties.values) {
          final county = countyList.where((c) => c.name == countyName).firstOrNull;
          if (county != null) {
            totalLiens += county.lienCount;
            foreclosures += county.foreclosureCount;
          }
        }
      }
    }

    return GeoStats(
      totalProperties: totalLiens,
      foreclosureCandidates: foreclosures,
    );
  }

  // Mock data for states
  static const _mockStates = [
    StateInfo(
      code: 'AZ',
      name: 'Arizona',
      type: 'Tax Lien',
      interestRate: 16,
      nextAuction: 'Feb 2026',
      totalLiens: 45000,
      foreclosureCandidates: 3200,
    ),
    StateInfo(
      code: 'FL',
      name: 'Florida',
      type: 'Tax Lien',
      interestRate: 18,
      nextAuction: 'May 2026',
      totalLiens: 120000,
      foreclosureCandidates: 8500,
    ),
    StateInfo(
      code: 'TX',
      name: 'Texas',
      type: 'Tax Deed',
      interestRate: 25,
      nextAuction: 'Monthly',
      totalLiens: 85000,
      foreclosureCandidates: 5200,
    ),
    StateInfo(
      code: 'SD',
      name: 'South Dakota',
      type: 'Tax Deed',
      interestRate: 12,
      nextAuction: 'Dec 2026',
      totalLiens: 8500,
      foreclosureCandidates: 620,
    ),
    StateInfo(
      code: 'UT',
      name: 'Utah',
      type: 'Tax Deed',
      interestRate: 0,
      nextAuction: 'May 2026',
      totalLiens: 12000,
      foreclosureCandidates: 890,
    ),
    StateInfo(
      code: 'NV',
      name: 'Nevada',
      type: 'Tax Deed',
      interestRate: 0,
      nextAuction: 'Varies',
      totalLiens: 18000,
      foreclosureCandidates: 1200,
    ),
  ];

  // Mock data for counties
  static const _mockCounties = <String, List<CountyInfo>>{
    'AZ': [
      CountyInfo(name: 'Maricopa', stateCode: 'AZ', majorCity: 'Phoenix', lienCount: 12450, foreclosureCount: 890),
      CountyInfo(name: 'Pima', stateCode: 'AZ', majorCity: 'Tucson', lienCount: 3200, foreclosureCount: 245),
      CountyInfo(name: 'Pinal', stateCode: 'AZ', majorCity: 'Casa Grande', lienCount: 2100, foreclosureCount: 156),
      CountyInfo(name: 'Yavapai', stateCode: 'AZ', majorCity: 'Prescott', lienCount: 1800, foreclosureCount: 134),
      CountyInfo(name: 'Coconino', stateCode: 'AZ', majorCity: 'Flagstaff', lienCount: 890, foreclosureCount: 67),
      CountyInfo(name: 'Mohave', stateCode: 'AZ', majorCity: 'Kingman', lienCount: 1200, foreclosureCount: 89),
    ],
    'FL': [
      CountyInfo(name: 'Miami-Dade', stateCode: 'FL', majorCity: 'Miami', lienCount: 28000, foreclosureCount: 2100),
      CountyInfo(name: 'Broward', stateCode: 'FL', majorCity: 'Fort Lauderdale', lienCount: 18500, foreclosureCount: 1340),
      CountyInfo(name: 'Palm Beach', stateCode: 'FL', majorCity: 'West Palm Beach', lienCount: 15200, foreclosureCount: 980),
      CountyInfo(name: 'Hillsborough', stateCode: 'FL', majorCity: 'Tampa', lienCount: 12800, foreclosureCount: 890),
    ],
    'SD': [
      CountyInfo(name: 'Lawrence', stateCode: 'SD', majorCity: 'Spearfish', lienCount: 450, foreclosureCount: 34),
      CountyInfo(name: 'Pennington', stateCode: 'SD', majorCity: 'Rapid City', lienCount: 1200, foreclosureCount: 89),
      CountyInfo(name: 'Minnehaha', stateCode: 'SD', majorCity: 'Sioux Falls', lienCount: 2100, foreclosureCount: 156),
    ],
  };
}
