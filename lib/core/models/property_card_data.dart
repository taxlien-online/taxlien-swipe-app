import 'marker.dart';
import 'tax_lien_models.dart';

/// Acquisition path for foreclosure property
enum AcquisitionPath {
  taxLien, // Buy lien → collect interest OR foreclose
  deed, // Buy deed directly at auction
  otc, // Over-the-counter (post-auction)
}

/// Property Card Data for Deal Detective swipe screen.
///
/// This represents a FORECLOSURE CANDIDATE - a property with high probability
/// of going to foreclosure through tax lien or deed acquisition.
///
/// Key metrics:
/// - foreclosureProbability: ML prediction of foreclosure likelihood
/// - priorYearsOwed: Delinquency indicator
/// - x1000Score: Hidden treasure potential (antiques, cars, scientific equipment)
/// - fvi: Family Value Index (combined expert scores)
class PropertyCardData {
  final String id;
  final String address;
  final String city;
  final String state;
  final String county;

  // Financial
  final double estimatedValue;
  final double lienCost;
  final double totalCost; // Including fees
  final double roi; // e.g. 0.18 for 18% or multiplier

  // FORECLOSURE METRICS (KEY!)
  final double foreclosureProbability; // 0.0 - 1.0 (ML prediction)
  final int priorYearsOwed; // Delinquency indicator (years)
  final AcquisitionPath acquisitionPath;

  // VALUE METRICS
  final double fvi; // Family Value Index 0-10
  final double karmaScore; // -1.0 to 1.0 (ethical filtering)
  final double? x1000Score; // Hidden treasure potential 0-10

  // Images
  final List<String> imageUrls;
  final Map<String, String> imageCategories; // e.g. {"url1": "roof", "url2": "lawn"}

  // Expert annotations
  final List<AnnotationMarker> markers;
  final String? expertReassurance; // "Khun Pho: Structure is solid"

  // Role-specific metrics for HUD display
  final Map<String, dynamic> roleMetrics;

  const PropertyCardData({
    required this.id,
    required this.address,
    required this.city,
    required this.state,
    this.county = '',
    required this.estimatedValue,
    required this.lienCost,
    required this.totalCost,
    required this.roi,
    this.foreclosureProbability = 0.0,
    this.priorYearsOwed = 0,
    this.acquisitionPath = AcquisitionPath.taxLien,
    required this.fvi,
    required this.karmaScore,
    this.x1000Score,
    required this.imageUrls,
    this.imageCategories = const {},
    this.markers = const [],
    this.expertReassurance,
    this.roleMetrics = const {},
  });

  /// Create PropertyCardData from TaxLien model
  factory PropertyCardData.fromTaxLien(TaxLien lien) {
    return PropertyCardData(
      id: lien.id,
      address: lien.propertyAddress,
      city: lien.city ?? '',
      state: lien.state,
      county: lien.county,
      estimatedValue: lien.estimatedValue,
      lienCost: lien.taxAmount,
      totalCost: lien.taxAmount * 1.1, // Estimate 10% fees
      roi: lien.interestRate / 100,
      foreclosureProbability: lien.foreclosureProbability ?? 0.0,
      priorYearsOwed: lien.priorYearsOwed ?? 0,
      acquisitionPath: _determineAcquisitionPath(lien),
      fvi: lien.fvi?.totalIndex ?? 5.0,
      karmaScore: lien.karmaScore ?? 0.0,
      x1000Score: _calculateX1000Score(lien),
      imageUrls: lien.images,
      imageCategories: const {},
      markers: const [],
      expertReassurance: null,
      roleMetrics: _buildRoleMetrics(lien),
    );
  }

  static AcquisitionPath _determineAcquisitionPath(TaxLien lien) {
    if (lien.status == 'otc' || lien.status == 'over_the_counter') {
      return AcquisitionPath.otc;
    }
    if (lien.status == 'deed' || lien.propertyType.toLowerCase().contains('deed')) {
      return AcquisitionPath.deed;
    }
    return AcquisitionPath.taxLien;
  }

  static double? _calculateX1000Score(TaxLien lien) {
    final metadata = lien.metadata;
    if (metadata == null) return null;

    double score = 0.0;
    if (metadata['hasVintageCar'] == true) score += 3.0;
    if (metadata['hasAntiques'] == true) score += 2.0;
    if (metadata['hasScientificEquipment'] == true) score += 4.0;
    if (metadata['hasPaintings'] == true) score += 2.0;
    if (metadata['ownerWasCollector'] == true) score += 2.0;

    return score > 0 ? score.clamp(0.0, 10.0) : null;
  }

