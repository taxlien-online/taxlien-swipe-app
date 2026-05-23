import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxlien_swipe_app/core/models/expert_role.dart';
import 'package:taxlien_swipe_app/core/models/swipe_mode.dart';
import 'package:taxlien_swipe_app/core/models/user_preferences.dart';
import 'package:taxlien_swipe_app/features/onboarding/services/onboarding_service.dart';

void main() {
  group('OnboardingService', () {
    late OnboardingService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = OnboardingService();
    });

    group('shouldShowOnboarding', () {
      test('returns true when onboarding not completed', () async {
        SharedPreferences.setMockInitialValues({});

        final result = await service.shouldShowOnboarding();

        expect(result, isTrue);
      });

      test('returns false when onboarding completed', () async {
        SharedPreferences.setMockInitialValues({
          'onboarding_completed': true,
        });

        final result = await service.shouldShowOnboarding();

        expect(result, isFalse);
      });
    });

    group('completeOnboarding', () {
      test('saves all preferences correctly', () async {
        SharedPreferences.setMockInitialValues({});

        final preferences = UserPreferences(
          userId: 'test-user',
          userName: 'Test User',
          swipeMode: SwipeMode.advanced,
          role: ExpertRole.builder,
          states: ['AZ', 'FL'],
          counties: ['Maricopa', 'Miami-Dade'],
          onboardingCompleted: true,
        );

        await service.completeOnboarding(preferences);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('onboarding_completed'), isTrue);
        expect(prefs.getString('swipe_mode'), 'advanced');
        expect(prefs.getString('role'), 'builder');
        expect(prefs.getStringList('states'), ['AZ', 'FL']);
        expect(prefs.getStringList('counties'), ['Maricopa', 'Miami-Dade']);
      });
    });

    group('skipOnboarding', () {
      test('saves default preferences', () async {
        SharedPreferences.setMockInitialValues({});

        await service.skipOnboarding();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('onboarding_completed'), isTrue);
        expect(prefs.getString('swipe_mode'), 'beginner');
        expect(prefs.getString('role'), 'guest');
        expect(prefs.getStringList('states'), isEmpty);
        expect(prefs.getStringList('counties'), isEmpty);
      });
    });

    group('loadPreferences', () {
      test('returns null when onboarding not completed', () async {
        SharedPreferences.setMockInitialValues({});

        final result = await service.loadPreferences();

        expect(result, isNull);
      });

      test('returns saved preferences when completed', () async {
        SharedPreferences.setMockInitialValues({
          'onboarding_completed': true,
          'swipe_mode': 'advanced',
          'role': 'builder',
          'states': ['AZ', 'TX'],
          'counties': ['Maricopa'],
        });

        final result = await service.loadPreferences();

        expect(result, isNotNull);
        expect(result!.swipeMode, SwipeMode.advanced);
        expect(result.role, ExpertRole.builder);
        expect(result.states, ['AZ', 'TX']);
        expect(result.counties, ['Maricopa']);
      });

      test('returns defaults for invalid stored values', () async {
        SharedPreferences.setMockInitialValues({
          'onboarding_completed': true,
          'swipe_mode': 'invalid_mode',
          'role': 'invalid_role',
        });

        final result = await service.loadPreferences();

        expect(result, isNotNull);
        expect(result!.swipeMode, SwipeMode.beginner);
        expect(result.role, ExpertRole.guest);
      });
    });

    group('getStates', () {
      test('returns list of states (mock data)', () async {
        final states = await service.getStates();

        expect(states, isNotEmpty);
        expect(states.any((s) => s.code == 'AZ'), isTrue);
        expect(states.any((s) => s.code == 'FL'), isTrue);
        expect(states.any((s) => s.code == 'TX'), isTrue);
      });

      test('states have required properties', () async {
        final states = await service.getStates();

        for (final state in states) {
          expect(state.code, isNotEmpty);
          expect(state.name, isNotEmpty);
          expect(state.type, isNotEmpty);
          expect(state.totalLiens, greaterThan(0));
        }
      });
    });

    group('getCounties', () {
      test('returns counties for valid state', () async {
        final counties = await service.getCounties('AZ');

        expect(counties, isNotEmpty);
        expect(counties.any((c) => c.name == 'Maricopa'), isTrue);
        expect(counties.any((c) => c.name == 'Pima'), isTrue);
      });

      test('returns empty list for state without counties', () async {
        final counties = await service.getCounties('WY');

        expect(counties, isEmpty);
      });

      test('counties have required properties', () async {
        final counties = await service.getCounties('FL');

        for (final county in counties) {
          expect(county.name, isNotEmpty);
          expect(county.stateCode, 'FL');
          expect(county.lienCount, greaterThanOrEqualTo(0));
        }
      });
    });

    group('getStats', () {
      test('returns stats for search everywhere', () async {
        final stats = await service.getStats([], []);

        expect(stats.totalProperties, greaterThan(0));
        expect(stats.foreclosureCandidates, greaterThan(0));
      });

      test('returns stats for selected states', () async {
        final stats = await service.getStats(['AZ', 'FL'], []);

        expect(stats.totalProperties, greaterThan(0));
        expect(stats.foreclosureCandidates, greaterThan(0));
        // Combined should be less than "everywhere"
        final everywhereStats = await service.getStats([], []);
        expect(stats.totalProperties, lessThan(everywhereStats.totalProperties));
      });

      test('returns stats for selected counties', () async {
        final stats = await service.getStats(['AZ'], ['Maricopa']);

        expect(stats.totalProperties, greaterThan(0));
        expect(stats.foreclosureCandidates, greaterThan(0));
        // County should be less than full state
        final stateStats = await service.getStats(['AZ'], []);
        expect(stats.totalProperties, lessThan(stateStats.totalProperties));
      });
    });

    group('getNearbyStates', () {
      test('returns states list', () async {
        // Phoenix, AZ coordinates
        final states = await service.getNearbyStates(33.4484, -112.0740);

        expect(states, isNotEmpty);
        expect(states.length, lessThanOrEqualTo(3));
      });
    });
  });
}
