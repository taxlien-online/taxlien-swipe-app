import '../../../core/models/expert_role.dart';
import '../../../core/models/swipe_mode.dart';

/// State for onboarding flow
class OnboardingState {
  final int currentStep;
  final SwipeMode? selectedMode;
  final ExpertRole? selectedRole;
  final List<String> selectedStates;
  final List<String> selectedCounties;
  final int tutorialProgress;
  final bool isLoading;
  final String? error;

  const OnboardingState({
    this.currentStep = 0,
    this.selectedMode,
    this.selectedRole,
    this.selectedStates = const [],
    this.selectedCounties = const [],
    this.tutorialProgress = 0,
    this.isLoading = false,
    this.error,
  });

  /// Initial state
  factory OnboardingState.initial() => const OnboardingState();

  /// Check if can proceed to next step
  bool get canProceed {
    switch (currentStep) {
      case 0: // Welcome - always can proceed
        return true;
      case 1: // Mode selection
        return selectedMode != null;
      case 2: // Role selection (expert only)
        return selectedRole != null || selectedMode == SwipeMode.beginner;
      case 3: // Geography
        return true; // Can search everywhere
      case 4: // County (optional)
        return true;
      case 5: // Tutorial
        return tutorialProgress >= requiredTutorialSteps;
      default:
        return true;
    }
  }

  /// Required tutorial steps based on mode
  int get requiredTutorialSteps {
    return selectedMode == SwipeMode.advanced ? 3 : 2;
  }

  /// Check if expert mode
  bool get isExpertMode => selectedMode == SwipeMode.advanced;

  OnboardingState copyWith({
    int? currentStep,
    SwipeMode? selectedMode,
    ExpertRole? selectedRole,
    List<String>? selectedStates,
    List<String>? selectedCounties,
    int? tutorialProgress,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      selectedMode: selectedMode ?? this.selectedMode,
      selectedRole: selectedRole ?? this.selectedRole,
      selectedStates: selectedStates ?? this.selectedStates,
      selectedCounties: selectedCounties ?? this.selectedCounties,
      tutorialProgress: tutorialProgress ?? this.tutorialProgress,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
