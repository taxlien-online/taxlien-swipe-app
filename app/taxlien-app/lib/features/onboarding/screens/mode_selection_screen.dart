import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/models/swipe_mode.dart';
import '../../../services/analytics_service.dart';
import '../../analytics/facebook_app_events_service.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/skip_button.dart';
import '../widgets/mode_card.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        actions: [
          SkipButton(onSkip: () => _skip(context)),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                'Как хотите искать?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Beginner mode card
              Expanded(
                child: ModeCard(
                  mode: SwipeMode.beginner,
                  title: 'ПРОСТОЙ',
                  description: 'Свайп влево/вправо как в Tinder\nБыстро отфильтровать foreclosures',
                  icon: Icons.swipe,
                  onTap: () => _selectMode(context, SwipeMode.beginner),
                ),
              ),
              const SizedBox(height: 16),

              // Expert mode card
              Expanded(
                child: ModeCard(
                  mode: SwipeMode.advanced,
                  title: 'ЭКСПЕРТ',
                  description: '4 направления + разметка фото\nГлубокий анализ для инвесторов',
                  icon: Icons.explore,
                  onTap: () => _selectMode(context, SwipeMode.advanced),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectMode(BuildContext context, SwipeMode mode) {
    context.read<OnboardingProvider>().selectMode(mode);
    context.read<AnalyticsService>().logEvent('mode_selected', parameters: {'mode': mode.name});
    context.read<FacebookAppEventsService>().logModeSwitch(mode.name);
    if (mode == SwipeMode.advanced) {
      context.push('/onboarding/role');
    } else {
      context.push('/onboarding/geo');
    }
  }

  void _skip(BuildContext context) async {
    context.read<AnalyticsService>().logEvent('onboarding_skipped');
    await context.read<OnboardingProvider>().skipOnboarding();
    if (context.mounted) context.go('/');
  }
}
