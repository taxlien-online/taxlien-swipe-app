import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/lesson.dart';
import '../services/tutorial_service.dart';
import '../services/achievement_service.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({
    super.key,
    required this.moduleId,
    required this.lessonIndex,
  });

  final String moduleId;
  final int lessonIndex;

  LearningModule? get _module {
    try {
      return learningModules.firstWhere((m) => m.id == moduleId);
    } catch (_) {
      return null;
    }
  }

  Lesson? get _lesson {
    final m = _module;
    if (m == null || lessonIndex < 0 || lessonIndex >= m.lessons.length) return null;
    return m.lessons[lessonIndex];
  }

  @override
  Widget build(BuildContext context) {
    final module = _module;
    final lesson = _lesson;
    if (module == null || lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lesson')),
        body: const Center(child: Text('Lesson not found')),
      );
    }

    final theme = Theme.of(context);
    final isLast = lessonIndex >= module.lessonCount - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('${module.emoji} ${module.title} · ${lessonIndex + 1}/${module.lessonCount}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              lesson.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              lesson.body,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                ...List.generate(module.lessonCount, (i) {
                  final done = i <= lessonIndex;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),
            if (lesson.tryItPath != null)
              OutlinedButton.icon(
                onPressed: () {
                  context.go(lesson.tryItPath!);
                },
                icon: const Icon(Icons.open_in_new, size: 20),
                label: const Text('Try It Now'),
              ),
            if (lesson.tryItPath != null) const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _markCompleteAndNext(context, module, lessonIndex),
              icon: const Icon(Icons.check, size: 20),
              label: Text(isLast ? 'Mark complete' : 'Mark complete & Next'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markCompleteAndNext(
    BuildContext context,
    LearningModule module,
    int index,
  ) async {
    final tutorial = context.read<TutorialService>();
    final achievement = context.read<AchievementService>();
    final router = GoRouter.of(context);
    await tutorial.setLessonCompleted(moduleId, index);
    if (!context.mounted) return;
    final stats = await tutorial.getStats();
    await achievement.checkAndUnlock(stats);
    if (!context.mounted) return;
    if (index < module.lessonCount - 1) {
      router.go('/learning/$moduleId/${index + 1}');
    } else {
      router.pop();
    }
  }
}
