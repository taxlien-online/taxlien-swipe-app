import 'package:flutter/material.dart';
import '../../../core/models/tax_lien_models.dart';
import '../models/family_match.dart';

class FamilyBoardService extends ChangeNotifier {
  static final FamilyBoardService _instance = FamilyBoardService._internal();
  factory FamilyBoardService() => _instance;
  FamilyBoardService._internal();

  static FamilyBoardService get instance => _instance;

  final List<FamilyMatch> _matches = [];

  List<FamilyMatch> get familyMatches => List.unmodifiable(_matches);

  void registerInterest(TaxLien property, String expertId) {
    final existingIndex = _matches.indexWhere((m) => m.property.id == property.id);

    if (existingIndex >= 0) {
      final existingMatch = _matches[existingIndex];
      if (!existingMatch.interestedExpertIds.contains(expertId)) {
        final updatedIds = List<String>.from(existingMatch.interestedExpertIds)..add(expertId);
        _matches[existingIndex] = FamilyMatch(
          property: property,
          interestedExpertIds: updatedIds,
          updatedAt: DateTime.now(),
        );
      }
    } else {
      _matches.add(FamilyMatch(
        property: property,
        interestedExpertIds: [expertId],
        updatedAt: DateTime.now(),
      ));
    }
    notifyListeners();
  }
}
