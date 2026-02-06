import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/models/tax_lien_models.dart';
import '../core/models/fvi.dart';
import '../core/models/property_card_data.dart';
import '../core/models/filter_options.dart';

class TaxLienService {
  final String? _baseUrl = dotenv.env['API_URL'];
  
  /// Search for foreclosure candidates (sdd-miw-gift integration)
  /// 
  /// Fetches liens with high foreclosure probability for Miw's strategy
  Future<List<TaxLien>> searchForeclosureCandidates({
    String state = 'AZ',
    int? priorYearsMin,
    double? maxAmount,
    double? foreclosureProbMin = 0.7,
    int limit = 100,
    FilterOptions? filter,
  }) async {
    if (_baseUrl == null) {
      return _getMockForeclosureCandidates();
    }

    try {
      final queryParams = <String, String>{
        'state': state,
        'foreclosure_prob_min': foreclosureProbMin.toString(),
        'limit': limit.toString(),
      };
      if (priorYearsMin != null) {
        queryParams['prior_years_min'] = priorYearsMin.toString();
      }
      if (maxAmount != null) {
        queryParams['max_amount'] = maxAmount.toString();
      }
      _applyFilterToParams(queryParams, filter);

      final uri = Uri.parse('$_baseUrl/api/v1/liens/foreclosure-candidates')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['liens'] ?? [];
        return data.map((json) => TaxLien.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load foreclosure candidates: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading foreclosure candidates: $e');
      return _getMockForeclosureCandidates();
    }
  }

  /// Regular search for liens
  /// This is the method DataRepository will call.
  Future<List<TaxLien>> searchLiens({
    String? state,
    String? county,
    int limit = 50, // Default limit
    FilterOptions? filter,
  }) async {
    if (_baseUrl == null) {
      return _getMockLiens();
    }

    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };
      if (state != null) queryParams['state'] = state;
      if (county != null) queryParams['county'] = county;
      _applyFilterToParams(queryParams, filter);

      final uri = Uri.parse('$_baseUrl/api/v1/liens/search')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['liens'] ?? [];
        return data.map((json) => TaxLien.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load liens: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading liens: $e');
      return _getMockLiens();
    }
  }

  /// Get foreclosure candidates as PropertyCardData (ready for UI)
  Future<List<PropertyCardData>> getForeclosureCandidateCards({
    String state = 'AZ',
    double? foreclosureProbMin = 0.7,
    int limit = 100,
  }) async {
    final liens = await searchForeclosureCandidates(
      state: state,
      foreclosureProbMin: foreclosureProbMin,
      limit: limit,
    );
    return liens.map((lien) => PropertyCardData.fromTaxLien(lien)).toList();
  }

  /// Get a single tax lien by ID
  Future<TaxLien?> getTaxLienById(String id) async {
    if (_baseUrl == null) {
      final allMock = [..._getMockLiens(), ..._getMockForeclosureCandidates()];
      try {
        return allMock.firstWhere((lien) => lien.id == id);
      } catch (_) {
        return null;
      }
    }

    try {
      final uri = Uri.parse('$_baseUrl/api/v1/liens/$id');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return TaxLien.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error loading lien $id: $e');
      return null;
    }
  }

  void _applyFilterToParams(Map<String, String> queryParams, FilterOptions? filter) {
    if (filter == null) return;
    if (filter.states.isNotEmpty) {
      queryParams['state'] = filter.states.first;
      if (filter.counties.isNotEmpty) {
        queryParams['county'] = filter.counties.join(',');
      }
    }
    queryParams['max_amount'] = filter.maxPrice.toString();
    queryParams['min_interest_rate'] = filter.minInterestRate.toString();
    queryParams['foreclosure_score_min'] = filter.minForeclosureScore.toString();
    queryParams['x1000_score_min'] = filter.minX1000Score.toString();
    if (filter.propertyTypes.isNotEmpty) {
      queryParams['property_type'] = filter.propertyTypes.join(',');
    }
    if (filter.saleTypes.isNotEmpty) {
      queryParams['sale_type'] = filter.saleTypes.join(',');
    }
  }

