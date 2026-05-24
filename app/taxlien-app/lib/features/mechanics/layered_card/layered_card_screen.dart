import 'package:flutter/material.dart';

import 'models/property_layer.dart';
import 'widgets/layer_stack.dart';

/// A full-screen view for exploring property layers.
class LayeredCardScreen extends StatefulWidget {
  const LayeredCardScreen({
    super.key,
    required this.propertyId,
    this.initialLayers,
  });

  final String propertyId;
  final List<PropertyLayer>? initialLayers;

  @override
  State<LayeredCardScreen> createState() => _LayeredCardScreenState();
}

class _LayeredCardScreenState extends State<LayeredCardScreen> {
  late List<PropertyLayer> _layers;
  int _currentLayerIndex = 0;

  @override
  void initState() {
    super.initState();
    _layers = widget.initialLayers ?? _generateSampleLayers();
  }

  List<PropertyLayer> _generateSampleLayers() {
    return [
      PropertyLayer(
        type: PropertyLayerType.tax,
        title: 'Tax & Lien Status',
        subtitle: 'Delinquent since 2022',
        fields: {
          'Tax Owed': '\$4,250.00',
          'Interest Rate': '18%',
          'Redemption Period': '2 years',
          'Lien Position': '1st Position',
          'Last Payment': 'March 2022',
        },
      ),
      PropertyLayer(
        type: PropertyLayerType.owner,
        title: 'Owner Information',
        subtitle: 'Individual Owner',
        fields: {
          'Owner Name': 'John Smith',
          'Ownership Type': 'Fee Simple',
          'Purchase Date': 'June 2015',
          'Purchase Price': '\$185,000',
          'Mailing Address': '123 Main St',
        },
      ),
      PropertyLayer(
        type: PropertyLayerType.market,
        title: 'Market Analysis',
        subtitle: 'FVI Score: 78',
        fields: {
          'Assessed Value': '\$210,000',
          'Est. Market Value': '\$245,000',
          'Price/SqFt': '\$125',
          'Days on Market': '45',
          'Comparable Sales': '5 within 0.5mi',
        },
      ),
      PropertyLayer(
        type: PropertyLayerType.condition,
        title: 'Property Condition',
        subtitle: 'Built 1985, Good Condition',
        fields: {
          'Year Built': '1985',
          'Square Feet': '1,960',
          'Bedrooms': '3',
          'Bathrooms': '2',
          'Lot Size': '0.25 acres',
        },
      ),
      PropertyLayer(
        type: PropertyLayerType.legal,
        title: 'Legal & Encumbrances',
        subtitle: '1 Active Lien',
        fields: {
          'Active Liens': '1',
          'Mortgage Balance': '\$142,000',
          'HOA Dues': '\$150/month',
          'Code Violations': 'None',
          'Title Issues': 'Clear',
        },
      ),
      PropertyLayer(
        type: PropertyLayerType.location,
        title: 'Location & Neighborhood',
        subtitle: 'Suburban Residential',
        fields: {
          'School District': 'A-Rated',
          'Walk Score': '62',
          'Crime Index': 'Low',
          'Nearest Grocery': '0.8 mi',
          'Commute Time': '25 min avg',
        },
      ),
    ];
  }

  void _onLayerChange(int index) {
    setState(() {
      _currentLayerIndex = index;
    });
  }

  void _onFieldTap(String fieldName, String fieldValue) {
    // Show AI explanation overlay
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildExplanationSheet(fieldName, fieldValue),
    );
  }

  Widget _buildExplanationSheet(String fieldName, String fieldValue) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'AI Explanation',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            fieldName,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            fieldValue,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'This field shows the $fieldName for this property. '
            'Understanding this value can help you make better investment decisions.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Layers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share property
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Layer indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  _layers[_currentLayerIndex].type.icon,
                  color: _layers[_currentLayerIndex].type.color,
                ),
                const SizedBox(width: 8),
                Text(
                  'Layer ${_currentLayerIndex + 1} of ${_layers.length}',
                  style: theme.textTheme.labelLarge,
                ),
                const Spacer(),
                Text(
                  'Swipe down to dig deeper',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Layer stack
          Expanded(
            child: LayerStack(
              layers: _layers,
              initialLayerIndex: _currentLayerIndex,
              onLayerChange: _onLayerChange,
              onFieldTap: _onFieldTap,
            ),
          ),
        ],
      ),
    );
  }
}
