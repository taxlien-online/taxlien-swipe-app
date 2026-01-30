import 'package:flutter/material.dart';
import '../models/expert_profile.dart';

class ExpertProfileService extends ChangeNotifier {
  static final ExpertProfileService _instance = ExpertProfileService._internal();
  factory ExpertProfileService() => _instance;
  ExpertProfileService._internal();

  static ExpertProfileService get instance => _instance;

  ExpertProfile _currentProfile = ExpertProfile.allProfiles.firstWhere((p) => p.id == 'anton');

  ExpertProfile get currentProfile => _currentProfile;

  void switchProfile(String profileId) {
    try {
      _currentProfile = ExpertProfile.allProfiles.firstWhere((p) => p.id == profileId);
      notifyListeners();
    } catch (e) {
      debugPrint('Profile $profileId not found');
    }
  }

  bool get isAnton => _currentProfile.role == ExpertRole.anton;
  bool get isKhunPho => _currentProfile.role == ExpertRole.khunPho;
  bool get isDenis => _currentProfile.role == ExpertRole.denis;
  bool get isVasilisa => _currentProfile.role == ExpertRole.vasilisa;

  Color getProfileColor(String profileId) {
    try {
      return ExpertProfile.allProfiles.firstWhere((p) => p.id == profileId).color;
    } catch (e) {
      return Colors.grey;
    }
  }
}
