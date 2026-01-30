import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/models/tax_lien_models.dart';
import '../../../services/tax_lien_service.dart';
import '../../profile/models/expert_profile.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String propertyId;
  final String stateCode;
  final String countyName;

  const PropertyDetailsScreen({
    super.key,
    required this.propertyId,
    required this.stateCode,
    required this.countyName,
  });

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  late Future<TaxLien> _propertyFuture;

  @override
  void initState() {
    super.initState();
    // В реальном приложении здесь будет запрос к Gateway API
    // Для демо используем мок из сервиса
    _propertyFuture = Future.value(
      TaxLienService.getMockLiens().firstWhere((p) => p.id == widget.propertyId)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<TaxLien>(
        future: _propertyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final property = snapshot.data!;
          return CustomScrollView(
            slivers: [
              _buildAppBar(property),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(property),
                      const SizedBox(height: 24),
                      _buildFVISection(property),
                      const SizedBox(height: 24),
                      _buildFinancialStats(property),
                      const SizedBox(height: 24),
                      _buildActionButtons(property),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(TaxLien property) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: property.images.isNotEmpty
            ? Image.network(property.images.first, fit: BoxFit.cover)
            : Container(color: Colors.grey, child: const Icon(Icons.home, size: 100)),
      ),
    );
  }

  Widget _buildHeader(TaxLien property) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          property.propertyAddress,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(
          '${property.city}, ${property.county}, ${property.state}',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Chip(
          label: Text(property.propertyType.toUpperCase()),
          backgroundColor: Colors.blue.shade50,
          labelStyle: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildFVISection(TaxLien property) {
    final fvi = property.fvi;
    if (fvi == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Family Value Index (ИПП)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
              ),
              Text(
                fvi.totalIndex.toStringAsFixed(1),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber),
              ),
            ],
          ),
          const Divider(height: 24),
          const Text('Expert Contributions:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...ExpertProfile.allProfiles.map((profile) {
            final score = fvi.getScoreFor(profile.id);
            if (score == 0) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: profile.color, radius: 10),
                  const SizedBox(width: 8),
                  Text(profile.name),
                  const Spacer(),
                  Text('$score/10', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFinancialStats(TaxLien property) {
    final roi = ((property.estimatedValue - property.taxAmount) / property.taxAmount * 100);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Financial Analysis', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildStatCard('Lien Amount', '\$${property.taxAmount.toStringAsFixed(0)}', Icons.attach_money),
            const SizedBox(width: 12),
            _buildStatCard('Potential ROI', '${roi.toStringAsFixed(1)}%', Icons.trending_up),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard('Est. Value', '\$${property.estimatedValue.toStringAsFixed(0)}', Icons.home_work),
            const SizedBox(width: 12),
            _buildStatCard('Interest Rate', '${property.interestRate}%', Icons.percent),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(TaxLien property) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => context.pushNamed('annotate', pathParameters: {'id': property.id}),
            icon: const Icon(Icons.edit_note, color: Colors.white),
            label: const Text('Expert Annotation Mode', style: TextStyle(color: Colors.white, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () {}, // Planned: Family Board
            icon: const Icon(Icons.family_restroom),
            label: const Text('Discuss with Family', style: TextStyle(fontSize: 16)),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}