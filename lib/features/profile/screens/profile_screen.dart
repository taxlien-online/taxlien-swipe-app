import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expert Profile'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 40, child: Icon(Icons.person)),
            SizedBox(height: 20),
            Text('Expert Profile Switcher'),
            Text('Roles: Khun Pho, Denis, Anton, Vasilisa'),
          ],
        ),
      ),
    );
  }
}
