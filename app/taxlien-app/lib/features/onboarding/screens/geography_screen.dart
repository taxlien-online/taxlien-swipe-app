import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/skip_button.dart';
import '../widgets/state_chip.dart';
import '../models/state_info.dart';
import '../services/onboarding_service.dart';

class GeographyScreen extends StatefulWidget {
  const GeographyScreen({super.key});

  @override
  State<GeographyScreen> createState() => _GeographyScreenState();
}

class _GeographyScreenState extends State<GeographyScreen> {
  final _service = OnboardingService();
  List<StateInfo> _states = [];
  final Set<String> _selectedStates = {};
  bool _searchEverywhere = false;
  bool _isLoading = true;
  String? _detectedState;
  bool _isDetectingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadStates();
    _detectLocation();
  }

  Future<void> _loadStates() async {
    final states = await _service.getStates();
    setState(() {
      _states = states;
      _isLoading = false;
    });
  }

  Future<void> _detectLocation() async {
    setState(() => _isDetectingLocation = true);
    try {
      final location = await _service.detectUserLocation();
      if (location?.stateCode != null && mounted) {
        setState(() {
          _detectedState = location!.stateCode;
          // Auto-select detected state
          _selectedStates.add(location.stateCode!);
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isDetectingLocation = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      'Где искать properties?',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Auto-detected location
                    if (_isDetectingLocation)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('Определяем местоположение...'),
                          ],
                        ),
                      )
                    else if (_detectedState != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Определено: ${_getStateName(_detectedState!)}',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Popular states section
                    Text(
                      'Популярные штаты:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _states.take(4).map((state) {
                        return StateChip(
                          stateInfo: state,
                          isSelected: _selectedStates.contains(state.code),
                          onTap: () => _toggleState(state.code),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // All states list
                    Expanded(
                      child: ListView.builder(
                        itemCount: _states.length,
                        itemBuilder: (context, index) {
                          final state = _states[index];
                          final isSelected = _selectedStates.contains(state.code);
                          return CheckboxListTile(
                            value: isSelected && !_searchEverywhere,
                            onChanged: _searchEverywhere
                                ? null
                                : (value) => _toggleState(state.code),
                            title: Text(state.name),
                            subtitle: Text(state.auctionInfo),
                            secondary: Text(
                              state.code,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const Divider(),

                    // Search everywhere option
                    CheckboxListTile(
                      value: _searchEverywhere,
                      onChanged: (value) {
                        setState(() {
                          _searchEverywhere = value ?? false;
                          if (_searchEverywhere) {
                            _selectedStates.clear();
                          }
                        });
                      },
                      title: const Row(
                        children: [
                          Icon(Icons.public),
                          SizedBox(width: 12),
                          Text('Искать везде'),
                        ],
                      ),
                      subtitle: const Text('Система сама ранжирует по foreclosure'),
                    ),

                    const SizedBox(height: 16),

                    // Continue button
                    FilledButton(
                      onPressed: _canProceed ? () => _proceed(context) : null,
                      child: const Text('Продолжить'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _toggleState(String code) {
    setState(() {
      if (_selectedStates.contains(code)) {
        _selectedStates.remove(code);
      } else {
        _selectedStates.add(code);
      }
      _searchEverywhere = false;
    });
  }

  bool get _canProceed => _searchEverywhere || _selectedStates.isNotEmpty;

  void _proceed(BuildContext context) {
    // TODO: Save selection to provider
    if (_selectedStates.length == 1 && !_searchEverywhere) {
      // If single state selected, offer county selection
      context.push('/onboarding/county?state=${_selectedStates.first}');
    } else {
      context.push('/onboarding/tutorial');
    }
  }

  String _getStateName(String code) {
    final state = _states.where((s) => s.code == code).firstOrNull;
    return state?.name ?? code;
  }
}
