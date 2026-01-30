# Status: sdd-taxlien-swipe-app-deeplink

## Current Phase
IMPLEMENTATION

## Last Updated
2026-01-30 by Claude

## Blockers
- None

## Progress
- [x] Requirements drafted
- [x] Open questions resolved
- [x] Requirements approved
- [x] Specifications drafted
- [x] Specifications approved
- [x] Plan drafted
- [x] Plan approved
- [ ] Implementation started
- [ ] Implementation complete

## Context Notes
Feature: Deep Linking + App Store Smart Banner для Flutter Web приложения

Основные требования:
- Web версия размещается на deal.taxlien.online
- При открытии с мобильного устройства - предлагать скачать приложение
- Поддержка множества сторов: Apple Store, Google Play, Xiaomi, Samsung, Huawei, RuStore
- Deep link механизм для сохранения контекста страницы (например /parcel/123)
- Работа в обе стороны: Web → App и App → Web (для sharing)