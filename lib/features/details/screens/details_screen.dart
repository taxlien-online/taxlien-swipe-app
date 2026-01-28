import 'package:flutter/material.dart';

class PropertyDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Property ID: $propertyId'),
            Text('Location: $countyName, $stateCode'),
            const SizedBox(height: 20),
            const Text('FVI Breakdown (Planned)'),
            const Text('Photo Gallery (Planned)'),
          ],
        ),
      ),
    );
  }
}
