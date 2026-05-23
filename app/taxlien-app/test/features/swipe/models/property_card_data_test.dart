import 'package:flutter_test/flutter_test.dart';
import 'package:taxlien_swipe_app/core/models/property_card_data.dart';
import 'package:taxlien_swipe_app/core/models/tax_lien_models.dart';

void main() {
  group('PropertyCardData', () {
    group('foreclosure helpers', () {
      test('isHighProbabilityForeclosure returns true for probability >= 0.7', () {
        final property = _createProperty(foreclosureProbability: 0.75);
        expect(property.isHighProbabilityForeclosure, isTrue);
      });

      test('isHighProbabilityForeclosure returns false for probability < 0.7', () {
        final property = _createProperty(foreclosureProbability: 0.65);
        expect(property.isHighProbabilityForeclosure, isFalse);
      });

      test('hasX1000Potential returns true for score >= 5.0', () {
        final property = _createProperty(x1000Score: 6.0);
        expect(property.hasX1000Potential, isTrue);
      });

      test('hasX1000Potential returns false for null score', () {
        final property = _createProperty(x1000Score: null);
        expect(property.hasX1000Potential, isFalse);
      });

      test('hasX1000Potential returns false for score < 5.0', () {
        final property = _createProperty(x1000Score: 4.0);
        expect(property.hasX1000Potential, isFalse);
      });
    });

    group('foreclosureProbabilityLabel', () {
      test('returns "Very High" for probability >= 0.8', () {
        final property = _createProperty(foreclosureProbability: 0.85);
        expect(property.foreclosureProbabilityLabel, 'Very High');
      });

      test('returns "High" for probability >= 0.6', () {
        final property = _createProperty(foreclosureProbability: 0.65);
        expect(property.foreclosureProbabilityLabel, 'High');
      });

      test('returns "Medium" for probability >= 0.4', () {
        final property = _createProperty(foreclosureProbability: 0.45);
        expect(property.foreclosureProbabilityLabel, 'Medium');
      });

      test('returns "Low" for probability >= 0.2', () {
        final property = _createProperty(foreclosureProbability: 0.25);
        expect(property.foreclosureProbabilityLabel, 'Low');
      });

      test('returns "Very Low" for probability < 0.2', () {
        final property = _createProperty(foreclosureProbability: 0.1);
        expect(property.foreclosureProbabilityLabel, 'Very Low');
      });
    });

    group('acquisitionPathLabel', () {
      test('returns "Tax Lien" for taxLien path', () {
        final property = _createProperty(acquisitionPath: AcquisitionPath.taxLien);
        expect(property.acquisitionPathLabel, 'Tax Lien');
      });

      test('returns "Deed" for deed path', () {
        final property = _createProperty(acquisitionPath: AcquisitionPath.deed);
        expect(property.acquisitionPathLabel, 'Deed');
      });

      test('returns "OTC" for otc path', () {
        final property = _createProperty(acquisitionPath: AcquisitionPath.otc);
        expect(property.acquisitionPathLabel, 'OTC');
      });
    });

    group('bridge potential', () {
      test('hasBridgePotential returns true for 2+ high role scores', () {
        final property = _createProperty(
          roleMetrics: {
            'businessman': {'roi': 8.0},
            'builder': {'structure': 7.5},
            'inventor': {'rarityScore': 3.0},
          },
        );
        expect(property.hasBridgePotential, isTrue);
      });

      test('hasBridgePotential returns false for 1 high role score', () {
        final property = _createProperty(
          roleMetrics: {
            'businessman': {'roi': 8.0},
            'builder': {'structure': 5.0},
            'inventor': {'rarityScore': 3.0},
          },
        );
        expect(property.hasBridgePotential, isFalse);
      });

      test('bridgeRoles returns correct roles with high scores', () {
        final property = _createProperty(
          roleMetrics: {
            'businessman': {'roi': 9.0},
            'builder': {'structure': 8.0},
            'inventor': {'rarityScore': 3.0},
          },
        );
        expect(property.bridgeRoles, ['Businessman', 'Builder']);
      });
    });

    group('fromTaxLien factory', () {
      test('converts TaxLien to PropertyCardData correctly', () {
        final taxLien = _createTaxLien(
          id: 'test-123',
          propertyAddress: '123 Test St',
          city: 'TestCity',
          state: 'AZ',
          county: 'Maricopa',
          taxAmount: 5000,
          estimatedValue: 150000,
          interestRate: 16.0,
          foreclosureProbability: 0.85,
          priorYearsOwed: 3,
          images: ['https://example.com/image1.jpg'],
        );

        final property = PropertyCardData.fromTaxLien(taxLien);

        expect(property.id, 'test-123');
        expect(property.address, '123 Test St');
        expect(property.city, 'TestCity');
        expect(property.state, 'AZ');
        expect(property.county, 'Maricopa');
        expect(property.lienCost, 5000);
        expect(property.estimatedValue, 150000);
        expect(property.foreclosureProbability, 0.85);
        expect(property.priorYearsOwed, 3);
        expect(property.imageUrls, ['https://example.com/image1.jpg']);
      });

      test('determines deed acquisition path from status', () {
        final taxLien = _createTaxLien(
          id: 'deed-1',
          propertyAddress: '456 Deed Ave',
          state: 'FL',
          county: 'Palm Beach',
          status: 'deed',
          taxAmount: 3000,
          estimatedValue: 100000,
          interestRate: 12.0,
        );

        final property = PropertyCardData.fromTaxLien(taxLien);
        expect(property.acquisitionPath, AcquisitionPath.deed);
      });

      test('determines otc acquisition path from status', () {
        final taxLien = _createTaxLien(
          id: 'otc-1',
          propertyAddress: '789 OTC Blvd',
          state: 'TX',
          county: 'Harris',
          status: 'over_the_counter',
          taxAmount: 2000,
          estimatedValue: 80000,
          interestRate: 10.0,
        );

        final property = PropertyCardData.fromTaxLien(taxLien);
        expect(property.acquisitionPath, AcquisitionPath.otc);
      });

      test('calculates x1000Score from metadata', () {
        final taxLien = _createTaxLien(
          id: 'x1000-1',
          propertyAddress: '1942 Tesla Ave',
          state: 'CA',
          county: 'Los Angeles',
          taxAmount: 10000,
          estimatedValue: 250000,
          interestRate: 18.0,
          metadata: {
            'hasVintageCar': true,
            'hasScientificEquipment': true,
          },
        );

        final property = PropertyCardData.fromTaxLien(taxLien);
        expect(property.x1000Score, 7.0); // 3.0 + 4.0
      });
    });

    group('copyWith', () {
      test('creates new instance with updated values', () {
        final original = _createProperty(
          foreclosureProbability: 0.5,
          x1000Score: 3.0,
        );

        final updated = original.copyWith(
          foreclosureProbability: 0.9,
          x1000Score: 8.0,
        );

        expect(updated.foreclosureProbability, 0.9);
        expect(updated.x1000Score, 8.0);
        expect(updated.id, original.id);
        expect(updated.address, original.address);
      });
    });
  });
}

