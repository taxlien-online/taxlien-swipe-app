import 'package:flutter/material.dart';

class ContextView extends StatelessWidget {
  final String propertyId;

  const ContextView({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.description, size: 80, color: Colors.white70),
          const SizedBox(height: 20),
          Text(
            'Context for Property $propertyId',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            'Here you will find news articles, obituaries, ownership history, and more.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
