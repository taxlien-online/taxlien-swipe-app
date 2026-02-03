import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../profile/models/expert_profile.dart';
import '../services/family_board_service.dart';
import '../models/family_match.dart';

class FamilyBoardScreen extends StatelessWidget {
  const FamilyBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // В реальном приложении здесь будет Provider для FamilyBoardService
    final familyService = FamilyBoardService.instance;
    final matches = familyService.familyMatches;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Decision Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {}, // Синхронизация с облаком
          ),
        ],
      ),
      body: matches.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: matches.length,
              itemBuilder: (context, index) => _buildMatchCard(context, matches[index]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.family_restroom, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No shared interests yet.', style: TextStyle(color: Colors.grey)),
          Text('Start swiping to find family matches!', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, FamilyMatch match) {
    final property = match.property;
    final fvi = property.fvi;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.pushNamed(
          'details',
          pathParameters: {
            'state': property.state.toLowerCase(),
            'county': property.county.toLowerCase(),
            'id': property.id,
          },
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  property.images.first,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
                    ),
                    child: Text(
                      'FVI: ${fvi?.totalIndex.toStringAsFixed(1) ?? "N/A"}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.propertyAddress,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('${property.county}, ${property.state}', style: TextStyle(color: Colors.grey[600])),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Text('Interested:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      ...match.interestedExpertIds.map((id) => _buildExpertAvatar(id)),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {}, // Перейти в чат обсуждения
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(80, 32),
                          backgroundColor: Colors.green.shade50,
                          elevation: 0,
                        ),
                        child: Text('Discuss', style: TextStyle(color: Colors.green.shade700, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertAvatar(String expertId) {
    try {
      final profile = ExpertProfile.allProfiles.firstWhere((p) => p.id == expertId);
      return Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Tooltip(
          message: profile.name,
          child: CircleAvatar(
            radius: 14,
            backgroundColor: profile.color,
            child: Text(
              profile.name[0],
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}