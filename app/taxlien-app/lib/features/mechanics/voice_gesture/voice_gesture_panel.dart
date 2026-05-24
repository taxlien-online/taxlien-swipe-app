import 'dart:async';

import 'package:flutter/material.dart';

import 'services/voice_recognition_service.dart';
import 'widgets/filter_tag.dart';
import 'widgets/transcription_display.dart';
import 'widgets/waveform_visualizer.dart';

/// A panel for voice-assisted property filtering.
class VoiceGesturePanel extends StatefulWidget {
  const VoiceGesturePanel({
    super.key,
    this.service,
    this.onFiltersExtracted,
    this.onDismiss,
    this.selectedPropertyCount = 0,
  });

  final VoiceRecognitionService? service;
  final void Function(List<FilterTag> filters)? onFiltersExtracted;
  final VoidCallback? onDismiss;
  final int selectedPropertyCount;

  @override
  State<VoiceGesturePanel> createState() => _VoiceGesturePanelState();
}

class _VoiceGesturePanelState extends State<VoiceGesturePanel> {
  late final VoiceRecognitionService _service;
  VoiceGestureState _state = const VoiceGestureState();

  StreamSubscription<String>? _transcriptionSub;
  StreamSubscription<List<FilterTag>>? _filterTagSub;
  StreamSubscription<double>? _audioLevelSub;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? StubVoiceRecognitionService();
    _setupListeners();
  }

  void _setupListeners() {
    _transcriptionSub = _service.transcriptionStream.listen((text) {
      setState(() {
        _state = _state.copyWith(transcription: text);
      });
    });

    _filterTagSub = _service.filterTagStream.listen((tags) {
      setState(() {
        _state = _state.copyWith(extractedTags: tags);
      });
      widget.onFiltersExtracted?.call(tags);
    });

    _audioLevelSub = _service.audioLevelStream.listen((level) {
      setState(() {
        _state = _state.copyWith(audioLevel: level);
      });
    });

    _service.statusNotifier.addListener(_onStatusChange);
  }

  void _onStatusChange() {
    setState(() {
      _state = _state.copyWith(status: _service.statusNotifier.value);
    });
  }

  @override
  void dispose() {
    _transcriptionSub?.cancel();
    _filterTagSub?.cancel();
    _audioLevelSub?.cancel();
    _service.statusNotifier.removeListener(_onStatusChange);
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_state.isListening) {
      await _service.stopListening();
    } else {
      final hasPermission = await _service.requestPermission();
      if (hasPermission) {
        await _service.startListening();
        setState(() {
          _state = _state.copyWith(isActive: true);
        });
      }
    }
  }

  void _removeTag(FilterTag tag) {
    setState(() {
      _state = _state.copyWith(
        extractedTags: _state.extractedTags.where((t) => t.id != tag.id).toList(),
      );
    });
    widget.onFiltersExtracted?.call(_state.extractedTags);
  }

  void _clearAllTags() {
    setState(() {
      _state = _state.copyWith(extractedTags: []);
    });
    widget.onFiltersExtracted?.call([]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 32,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.mic,
                  color: _state.isListening
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  _state.isListening ? 'Listening...' : 'Voice Filter',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (widget.selectedPropertyCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.selectedPropertyCount} selected',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onDismiss,
                ),
              ],
            ),
          ),

          // Waveform
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: WaveformVisualizer(
              audioLevel: _state.audioLevel,
              isActive: _state.isListening,
              color: theme.colorScheme.primary,
            ),
          ),

          // Transcription
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TranscriptionDisplay(
              text: _state.transcription,
              isListening: _state.isListening,
            ),
          ),

          // Extracted filters
          if (_state.extractedTags.isNotEmpty) ...[
            const SizedBox(height: 16),
            FilterTagRow(
              tags: _state.extractedTags,
              onRemove: _removeTag,
              onClearAll: _clearAllTags,
            ),
          ],

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _toggleListening,
                    icon: Icon(_state.isListening ? Icons.stop : Icons.mic),
                    label: Text(_state.isListening ? 'Stop' : 'Start'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _state.extractedTags.isNotEmpty
                        ? () {
                            widget.onFiltersExtracted?.call(_state.extractedTags);
                            widget.onDismiss?.call();
                          }
                        : null,
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A compact floating button to trigger voice input.
class VoiceGestureButton extends StatelessWidget {
  const VoiceGestureButton({
    super.key,
    this.isListening = false,
    this.onPressed,
  });

  final bool isListening;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor:
          isListening ? theme.colorScheme.error : theme.colorScheme.primary,
      child: Icon(
        isListening ? Icons.mic : Icons.mic_none,
        color: isListening
            ? theme.colorScheme.onError
            : theme.colorScheme.onPrimary,
      ),
    );
  }
}