  static Map<String, dynamic> _buildRoleMetrics(TaxLien lien) {
    return {
      'businessman': {
        'roi': lien.interestRate,
        'risk': (1 - (lien.foreclosureProbability ?? 0.5)) * 10,
      },
      'builder': {
        'structure': lien.metadata?['structureScore'] ?? 5.0,
        'roofAge': lien.metadata?['roofAge'] ?? 'Unknown',
      },
      'inventor': {
        'rarityScore': lien.metadata?['rarityScore'] ?? 0.0,
        'authenticity': lien.metadata?['authenticityScore'] ?? 0.0,
      },
    };
  }

  /// Copy with modified fields
  PropertyCardData copyWith({
    String? id,
    String? address,
    String? city,
    String? state,
    String? county,
    double? estimatedValue,
    double? lienCost,
    double? totalCost,
    double? roi,
    double? foreclosureProbability,
    int? priorYearsOwed,
    AcquisitionPath? acquisitionPath,
    double? fvi,
    double? karmaScore,
    double? x1000Score,
    List<String>? imageUrls,
    Map<String, String>? imageCategories,
    List<AnnotationMarker>? markers,
    String? expertReassurance,
    Map<String, dynamic>? roleMetrics,
  }) {
    return PropertyCardData(
      id: id ?? this.id,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      county: county ?? this.county,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      lienCost: lienCost ?? this.lienCost,
      totalCost: totalCost ?? this.totalCost,
      roi: roi ?? this.roi,
      foreclosureProbability: foreclosureProbability ?? this.foreclosureProbability,
      priorYearsOwed: priorYearsOwed ?? this.priorYearsOwed,
      acquisitionPath: acquisitionPath ?? this.acquisitionPath,
      fvi: fvi ?? this.fvi,
      karmaScore: karmaScore ?? this.karmaScore,
      x1000Score: x1000Score ?? this.x1000Score,
      imageUrls: imageUrls ?? this.imageUrls,
      imageCategories: imageCategories ?? this.imageCategories,
      markers: markers ?? this.markers,
      expertReassurance: expertReassurance ?? this.expertReassurance,
      roleMetrics: roleMetrics ?? this.roleMetrics,
    );
  }

  // Helper getters
  String get fullAddress => '$address, $city, $state';

  bool get isHighProbabilityForeclosure => foreclosureProbability >= 0.7;

  bool get hasX1000Potential => x1000Score != null && x1000Score! >= 5.0;

  String get foreclosureProbabilityLabel {
    if (foreclosureProbability >= 0.8) return 'Very High';
    if (foreclosureProbability >= 0.6) return 'High';
    if (foreclosureProbability >= 0.4) return 'Medium';
    if (foreclosureProbability >= 0.2) return 'Low';
    return 'Very Low';
  }

  String get acquisitionPathLabel {
    switch (acquisitionPath) {
      case AcquisitionPath.taxLien:
        return 'Tax Lien';
      case AcquisitionPath.deed:
        return 'Deed';
      case AcquisitionPath.otc:
        return 'OTC';
    }
  }

  /// Check if property has "Bridge" potential (high scores across multiple roles)
  /// A Bridge property appeals to multiple family members
  bool get hasBridgePotential {
    int highScoreCount = 0;
    const threshold = 7.0;

    // Check businessman ROI (normalized to 0-10)
    final businessmanRoi = roleMetrics['businessman']?['roi'];
    if (businessmanRoi != null && (businessmanRoi as num) >= threshold) {
      highScoreCount++;
    }

    // Check builder structure score
    final builderStructure = roleMetrics['builder']?['structure'];
    if (builderStructure != null && (builderStructure as num) >= threshold) {
      highScoreCount++;
    }

    // Check inventor rarity score
    final inventorRarity = roleMetrics['inventor']?['rarityScore'];
    if (inventorRarity != null && (inventorRarity as num) >= threshold) {
      highScoreCount++;
    }

    // Bridge if high across 2+ roles
    return highScoreCount >= 2;
  }

  /// Get the roles with high scores
  List<String> get bridgeRoles {
    final roles = <String>[];
    const threshold = 7.0;

    final businessmanRoi = roleMetrics['businessman']?['roi'];
    if (businessmanRoi != null && (businessmanRoi as num) >= threshold) {
      roles.add('Businessman');
    }

    final builderStructure = roleMetrics['builder']?['structure'];
    if (builderStructure != null && (builderStructure as num) >= threshold) {
      roles.add('Builder');
    }

    final inventorRarity = roleMetrics['inventor']?['rarityScore'];
    if (inventorRarity != null && (inventorRarity as num) >= threshold) {
      roles.add('Inventor');
    }

    return roles;
  }
}

/// Alias for future migration to more explicit naming
typedef ForeclosureCandidateCard = PropertyCardData;
