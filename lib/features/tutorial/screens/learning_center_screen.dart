import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/lesson.dart';
import '../services/tutorial_service.dart';

class LearningCenterScreen extends StatelessWidget {
  const LearningCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Center'),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: context.read<TutorialService>().getState().then((s) => s.lessonProgress),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final progress = snapshot.data!;
          final totalLessons = learningModules.fold<int>(0, (s, m) => s + m.lessonCount);
          final completedLessons = learningModules.fold<int>(
            0,
            (s, m) => s + ((progress[m.id] ?? -1) + 1).clamp(0, m.lessonCount),
          );
          final percent = totalLessons > 0 ? (completedLessons / totalLessons * 100).round() : 0;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your progress',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: totalLessons > 0 ? completedLessons / totalLessons : 0,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$completedLessons of $totalLessons lessons ($percent%)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Modules',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ...learningModules.map((module) {
                final completed = (progress[module.id] ?? -1) + 1;
                final total = module.lessonCount;
                final isComplete = completed >= total;
                final nextIndex = completed < total ? completed : 0;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(module.emoji, style: const TextStyle(fontSize: 28)),
                    title: Text(module.title),
                    subtitle: Text(
                      isComplete ? '$total/$total complete' : '$completed/$total lessons',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isComplete)
                          Icon(Icons.check_circle, color: theme.colorScheme.primary)
                        else
                          FilledButton(
                            onPressed: () => context.push(
                              '/learning/${module.id}/$nextIndex',
                            ),
                            child: Text(nextIndex == 0 ? 'Start' : 'Continue'),
                          ),
                      ],
                    ),
                    onTap: () => context.push('/learning/${module.id}/$nextIndex'),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
