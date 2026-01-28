# Specifications: TaxLien Swipe App (Deal Detective)

**Version:** 1.2
**Status:** APPROVED
**Last Updated:** 2026-01-28

---

## Архитектура Навигации (GoRouter)

### Конфигурация путей:
- `/` (`home`) -> `SwipeHomeScreen` (Discovery)
- `/details/:id` (`details`) -> `PropertyDetailsScreen`
- `/annotate/:id` (`annotate`) -> `AnnotationCanvas`
- `/family` (`family_board`) -> `FamilyBoardScreen`
- `/profile` (`profile`) -> `ExpertProfileSwitcher`

---

## Data Models (Expanded)

### FVI Model
```dart
class FVI {
  final double financialScore; // ROI, Tax history
  final Map<String, double> expertScores; // { "khun_pho": 8.0, "denis": 9.5 }
  final double totalIndex; // (financial + sum(expert)) / cost
}
```

### Annotation Model
```dart
class Annotation {
  final String id;
  final String expertId;
  final Offset position; // normalized 0.0 to 1.0
  final AnnotationType type; // point, line, area
  final String? comment;
  final String? voiceUrl; // Speech-to-text source
  final List<String> tags; // [#mustang, #foundation]
}
```

---

## Project Structure
```
lib/
├── core/
│   ├── navigation/app_router.dart
│   ├── theme/
│   └── models/fvi.dart
├── features/
│   ├── swipe/          <-- Discovery UI
│   ├── details/        <-- Deep-dive & ROI
│   ├── annotation/     <-- Expert Canvas
│   └── family/         <-- Collaborative Board
└── services/
    ├── match_service.dart
    └── annotation_service.dart
```
