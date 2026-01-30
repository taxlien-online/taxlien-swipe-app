import '../../../core/models/tax_lien_models.dart';

class FamilyMatch {
  final TaxLien property;
  final List<String> interestedExpertIds;
  final DateTime updatedAt;

  const FamilyMatch({
    required this.property,
    required this.interestedExpertIds,
    required this.updatedAt,
  });
}
