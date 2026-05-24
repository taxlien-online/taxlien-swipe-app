import 'package:flutter/material.dart';

/// Display for live transcription with typing cursor.
class TranscriptionDisplay extends StatefulWidget {
  const TranscriptionDisplay({
    super.key,
    required this.text,
    this.isListening = false,
    this.highlightedEntities = const {},
    this.maxLines = 3,
    this.style,
  });

  final String text;
  final bool isListening;
  final Map<String, Color> highlightedEntities;
  final int maxLines;
  final TextStyle? style;

  @override
  State<TranscriptionDisplay> createState() => _TranscriptionDisplayState();
}

class _TranscriptionDisplayState extends State<TranscriptionDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = widget.style ??
        theme.textTheme.bodyLarge?.copyWith(
          height: 1.5,
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Microphone indicator
          if (widget.isListening)
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 2),
              child: Icon(
                Icons.mic,
                color: theme.colorScheme.error,
                size: 20,
              ),
            ),

          // Transcription text
          Expanded(
            child: widget.text.isEmpty
                ? Text(
                    widget.isListening
                        ? 'Listening...'
                        : 'Tap to start speaking',
                    style: textStyle?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : _buildHighlightedText(textStyle),
          ),

          // Typing cursor
          if (widget.isListening)
            AnimatedBuilder(
              animation: _cursorController,
              builder: (context, child) {
                return Opacity(
                  opacity: _cursorController.value,
                  child: Container(
                    width: 2,
                    height: 20,
                    margin: const EdgeInsets.only(left: 2),
                    color: theme.colorScheme.primary,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(TextStyle? baseStyle) {
    if (widget.highlightedEntities.isEmpty) {
      return Text(
        widget.text,
        style: baseStyle,
        maxLines: widget.maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    // Build text spans with highlighted entities
    final spans = <TextSpan>[];
    var remainingText = widget.text;

    for (final entry in widget.highlightedEntities.entries) {
      final entity = entry.key;
      final color = entry.value;

      final parts = remainingText.split(RegExp(entity, caseSensitive: false));
      if (parts.length > 1) {
        for (var i = 0; i < parts.length; i++) {
          if (parts[i].isNotEmpty) {
            spans.add(TextSpan(text: parts[i]));
          }
          if (i < parts.length - 1) {
            spans.add(TextSpan(
              text: entity,
              style: TextStyle(
                backgroundColor: color.withValues(alpha: 0.3),
                fontWeight: FontWeight.w600,
              ),
            ));
          }
        }
        break;
      }
    }

    if (spans.isEmpty) {
      return Text(
        widget.text,
        style: baseStyle,
        maxLines: widget.maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: spans,
      ),
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// A compact inline transcription display.
class InlineTranscriptionDisplay extends StatelessWidget {
  const InlineTranscriptionDisplay({
    super.key,
    required this.text,
    this.isListening = false,
  });

  final String text;
  final bool isListening;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isListening
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isListening)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
          Flexible(
            child: Text(
              text.isEmpty ? 'Listening...' : text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: text.isEmpty
                    ? theme.colorScheme.onSurfaceVariant
                    : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
