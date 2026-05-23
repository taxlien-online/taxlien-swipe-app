import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxlien_swipe_app/l10n/app_localizations.dart';
import '../services/tutorial_service.dart';

/// Wraps [child] and shows a tooltip below it on first view if [TutorialService.shouldShowHint] is true.
class HintTrigger extends StatefulWidget {
  final String hintId;
  final String title;
  final String body;
  final Widget child;
  final bool showDontShowAgain;

  const HintTrigger({
    super.key,
    required this.hintId,
    required this.title,
    required this.body,
    required this.child,
    this.showDontShowAgain = true,
  });

  @override
  State<HintTrigger> createState() => _HintTriggerState();
}

class _HintTriggerState extends State<HintTrigger> {
  bool _showHint = false;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkHint());
  }

  Future<void> _checkHint() async {
    if (!mounted || _checked) return;
    final service = context.read<TutorialService>();
    final shouldShow = await service.shouldShowHint(widget.hintId);
    _checked = true;
    if (mounted && shouldShow) setState(() => _showHint = true);
  }

  Future<void> _dismiss({bool dontShowAgain = false}) async {
    if (!mounted) return;
    final service = context.read<TutorialService>();
    await service.markHintShown(widget.hintId, dontShowAgain: dontShowAgain);
    if (mounted) setState(() => _showHint = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_showHint) return widget.child;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.child,
        const SizedBox(height: 8),
        Container(
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
                      widget.title,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.showDontShowAgain)
                    TextButton(
                      onPressed: () => _dismiss(dontShowAgain: true),
                      child: Text(l10n.hintDontShowAgain, style: theme.textTheme.labelMedium),
                    ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => _dismiss(),
                    child: Text(l10n.hintGotIt),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
