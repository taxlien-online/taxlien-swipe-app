# Status: sdd-taxlien-swipe-app-deeplink

## Current Phase
REQUIREMENTS (awaiting approval)

## Last Updated
2026-01-30 by Claude

## Blockers
- Awaiting user approval of requirements

## Progress
- [x] Requirements drafted
- [x] Open questions resolved
- [ ] Requirements approved
- [ ] Specifications drafted
- [ ] Specifications approved
- [ ] Plan drafted
- [ ] Plan approved
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
