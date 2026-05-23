import 'package:flutter/material.dart';

enum ExpertRole {
  khunPho,
  denis,
  anton,
  vasilisa,
}

class ExpertProfile {
  final String id;
  final String name;
  final ExpertRole role;
  final String avatarUrl;
  final List<String> interests;
  final Color color;

  const ExpertProfile({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.interests,
    required this.color,
  });

  static List<ExpertProfile> get allProfiles => [
    const ExpertProfile(
      id: 'khun_pho',
      name: 'Khun Pho',
      role: ExpertRole.khunPho,
      avatarUrl: 'assets/avatars/khun_pho.png',
      interests: ['Foundation', 'Roof', 'Construction Defects'],
      color: Colors.blue,
    ),
    const ExpertProfile(
      id: 'denis',
      name: 'Denis',
      role: ExpertRole.denis,
      avatarUrl: 'assets/avatars/denis.png',
      interests: ['Furniture', 'Restoration', 'Materials'],
      color: Colors.green,
    ),
    const ExpertProfile(
      id: 'anton',
      name: 'Anton',
      role: ExpertRole.anton,
      avatarUrl: 'assets/avatars/anton.png',
      interests: ['Inventions', 'Retro Cars', 'Art', 'Archives'],
      color: Colors.red,
    ),
    const ExpertProfile(
      id: 'vasilisa',
      name: 'Vasilisa',
      role: ExpertRole.vasilisa,
      avatarUrl: 'assets/avatars/vasilisa.png',
      interests: ['Antique Toys', 'Dolls', 'Steiff Bears'],
      color: Colors.purple,
    ),
  ];
}
