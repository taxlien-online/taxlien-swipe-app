import 'package:flutter/material.dart';

/// Filter criteria for property/lien search.
/// Used by TaxLienService and FilterSheet.
class FilterOptions {
  final List<String> states;
  final List<String> counties;
  final double maxPrice;
  final double minInterestRate;
  final double maxLtvRatio;
  final List<String> propertyTypes;
  final List<String> saleTypes;
  final DateTimeRange? auctionDateRange;
  final double minForeclosureScore;
  final double minX1000Score;
  final bool hasPhotos;
  final bool hasStreetView;

  const FilterOptions({
    this.states = const [],
    this.counties = const [],
    this.maxPrice = 100000.0,
    this.minInterestRate = 0.08,
    this.maxLtvRatio = 0.10,
    this.propertyTypes = const ['Residential', 'Vacant Land'],
    this.saleTypes = const ['Auction', 'OTC'],
    this.auctionDateRange,
    this.minForeclosureScore = 0.0,
    this.minX1000Score = 0.0,
    this.hasPhotos = true,
    this.hasStreetView = false,
  });

  FilterOptions copyWith({
    List<String>? states,
    List<String>? counties,
    double? maxPrice,
    double? minInterestRate,
    double? maxLtvRatio,
    List<String>? propertyTypes,
    List<String>? saleTypes,
    DateTimeRange? auctionDateRange,
    double? minForeclosureScore,
    double? minX1000Score,
    bool? hasPhotos,
    bool? hasStreetView,
  }) {
    return FilterOptions(
      states: states ?? this.states,
      counties: counties ?? this.counties,
      maxPrice: maxPrice ?? this.maxPrice,
      minInterestRate: minInterestRate ?? this.minInterestRate,
      maxLtvRatio: maxLtvRatio ?? this.maxLtvRatio,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      saleTypes: saleTypes ?? this.saleTypes,
      auctionDateRange: auctionDateRange ?? this.auctionDateRange,
      minForeclosureScore: minForeclosureScore ?? this.minForeclosureScore,
      minX1000Score: minX1000Score ?? this.minX1000Score,
      hasPhotos: hasPhotos ?? this.hasPhotos,
      hasStreetView: hasStreetView ?? this.hasStreetView,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'states': states,
      'counties': counties,
      'maxPrice': maxPrice,
      'minInterestRate': minInterestRate,
      'maxLtvRatio': maxLtvRatio,
      'propertyTypes': propertyTypes,
      'saleTypes': saleTypes,
      'auctionDateRange': auctionDateRange != null
          ? {
              'start': auctionDateRange!.start.toIso8601String(),
              'end': auctionDateRange!.end.toIso8601String(),
            }
          : null,
      'minForeclosureScore': minForeclosureScore,
      'minX1000Score': minX1000Score,
      'hasPhotos': hasPhotos,
      'hasStreetView': hasStreetView,
    };
  }

  factory FilterOptions.fromJson(Map<String, dynamic> json) {
    DateTimeRange? range;
    if (json['auctionDateRange'] != null) {
      final r = json['auctionDateRange'] as Map<String, dynamic>;
      range = DateTimeRange(
        start: DateTime.parse(r['start'] as String),
        end: DateTime.parse(r['end'] as String),
      );
    }
    return FilterOptions(
      states: List<String>.from(json['states'] ?? []),
      counties: List<String>.from(json['counties'] ?? []),
      maxPrice: (json['maxPrice'] as num?)?.toDouble() ?? 100000.0,
      minInterestRate: (json['minInterestRate'] as num?)?.toDouble() ?? 0.08,
      maxLtvRatio: (json['maxLtvRatio'] as num?)?.toDouble() ?? 0.10,
      propertyTypes: List<String>.from(json['propertyTypes'] ?? ['Residential', 'Vacant Land']),
      saleTypes: List<String>.from(json['saleTypes'] ?? ['Auction', 'OTC']),
      auctionDateRange: range,
      minForeclosureScore: (json['minForeclosureScore'] as num?)?.toDouble() ?? 0.0,
      minX1000Score: (json['minX1000Score'] as num?)?.toDouble() ?? 0.0,
      hasPhotos: json['hasPhotos'] as bool? ?? true,
      hasStreetView: json['hasStreetView'] as bool? ?? false,
    );
  }

  /// Stable key for caching/stream context (simplified)
  String get contextHash {
    final parts = [
      states.join(','),
      counties.join(','),
      maxPrice.toStringAsFixed(0),
      minForeclosureScore.toStringAsFixed(2),
    ];
    return parts.join('|');
  }
}
