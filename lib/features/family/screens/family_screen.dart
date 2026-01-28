import 'package:flutter/material.dart';

class FamilyBoardScreen extends StatelessWidget {
  const FamilyBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Board'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.family_restroom, size: 64),
            Text('Family Collaborative Board'),
            Text('Shared Liked Properties (Planned)'),
          ],
        ),
      ),
    );
  }
}
