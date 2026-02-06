import 'package:flutter/material.dart';

/// Static map of state -> counties for filter drill-down.
const Map<String, List<String>> _stateCounties = {
  'AZ': ['Maricopa', 'Pinal', 'Pima', 'Yavapai', 'Mohave', 'Yuma', 'Coconino'],
  'FL': ['Miami-Dade', 'Broward', 'Palm Beach', 'Hillsborough', 'Pinellas', 'Orange', 'Duval'],
  'TX': ['Harris', 'Dallas', 'Tarrant', 'Bexar', 'Travis', 'Collin', 'Denton'],
  'NV': ['Clark', 'Washoe', 'Carson City', 'Elko', 'Nye'],
  'CO': ['Denver', 'El Paso', 'Arapahoe', 'Jefferson', 'Adams', 'Boulder'],
};

class CountySelectorScreen extends StatefulWidget {
  final List<String> selectedCounties;
  final String state;

  const CountySelectorScreen({
    super.key,
    required this.selectedCounties,
    required this.state,
  });

  @override
  State<CountySelectorScreen> createState() => _CountySelectorScreenState();
}

class _CountySelectorScreenState extends State<CountySelectorScreen> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedCounties);
  }

  List<String> get _counties =>
      _stateCounties[widget.state] ?? ['Unknown'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counties in ${widget.state}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_selected),
            child: const Text('Done'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _counties.length,
        itemBuilder: (context, index) {
          final county = _counties[index];
          final isSelected = _selected.contains(county);
          return CheckboxListTile(
            title: Text(county),
            value: isSelected,
            onChanged: (v) {
              setState(() {
                if (v == true) {
                  _selected.add(county);
                } else {
                  _selected.remove(county);
                }
              });
            },
          );
        },
      ),
    );
  }
}
