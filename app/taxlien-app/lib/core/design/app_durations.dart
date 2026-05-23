/// Animation duration tokens
class AppDurations {
  AppDurations._();

  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Galaxy-specific
  static const Duration dimensionTransition = Duration(milliseconds: 400);
  static const Duration selectionPulse = Duration(milliseconds: 600);
  static const Duration lassoClose = Duration(milliseconds: 150);
  static const Duration xrayActivate = Duration(milliseconds: 300);
  static const Duration copilotSlide = Duration(milliseconds: 350);
}
