import 'package:flutter/foundation.dart';
import '../../../core/models/lasso_selection.dart';
import '../../../core/models/selection_stats.dart';
import '../../../core/models/tax_lien_models.dart';

/// State management for property selection in Galaxy view
class SelectionProvider extends ChangeNotifier {
  // Selected property IDs
  final Set<String> _selectedIds = {};
  Set<String> get selectedIds => Set.unmodifiable(_selectedIds);

  // Highlighted property IDs (from AI query results)
  final Set<String> _highlightedIds = {};
  Set<String> get highlightedIds => Set.unmodifiable(_highlightedIds);

  // Current lasso selection in progress
  LassoSelection? _currentLasso;
  LassoSelection? get currentLasso => _currentLasso;

  // Lasso mode state
  bool _isLassoMode = false;
  bool get isLassoMode => _isLassoMode;

  // Selection stats (computed from selected properties)
  SelectionStats _stats = SelectionStats.empty();
  SelectionStats get stats => _stats;

  // Properties cache for stats calculation
  List<TaxLien> _propertiesCache = [];

  /// Update properties cache for stats calculation
  void setPropertiesCache(List<TaxLien> properties) {
    _propertiesCache = properties;
    _recalculateStats();
  }

  /// Whether any properties are selected
  bool get hasSelection => _selectedIds.isNotEmpty;

  /// Number of selected properties
  int get selectionCount => _selectedIds.length;

  /// Select a single property
  void select(String propertyId) {
    _selectedIds.add(propertyId);
    _recalculateStats();
    notifyListeners();
  }

  /// Deselect a single property
  void deselect(String propertyId) {
    _selectedIds.remove(propertyId);
    _recalculateStats();
    notifyListeners();
  }

  /// Toggle selection for a property
  void toggle(String propertyId) {
    if (_selectedIds.contains(propertyId)) {
      _selectedIds.remove(propertyId);
    } else {
      _selectedIds.add(propertyId);
    }
    _recalculateStats();
    notifyListeners();
  }

  /// Select multiple properties
  void selectAll(Iterable<String> propertyIds) {
    _selectedIds.addAll(propertyIds);
    _recalculateStats();
    notifyListeners();
  }

  /// Deselect multiple properties
  void deselectAll(Iterable<String> propertyIds) {
    _selectedIds.removeAll(propertyIds);
    _recalculateStats();
    notifyListeners();
  }

  /// Clear all selections
  void clearSelection() {
    _selectedIds.clear();
    _stats = SelectionStats.empty();
    notifyListeners();
  }

  /// Check if a property is selected
  bool isSelected(String propertyId) => _selectedIds.contains(propertyId);

  // Lasso selection methods

  /// Enter lasso mode
  void enterLassoMode() {
    _isLassoMode = true;
    notifyListeners();
  }

  /// Exit lasso mode
  void exitLassoMode() {
    _isLassoMode = false;
    _currentLasso = null;
    notifyListeners();
  }

  /// Start drawing a lasso
  void startLasso(Offset point) {
    _currentLasso = LassoSelection.start(point);
    notifyListeners();
  }

  /// Add point to current lasso
  void updateLasso(Offset point) {
    if (_currentLasso == null) return;
    _currentLasso = _currentLasso!.addPoint(point);
    notifyListeners();
  }

  /// Complete lasso and select enclosed properties
  void completeLasso(List<String> enclosedPropertyIds) {
    if (_currentLasso == null) return;

    final lasso = _currentLasso!.close();

    if (lasso.isValid) {
      if (lasso.isClockwise) {
        // Clockwise: add to selection
        _selectedIds.addAll(enclosedPropertyIds);
      } else {
        // Counter-clockwise: remove from selection
        _selectedIds.removeAll(enclosedPropertyIds);
      }
      _recalculateStats();
    }

    _currentLasso = null;
    notifyListeners();
  }

  /// Cancel current lasso without selecting
  void cancelLasso() {
    _currentLasso = null;
    notifyListeners();
  }

  // Highlight methods (for AI query results)

  /// Set highlighted properties
  void setHighlighted(Set<String> propertyIds) {
    _highlightedIds.clear();
    _highlightedIds.addAll(propertyIds);
    notifyListeners();
  }

  /// Clear highlights
  void clearHighlights() {
    _highlightedIds.clear();
    notifyListeners();
  }

  /// Select all highlighted properties
  void selectHighlighted() {
    _selectedIds.addAll(_highlightedIds);
    _recalculateStats();
    notifyListeners();
  }

  // Stats calculation

  void _recalculateStats() {
    if (_selectedIds.isEmpty) {
      _stats = SelectionStats.empty();
      return;
    }

    final selectedProperties = _propertiesCache
        .where((p) => _selectedIds.contains(p.id))
        .toList();

    _stats = SelectionStats.fromProperties(selectedProperties);
  }

  /// Get selected properties as list
  List<TaxLien> getSelectedProperties() {
    return _propertiesCache
        .where((p) => _selectedIds.contains(p.id))
        .toList();
  }

  @override
  void dispose() {
    _selectedIds.clear();
    _highlightedIds.clear();
    _propertiesCache = [];
    super.dispose();
  }
}
