/// A single lesson within a module.
class Lesson {
  final String id;
  final String title;
  final String body;
  /// Optional route for "Try It Now" (e.g. '/' or '/profile').
  final String? tryItPath;

  const Lesson({
    required this.id,
    required this.title,
    required this.body,
    this.tryItPath,
  });
}

/// A learning module containing multiple lessons.
class LearningModule {
  final String id;
  final String emoji;
  final String title;
  final List<Lesson> lessons;

  const LearningModule({
    required this.id,
    required this.emoji,
    required this.title,
    required this.lessons,
  });

  int get lessonCount => lessons.length;
}

/// Static catalog of all learning modules and lessons.
List<LearningModule> get learningModules => [
      const LearningModule(
        id: 'basics',
        emoji: '🎯',
        title: 'Basics',
        lessons: [
          Lesson(
            id: '1',
            title: 'What is Tax Lien / Tax Deed',
            body: 'Tax liens are claims against property for unpaid taxes. '
                'Investing in tax liens can lead to interest income or property acquisition.',
            tryItPath: '/',
          ),
          Lesson(
            id: '2',
            title: 'Swipes and navigation',
            body: 'Swipe right to like a property, left to pass. '
                'Tap the card to flip and see more details.',
            tryItPath: '/',
          ),
          Lesson(
            id: '3',
            title: 'Understanding the property card',
            body: 'Each card shows address, FVI score, lien cost, and foreclosure probability. '
                'Use filters to find the best matches.',
            tryItPath: '/',
          ),
        ],
      ),
      const LearningModule(
        id: 'foreclosure',
        emoji: '🔍',
        title: 'Foreclosure Hunting',
        lessons: [
          Lesson(
            id: '1',
            title: 'What is Foreclosure Probability',
            body: 'Foreclosure probability estimates the chance of acquiring the property. '
                '70%+ is a strong candidate for investment.',
            tryItPath: '/',
          ),
          Lesson(
            id: '2',
            title: 'Using filters',
            body: 'Use the filter to set min foreclosure score, price range, and location. '
                'Apply filters from the app bar on the swipe screen.',
            tryItPath: '/',
          ),
        ],
      ),
      const LearningModule(
        id: 'fvi',
        emoji: '📊',
        title: 'FVI Mastery',
        lessons: [
          Lesson(
            id: '1',
            title: 'What is Family Value Index',
            body: 'FVI combines financial score with your family\'s preferences. '
                'Tap the FVI badge on a card for details.',
            tryItPath: '/',
          ),
        ],
      ),
    ];
