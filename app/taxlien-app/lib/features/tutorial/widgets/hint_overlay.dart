import 'package:flutter/material.dart';
import 'package:taxlien_swipe_app/l10n/app_localizations.dart';

enum HintType { tooltip, coachMark, banner, pulse }

/// Reusable overlay for contextual tooltips: bubble, optional arrow, dismiss actions.
/// Use with [TutorialService.shouldShowHint] and [TutorialService.markHintShown].
class HintOverlay extends StatelessWidget {
  final String hintId;
  final Widget child;
  final HintType type;
  final String title;
  final String body;
  final VoidCallback? onDismiss;
  final bool showDontShowAgain;
  final VoidCallback? onDontShowAgain;

  const HintOverlay({
    super.key,
    required this.hintId,
    required this.child,
    this.type = HintType.tooltip,
    required this.title,
    required this.body,
    this.onDismiss,
    this.showDontShowAgain = true,
    this.onDontShowAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (type == HintType.tooltip) _buildTooltipBubble(context),
      ],
    );
  }

  Widget _buildTooltipBubble(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: Material(
        color: Colors.transparent,
        child: _TooltipBubble(
          title: title,
          body: body,
          showDontShowAgain: showDontShowAgain,
          onDismiss: onDismiss,
          onDontShowAgain: onDontShowAgain ?? onDismiss,
        ),
      ),
    );
  }
}

/// Inline tooltip bubble (title + body + buttons). Renders below the anchor by default.
class _TooltipBubble extends StatelessWidget {
  final String title;
  final String body;
  final bool showDontShowAgain;
  final VoidCallback? onDismiss;
  final VoidCallback? onDontShowAgain;

  const _TooltipBubble({
    required this.title,
    required this.body,
    required this.showDontShowAgain,
    this.onDismiss,
    this.onDontShowAgain,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showDontShowAgain)
                TextButton(
                  onPressed: onDontShowAgain,
                  child: Text(
                    _dontShowAgainLabel(context),
                    style: theme.textTheme.labelMedium,
                  ),
                ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: onDismiss,
                child: Text(_gotItLabel(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _gotItLabel(BuildContext context) {
    return AppLocalizations.of(context)!.hintGotIt;
  }

  String _dontShowAgainLabel(BuildContext context) {
    return AppLocalizations.of(context)!.hintDontShowAgain;
  }
}
