import 'dart:async';

import 'package:flutter/material.dart';

/// A filter tag extracted from voice input.
class FilterTag {
  const FilterTag({
    required this.id,
    required this.category,
    required this.value,
    this.displayText,
    this.confidence = 1.0,
  });

  final String id;
  final String category;
  final String value;
  final String? displayText;
  final double confidence;

  String get display => displayText ?? '$category: $value';

  Color get color {
    switch (category.toLowerCase()) {
      case 'price':
      case 'value':
        return const Color(0xFF059669);
      case 'location':
      case 'county':
      case 'state':
        return const Color(0xFF2563EB);
      case 'type':
      case 'property':
        return const Color(0xFF7C3AED);
      case 'fvi':
      case 'score':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

/// Recognition status of the voice service.
enum RecognitionStatus {
  /// Not listening
  idle,

  /// Waiting for speech
  listening,

  /// Processing speech
  processing,

  /// Encountered an error
  error,
}

/// Abstract interface for voice recognition service.
abstract class VoiceRecognitionService {
  /// Start listening for voice input.
  Future<void> startListening();

  /// Stop listening.
  Future<void> stopListening();

  /// Cancel current recognition.
  Future<void> cancel();

  /// Stream of transcription updates.
  Stream<String> get transcriptionStream;

  /// Stream of extracted filter tags.
  Stream<List<FilterTag>> get filterTagStream;

  /// Stream of audio level for visualization.
  Stream<double> get audioLevelStream;

  /// Current recognition status.
  ValueNotifier<RecognitionStatus> get statusNotifier;

  /// Check if speech recognition is available.
  Future<bool> isAvailable();

  /// Request microphone permission.
  Future<bool> requestPermission();
}

/// Stub implementation for development.
class StubVoiceRecognitionService implements VoiceRecognitionService {
  final _transcriptionController = StreamController<String>.broadcast();
  final _filterTagController = StreamController<List<FilterTag>>.broadcast();
  final _audioLevelController = StreamController<double>.broadcast();
  final _statusNotifier = ValueNotifier(RecognitionStatus.idle);

  Timer? _simulationTimer;

  @override
  Stream<String> get transcriptionStream => _transcriptionController.stream;

  @override
  Stream<List<FilterTag>> get filterTagStream => _filterTagController.stream;

  @override
  Stream<double> get audioLevelStream => _audioLevelController.stream;

  @override
  ValueNotifier<RecognitionStatus> get statusNotifier => _statusNotifier;

  @override
  Future<void> startListening() async {
    _statusNotifier.value = RecognitionStatus.listening;

    // Simulate audio levels
    var level = 0.0;
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      level = (level + 0.1) % 1.0;
      _audioLevelController.add(level);
    });
  }

  @override
  Future<void> stopListening() async {
    _simulationTimer?.cancel();
    _statusNotifier.value = RecognitionStatus.processing;

    // Simulate processing
    await Future.delayed(const Duration(milliseconds: 500));

    // Emit sample results
    _transcriptionController.add('Show properties under fifty thousand');
    _filterTagController.add([
      const FilterTag(
        id: '1',
        category: 'Price',
        value: '<50000',
        displayText: 'Under \$50K',
      ),
    ]);

    _statusNotifier.value = RecognitionStatus.idle;
  }

  @override
  Future<void> cancel() async {
    _simulationTimer?.cancel();
    _statusNotifier.value = RecognitionStatus.idle;
  }

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<bool> requestPermission() async => true;

  void dispose() {
    _simulationTimer?.cancel();
    _transcriptionController.close();
    _filterTagController.close();
    _audioLevelController.close();
    _statusNotifier.dispose();
  }
}

/// State for the voice gesture panel.
class VoiceGestureState {
  const VoiceGestureState({
    this.isActive = false,
    this.status = RecognitionStatus.idle,
    this.transcription = '',
    this.extractedTags = const [],
    this.selectedPropertyIds = const {},
    this.audioLevel = 0.0,
    this.error,
  });

  final bool isActive;
  final RecognitionStatus status;
  final String transcription;
  final List<FilterTag> extractedTags;
  final Set<String> selectedPropertyIds;
  final double audioLevel;
  final String? error;

  bool get isListening => status == RecognitionStatus.listening;
  bool get isProcessing => status == RecognitionStatus.processing;
  bool get hasError => status == RecognitionStatus.error;

  VoiceGestureState copyWith({
    bool? isActive,
    RecognitionStatus? status,
    String? transcription,
    List<FilterTag>? extractedTags,
    Set<String>? selectedPropertyIds,
    double? audioLevel,
    String? error,
  }) {
    return VoiceGestureState(
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      transcription: transcription ?? this.transcription,
      extractedTags: extractedTags ?? this.extractedTags,
      selectedPropertyIds: selectedPropertyIds ?? this.selectedPropertyIds,
      audioLevel: audioLevel ?? this.audioLevel,
      error: error ?? this.error,
    );
  }
}
