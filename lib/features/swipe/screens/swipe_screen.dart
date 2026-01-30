import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/swipe_provider.dart';
import '../widgets/property_card_beginner.dart';
import '../../../core/models/expert_role.dart';

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
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.currentProperty == null) {
            return const Center(
              child: Text('No more properties! Check back later.'),
            );
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
                        onLike: () {},
                        onPass: () {},
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
