/// Information about a US state for tax lien/deed investing
class StateInfo {
  final String code;           // 'AZ'
  final String name;           // 'Arizona'
  final String type;           // 'Tax Lien' or 'Tax Deed'
  final double interestRate;   // 16.0
  final String? nextAuction;   // 'Feb 2026'
  final int totalLiens;
  final int foreclosureCandidates;

  const StateInfo({
    required this.code,
    required this.name,
    required this.type,
    required this.interestRate,
    this.nextAuction,
    this.totalLiens = 0,
    this.foreclosureCandidates = 0,
  });

  /// Display string for auction info
  String get auctionInfo {
    final parts = <String>[type];
    if (interestRate > 0) {
      parts.add('${interestRate.toStringAsFixed(0)}%');
    }
    if (nextAuction != null) {
      parts.add(nextAuction!);
    }
    return parts.join(', ');
  }

  factory StateInfo.fromJson(Map<String, dynamic> json) {
    return StateInfo(
      code: json['code'] as String,
      name: json['name'] as String,
      type: json['type'] as String? ?? 'Tax Lien',
      interestRate: (json['interest_rate'] as num?)?.toDouble() ?? 0,
      nextAuction: json['next_auction'] as String?,
      totalLiens: json['total_liens'] as int? ?? 0,
      foreclosureCandidates: json['foreclosure_candidates'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'type': type,
      'interest_rate': interestRate,
      'next_auction': nextAuction,
      'total_liens': totalLiens,
      'foreclosure_candidates': foreclosureCandidates,
    };
  }
}

/// Information about a county within a state
class CountyInfo {
  final String name;           // 'Maricopa'
  final String stateCode;      // 'AZ'
  final String? majorCity;     // 'Phoenix'
  final int lienCount;
  final int foreclosureCount;

  const CountyInfo({
    required this.name,
    required this.stateCode,
    this.majorCity,
    this.lienCount = 0,
    this.foreclosureCount = 0,
  });

  factory CountyInfo.fromJson(Map<String, dynamic> json) {
    return CountyInfo(
      name: json['name'] as String,
      stateCode: json['state_code'] as String,
      majorCity: json['major_city'] as String?,
      lienCount: json['lien_count'] as int? ?? 0,
      foreclosureCount: json['foreclosure_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'state_code': stateCode,
      'major_city': majorCity,
      'lien_count': lienCount,
      'foreclosure_count': foreclosureCount,
    };
  }
}

/// Statistics for selected geography
class GeoStats {
  final int totalProperties;
  final int foreclosureCandidates;

  const GeoStats({
    required this.totalProperties,
    required this.foreclosureCandidates,
  });

  factory GeoStats.fromJson(Map<String, dynamic> json) {
    return GeoStats(
      totalProperties: json['total_properties'] as int? ?? 0,
      foreclosureCandidates: json['foreclosure_candidates'] as int? ?? 0,
    );
  }
}
