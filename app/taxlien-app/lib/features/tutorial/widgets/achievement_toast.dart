import 'dart:async';
import 'package:flutter/material.dart';
import '../models/achievement.dart';

/// Toast overlay shown when an achievement is unlocked.
class AchievementToast extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback onDismiss;

  const AchievementToast({
    super.key,
    required this.achievement,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    achievement.badgeEmoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Achievement Unlocked!',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          achievement.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          achievement.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onDismiss,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Listens to [AchievementService.onAchievementUnlocked] and shows a toast overlay.
class AchievementToastListener extends StatefulWidget {
  final Stream<Achievement> unlockStream;
  final Widget child;

  const AchievementToastListener({
    super.key,
    required this.unlockStream,
    required this.child,
  });

  @override
  State<AchievementToastListener> createState() => _AchievementToastListenerState();
}

class _AchievementToastListenerState extends State<AchievementToastListener> {
  StreamSubscription<Achievement>? _subscription;
  OverlayEntry? _currentEntry;

  @override
  void initState() {
    super.initState();
    _subscription = widget.unlockStream.listen(_showToast);
  }

  void _showToast(Achievement achievement) {
    if (!mounted) return;
    _currentEntry?.remove();
    _currentEntry = null;
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: AchievementToast(
          achievement: achievement,
          onDismiss: () {
            entry.remove();
            if (_currentEntry == entry) _currentEntry = null;
          },
        ),
      ),
    );
    _currentEntry = entry;
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 4), () {
      if (entry.mounted) {
        entry.remove();
        if (_currentEntry == entry) _currentEntry = null;
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _currentEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