  // Helper for mock foreclosure candidates (sdd-miw-gift)
  // These represent properties with HIGH foreclosure probability
  // that we're actively hunting for Miw's strategy
  static List<TaxLien> _getMockForeclosureCandidates() {
    return [
      // HIGH FORECLOSURE + x1000 POTENTIAL (Vintage Car in garage!)
      TaxLien(
        id: 'fc-1',
        parcelId: 'AZ-MAR-001',
        propertyAddress: '789 Foreclosure St',
        city: 'Phoenix',
        county: 'Maricopa',
        state: 'AZ',
        taxAmount: 450.0,
        interestRate: 16.0,
        auctionDate: DateTime(2026, 2, 12),
        status: 'active',
        propertyType: 'Residential',
        estimatedValue: 250000.0,
        assessedValue: 210000.0,
        description: 'Estate of retired mechanic. Garage visible in photos.',
        images: [
          'https://images.unsplash.com/photo-1568605114967-8130f3a36994',
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64', // garage
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        foreclosureProbability: 0.85,
        miwScore: 0.92,
        karmaScore: 0.7,
        priorYearsOwed: 3,
        fvi: const FVI(
          financialScore: 8.0,
          expertScores: {'khun_pho': 7.5, 'anton': 9.5},
          propertyCost: 450.0,
        ),
        metadata: {
          'hasVintageCar': true,
          'x1000Hint': 'Ford Mustang 1967 spotted in garage photo',
          'structureScore': 7.5,
          'roofAge': '15 years',
          'ownerDeceased': true,
          'noHeirs': true,
        },
      ),

      // HIGH FORECLOSURE + Antique Furniture potential
      TaxLien(
        id: 'fc-2',
        parcelId: 'AZ-PIN-002',
        propertyAddress: '321 OTC Lane',
        city: 'Casa Grande',
        county: 'Pinal',
        state: 'AZ',
        taxAmount: 320.0,
        interestRate: 16.0,
        auctionDate: DateTime(2026, 2, 10),
        status: 'otc',
        propertyType: 'Residential',
        estimatedValue: 185000.0,
        assessedValue: 160000.0,
        description: 'Victorian-era home, original interior visible.',
        images: [
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9',
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc', // furniture
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        foreclosureProbability: 0.78,
        miwScore: 0.88,
        karmaScore: 0.6,
        priorYearsOwed: 2,
        fvi: const FVI(
          financialScore: 7.5,
          expertScores: {'denis': 9.0, 'khun_pho': 6.5},
          propertyCost: 320.0,
        ),
        metadata: {
          'hasAntiques': true,
          'x1000Hint': 'Victorian furniture, possible Eames chair',
          'structureScore': 6.5,
          'roofAge': '25 years',
          'ownerDeceased': true,
        },
      ),

      // HIGH FORECLOSURE - Good structure (Khun Pho approved)
      TaxLien(
        id: 'fc-3',
        parcelId: 'AZ-YAV-003',
        propertyAddress: '555 Prescott Valley Rd',
        city: 'Prescott',
        county: 'Yavapai',
        state: 'AZ',
        taxAmount: 280.0,
        interestRate: 16.0,
        auctionDate: DateTime(2026, 2, 15),
        status: 'active',
        propertyType: 'Residential',
        estimatedValue: 320000.0,
        assessedValue: 280000.0,
        description: 'Modern construction, excellent bones. Needs cosmetic work.',
        images: [
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6',
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        foreclosureProbability: 0.72,
        miwScore: 0.85,
        karmaScore: 0.8,
        priorYearsOwed: 2,
        fvi: const FVI(
          financialScore: 8.5,
          expertScores: {'khun_pho': 9.5, 'miw': 8.0},
          propertyCost: 280.0,
        ),
        metadata: {
          'structureScore': 9.5,
          'roofAge': '5 years',
          'foundationCondition': 'excellent',
          'expertReassurance': 'Khun Pho: Solid structure, needs paint only',
        },
      ),

      // VERY HIGH FORECLOSURE - Scientific equipment x1000!!!
      TaxLien(
        id: 'fc-4',
        parcelId: 'AZ-MAR-004',
        propertyAddress: '1942 Tesla Ave',
        city: 'Scottsdale',
        county: 'Maricopa',
        state: 'AZ',
        taxAmount: 890.0,
        interestRate: 16.0,
        auctionDate: DateTime(2026, 2, 20),
        status: 'active',
        propertyType: 'Residential',
        estimatedValue: 450000.0,
        assessedValue: 400000.0,
        description: 'Estate of retired physics professor. Lab equipment in basement.',
        images: [
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
          'https://images.unsplash.com/photo-1532094349884-543bc11b234d', // lab
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        foreclosureProbability: 0.91,
        miwScore: 0.95,
        karmaScore: 0.9,
        priorYearsOwed: 4,
        fvi: const FVI(
          financialScore: 7.0,
          expertScores: {'anton': 10.0, 'khun_pho': 7.0},
          propertyCost: 890.0,
        ),
        metadata: {
          'hasScientificEquipment': true,
          'ownerWasCollector': true,
          'x1000Hint': 'Owner was physics professor, possible rare equipment',
          'structureScore': 7.0,
          'roofAge': '20 years',
          'ownerDeceased': true,
          'noHeirs': true,
          'rarityScore': 9.5,
          'authenticityScore': 8.0,
        },
      ),

      // DEED sale - Vacant Land near Denis family
      TaxLien(
        id: 'fc-5',
        parcelId: 'SD-LAW-001',
        propertyAddress: 'Lot 42 Spearfish Canyon',
        city: 'Spearfish',
        county: 'Lawrence',
        state: 'SD',
        taxAmount: 150.0,
        interestRate: 12.0,
        auctionDate: DateTime(2026, 3, 1),
        status: 'deed',
        propertyType: 'Vacant Land',
        estimatedValue: 35000.0,
        assessedValue: 30000.0,
        description: 'Buildable lot near Denis family in Spearfish.',
        images: [
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef',
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        foreclosureProbability: 0.95, // Deed = guaranteed acquisition
        miwScore: 0.80,
        karmaScore: 0.85,
        priorYearsOwed: 5,
        fvi: const FVI(
          financialScore: 9.0,
          expertScores: {'denis': 8.5, 'miw': 7.0},
          propertyCost: 150.0,
        ),
        metadata: {
          'nearDenisFamily': true,
          'structureScore': 0.0, // vacant land
          'buildable': true,
          'roadAccess': true,
        },
      ),

      // Paintings potential x1000
      TaxLien(
        id: 'fc-6',
        parcelId: 'AZ-PIM-006',
        propertyAddress: '888 Art Collector Way',
        city: 'Tucson',
        county: 'Pima',
        state: 'AZ',
        taxAmount: 520.0,
        interestRate: 16.0,
        auctionDate: DateTime(2026, 2, 25),
        status: 'active',
        propertyType: 'Residential',
        estimatedValue: 380000.0,
        assessedValue: 340000.0,
        description: 'Estate of art dealer. Paintings visible in listing photos.',
        images: [
          'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c',
          'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5', // paintings
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        foreclosureProbability: 0.75,
        miwScore: 0.82,
        karmaScore: 0.65,
        priorYearsOwed: 2,
        fvi: const FVI(
          financialScore: 7.0,
          expertScores: {'anton': 8.5, 'miw': 9.0},
          propertyCost: 520.0,
        ),
        metadata: {
          'hasPaintings': true,
          'ownerWasCollector': true,
          'x1000Hint': 'Art dealer estate, Russian paintings spotted',
          'structureScore': 8.0,
          'roofAge': '10 years',
        },
      ),
    ];
  }

  // Helper for mock data during development
  static List<TaxLien> _getMockLiens() {
    return [
      TaxLien(
        id: '1',
        parcelId: '123-45-678',
        propertyAddress: '123 Phoenix Way',
        city: 'Phoenix',
        county: 'Maricopa',
        state: 'AZ',
        taxAmount: 450.0,
        interestRate: 0.16,
        auctionDate: DateTime(2026, 2, 12),
        status: 'active',
        propertyType: 'Residential',
        estimatedValue: 250000.0,
        assessedValue: 210000.0,
        description: 'Single family home in Phoenix',
        images: ['https://images.unsplash.com/photo-1568605114967-8130f3a36994'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        fvi: const FVI(
          financialScore: 7.5,
          expertScores: {'anton': 9.8, 'khun_pho': 8.0},
          propertyCost: 450.0,
        ),
      ),
      TaxLien(
        id: '2',
        parcelId: '987-65-432',
        propertyAddress: '456 Tucson Dr',
        city: 'Tucson',
        county: 'Pima',
        state: 'AZ',
        taxAmount: 320.0,
        interestRate: 0.16,
        auctionDate: DateTime(2026, 2, 26),
        status: 'active',
        propertyType: 'Vacant Land',
        estimatedValue: 45000.0,
        assessedValue: 40000.0,
        description: 'Buildable lot in Tucson',
        images: ['https://images.unsplash.com/photo-1500382017468-9049fed747ef'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        fvi: const FVI(
          financialScore: 6.0,
          expertScores: {'denis': 7.0, 'khun_pho': 9.0},
          propertyCost: 320.0,
        ),
      ),
    ];
  }
}