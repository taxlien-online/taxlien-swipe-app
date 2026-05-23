import 'package:flutter_test/flutter_test.dart';
import 'package:taxlien_swipe_app/core/models/expert_role.dart';
import 'package:taxlien_swipe_app/core/models/swipe_mode.dart';
import 'package:taxlien_swipe_app/features/onboarding/models/onboarding_state.dart';

void main() {
  group('OnboardingState', () {
    group('initial factory', () {
      test('creates state with default values', () {
        final state = OnboardingState.initial();

        expect(state.currentStep, 0);
        expect(state.selectedMode, isNull);
        expect(state.selectedRole, isNull);
        expect(state.selectedStates, isEmpty);
        expect(state.selectedCounties, isEmpty);
        expect(state.tutorialProgress, 0);
        expect(state.isLoading, isFalse);
        expect(state.error, isNull);
      });
    });

    group('canProceed', () {
      test('welcome step always can proceed', () {
        final state = OnboardingState.initial();

        expect(state.canProceed, isTrue);
      });

      test('mode selection requires mode selected', () {
        var state = const OnboardingState(currentStep: 1);
        expect(state.canProceed, isFalse);

        state = state.copyWith(selectedMode: SwipeMode.beginner);
        expect(state.canProceed, isTrue);
      });

      test('role selection requires role for expert mode', () {
        var state = const OnboardingState(
          currentStep: 2,
          selectedMode: SwipeMode.advanced,
        );
        expect(state.canProceed, isFalse);

        state = state.copyWith(selectedRole: ExpertRole.builder);
        expect(state.canProceed, isTrue);
      });

      test('role selection skipped for beginner mode', () {
        final state = const OnboardingState(
          currentStep: 2,
          selectedMode: SwipeMode.beginner,
        );

        expect(state.canProceed, isTrue);
      });

      test('geography step always can proceed', () {
        final state = const OnboardingState(currentStep: 3);

        expect(state.canProceed, isTrue);
      });

      test('tutorial requires completion', () {
        var state = const OnboardingState(
          currentStep: 5,
          selectedMode: SwipeMode.beginner,
          tutorialProgress: 0,
        );
        expect(state.canProceed, isFalse);

        state = state.copyWith(tutorialProgress: 2);
        expect(state.canProceed, isTrue);
      });
    });

    group('requiredTutorialSteps', () {
      test('returns 2 for beginner mode', () {
        final state = const OnboardingState(
          selectedMode: SwipeMode.beginner,
        );

        expect(state.requiredTutorialSteps, 2);
      });

      test('returns 3 for advanced mode', () {
        final state = const OnboardingState(
          selectedMode: SwipeMode.advanced,
        );

        expect(state.requiredTutorialSteps, 3);
      });

      test('returns 2 for null mode (default)', () {
        final state = OnboardingState.initial();

        expect(state.requiredTutorialSteps, 2);
      });
    });

    group('isExpertMode', () {
      test('returns false for beginner mode', () {
        final state = const OnboardingState(
          selectedMode: SwipeMode.beginner,
        );

        expect(state.isExpertMode, isFalse);
      });

      test('returns true for advanced mode', () {
        final state = const OnboardingState(
          selectedMode: SwipeMode.advanced,
        );

        expect(state.isExpertMode, isTrue);
      });

      test('returns false for null mode', () {
        final state = OnboardingState.initial();

        expect(state.isExpertMode, isFalse);
      });
    });

    group('copyWith', () {
      test('creates new instance with updated values', () {
        final state = OnboardingState.initial();
        final updated = state.copyWith(
          currentStep: 2,
          selectedMode: SwipeMode.advanced,
          selectedRole: ExpertRole.builder,
          selectedStates: ['AZ', 'FL'],
          selectedCounties: ['Maricopa'],
          tutorialProgress: 1,
          isLoading: true,
          error: 'test error',
        );

        expect(updated.currentStep, 2);
        expect(updated.selectedMode, SwipeMode.advanced);
        expect(updated.selectedRole, ExpertRole.builder);
        expect(updated.selectedStates, ['AZ', 'FL']);
        expect(updated.selectedCounties, ['Maricopa']);
        expect(updated.tutorialProgress, 1);
        expect(updated.isLoading, isTrue);
        expect(updated.error, 'test error');
      });

      test('preserves unchanged values', () {
        final state = const OnboardingState(
          currentStep: 3,
          selectedMode: SwipeMode.beginner,
          selectedStates: ['TX'],
        );
        final updated = state.copyWith(tutorialProgress: 1);

        expect(updated.currentStep, 3);
        expect(updated.selectedMode, SwipeMode.beginner);
        expect(updated.selectedStates, ['TX']);
        expect(updated.tutorialProgress, 1);
      });

      test('clears error when not provided', () {
        final state = const OnboardingState(error: 'test error');
        final updated = state.copyWith(currentStep: 1);

        expect(updated.error, isNull);
      });
    });
  });
}
