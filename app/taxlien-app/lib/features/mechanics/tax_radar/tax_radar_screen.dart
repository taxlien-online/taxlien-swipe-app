import 'package:flutter/material.dart';

import 'models/counterparty.dart';
import 'widgets/activity_feed.dart';
import 'widgets/radar_canvas.dart';

/// A full-screen radar view showing counterparties around user's portfolio.
class TaxRadarScreen extends StatefulWidget {
  const TaxRadarScreen({
    super.key,
    this.initialState,
  });

  final TaxRadarState? initialState;

  @override
  State<TaxRadarScreen> createState() => _TaxRadarScreenState();
}

class _TaxRadarScreenState extends State<TaxRadarScreen> {
  late TaxRadarState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState ?? _generateSampleState();
  }

  TaxRadarState _generateSampleState() {
    final now = DateTime.now();

    return TaxRadarState(
      counterparties: [
        Counterparty(
          id: '1',
          name: 'Harris County Tax Office',
          type: CounterpartyType.taxAuthority,
          angle: 45,
          distance: 0.3,
          health: RelationshipHealth.good,
          interactionCount: 25,
          lastActivity: now.subtract(const Duration(days: 2)),
          recentActivities: [
            ActivityItem(
              id: 'a1',
              description: 'Tax certificate issued for 123 Main St',
              timestamp: now.subtract(const Duration(days: 2)),
              icon: Icons.receipt,
            ),
          ],
        ),
        Counterparty(
          id: '2',
          name: 'John Smith (Investor)',
          type: CounterpartyType.bidder,
          angle: 120,
          distance: 0.6,
          health: RelationshipHealth.warning,
          interactionCount: 8,
          lastActivity: now.subtract(const Duration(days: 7)),
        ),
        Counterparty(
          id: '3',
          name: 'ABC Title Company',
          type: CounterpartyType.titleCompany,
          angle: 200,
          distance: 0.4,
          health: RelationshipHealth.good,
          interactionCount: 15,
          lastActivity: now.subtract(const Duration(days: 1)),
        ),
        Counterparty(
          id: '4',
          name: 'First National Bank',
          type: CounterpartyType.lender,
          angle: 280,
          distance: 0.7,
          health: RelationshipHealth.critical,
          interactionCount: 3,
          lastActivity: now.subtract(const Duration(days: 30)),
        ),
        Counterparty(
          id: '5',
          name: 'Maria Garcia (Owner)',
          type: CounterpartyType.owner,
          angle: 330,
          distance: 0.5,
          health: RelationshipHealth.unknown,
          interactionCount: 1,
        ),
      ],
    );
  }

  void _onCounterpartyTap(Counterparty counterparty) {
    setState(() {
      _state = _state.copyWith(
        selectedCounterpartyId:
            _state.selectedCounterpartyId == counterparty.id
                ? null
                : counterparty.id,
      );
    });
  }

  void _startScan() {
    setState(() {
      _state = _state.copyWith(isScanning: true);
    });

    // Stop after one rotation
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _state = _state.copyWith(isScanning: false);
        });
      }
    });
  }

  void _toggleFilter(CounterpartyType type) {
    setState(() {
      final newFilters = Set<CounterpartyType>.from(_state.filterTypes);
      if (newFilters.contains(type)) {
        newFilters.remove(type);
      } else {
        newFilters.add(type);
      }
      _state = _state.copyWith(filterTypes: newFilters);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Radar'),
        actions: [
          IconButton(
            icon: Icon(
              _state.isScanning ? Icons.stop : Icons.radar,
              color: _state.isScanning ? theme.colorScheme.error : null,
            ),
            onPressed: _startScan,
            tooltip: _state.isScanning ? 'Stop scan' : 'Scan',
          ),
        ],
      ),
      body: Column(
        children: [
          // Type filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: CounterpartyType.values.map((type) {
                final isSelected = _state.filterTypes.isEmpty ||
                    _state.filterTypes.contains(type);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(type.label),
                    avatar: Icon(type.icon, size: 16),
                    selected: isSelected,
                    onSelected: (_) => _toggleFilter(type),
                    selectedColor: type.color.withValues(alpha: 0.2),
                  ),
                );
              }).toList(),
            ),
          ),

          // Radar canvas
          Expanded(
            flex: 3,
            child: RadarCanvas(
              state: _state,
              onCounterpartyTap: _onCounterpartyTap,
            ),
          ),

          // Activity feed (if counterparty selected)
          if (_state.selectedCounterparty != null &&
              _state.selectedCounterparty!.recentActivities.isNotEmpty)
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            _state.selectedCounterparty!.type.icon,
                            color: _state.selectedCounterparty!.type.color,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _state.selectedCounterparty!.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _state =
                                    _state.copyWith(selectedCounterpartyId: null);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ActivityFeed(
                        activities:
                            _state.selectedCounterparty!.recentActivities,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
