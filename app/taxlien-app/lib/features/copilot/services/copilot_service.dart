import '../../../core/models/copilot_models.dart';

/// Service for AI Copilot queries
/// In MVP, uses rule-based parsing. Can be upgraded to cloud AI later.
class CopilotService {
  /// Process a natural language query
  Future<CopilotResponse> processQuery(
    String query, {
    List<String>? contextPropertyIds,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final lowerQuery = query.toLowerCase();

    try {
      // Parse query intent
      final filters = _parseFilters(lowerQuery);
      final explanation = _generateExplanation(filters);

      // In real implementation, this would query the backend
      // For MVP, return mock response with filters
      return CopilotResponse.success(
        query: query,
        matchingPropertyIds: [], // Would be populated by backend
        explanation: explanation,
        appliedFilters: filters,
        suggestions: _generateFollowUpSuggestions(filters),
      );
    } catch (e) {
      return CopilotResponse.error(query, 'Failed to process query: $e');
    }
  }

  /// Get autocomplete suggestions
  List<String> getSuggestions(String partialQuery) {
    final lower = partialQuery.toLowerCase();

    final allSuggestions = [
      ...CopilotSuggestions.general,
      ...CopilotSuggestions.withSelection,
      'Properties in Florida with high ROI',
      'Low risk OTC opportunities',
      'Upcoming auctions this week',
      'Properties under \$5,000 lien amount',
      'High value single family homes',
      'Land parcels with low redemption risk',
    ];

    return allSuggestions
        .where((s) => s.toLowerCase().contains(lower))
        .take(5)
        .toList();
  }

  /// Parse query into filter parameters
  Map<String, dynamic> _parseFilters(String query) {
    final filters = <String, dynamic>{};

    // ROI parsing
    if (query.contains('high roi')) {
      filters['min_roi'] = 0.15;
    } else if (query.contains('low roi')) {
      filters['max_roi'] = 0.10;
    }

    // Risk parsing
    if (query.contains('low risk')) {
      filters['max_risk_score'] = 30;
    } else if (query.contains('high risk')) {
      filters['min_risk_score'] = 70;
    }

    // Stage parsing
    if (query.contains('otc') || query.contains('over the counter')) {
      filters['listing_stage'] = 'otc';
    } else if (query.contains('auction')) {
      filters['listing_stage'] = 'listed';
    }

    // State parsing
    final stateMatches = RegExp(r'\b(florida|texas|arizona|california|georgia)\b')
        .allMatches(query);
    if (stateMatches.isNotEmpty) {
      final state = stateMatches.first.group(0)!;
      filters['state'] = _stateCodeFromName(state);
    }

    // Amount parsing
    final amountMatch = RegExp(r'\$?([\d,]+)k?').firstMatch(query);
    if (amountMatch != null) {
      var amount = double.tryParse(
          amountMatch.group(1)!.replaceAll(',', '')) ?? 0;
      if (query.contains('k')) amount *= 1000;

      if (query.contains('under') || query.contains('below')) {
        filters['max_lien_amount'] = amount;
      } else if (query.contains('over') || query.contains('above')) {
        filters['min_lien_amount'] = amount;
      }
    }

    // Property type parsing
    if (query.contains('single family') || query.contains('sfr')) {
      filters['property_type'] = 'Single Family';
    } else if (query.contains('land') || query.contains('vacant')) {
      filters['property_type'] = 'Land';
    } else if (query.contains('commercial')) {
      filters['property_type'] = 'Commercial';
    }

    // Time parsing
    if (query.contains('this week')) {
      filters['auction_date_max'] = DateTime.now().add(const Duration(days: 7));
    } else if (query.contains('this month')) {
      filters['auction_date_max'] = DateTime.now().add(const Duration(days: 30));
    }

    return filters;
  }

  String _generateExplanation(Map<String, dynamic> filters) {
    if (filters.isEmpty) {
      return 'Showing all properties matching your search.';
    }

    final parts = <String>[];

    if (filters.containsKey('min_roi')) {
      parts.add('ROI above ${(filters['min_roi'] * 100).toInt()}%');
    }
    if (filters.containsKey('max_risk_score')) {
      parts.add('low risk (score ≤ ${filters['max_risk_score']})');
    }
    if (filters.containsKey('listing_stage')) {
      parts.add('${filters['listing_stage']} stage');
    }
    if (filters.containsKey('state')) {
      parts.add('in ${filters['state']}');
    }
    if (filters.containsKey('max_lien_amount')) {
      parts.add('under \$${filters['max_lien_amount'].toInt()}');
    }
    if (filters.containsKey('property_type')) {
      parts.add('${filters['property_type']} properties');
    }

    if (parts.isEmpty) {
      return 'Searching for matching properties...';
    }

    return 'Filtering for ${parts.join(', ')}.';
  }

  List<CopilotSuggestion> _generateFollowUpSuggestions(
      Map<String, dynamic> filters) {
    final suggestions = <CopilotSuggestion>[];

    if (!filters.containsKey('min_roi')) {
      suggestions.add(const CopilotSuggestion(
        text: 'Add high ROI filter',
        action: CopilotSuggestionAction.filter,
      ));
    }

    if (!filters.containsKey('max_risk_score')) {
      suggestions.add(const CopilotSuggestion(
        text: 'Filter to low risk only',
        action: CopilotSuggestionAction.filter,
      ));
    }

    suggestions.add(const CopilotSuggestion(
      text: 'Select all matches',
      action: CopilotSuggestionAction.select,
    ));

    return suggestions;
  }

  String _stateCodeFromName(String name) {
    return switch (name.toLowerCase()) {
      'florida' => 'FL',
      'texas' => 'TX',
      'arizona' => 'AZ',
      'california' => 'CA',
      'georgia' => 'GA',
      _ => name.toUpperCase(),
    };
  }
}
