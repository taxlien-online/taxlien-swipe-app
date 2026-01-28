import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/models/tax_lien_models.dart';
import '../core/models/fvi.dart';

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
  }) async {
    if (_baseUrl == null) {
      // Return mock data during development
      return getMockForeclosureCandidates();
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
      // Fallback to mock data
      return getMockForeclosureCandidates();
    }
  }

  /// Regular search for liens
  Future<List<TaxLien>> searchLiens({
    String? state,
    String? county,
    int limit = 50,
  }) async {
    if (_baseUrl == null) {
      // Return mock data during development
      return getMockLiens();
    }

    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };
      if (state != null) queryParams['state'] = state;
      if (county != null) queryParams['county'] = county;

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
      // Fallback to mock data
      return getMockLiens();
    }
  }

  // Helper for mock foreclosure candidates (sdd-miw-gift)
  static List<TaxLien> getMockForeclosureCandidates() {
    return [
      TaxLien(
        id: 'fc-1',
        parcelId: 'AZ-MAR-001',
        propertyAddress: '789 Foreclosure St',
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
        description: 'High foreclosure potential property',
        images: ['https://images.unsplash.com/photo-1568605114967-8130f3a36994'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        foreclosureProbability: 0.85,
        miwScore: 0.92,
        karmaScore: 0.7,
        priorYearsOwed: 3,
        fvi: const FVI(
          financialScore: 8.0,
          expertScores: {'khun_pho': 7.5},
          propertyCost: 450.0,
        ),
      ),
      TaxLien(
        id: 'fc-2',
        parcelId: 'AZ-PIN-002',
        propertyAddress: '321 OTC Lane',
        city: 'Casa Grande',
        county: 'Pinal',
        state: 'AZ',
        taxAmount: 320.0,
        interestRate: 0.16,
        auctionDate: DateTime(2026, 2, 10),
        status: 'otc',
        propertyType: 'Vacant Land',
        estimatedValue: 45000.0,
        assessedValue: 40000.0,
        description: 'OTC lien with high foreclosure probability',
        images: ['https://images.unsplash.com/photo-1500382017468-9049fed747ef'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        foreclosureProbability: 0.78,
        miwScore: 0.88,
        karmaScore: 0.6,
        priorYearsOwed: 2,
        fvi: const FVI(
          financialScore: 7.5,
          expertScores: {'denis': 8.0},
          propertyCost: 320.0,
        ),
      ),
    ];
  }

  // Helper for mock data during development
  static List<TaxLien> getMockLiens() {
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
          expertScores: {'anton': 9.8, 'khun_pho': 8.0}, // Антон нашел что-то крутое!
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
          expertScores: {'denis': 7.0, 'khun_pho': 9.0}, // Кхун Пхо подтвердил фундамент
          propertyCost: 320.0,
        ),
      ),
    ];
  }
}