PropertyCardData _createProperty({
  double foreclosureProbability = 0.5,
  double? x1000Score,
  AcquisitionPath acquisitionPath = AcquisitionPath.taxLien,
  Map<String, dynamic> roleMetrics = const {},
}) {
  return PropertyCardData(
    id: 'test-id',
    address: '123 Test St',
    city: 'TestCity',
    state: 'AZ',
    estimatedValue: 100000,
    lienCost: 5000,
    totalCost: 5500,
    roi: 0.16,
    foreclosureProbability: foreclosureProbability,
    x1000Score: x1000Score,
    acquisitionPath: acquisitionPath,
    fvi: 7.0,
    karmaScore: 0.5,
    imageUrls: ['https://example.com/test.jpg'],
    roleMetrics: roleMetrics,
  );
}

TaxLien _createTaxLien({
  required String id,
  required String propertyAddress,
  String? city,
  required String state,
  required String county,
  required double taxAmount,
  required double estimatedValue,
  required double interestRate,
  String status = 'active',
  double? foreclosureProbability,
  int? priorYearsOwed,
  List<String> images = const [],
  Map<String, dynamic>? metadata,
}) {
  final now = DateTime.now();
  return TaxLien(
    id: id,
    propertyAddress: propertyAddress,
    city: city,
    county: county,
    state: state,
    taxAmount: taxAmount,
    interestRate: interestRate,
    auctionDate: now.add(const Duration(days: 30)),
    status: status,
    propertyType: 'residential',
    estimatedValue: estimatedValue,
    assessedValue: estimatedValue * 0.8,
    description: 'Test property',
    images: images,
    createdAt: now,
    updatedAt: now,
    foreclosureProbability: foreclosureProbability,
    priorYearsOwed: priorYearsOwed,
    metadata: metadata,
  );
}
