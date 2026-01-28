import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/models/tax_lien_models.dart';
import '../core/models/fvi.dart';

class TaxLienService {
  final String? _baseUrl = dotenv.env['API_URL'];
  
  // ... методы ...

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
