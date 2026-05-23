import 'package:flutter/material.dart';
import 'package:taxlien_swipe_app/l10n/app_localizations.dart';

/// Bottom banner for feature-discovery nudges. "Try it" / "Not now" actions.
class NudgeBanner extends StatelessWidget {
  final String nudgeId;
  final VoidCallback onTry;
  final VoidCallback onDismiss;

  const NudgeBanner({
    super.key,
    required this.nudgeId,
    required this.onTry,
    required this.onDismiss,
  });

  (String title, String body) _content(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (nudgeId) {
      case 'expert_mode':
        return (l10n.nudgeExpertModeTitle, l10n.nudgeExpertModeBody);
      case 'annotation':
        return (l10n.nudgeAnnotationTitle, l10n.nudgeAnnotationBody);
      case 'foreclosure_filter':
        return (l10n.nudgeForeclosureFilterTitle, l10n.nudgeForeclosureFilterBody);
      case 'family_board':
        return (l10n.nudgeFamilyBoardTitle, l10n.nudgeFamilyBoardBody);
      default:
        return (l10n.nudgeDefaultTitle, l10n.nudgeDefaultBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (title, body) = _content(context);
    final l10n = AppLocalizations.of(context)!;
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            border: Border(
              top: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline,
                      size: 22, color: theme.colorScheme.primary),
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
              const SizedBox(height: 4),
              Text(
                body,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onDismiss,
                    child: Text(l10n.nudgeNotNow),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: onTry,
                    child: Text(l10n.nudgeTryIt),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
