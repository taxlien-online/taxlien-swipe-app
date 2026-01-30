import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/swipe_provider.dart';
import '../widgets/property_card_beginner.dart';
import '../../../core/models/expert_role.dart';
import 'package:go_router/go_router.dart'; // Import for navigation

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SwipeProvider>().loadProperties();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Deal Detective'),
        actions: [
          _buildRolePicker(),
        ],
      ),
      body: Consumer<SwipeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.properties.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.currentProperty == null) {
            return _buildEmptyState(context);
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                // Display two cards for stack effect
                if (provider.currentIndex + 1 < provider.properties.length)
                  Opacity(
                    opacity: 0.5,
                    child: Transform.scale(
                      scale: 0.95,
                      child: PropertyCardBeginner(
                        property: provider.properties[provider.currentIndex + 1],
                        onLike: () {}, // These will be handled by Draggable
                        onPass: () {}, // These will be handled by Draggable
                      ),
                    ),
                  ),
                
                // Top Draggable Card
                Draggable(
                  feedback: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 32,
                      height: MediaQuery.of(context).size.height - 200,
                      child: PropertyCardBeginner(
                        property: provider.currentProperty!,
                        onLike: () {},
                        onPass: () {},
                      ),
                    ),
                  ),
                  childWhenDragging: const SizedBox.shrink(),
                  onDragEnd: (details) {
                    // Simple swipe logic
                    if (details.offset.dx > 100) {
                      provider.handleLike(provider.currentProperty!.id);
                    } else if (details.offset.dx < -100) {
                      provider.handlePass(provider.currentProperty!.id);
                    } else {
                      // If dropped without significant swipe, advance to next as if passed
                      // This is a UX choice; could also revert position or prompt
                      provider.handlePass(provider.currentProperty!.id); 
                    }
                  },
                  child: PropertyCardBeginner(
                    property: provider.currentProperty!,
                    onLike: () => provider.handleLike(provider.currentProperty!.id),
                    onPass: () => provider.handlePass(provider.currentProperty!.id),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'No more properties to swipe!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Connect to the internet to load more properties or review your liked deals.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to 'Liked' properties screen
                // For now, let's assume a route like '/liked-properties'
                context.go('/liked-properties'); 
              },
              icon: const Icon(Icons.favorite),
              label: const Text('Review Liked Properties'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Optionally allow user to manually retry loading
                context.read<SwipeProvider>().loadProperties();
              },
              child: const Text('Try loading again'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRolePicker() {
    return Consumer<SwipeProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton<ExpertRole>(
          icon: const Icon(Icons.person_outline),
          onSelected: (role) => provider.setRole(role),
          itemBuilder: (context) => ExpertRole.values.map((role) {
            return PopupMenuItem(
              value: role,
              child: Text(role.name.toUpperCase()),
            );
          }).toList(),
        );
      },
    );
  }
}
