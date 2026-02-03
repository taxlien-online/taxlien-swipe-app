import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReadyScreen extends StatelessWidget {
  const ReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Get actual stats from provider
    const region = 'Arizona';
    const counties = 'Maricopa, Pinal';
    const totalProperties = 15650;
    const foreclosures = 2340;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 48,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Готово к поиску!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 32),

              // Summary card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        context,
                        icon: Icons.location_on,
                        label: 'Регион',
                        value: region,
                      ),
                      const Divider(height: 24),
                      _buildSummaryRow(
                        context,
                        icon: Icons.map,
                        label: 'Counties',
                        value: counties,
                      ),
                      const Divider(height: 24),
                      _buildSummaryRow(
                        context,
                        icon: Icons.home,
                        label: 'Доступно',
                        value: '$totalProperties properties',
                      ),
                      const Divider(height: 24),
                      _buildSummaryRow(
                        context,
                        icon: Icons.local_fire_department,
                        label: 'Foreclosures',
                        value: '$foreclosures',
                        valueColor: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Tip
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    'Тапните на карточку чтобы увидеть детали',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),

              const Spacer(),

              // Start button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _startSearch(context),
                  icon: const Icon(Icons.search),
                  label: const Text('Начать поиск'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
        ),
      ],
    );
  }

  void _startSearch(BuildContext context) {
    // TODO: Complete onboarding via provider
    context.go('/');
  }
}
