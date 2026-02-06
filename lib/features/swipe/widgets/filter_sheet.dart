import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/filter_options.dart';
import '../providers/filter_provider.dart';
import '../providers/swipe_provider.dart';
import '../screens/county_selector_screen.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late FilterOptions _temp;
  bool _loadingCount = false;

  @override
  void initState() {
    super.initState();
    _temp = context.read<FilterProvider>().filter;
  }

  Future<void> _apply() async {
    context.read<FilterProvider>().setFilter(_temp);
    await context.read<FilterProvider>().saveToPreferences();
    if (mounted) {
      context.read<SwipeProvider>().loadProperties();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    _buildSectionHeader(context, 'Location'),
                    _buildStateChips(context),
                    ListTile(
                      title: const Text('Counties'),
                      trailing: Text(
                        _temp.counties.isEmpty ? 'All' : _temp.counties.join(', '),
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                      onTap: () async {
                        final selected = await Navigator.of(context).push<List<String>>(
                          MaterialPageRoute(
                            builder: (context) => CountySelectorScreen(
                              selectedCounties: _temp.counties,
                              state: _temp.states.isNotEmpty ? _temp.states.first : 'AZ',
                            ),
                          ),
                        );
                        if (selected != null) setState(() => _temp = _temp.copyWith(counties: selected));
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSectionHeader(context, 'Financial'),
                    _buildSlider(
                      label: 'Max price',
                      value: _temp.maxPrice,
                      min: 1000,
                      max: 500000,
                      divisions: 50,
                      format: (v) => '\$${(v / 1000).toStringAsFixed(0)}k',
                      onChanged: (v) => setState(() => _temp = _temp.copyWith(maxPrice: v)),
                    ),
                    _buildSlider(
                      label: 'Min interest rate %',
                      value: _temp.minInterestRate * 100,
                      min: 0,
                      max: 25,
                      divisions: 25,
                      format: (v) => '${v.toStringAsFixed(0)}%',
                      onChanged: (v) => setState(() => _temp = _temp.copyWith(minInterestRate: v / 100)),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionHeader(context, 'Property type'),
                    Wrap(
                      spacing: 8,
                      children: ['Residential', 'Vacant Land', 'Commercial'].map((t) {
                        final selected = _temp.propertyTypes.contains(t);
                        return FilterChip(
                          label: Text(t),
                          selected: selected,
                          onSelected: (v) {
                            setState(() {
                              final list = List<String>.from(_temp.propertyTypes);
                              if (v) list.add(t); else list.remove(t);
                              if (list.isEmpty) {
                                  list.add('Residential');
                                }
                                _temp = _temp.copyWith(propertyTypes: list);
                              });
                            },
                          );
                        }).toList(),
                    ),
                    const SizedBox(height: 16),
                    ExpansionTile(
                      title: const Text('Expert scores'),
                      children: [
                        _buildSlider(
                          label: 'Min foreclosure score',
                          value: _temp.minForeclosureScore,
                          min: 0,
                          max: 1,
                          divisions: 10,
                          format: (v) => v.toStringAsFixed(1),
                          onChanged: (v) => setState(() => _temp = _temp.copyWith(minForeclosureScore: v)),
                        ),
                        _buildSlider(
                          label: 'Min x1000 score',
                          value: _temp.minX1000Score,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          format: (v) => v.toStringAsFixed(0),
                          onChanged: (v) => setState(() => _temp = _temp.copyWith(minX1000Score: v)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _loadingCount ? null : _apply,
                    child: _loadingCount
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Apply filters'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStateChips(BuildContext context) {
    const states = ['AZ', 'FL', 'TX', 'NV', 'CO'];
    return Wrap(
      spacing: 8,
      children: [
        ...states.map((state) {
          final selected = _temp.states.contains(state);
          return FilterChip(
            label: Text(state),
            selected: selected,
            onSelected: (v) {
              setState(() {
                final list = List<String>.from(_temp.states);
                if (v) {
                  list.add(state);
                } else {
                  list.remove(state);
                }
                _temp = _temp.copyWith(states: list);
                if (list.isEmpty && _temp.counties.isNotEmpty) {
                  _temp = _temp.copyWith(counties: const []);
                }
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String Function(double) format,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value.clamp(min, max),
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: onChanged,
                ),
              ),
              SizedBox(
                width: 56,
                child: Text(format(value)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
