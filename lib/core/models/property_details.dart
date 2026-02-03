/// Property Details Data for Deal Detective
///
/// Details provide information about the physical property -
/// interior photos, maps, utilities, structure assessment.
class PropertyDetails {
  final String propertyId;

  /// Property characteristics
  final PropertyCharacteristics? characteristics;

  /// Interior/additional photos organized by category
  final List<PropertyPhoto> photos;

  /// Location information with maps
  final LocationInfo? location;

  /// Utility information
  final UtilityInfo? utilities;

  /// Structure assessment (from Khun Pho perspective)
  final StructureAssessment? structureAssessment;

  /// Neighborhood info
  final NeighborhoodInfo? neighborhood;

  const PropertyDetails({
    required this.propertyId,
    this.characteristics,
    this.photos = const [],
    this.location,
    this.utilities,
    this.structureAssessment,
    this.neighborhood,
  });

  /// Get photos by category
  List<PropertyPhoto> getPhotosByCategory(String category) {
    return photos.where((p) => p.category == category).toList();
  }

  /// Get main interior photos
  List<PropertyPhoto> get interiorPhotos => getPhotosByCategory('interior');

  /// Get exterior photos
  List<PropertyPhoto> get exteriorPhotos => getPhotosByCategory('exterior');

  /// Get garage/storage photos (x1000 potential!)
  List<PropertyPhoto> get garagePhotos => getPhotosByCategory('garage');
}

class PropertyCharacteristics {
  final int? bedrooms;
  final int? bathrooms;
  final int? squareFeet;
  final int? lotSizeSquareFeet;
  final int? yearBuilt;
  final String? propertyType; // single_family, condo, mobile_home, vacant_land
  final String? constructionType; // wood, brick, concrete, etc.
  final int? stories;
  final bool? hasGarage;
  final bool? hasPool;
  final bool? hasBasement;
  final String? heatingType;
  final String? coolingType;

  const PropertyCharacteristics({
    this.bedrooms,
    this.bathrooms,
    this.squareFeet,
    this.lotSizeSquareFeet,
    this.yearBuilt,
    this.propertyType,
    this.constructionType,
    this.stories,
    this.hasGarage,
    this.hasPool,
    this.hasBasement,
    this.heatingType,
    this.coolingType,
  });

  String get bedroomsBathroomsLabel {
    final beds = bedrooms != null ? '$bedrooms bed' : '';
    final baths = bathrooms != null ? '$bathrooms bath' : '';
    return [beds, baths].where((s) => s.isNotEmpty).join(' / ');
  }

  String get squareFeetLabel {
    if (squareFeet == null) return '';
    return '${_formatNumber(squareFeet!)} sq ft';
  }

  String _formatNumber(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}

class PropertyPhoto {
  final String url;
  final String category; // exterior, interior, garage, roof, basement, etc.
  final String? caption;
  final DateTime? takenDate;
  final bool isMainPhoto;

  const PropertyPhoto({
    required this.url,
    required this.category,
    this.caption,
    this.takenDate,
    this.isMainPhoto = false,
  });
}

class LocationInfo {
  final double? latitude;
  final double? longitude;
  final String? streetViewUrl;
  final String? satelliteViewUrl;
  final String? parcelMapUrl;
  final String? zoningInfo;
  final String? floodZone;
  final double? elevationFeet;

  const LocationInfo({
    this.latitude,
    this.longitude,
    this.streetViewUrl,
    this.satelliteViewUrl,
    this.parcelMapUrl,
    this.zoningInfo,
    this.floodZone,
    this.elevationFeet,
  });

  bool get hasCoordinates => latitude != null && longitude != null;
}

class UtilityInfo {
  final String? waterSource; // municipal, well, none
  final String? sewerType; // municipal, septic, none
  final String? electricProvider;
  final String? gasProvider;
  final bool? hasInternet;
  final String? internetType;

  const UtilityInfo({
    this.waterSource,
    this.sewerType,
    this.electricProvider,
    this.gasProvider,
    this.hasInternet,
    this.internetType,
  });
}

class StructureAssessment {
  final double? overallScore; // 0-10 (Khun Pho rating)
  final String? roofCondition;
  final int? roofAgeYears;
  final String? foundationCondition;
  final String? wallsCondition;
  final String? plumbingCondition;
  final String? electricalCondition;
  final List<String> majorIssues;
  final List<String> minorIssues;
  final String? expertNotes; // Khun Pho's notes

  const StructureAssessment({
    this.overallScore,
    this.roofCondition,
    this.roofAgeYears,
    this.foundationCondition,
    this.wallsCondition,
    this.plumbingCondition,
    this.electricalCondition,
    this.majorIssues = const [],
    this.minorIssues = const [],
    this.expertNotes,
  });

  bool get needsMajorWork => majorIssues.isNotEmpty;
}

class NeighborhoodInfo {
  final double? walkScore;
  final double? crimeScore; // 0-10, higher is safer
  final String? schoolDistrict;
  final int? schoolRating; // 1-10
  final List<String> nearbyAmenities;
  final double? medianHomeValue;
  final double? medianIncome;

  const NeighborhoodInfo({
    this.walkScore,
    this.crimeScore,
    this.schoolDistrict,
    this.schoolRating,
    this.nearbyAmenities = const [],
    this.medianHomeValue,
    this.medianIncome,
  });
}
