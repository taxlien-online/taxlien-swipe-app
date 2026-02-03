import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/skip_button.dart';
import '../widgets/tutorial_card.dart';
import '../widgets/swipe_hint_overlay.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _currentStep = 0;
  final int _totalSteps = 2; // Beginner mode has 2 steps

  final List<TutorialStep> _steps = [
    TutorialStep(
      instruction: 'Свайпните ВПРАВО на интересное',
      requiredDirection: SwipeDirection.right,
      hintText: '👍',
      propertyTitle: 'Phoenix, AZ',
      propertySubtitle: 'Foreclosure: 85%  •  Lien: \$320',
    ),
    TutorialStep(
      instruction: 'Свайпните ВЛЕВО чтобы пропустить',
      requiredDirection: SwipeDirection.left,
      hintText: '👎',
      propertyTitle: 'Remote Location, AZ',
      propertySubtitle: 'Foreclosure: 20%  •  Lien: \$4,500',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          SkipButton(onSkip: () => _complete(context)),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Text(
                _currentStep == 0 ? 'Попробуйте!' : 'Отлично!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '(${_currentStep + 1}/$_totalSteps)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 16),

              // Instruction
              Text(
                step.instruction,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Tutorial card with hint overlay
              Stack(
                alignment: Alignment.center,
                children: [
                  TutorialCard(
                    title: step.propertyTitle,
                    subtitle: step.propertySubtitle,
                    onSwipe: (direction) => _handleSwipe(direction, step.requiredDirection),
                  ),
                  SwipeHintOverlay(
                    direction: step.requiredDirection,
                    hint: step.hintText,
                  ),
                ],
              ),

              const Spacer(),

              // Progress indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_totalSteps, (index) {
                  return Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index <= _currentStep
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSwipe(SwipeDirection direction, SwipeDirection required) {
    if (direction == required) {
      if (_currentStep < _totalSteps - 1) {
        setState(() {
          _currentStep++;
        });
      } else {
        _complete(context);
      }
    }
  }

  void _complete(BuildContext context) {
    context.push('/onboarding/ready');
  }
}

class TutorialStep {
  final String instruction;
  final SwipeDirection requiredDirection;
  final String hintText;
  final String propertyTitle;
  final String propertySubtitle;

  TutorialStep({
    required this.instruction,
    required this.requiredDirection,
    required this.hintText,
    required this.propertyTitle,
    required this.propertySubtitle,
  });
}
