# Plan: TaxLien Swipe App (Deal Detective)

**Version:** 1.2
**Status:** APPROVED
**Last Updated:** 2026-01-28

---

## Phase 0: Навигация и Основа (Current)
- [x] Интеграция `go_router` в `pubspec.yaml`.
- [x] Настройка `AppRouter` с путями: Home, Details, Annotate, Family.
- [x] Обновление `main.dart` для запуска `MaterialApp.router`.

## Phase 1: Профили и FVI
- [x] Реализация `ExpertProfileService` (хранение текущего эксперта).
- [x] Добавление UI-индикатора текущего профиля на главный экран.
- [x] Реализация базовой модели `FVI` и её отображение на карточке.

## Phase 2: Property Deep-Dive (Details)
- [x] Создание `PropertyDetailsScreen`.
- [x] Интеграция галереи фото.
- [x] Отображение ROI и вклада экспертов (FVI Breakdown).

## Phase 3: Expert Canvas (Annotation)
- [x] Создание `AnnotationCanvas`.
- [x] Реализация инструментов: Точка, Линия, Область.
- [x] Интеграция голосовых заметок (заглушка/сервис).

## Phase 4: Family Board
- [x] Реализация `FamilyBoardScreen`.
- [x] Синхронизация лайков между профилями.
