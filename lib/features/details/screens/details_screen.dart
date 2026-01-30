import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // New Import

import '../../../core/models/tax_lien_models.dart';
import '../../../core/repositories/data_repository.dart'; // New Import
import '../../../core/models/device_capabilities.dart'; // New Import
import '../../../services/image_cache_service.dart'; // New Import

import '../../deeplink/widgets/smart_banner.dart';
import '../../profile/models/expert_profile.dart';
import '../../swipe/widgets/share_sheet.dart';

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
  late Future<TaxLien?> _propertyFuture; // Allow null

  @override
  void initState() {
    super.initState();
    // Fetch property from DataRepository
    _propertyFuture = Provider.of<IDataRepository>(context, listen: false)
        .getPropertyById(widget.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<TaxLien?>( // Allow null
        future: _propertyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final property = snapshot.data;

          if (property == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 80,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Property Not Found Offline',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'This property may not have been preloaded or is no longer available.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.go('/swipe'); // Go back to swipe screen
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to Swiping'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              const SmartBanner(),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    _buildAppBar(property, context), // Pass context for DeviceCapabilities
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
                ),
              ),
            ],
          );
        },
      ),

    );
  }

  Widget _buildAppBar(TaxLien property, BuildContext context) {
    final imageCacheService = Provider.of<ImageCacheService>(context, listen: false);
    final caps = DeviceCapabilities.of(context);

    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            SharePropertySheet.show(
              context: context,
              property: property,
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: property.images.isNotEmpty
            ? Stack(
                children: [
                  PageView.builder(
                    itemCount: property.images.length,
                    itemBuilder: (context, index) {
                      // Request Ultra-Res images for details screen
                      final imageUrl = imageCacheService.buildOptimizedImageUrl(
                        property.images[index],
                        caps,
                        isUltraRes: true,
                      ).toString();
                      
                      return CachedNetworkImage( // Using CachedNetworkImage for consistency and caching
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey[300]),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey,
                          child: const Icon(Icons.broken_image, size: 100),
                        ),
                      );
                    },
                  ),
                  if (property.images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          property.images.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : Container(color: Colors.grey, child: const Icon(Icons.home, size: 100)),
      ),
    );
  }

  Widget _buildHeader(TaxLien property) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
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
                ],
              ),
            ),
            if (property.parcelId != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text('PARCEL ID', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(property.parcelId!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Chip(
              label: Text(property.propertyType.toUpperCase()),
              backgroundColor: Colors.blue.shade50,
              labelStyle: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            if (property.foreclosureProbability != null)
              Chip(
                label: Text('FORECLOSURE ${(property.foreclosureProbability! * 100).toStringAsFixed(0)}%'),
                backgroundColor: Colors.red.shade50,
                labelStyle: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFVISection(TaxLien property) {
    final fvi = property.fvi;
    if (fvi == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
        ),
        const SizedBox(height: 24),
        _buildInternalMapPlaceholder(property),
      ],
    );
  }

  Widget _buildInternalMapPlaceholder(TaxLien property) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location (Gateway Map Service)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade900,
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: AssetImage('assets/images/map_grid_placeholder.png'),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, color: Colors.white, size: 48),
                SizedBox(height: 8),
                Text(
                  'Secure Gateway Map Data',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Encrypted Parcel Boundaries Only',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
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