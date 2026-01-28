import 'package:flutter/material.dart';

class AnnotationScreen extends StatelessWidget {
  final String propertyId;

  const AnnotationScreen({
    super.key,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expert Annotation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Annotating Property: $propertyId'),
            const SizedBox(height: 20),
            const Icon(Icons.edit_road, size: 64),
            const Text('Annotation Canvas (Planned)'),
            const Text('Point / Line / Area Tools'),
          ],
        ),
      ),
    );
  }
}
