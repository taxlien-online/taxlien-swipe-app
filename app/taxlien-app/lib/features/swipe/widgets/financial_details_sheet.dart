import 'package:flutter/material.dart';
import '../../../core/models/property_card_data.dart';
import '../../../core/models/tax_lien_models.dart';

class FinancialDetailsSheet extends StatelessWidget {
  final PropertyCardData property;

  const FinancialDetailsSheet({super.key, required this.property});

  /// Create from TaxLien using the converter
  factory FinancialDetailsSheet.fromTaxLien({
    Key? key,
    required TaxLien lien,
  }) {
    return FinancialDetailsSheet(
      key: key,
      property: PropertyCardData.fromTaxLien(lien),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header with address
          Text(
            property.address,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            '${property.city}, ${property.state}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 16),

          // FORECLOSURE METRICS (KEY!)
          _buildSectionHeader(context, 'Foreclosure Analysis'),
          _buildForeclosureProbabilityRow(context),
          _buildDetailRow('Acquisition Path', property.acquisitionPathLabel),
          if (property.priorYearsOwed > 0)
            _buildDetailRow('Years Delinquent', '${property.priorYearsOwed} years'),

          const Divider(height: 24),

          // FINANCIAL METRICS
          _buildSectionHeader(context, 'Financial Breakdown'),
          _buildDetailRow('Estimated Value', '\$${_formatNumber(property.estimatedValue)}'),
          _buildDetailRow('Lien Cost', '\$${_formatNumber(property.lienCost)}'),
          _buildDetailRow('Total Cost (w/ fees)', '\$${_formatNumber(property.totalCost)}'),
          _buildDetailRow('Potential ROI', '${(property.roi * 100).toStringAsFixed(1)}%'),

          const Divider(height: 24),

          // VALUE METRICS
          _buildSectionHeader(context, 'Value Indicators'),
          _buildFviRow(context),
          _buildDetailRow('Karma Score', _formatKarmaScore(property.karmaScore)),
          if (property.hasX1000Potential)
            _buildX1000Row(context),

          // Expert reassurance if present
          if (property.expertReassurance != null) ...[
            const Divider(height: 24),
            _buildExpertReassurance(context),
          ],

          // Role metrics
          if (property.roleMetrics.isNotEmpty) ...[
            const Divider(height: 24),
            _buildSectionHeader(context, 'Expert Metrics'),
            ...property.roleMetrics.entries.map((entry) {
              return _buildDetailRow(
                _formatRoleName(entry.key),
                _formatRoleValue(entry.value),
              );
            }),
          ],

          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildForeclosureProbabilityRow(BuildContext context) {
    final prob = property.foreclosureProbability;
    final color = prob >= 0.7
        ? Colors.green
        : prob >= 0.4
            ? Colors.orange
            : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Foreclosure Probability', style: TextStyle(fontSize: 16)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color),
            ),
            child: Text(
              '${(prob * 100).toStringAsFixed(0)}% ${property.foreclosureProbabilityLabel}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFviRow(BuildContext context) {
    final fvi = property.fvi;
    final stars = (fvi / 2).round(); // 0-10 → 0-5 stars

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Family Value Index', style: TextStyle(fontSize: 16)),
          Row(
            children: [
              Text(
                fvi.toStringAsFixed(1),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              ...List.generate(5, (int i) {
                return Icon(
                  i < stars ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildX1000Row(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.diamond, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              const Text('x1000 Potential', style: TextStyle(fontSize: 16)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${property.x1000Score!.toStringAsFixed(1)}/10',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertReassurance(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha:0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              property.expertReassurance!,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  String _formatKarmaScore(double score) {
    if (score > 0.5) return 'Good (+${score.toStringAsFixed(1)})';
    if (score < -0.5) return 'Caution (${score.toStringAsFixed(1)})';
    return 'Neutral (${score.toStringAsFixed(1)})';
  }

  String _formatRoleName(String role) {
    return role[0].toUpperCase() + role.substring(1);
  }

  String _formatRoleValue(dynamic value) {
    if (value is Map) {
      return value.entries
          .take(2)
          .map((e) => '${e.key}: ${e.value}')
          .join(', ');
    }
    return value.toString();
  }
}
