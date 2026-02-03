import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Result of location detection
class LocationResult {
  final double latitude;
  final double longitude;
  final String? stateCode;
  final String? stateName;
  final String? county;
  final String? city;

  const LocationResult({
    required this.latitude,
    required this.longitude,
    this.stateCode,
    this.stateName,
    this.county,
    this.city,
  });

  @override
  String toString() =>
      'LocationResult(lat: $latitude, lng: $longitude, state: $stateCode, county: $county)';
}

/// Service for detecting user location
class GeolocationService {
  // US state abbreviations mapping
  static const _stateAbbreviations = {
    'Alabama': 'AL',
    'Alaska': 'AK',
    'Arizona': 'AZ',
    'Arkansas': 'AR',
    'California': 'CA',
    'Colorado': 'CO',
    'Connecticut': 'CT',
    'Delaware': 'DE',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Hawaii': 'HI',
    'Idaho': 'ID',
    'Illinois': 'IL',
    'Indiana': 'IN',
    'Iowa': 'IA',
    'Kansas': 'KS',
    'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Maine': 'ME',
    'Maryland': 'MD',
    'Massachusetts': 'MA',
    'Michigan': 'MI',
    'Minnesota': 'MN',
    'Mississippi': 'MS',
    'Missouri': 'MO',
    'Montana': 'MT',
    'Nebraska': 'NE',
    'Nevada': 'NV',
    'New Hampshire': 'NH',
    'New Jersey': 'NJ',
    'New Mexico': 'NM',
    'New York': 'NY',
    'North Carolina': 'NC',
    'North Dakota': 'ND',
    'Ohio': 'OH',
    'Oklahoma': 'OK',
    'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'Rhode Island': 'RI',
    'South Carolina': 'SC',
    'South Dakota': 'SD',
    'Tennessee': 'TN',
    'Texas': 'TX',
    'Utah': 'UT',
    'Vermont': 'VT',
    'Virginia': 'VA',
    'Washington': 'WA',
    'West Virginia': 'WV',
    'Wisconsin': 'WI',
    'Wyoming': 'WY',
  };

  /// Check if location services are available and permitted
  Future<bool> isLocationAvailable() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Request location permission
  Future<bool> requestPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Get current location with reverse geocoding
  Future<LocationResult?> getCurrentLocation() async {
    try {
      // Check if service is enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      // Check permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      // Get position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // Reverse geocode
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        return LocationResult(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }

      final placemark = placemarks.first;
      final stateName = placemark.administrativeArea;
      final stateCode =
          stateName != null ? _stateAbbreviations[stateName] : null;

      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        stateCode: stateCode,
        stateName: stateName,
        county: placemark.subAdministrativeArea,
        city: placemark.locality,
      );
    } catch (e) {
      // Location failed, return null
      return null;
    }
  }

  /// Get state code from coordinates (without getting current position)
  Future<String?> getStateFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;

      final stateName = placemarks.first.administrativeArea;
      return stateName != null ? _stateAbbreviations[stateName] : null;
    } catch (e) {
      return null;
    }
  }
}
