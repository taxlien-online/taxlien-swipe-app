import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/skip_button.dart';
import '../widgets/county_tile.dart';
import '../models/state_info.dart';
import '../services/onboarding_service.dart';

class CountySelectionScreen extends StatefulWidget {
  final String stateCode;

  const CountySelectionScreen({super.key, required this.stateCode});

  @override
  State<CountySelectionScreen> createState() => _CountySelectionScreenState();
}

class _CountySelectionScreenState extends State<CountySelectionScreen> {
  final _service = OnboardingService();
  List<CountyInfo> _counties = [];
  final Set<String> _selectedCounties = {};
  bool _selectWholeState = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCounties();
  }

  Future<void> _loadCounties() async {
    final counties = await _service.getCounties(widget.stateCode);
    setState(() {
      _counties = counties;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stateCode),
        leading: BackButton(onPressed: () => context.pop()),
        actions: [
          SkipButton(onSkip: () => context.go('/')),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text(
                      'Какие counties интересуют?',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Whole state option
                    Card(
                      child: CheckboxListTile(
                        value: _selectWholeState,
                        onChanged: (value) {
                          setState(() {
                            _selectWholeState = value ?? true;
                            if (_selectWholeState) {
                              _selectedCounties.clear();
                            }
                          });
                        },
                        title: Text('Весь штат ${widget.stateCode}'),
                        subtitle: Text('${_counties.fold(0, (sum, c) => sum + c.lienCount)} liens'),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    Text(
                      'или конкретные counties:',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),

                    // Counties grid
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _counties.length,
                        itemBuilder: (context, index) {
                          final county = _counties[index];
                          return CountyTile(
                            county: county,
                            isSelected: _selectedCounties.contains(county.name),
                            onTap: () => _toggleCounty(county.name),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Continue button
                    FilledButton(
                      onPressed: () => _proceed(context),
                      child: const Text('Продолжить'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _toggleCounty(String name) {
    setState(() {
      if (_selectedCounties.contains(name)) {
        _selectedCounties.remove(name);
        if (_selectedCounties.isEmpty) {
          _selectWholeState = true;
        }
      } else {
        _selectedCounties.add(name);
        _selectWholeState = false;
      }
    });
  }

  void _proceed(BuildContext context) {
    // TODO: Save selection to provider
    context.push('/onboarding/tutorial');
  }
}
