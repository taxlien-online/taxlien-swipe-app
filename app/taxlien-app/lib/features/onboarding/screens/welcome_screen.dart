import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taxlien_swipe_app/l10n/app_localizations.dart';
import '../../../services/analytics_service.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/skip_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsService>().logEvent('onboarding_start');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: SkipButton(
                  onSkip: () => _skipOnboarding(context),
                ),
              ),
              const SizedBox(height: 32),
              const Icon(
                Icons.home_work_outlined,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.dealDetective,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.push('/onboarding/mode'),
                  icon: const Icon(Icons.search),
                  label: Text(l10n.startSetup),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.orDivider,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _skipOnboarding(context),
                child: Text(l10n.skipKnowSwipe),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _skipOnboarding(BuildContext context) async {
    context.read<AnalyticsService>().logEvent('onboarding_skipped');
    await context.read<OnboardingProvider>().skipOnboarding();
    if (context.mounted) context.go('/');
  }
}
