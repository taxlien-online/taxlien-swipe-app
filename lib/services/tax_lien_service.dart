import '../core/models/tax_lien_models.dart';
import '../core/models/fvi.dart';

class TaxLienService {
  Future<List<TaxLien>> searchLiens() async {
    // Имитация задержки сети
    await Future.delayed(const Duration(milliseconds: 800));
    return getMockLiens();
  }

  Future<List<TaxLien>> searchForeclosureCandidates({
    required String state,
    required int priorYearsMin,
    required int maxAmount,
    required double foreclosureProbMin,
  }) async {
    // Имитация задержки сети
    await Future.delayed(const Duration(milliseconds: 800));
    return getMockLiens().where((lien) =>
      lien.state == state &&
      (lien.priorYearsOwed ?? 0) >= priorYearsMin &&
      lien.taxAmount <= maxAmount &&
      (lien.foreclosureProbability ?? 0.0) >= foreclosureProbMin
    ).toList();
  }

  Future<TaxLien> getTaxLienById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockLiens().firstWhere((lien) => lien.id == id);
  }

  static List<TaxLien> getMockLiens() {
    return [
      TaxLien(
        id: '1',
        propertyAddress: '123 Oak Street',
        city: 'Phoenix',
        state: 'AZ',
        county: 'Maricopa',
        estimatedValue: 150000,
        assessedValue: 120000,
        taxAmount: 450,
        interestRate: 0.16,
        auctionDate: DateTime(2026, 2, 15),
        status: 'active',
        propertyType: 'Residential',
        description: 'Single family home in a quiet neighborhood.',
        images: [
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800',
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        fvi: FVI.mock(),
        foreclosureProbability: 0.75,
        priorYearsOwed: 3,
      ),
      TaxLien(
        id: '2',
        propertyAddress: '742 Evergreen Terrace',
        city: 'Springfield',
        state: 'IL',
        county: 'Sangamon',
        estimatedValue: 220000,
        assessedValue: 200000,
        taxAmount: 1200,
        interestRate: 0.18,
        auctionDate: DateTime(2026, 3, 1),
        status: 'active',
        propertyType: 'Residential',
        description: 'Classic American family home.',
        images: [
          'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800',
          'https://images.unsplash.com/photo-1480074568708-e7b720bb3f09?w=800',
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        fvi: FVI.mock(),
        foreclosureProbability: 0.6,
        priorYearsOwed: 2,
      ),
      TaxLien(
        id: '3',
        propertyAddress: 'Desert Plot 42',
        city: 'Mojave',
        state: 'CA',
        county: 'San Bernardino',
        estimatedValue: 15000,
        assessedValue: 10000,
        taxAmount: 300,
        interestRate: 0.10,
        auctionDate: DateTime(2026, 4, 1),
        status: 'active',
        propertyType: 'Land',
        description: 'Undeveloped desert land.',
        images: [
          'https://images.unsplash.com/photo-1473580044384-7ba9967e16a0?w=800',
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        fvi: FVI.mock(),
        foreclosureProbability: 0.1,
        priorYearsOwed: 1,
      ),
    ];
  }
}