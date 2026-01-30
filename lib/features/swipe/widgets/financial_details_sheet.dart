import 'package:flutter/material.dart';
import '../../../../core/models/property_card_data.dart';

class FinancialDetailsSheet extends StatelessWidget {
  final PropertyCardData property;

  const FinancialDetailsSheet({super.key, required this.property});

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
          Text(
            'Financial Breakdown for ${property.address}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Divider(),
          _buildDetailRow('Estimated Market Value', '\$${property.estimatedValue.toStringAsFixed(0)}'),
          _buildDetailRow('Lien Cost', '\$${property.lienCost.toStringAsFixed(0)}'),
          _buildDetailRow('Total Cost (w/ fees)', '\$${property.totalCost.toStringAsFixed(0)}'),
          _buildDetailRow('Potential ROI', '${property.roi}%'),
          _buildDetailRow('Karma Score', '${property.karmaScore.toStringAsFixed(1)}'),
          
          if (property.roleMetrics.isNotEmpty) ...[
            const Divider(),
            Text(
              'Expert Metrics:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ...property.roleMetrics.entries.map((entry) {
              return _buildDetailRow(
                '${entry.key.toUpperCase()} Insights', 
                entry.value.toString(),
              );
            }).toList(),
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
}
