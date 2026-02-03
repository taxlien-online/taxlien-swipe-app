import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/property_details.dart';

/// Details View for Advanced Mode (right swipe)
///
/// Shows detailed property information:
/// - Photo gallery (interior, garage, etc.)
/// - Property characteristics (beds, baths, sqft)
/// - Structure assessment (Khun Pho perspective)
/// - Location info with maps
/// - Utilities
/// - Neighborhood info
class DetailsView extends StatelessWidget {
  final String propertyId;
  final PropertyDetails? details;

  const DetailsView({
    super.key,
    required this.propertyId,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    final det = details ?? _getMockDetails();

    return Container(
      color: const Color(0xFF311B92), // Deep purple for details
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),

            // Photo Gallery
            if (det.photos.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildPhotoGallery(context, det.photos),
              ),

            // Property Characteristics
            if (det.characteristics != null)
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'Property Details',
                  icon: Icons.home,
                  child: _buildCharacteristics(context, det.characteristics!),
                ),
              ),

            // Structure Assessment (Khun Pho)
            if (det.structureAssessment != null)
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'Structure Assessment',
                  icon: Icons.construction,
                  iconColor: Colors.blue,
                  child: _buildStructureAssessment(context, det.structureAssessment!),
                ),
              ),

            // Location & Maps
            if (det.location != null)
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'Location',
                  icon: Icons.location_on,
                  child: _buildLocation(context, det.location!),
                ),
              ),

            // Utilities
            if (det.utilities != null)
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'Utilities',
                  icon: Icons.electrical_services,
                  child: _buildUtilities(context, det.utilities!),
                ),
              ),

            // Neighborhood
            if (det.neighborhood != null)
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'Neighborhood',
                  icon: Icons.location_city,
                  child: _buildNeighborhood(context, det.neighborhood!),
                ),
              ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.photo_library, color: Colors.white70, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Property Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Interior photos, maps, and property information',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGallery(BuildContext context, List<PropertyPhoto> photos) {
    // Group photos by category
    final categories = <String, List<PropertyPhoto>>{};
    for (final photo in photos) {
      categories.putIfAbsent(photo.category, () => []).add(photo);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: Row(
                  children: [
                    Icon(
                      _getCategoryIcon(entry.key),
                      color: Colors.white70,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatCategoryName(entry.key),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${entry.value.length} photos',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    final photo = entry.value[index];
                    return GestureDetector(
                      onTap: () => _showFullScreenPhoto(context, photo),
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          imageUrl: photo.url,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.white.withValues(alpha: 0.1),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.white.withValues(alpha: 0.1),
                            child: const Icon(Icons.broken_image, color: Colors.white54),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showFullScreenPhoto(BuildContext context, PropertyPhoto photo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: photo.url,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            if (photo.caption != null)
              Positioned(
                bottom: 40,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    photo.caption!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: iconColor ?? Colors.white70, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildCharacteristics(BuildContext context, PropertyCharacteristics chars) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          // Main stats row
          Row(
            children: [
              if (chars.bedrooms != null)
                _buildStatChip(Icons.bed, '${chars.bedrooms} Bed'),
              if (chars.bathrooms != null)
                _buildStatChip(Icons.bathtub, '${chars.bathrooms} Bath'),
              if (chars.squareFeet != null)
                _buildStatChip(Icons.square_foot, chars.squareFeetLabel),
            ],
          ),
          const SizedBox(height: 12),
          // Additional details
          if (chars.yearBuilt != null)
            _buildInfoRow('Year Built', '${chars.yearBuilt}'),
          if (chars.propertyType != null)
            _buildInfoRow('Type', _formatPropertyType(chars.propertyType!)),
          if (chars.stories != null)
            _buildInfoRow('Stories', '${chars.stories}'),
          if (chars.lotSizeSquareFeet != null)
            _buildInfoRow('Lot Size', '${_formatNumber(chars.lotSizeSquareFeet!)} sq ft'),
          if (chars.hasGarage == true)
            _buildInfoRow('Garage', 'Yes', valueColor: Colors.green),
          if (chars.hasPool == true)
            _buildInfoRow('Pool', 'Yes', valueColor: Colors.blue),
          if (chars.hasBasement == true)
            _buildInfoRow('Basement', 'Yes'),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white70, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStructureAssessment(BuildContext context, StructureAssessment assessment) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall score
          if (assessment.overallScore != null) ...[
            Row(
              children: [
                const Text('Overall Score:', style: TextStyle(color: Colors.white70)),
                const Spacer(),
                _buildScoreBadge(assessment.overallScore!),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Conditions
          if (assessment.roofCondition != null)
            _buildConditionRow('Roof', assessment.roofCondition!, assessment.roofAgeYears),
          if (assessment.foundationCondition != null)
            _buildConditionRow('Foundation', assessment.foundationCondition!, null),
          if (assessment.wallsCondition != null)
            _buildConditionRow('Walls', assessment.wallsCondition!, null),
          if (assessment.plumbingCondition != null)
            _buildConditionRow('Plumbing', assessment.plumbingCondition!, null),
          if (assessment.electricalCondition != null)
            _buildConditionRow('Electrical', assessment.electricalCondition!, null),

          // Issues
          if (assessment.majorIssues.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Major Issues:',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            ...assessment.majorIssues.map((issue) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(issue, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ],
              ),
            )),
          ],

          // Expert notes
          if (assessment.expertNotes != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.engineering, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Khun Pho says:',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          assessment.expertNotes!,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreBadge(double score) {
    final color = score >= 7 ? Colors.green : score >= 5 ? Colors.orange : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        '${score.toStringAsFixed(1)}/10',
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildConditionRow(String label, String condition, int? age) {
    final color = _getConditionColor(condition);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              condition,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          if (age != null) ...[
            const SizedBox(width: 8),
            Text(
              '($age yrs)',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'excellent':
      case 'good':
        return Colors.green;
      case 'fair':
      case 'average':
        return Colors.orange;
      case 'poor':
      case 'needs repair':
        return Colors.red;
      default:
        return Colors.white70;
    }
  }

  Widget _buildLocation(BuildContext context, LocationInfo location) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          // Map placeholder (would integrate with Google Maps)
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, color: Colors.white54, size: 40),
                  const SizedBox(height: 8),
                  if (location.hasCoordinates)
                    Text(
                      '${location.latitude!.toStringAsFixed(4)}, ${location.longitude!.toStringAsFixed(4)}',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (location.zoningInfo != null)
            _buildInfoRow('Zoning', location.zoningInfo!),
          if (location.floodZone != null)
            _buildInfoRow(
              'Flood Zone',
              location.floodZone!,
              valueColor: location.floodZone!.toLowerCase().contains('high') ? Colors.red : null,
            ),
        ],
      ),
    );
  }

  Widget _buildUtilities(BuildContext context, UtilityInfo utilities) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          if (utilities.waterSource != null)
            _buildInfoRow('Water', _formatUtility(utilities.waterSource!)),
          if (utilities.sewerType != null)
            _buildInfoRow('Sewer', _formatUtility(utilities.sewerType!)),
          if (utilities.electricProvider != null)
            _buildInfoRow('Electric', utilities.electricProvider!),
          if (utilities.gasProvider != null)
            _buildInfoRow('Gas', utilities.gasProvider!),
          if (utilities.hasInternet == true)
            _buildInfoRow('Internet', utilities.internetType ?? 'Available'),
        ],
      ),
    );
  }

  Widget _buildNeighborhood(BuildContext context, NeighborhoodInfo neighborhood) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          if (neighborhood.walkScore != null)
            _buildScoreRow('Walk Score', neighborhood.walkScore!.toInt()),
          if (neighborhood.crimeScore != null)
            _buildScoreRow('Safety Score', neighborhood.crimeScore!.toInt()),
          if (neighborhood.schoolRating != null)
            _buildInfoRow('School Rating', '${neighborhood.schoolRating}/10'),
          if (neighborhood.schoolDistrict != null)
            _buildInfoRow('School District', neighborhood.schoolDistrict!),
          if (neighborhood.nearbyAmenities.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: neighborhood.nearbyAmenities.take(6).map((amenity) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    amenity,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, int score) {
    final color = score >= 70 ? Colors.green : score >= 40 ? Colors.orange : Colors.red;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
          Container(
            width: 100,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: score / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              '$score',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'interior':
        return Icons.chair;
      case 'exterior':
        return Icons.home;
      case 'garage':
        return Icons.garage;
      case 'roof':
        return Icons.roofing;
      case 'basement':
        return Icons.foundation;
      case 'yard':
        return Icons.grass;
      default:
        return Icons.photo;
    }
  }

  String _formatCategoryName(String category) {
    return category[0].toUpperCase() + category.substring(1);
  }

  String _formatPropertyType(String type) {
    return type.replaceAll('_', ' ').split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  String _formatUtility(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }

  String _formatNumber(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  /// Mock details data for development
  PropertyDetails _getMockDetails() {
    return PropertyDetails(
      propertyId: propertyId,
      characteristics: const PropertyCharacteristics(
        bedrooms: 3,
        bathrooms: 2,
        squareFeet: 1850,
        lotSizeSquareFeet: 8500,
        yearBuilt: 1975,
        propertyType: 'single_family',
        stories: 1,
        hasGarage: true,
        hasPool: false,
        hasBasement: true,
      ),
      photos: [
        const PropertyPhoto(
          url: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2',
          category: 'interior',
          caption: 'Living room with original hardwood floors',
        ),
        const PropertyPhoto(
          url: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136',
          category: 'interior',
          caption: 'Kitchen - needs updating',
        ),
        const PropertyPhoto(
          url: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64',
          category: 'garage',
          caption: 'Garage with storage - check for hidden items!',
        ),
        const PropertyPhoto(
          url: 'https://images.unsplash.com/photo-1568605114967-8130f3a36994',
          category: 'exterior',
          caption: 'Front view',
        ),
      ],
      structureAssessment: const StructureAssessment(
        overallScore: 7.5,
        roofCondition: 'Fair',
        roofAgeYears: 15,
        foundationCondition: 'Good',
        wallsCondition: 'Good',
        plumbingCondition: 'Fair',
        electricalCondition: 'Needs Update',
        majorIssues: [],
        minorIssues: ['Some cracks in driveway', 'Gutters need cleaning'],
        expertNotes: 'Solid structure overall. Roof will need replacement in 5-10 years. Foundation is excellent - no signs of settling.',
      ),
      location: const LocationInfo(
        latitude: 33.4484,
        longitude: -112.0740,
        zoningInfo: 'R-5 Residential',
        floodZone: 'Zone X (Low Risk)',
      ),
      utilities: const UtilityInfo(
        waterSource: 'municipal',
        sewerType: 'municipal',
        electricProvider: 'APS',
        gasProvider: 'Southwest Gas',
        hasInternet: true,
        internetType: 'Fiber available',
      ),
      neighborhood: const NeighborhoodInfo(
        walkScore: 45,
        crimeScore: 72,
        schoolRating: 7,
        schoolDistrict: 'Phoenix Union',
        nearbyAmenities: ['Grocery', 'Parks', 'Hospital', 'Schools', 'Shopping'],
        medianHomeValue: 285000,
      ),
    );
  }
}
