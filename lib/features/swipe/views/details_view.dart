import 'package:flutter/material.dart';

class DetailsView extends StatelessWidget {
  final String propertyId;

  const DetailsView({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[900],
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.photo_library, size: 80, color: Colors.white70),
          const SizedBox(height: 20),
          Text(
            'Details for Property $propertyId',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            'Here you will find interior photos, maps, utility information, and more.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
