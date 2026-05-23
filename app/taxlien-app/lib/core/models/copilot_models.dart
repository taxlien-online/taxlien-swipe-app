/// AI Copilot query model
class CopilotQuery {
  final String text;
  final DateTime timestamp;
  final List<String>? contextPropertyIds; // Selected properties for context
  final CopilotQueryType? type;

  const CopilotQuery({
    required this.text,
    required this.timestamp,
    this.contextPropertyIds,
    this.type,
  });

  factory CopilotQuery.now(String text, {List<String>? contextPropertyIds}) {
    return CopilotQuery(
      text: text,
      timestamp: DateTime.now(),
      contextPropertyIds: contextPropertyIds,
      type: CopilotQueryType.fromText(text),
    );
  }

  /// Whether this query has selection context
  bool get hasContext =>
      contextPropertyIds != null && contextPropertyIds!.isNotEmpty;

  @override
  String toString() => 'CopilotQuery("$text")';
}

/// Types of queries the Copilot can handle
enum CopilotQueryType {
  filter, // "Show high ROI properties"
  search, // "Find properties in Miami"
  compare, // "Compare these two properties"
  analyze, // "What's wrong with this selection?"
  explain, // "Why is this property high risk?"
  suggest, // "What should I buy next?"
  general, // Catch-all
}

extension CopilotQueryTypeExt on CopilotQueryType {
  static CopilotQueryType fromText(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('show') ||
        lower.contains('filter') ||
        lower.contains('only')) {
      return CopilotQueryType.filter;
    }
    if (lower.contains('find') ||
        lower.contains('search') ||
        lower.contains('where')) {
      return CopilotQueryType.search;
    }
    if (lower.contains('compare') || lower.contains('vs') || lower.contains('versus')) {
      return CopilotQueryType.compare;
    }
    if (lower.contains('analyze') ||
        lower.contains('what\'s wrong') ||
        lower.contains('issues')) {
      return CopilotQueryType.analyze;
    }
    if (lower.contains('why') || lower.contains('explain') || lower.contains('how')) {
      return CopilotQueryType.explain;
    }
    if (lower.contains('suggest') ||
        lower.contains('recommend') ||
        lower.contains('should i')) {
      return CopilotQueryType.suggest;
    }
    return CopilotQueryType.general;
  }
}

/// Response from AI Copilot
class CopilotResponse {
  final String query;
  final List<String> matchingPropertyIds;
  final String? explanation;
  final Map<String, dynamic>? appliedFilters;
  final List<CopilotSuggestion>? suggestions;
  final bool success;
  final String? error;
  final DateTime timestamp;

  const CopilotResponse({
    required this.query,
    required this.matchingPropertyIds,
    this.explanation,
    this.appliedFilters,
    this.suggestions,
    this.success = true,
    this.error,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? const _DefaultTimestamp();

  factory CopilotResponse.error(String query, String error) {
    return CopilotResponse(
      query: query,
      matchingPropertyIds: [],
      success: false,
      error: error,
      timestamp: DateTime.now(),
    );
  }

  factory CopilotResponse.success({
    required String query,
    required List<String> matchingPropertyIds,
    String? explanation,
    Map<String, dynamic>? appliedFilters,
    List<CopilotSuggestion>? suggestions,
  }) {
    return CopilotResponse(
      query: query,
      matchingPropertyIds: matchingPropertyIds,
      explanation: explanation,
      appliedFilters: appliedFilters,
      suggestions: suggestions,
      success: true,
      timestamp: DateTime.now(),
    );
  }

  /// Number of matches
  int get matchCount => matchingPropertyIds.length;

  /// Whether any properties matched
  bool get hasMatches => matchingPropertyIds.isNotEmpty;

  @override
  String toString() =>
      'CopilotResponse(${success ? "${matchCount} matches" : "error: $error"})';
}

/// A workaround for default timestamp in const constructor
class _DefaultTimestamp implements DateTime {
  const _DefaultTimestamp();

  @override
  dynamic noSuchMethod(Invocation invocation) => DateTime.now();
}

/// A suggested follow-up action or query
class CopilotSuggestion {
  final String text;
  final String? icon;
  final CopilotSuggestionAction action;

  const CopilotSuggestion({
    required this.text,
    this.icon,
    required this.action,
  });
}

/// Action type for suggestions
enum CopilotSuggestionAction {
  query, // Run another query
  filter, // Apply a filter
  select, // Select properties
  navigate, // Go to a screen
}

/// Predefined query suggestions
class CopilotSuggestions {
  static const List<String> general = [
    'High ROI properties',
    'Low risk deals',
    'Upcoming auctions this week',
    'OTC opportunities',
    'Properties under \$5k',
  ];

  static const List<String> withSelection = [
    'Analyze my selection',
    'Find similar properties',
    'What are the risks?',
    'Compare top 3',
  ];

  static List<String> forContext({bool hasSelection = false, String? county}) {
    final suggestions = <String>[];
    if (hasSelection) {
      suggestions.addAll(withSelection);
    } else {
      suggestions.addAll(general);
    }
    if (county != null) {
      suggestions.add('More in $county');
    }
    return suggestions;
  }
}
