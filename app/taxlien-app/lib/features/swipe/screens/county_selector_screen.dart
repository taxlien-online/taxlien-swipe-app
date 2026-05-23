import 'package:flutter/material.dart';

import '../../../core/data/state_counties.dart';

/// Full list of counties per state from StateCounties (sdd-miw-gift).
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
      StateCounties.getCountiesForState(widget.state);

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
      body: _counties.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No county data for ${widget.state}. Full lists are in StateCounties.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          : ListView.builder(
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
