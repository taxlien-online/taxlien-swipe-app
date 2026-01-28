# Plan: TaxLien Swipe App (Deal Detective)

**Version:** 1.2
**Status:** APPROVED
**Last Updated:** 2026-01-28

---

## Phase 0: Навигация и Основа (Current)
- [ ] Интеграция `go_router` в `pubspec.yaml`.
- [ ] Настройка `AppRouter` с путями: Home, Details, Annotate, Family.
- [ ] Обновление `main.dart` для запуска `MaterialApp.router`.

## Phase 1: Профили и FVI
- [ ] Реализация `ExpertProfileService` (хранение текущего эксперта).
- [ ] Добавление UI-индикатора текущего профиля на главный экран.
- [ ] Реализация базовой модели `FVI` и её отображение на карточке.

## Phase 2: Property Deep-Dive (Details)
- [ ] Создание `PropertyDetailsScreen`.
- [ ] Интеграция галереи фото.
- [ ] Отображение ROI и вклада экспертов (FVI Breakdown).

## Phase 3: Expert Canvas (Annotation)
- [ ] Создание `AnnotationCanvas`.
- [ ] Реализация инструментов: Точка, Линия, Область.
- [ ] Интеграция голосовых заметок (заглушка/сервис).

## Phase 4: Family Board
- [ ] Реализация `FamilyBoardScreen`.
- [ ] Синхронизация лайков между профилями.
