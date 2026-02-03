import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/skip_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: SkipButton(
                  onSkip: () => _skipOnboarding(context),
                ),
              ),

              const Spacer(),

              // Logo
              const Icon(
                Icons.home_work_outlined,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'DEAL DETECTIVE',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Найдите foreclosure properties\nпо лучшей цене',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),

              const Spacer(),

              // Primary CTA
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.push('/onboarding/mode'),
                  icon: const Icon(Icons.search),
                  label: const Text('Начать настройку'),
                ),
              ),
              const SizedBox(height: 16),

              // Divider with "or"
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'или',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),

              // Secondary CTA
              TextButton(
                onPressed: () => _skipOnboarding(context),
                child: const Text('Я уже знаю как свайпать'),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _skipOnboarding(BuildContext context) {
    // TODO: Call onboarding provider skip
    context.go('/');
  }
}
