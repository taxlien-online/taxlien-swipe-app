import 'package:flutter/foundation.dart';
import '../../../core/models/copilot_models.dart';
import '../services/copilot_service.dart';

/// State management for AI Copilot
class CopilotProvider extends ChangeNotifier {
  final CopilotService _service = CopilotService();

  // Query history
  final List<CopilotQuery> _queryHistory = [];
  List<CopilotQuery> get queryHistory => List.unmodifiable(_queryHistory);

  // Current query state
  String _currentInput = '';
  String get currentInput => _currentInput;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  CopilotResponse? _lastResponse;
  CopilotResponse? get lastResponse => _lastResponse;

  String? _error;
  String? get error => _error;

  // Suggestions
  List<String> _suggestions = CopilotSuggestions.general;
  List<String> get suggestions => _suggestions;

  // Context
  List<String>? _contextPropertyIds;
  String? _currentCounty;

  /// Update current input text
  void setInput(String text) {
    _currentInput = text;
    _updateSuggestions();
    notifyListeners();
  }

  /// Set context for queries
  void setContext({List<String>? propertyIds, String? county}) {
    _contextPropertyIds = propertyIds;
    _currentCounty = county;
    _updateSuggestions();
    notifyListeners();
  }

  /// Submit a query
  Future<void> submitQuery(String query) async {
    if (query.trim().isEmpty) return;

    _isProcessing = true;
    _error = null;
    notifyListeners();

    final copilotQuery = CopilotQuery.now(
      query,
      contextPropertyIds: _contextPropertyIds,
    );
    _queryHistory.add(copilotQuery);

    try {
      final response = await _service.processQuery(
        query,
        contextPropertyIds: _contextPropertyIds,
      );
      _lastResponse = response;
      _currentInput = '';
    } catch (e) {
      _error = e.toString();
      _lastResponse = CopilotResponse.error(query, _error!);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Use a suggestion
  void useSuggestion(String suggestion) {
    setInput(suggestion);
    submitQuery(suggestion);
  }

  /// Clear last response
  void clearResponse() {
    _lastResponse = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear history
  void clearHistory() {
    _queryHistory.clear();
    notifyListeners();
  }

  void _updateSuggestions() {
    if (_currentInput.isNotEmpty) {
      // Filter suggestions based on input
      _suggestions = _service.getSuggestions(_currentInput);
    } else {
      // Contextual suggestions
      _suggestions = CopilotSuggestions.forContext(
        hasSelection: _contextPropertyIds?.isNotEmpty ?? false,
        county: _currentCounty,
      );
    }
  }

  /// Get matching property IDs from last response
  Set<String> get matchingPropertyIds {
    if (_lastResponse == null || !_lastResponse!.success) {
      return {};
    }
    return _lastResponse!.matchingPropertyIds.toSet();
  }

  @override
  void dispose() {
    _queryHistory.clear();
    super.dispose();
  }
}
