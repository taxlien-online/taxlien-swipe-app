import 'package:flutter/material.dart';

import 'models/triage_board.dart';
import 'widgets/orbit_canvas.dart';

/// A full-screen view for triaging properties with radial zones.
class OrbitTriageScreen extends StatefulWidget {
  const OrbitTriageScreen({
    super.key,
    this.initialCards,
  });

  final List<TriageCard>? initialCards;

  @override
  State<OrbitTriageScreen> createState() => _OrbitTriageScreenState();
}

class _OrbitTriageScreenState extends State<OrbitTriageScreen> {
  late TriageBoard _board;

  @override
  void initState() {
    super.initState();
    _board = TriageBoard(
      queue: widget.initialCards ?? _generateSampleCards(),
    );
  }

  List<TriageCard> _generateSampleCards() {
    return [
      const TriageCard(
        id: '1',
        address: '123 Main Street, Austin, TX 78701',
        fviScore: 85,
      ),
      const TriageCard(
        id: '2',
        address: '456 Oak Avenue, Dallas, TX 75201',
        fviScore: 72,
      ),
      const TriageCard(
        id: '3',
        address: '789 Pine Road, Houston, TX 77001',
        fviScore: 91,
      ),
      const TriageCard(
        id: '4',
        address: '321 Elm Court, San Antonio, TX 78201',
        fviScore: 68,
      ),
      const TriageCard(
        id: '5',
        address: '654 Maple Lane, Fort Worth, TX 76101',
        fviScore: 79,
      ),
    ];
  }

  void _onFlick(TriageCard card, TriageZone zone) {
    setState(() {
      _board = _board.addToZone(card, zone);
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(zone.icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('Added to ${zone.label}'),
          ],
        ),
        backgroundColor: zone.color,
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onCardTap(TriageCard card) {
    // Show property details
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPropertySheet(card),
    );
  }

  void _onZoneTap(TriageZone zone) {
    final cards = _board.categorized[zone] ?? [];
    if (cards.isEmpty) return;

    // Show zone contents
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildZoneSheet(zone, cards),
    );
  }

  Widget _buildPropertySheet(TriageCard card) {
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
          Text(
            card.address,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getFviColor(card.fviScore),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'FVI ${card.fviScore.toStringAsFixed(0)}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to property details
                  },
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZoneSheet(TriageZone zone, List<TriageCard> cards) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(zone.icon, color: zone.color),
                    const SizedBox(width: 8),
                    Text(
                      '${zone.label} (${cards.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Cards list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: zone.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.home, color: zone.color),
                      ),
                      title: Text(
                        card.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('FVI ${card.fviScore.toStringAsFixed(0)}'),
                      onTap: () => _onCardTap(card),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getFviColor(double score) {
    if (score >= 80) return const Color(0xFF059669);
    if (score >= 60) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Triage'),
        actions: [
          if (_board.remainingCount == 0)
            TextButton(
              onPressed: () {
                // Navigate to summary
              },
              child: const Text('Done'),
            ),
        ],
      ),
      body: OrbitCanvas(
        board: _board,
        onFlick: _onFlick,
        onCardTap: _onCardTap,
        onZoneTap: _onZoneTap,
      ),
    );
  }
}
