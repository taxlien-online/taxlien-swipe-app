# Requirements: Tutorial & Learning System

**Version:** 1.1
**Status:** DRAFT
**Last Updated:** 2026-02-03

---

## Problem Statement

Deal Detective - сложное приложение с множеством функций:
- Два режима свайпа (Beginner/Expert)
- Система аннотаций для экспертов
- FVI/ИПП метрики
- Фильтры foreclosure
- Семейная доска (Family Board)

(Экспорт в PDF реализован в **taxlien-flutter-app**, см. `flows/sdd-taxlien-flutter-app-export-pdf`; упоминания PDF в туториале — для кросс-приложения или основной апп.)

**Проблема:** Mini-tutorial в onboarding (2-3 свайпа) недостаточен для раскрытия всех возможностей.

**Цель:** Создать **интерактивную систему подсказок прямо на экране** во время работы:
1. Подсказки появляются в контексте действий пользователя
2. Можно пропустить любую подсказку (или все)
3. Не прерывают workflow пользователя
4. Раскрывают функции постепенно (по мере использования)

---

## Ключевой принцип: Learn by Doing

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ИНТЕРАКТИВНОЕ ОБУЧЕНИЕ НА ЭКРАНЕ                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  НЕ отдельный экран tutorial, а подсказки ВО ВРЕМЯ работы:                 │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                     PROPERTY CARD                                    │   │
│  │  ┌───────────────────────────────────────────────────┐              │   │
│  │  │                 [Photo]                            │              │   │
│  │  │                              ┌──────────────────┐  │              │   │
│  │  │                              │ FVI: 85 ← ─ ─ ─ ─│─ │─ ─ ┐        │   │
│  │  │                              └──────────────────┘  │     │        │   │
│  │  │  Phoenix, AZ                                       │     │        │   │
│  │  │  Foreclosure: 85%  ← ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│─ ─ ─│─ ┐    │   │
│  │  └───────────────────────────────────────────────────┘     │   │    │   │
│  │                                                             │   │    │   │
│  │  ┌─────────────────────────────────────────────────────┐   │   │    │   │
│  │  │ 💡 FVI = Family Value Index                          │◄──┘   │    │   │
│  │  │    Показывает ценность для вашей семьи.             │       │    │   │
│  │  │    Тапните на badge для деталей.                    │       │    │   │
│  │  │                                                      │       │    │   │
│  │  │    [Понятно]  [Больше не показывать]                │       │    │   │
│  │  └─────────────────────────────────────────────────────┘       │    │   │
│  │                                                                 │    │   │
│  │  ┌─────────────────────────────────────────────────────────┐   │    │   │
│  │  │ 💡 Foreclosure 85% = высокий шанс получить property    │◄──┘    │   │
│  │  │    Мы ищем именно такие! 70%+ = отличный кандидат.    │        │   │
│  │  │                                                        │        │   │
│  │  │    [Понятно]                                          │        │   │
│  │  └─────────────────────────────────────────────────────────┘       │   │
│  │                                                                     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  Подсказки:                                                                │
│  • Появляются ПРИ ПЕРВОМ взаимодействии с элементом                        │
│  • НЕ блокируют UI (можно продолжать работать)                             │
│  • Можно dismiss свайпом или кнопкой                                       │
│  • "Больше не показывать" отключает все подсказки                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Концепция: Tutorial vs Onboarding

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        ONBOARDING (существующий)                            │
├─────────────────────────────────────────────────────────────────────────────┤
│  Когда: Первый запуск                                                       │
│  Цель: Быстрый старт                                                        │
│  Контент:                                                                   │
│    • Выбор режима (Beginner/Expert)                                        │
│    • Выбор роли (Expert only)                                              │
│    • Выбор географии                                                       │
│    • Mini-tutorial (2-3 свайпа)                                            │
│  Время: 1-2 минуты                                                          │
│  Можно пропустить: Да                                                       │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         TUTORIAL SYSTEM (этот SDD)                          │
├─────────────────────────────────────────────────────────────────────────────┤
│  Когда: В процессе использования                                            │
│  Цель: Глубокое освоение                                                    │
│  Компоненты:                                                                │
│    • Contextual Tooltips (появляются при первом посещении)                 │
│    • Feature Discovery (подсказки о неиспользуемых функциях)               │
│    • Learning Modules (глубокие гайды)                                     │
│    • Achievement System (мотивация)                                        │
│    • Help Center (справка)                                                 │
│  Время: Распределено по сессиям                                             │
│  Можно пропустить: Да (каждый элемент)                                     │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## User Stories

### US-0: Interactive On-Screen Hints (CORE FEATURE)

**As a** пользователь работающий в приложении
**I want** видеть подсказки прямо на экране во время работы
**So that** обучаюсь не прерывая workflow

**Hint Types:**

| Type | Appearance | Behavior |
|------|------------|----------|
| **Tooltip** | Bubble рядом с элементом | Появляется при первом view |
| **Coach Mark** | Spotlight на элемент + подсказка | Пошаговый guided tour |
| **Banner** | Плашка внизу экрана | Feature announcement |
| **Pulse** | Анимированная точка на элементе | Привлечь внимание к новому |

**Interaction:**
```dart
// Hint можно закрыть:
// 1. Тап на "Понятно" / "Got it"
// 2. Тап вне hint area
// 3. Свайп вниз (dismiss)
// 4. Автоматически через 10 сек (configurable)

// "Больше не показывать" отключает:
// - Только этот тип hint (default)
// - Все hints (если выбрано в settings)
```

**Visual Design:**
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         HINT STYLES                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. TOOLTIP (pointing to element):                                          │
│     ┌────────────────────────────────┐                                     │
│     │ 💡 FVI показывает ценность    │                                     │
│     │    для вашей семьи            │                                     │
│     │    [Понятно]                  │                                     │
│     └────────────▲───────────────────┘                                     │
│                  │                                                          │
│              [FVI: 85]  ← element                                          │
│                                                                             │
│  2. COACH MARK (spotlight + overlay):                                       │
│     ╔═══════════════════════════════════════════════════════════════════╗  │
│     ║ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ ║  │
│     ║ ░░░░░░░░░░░░░░┌─────────────────┐░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ ║  │
│     ║ ░░░░░░░░░░░░░░│   [ELEMENT]     │░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ ║  │
│     ║ ░░░░░░░░░░░░░░└─────────────────┘░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ ║  │
│     ║ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ ║  │
│     ║ ┌─────────────────────────────────────────────────────────────┐  ║  │
│     ║ │  Свайпните вправо для деталей                               │  ║  │
│     ║ │                                        [Пропустить] [Далее] │  ║  │
│     ║ └─────────────────────────────────────────────────────────────┘  ║  │
│     ╚═══════════════════════════════════════════════════════════════════╝  │
│                                                                             │
│  3. BANNER (bottom of screen):                                             │
│     ┌─────────────────────────────────────────────────────────────────┐    │
│     │ 💡 Новое! Экспорт в PDF теперь доступен           [Попробовать]│    │
│     └─────────────────────────────────────────────────────────────────┘    │
│                                                                             │
│  4. PULSE (animated dot):                                                   │
│     ┌──────────┐                                                           │
│     │ Filter 🔴│  ← пульсирующая точка привлекает внимание                │
│     └──────────┘                                                           │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Acceptance Criteria:**
- [ ] Hints не блокируют основной UI
- [ ] Можно продолжать работать пока hint виден
- [ ] Skip/dismiss доступен всегда
- [ ] "Отключить все подсказки" в Settings
- [ ] Hints tracked: показан ли данный hint пользователю (не показывать повторно)
- [ ] Maximum 1 hint видимый одновременно

---

### US-1: Contextual Tooltips

**As a** новый пользователь
**I want** видеть подсказки при первом взаимодействии с элементом
**So that** понимаю что это такое и как использовать

**Triggers:**
| Element | Trigger | Tooltip Content |
|---------|---------|-----------------|
| FVI Badge | First view | "FVI показывает ценность для вашей семьи. Тапните для деталей." |
| Foreclosure % | First view | "Вероятность получить property. 85%+ = высокий шанс." |
| Filter button | First tap | "Фильтры помогут найти идеальный foreclosure." |
| Annotation tool | First long press | "Отметьте важные детали на фото." |
| Family indicator | First see | "Кто-то из семьи уже смотрел эту property!" |
| Export PDF | First view details | "Экспортируйте карточку для offline анализа." |

**Acceptance Criteria:**
- [ ] Tooltip показывается ОДИН раз (tracked в UserPreferences)
- [ ] Tooltip не блокирует действие пользователя
- [ ] "Больше не показывать" опция доступна
- [ ] Tooltips стилизованы под app design (не системные)
- [ ] Максимум 1 tooltip за сессию (не раздражать)

---

### US-2: Feature Discovery Nudges

**As a** пользователь который не использует какую-то функцию
**I want** узнать о ней в подходящий момент
**So that** получаю максимум от приложения

**Discovery Rules:**
| Feature | Trigger Condition | Nudge |
|---------|-------------------|-------|
| Expert Mode | 50 swipes in Beginner | "Готовы к большему? Попробуйте Expert режим!" |
| Annotation | 10 likes, 0 annotations | "Отмечайте детали на фото для семьи!" |
| Foreclosure Filter | 5 sessions, filter never used | "Включите foreclosure фильтр для лучших deals!" |
| PDF Export | 3 detailed views, 0 exports | "Сохраните карточку для offline анализа!" |
| Family Board | 5 likes, never visited board | "Посмотрите что нашли другие члены семьи!" |

**Acceptance Criteria:**
- [ ] Nudges показываются в natural breaks (между свайпами)
- [ ] Не более 1 nudge за сессию
- [ ] "Понятно" / "Попробовать" / "Не сейчас" опции
- [ ] Dismissed nudges не показываются повторно (или через 7 дней)

---

### US-3: Learning Modules (Deep Tutorials)

**As a** пользователь желающий стать экспертом
**I want** пройти структурированное обучение
**So that** использую все возможности приложения

**Modules:**
```
📚 LEARNING CENTER
├── 🎯 Basics (обязательный для новичков)
│   ├── Lesson 1: Что такое Tax Lien / Tax Deed
│   ├── Lesson 2: Свайпы и навигация
│   └── Lesson 3: Понимание карточки property
│
├── 🔍 Foreclosure Hunting (для Miw)
│   ├── Lesson 1: Что такое Foreclosure Probability
│   ├── Lesson 2: Использование фильтров
│   ├── Lesson 3: Признаки хорошего foreclosure
│   └── Lesson 4: Due Diligence checklist
│
├── 🎨 Expert Annotations (для экспертов)
│   ├── Lesson 1: Зачем нужны аннотации
│   ├── Lesson 2: Инструменты (точки, линии, области)
│   ├── Lesson 3: Голосовые заметки
│   └── Lesson 4: Collaboration с семьей
│
├── 📊 FVI / ИПП Mastery
│   ├── Lesson 1: Что такое Family Value Index
│   ├── Lesson 2: Как формируется Personal Value
│   ├── Lesson 3: Роли экспертов (Khun Pho, Denis, etc.)
│   └── Lesson 4: Использование FVI для решений
│
├── 🏠 Property Analysis (для Denis/Khun Pho)
│   ├── Lesson 1: Оценка состояния дома по фото
│   ├── Lesson 2: Red flags (фундамент, крыша)
│   ├── Lesson 3: Hidden value indicators
│   └── Lesson 4: Renovation scope estimation
│
└── 💼 Investment Strategy (advanced)
    ├── Lesson 1: Tax Lien vs Tax Deed
    ├── Lesson 2: Lien states vs Deed states
    ├── Lesson 3: OTC opportunities
    └── Lesson 4: Portfolio strategy
```

**Lesson Format:**
```
┌─────────────────────────────────────────────────────────────────────────────┐
│  📚 Lesson 2: Использование фильтров                           [Progress]  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  [📹 Short Video or Animation - 30 sec]                                    │
│                                                                             │
│  Фильтры помогают найти идеальный foreclosure:                             │
│                                                                             │
│  • **Foreclosure %** - вероятность получить property                       │
│    Рекомендуем: 70%+                                                       │
│                                                                             │
│  • **Price Range** - максимальная цена lien                                │
│    Для Miw: $150-$500                                                      │
│                                                                             │
│  • **Prior Years** - сколько лет не платили                                │
│    Больше лет = выше шанс foreclosure                                      │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  💡 Pro Tip: Включите "Foreclosure Only" для лучших результатов     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  [Try It Now →]    [Mark as Complete]    [Skip]                            │
│                                                                             │
│  ● ● ● ○ ○                                                                 │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Acceptance Criteria:**
- [ ] Модули доступны из Settings → Learning Center
- [ ] Progress сохраняется между сессиями
- [ ] "Try It Now" переводит в приложение с подсветкой элемента
- [ ] Completion дает achievement badge

---

### US-4: Achievement System (Gamification)

**As a** пользователь
**I want** получать награды за прогресс
**So that** мотивирован продолжать использовать приложение

**Achievements:**
| Category | Achievement | Trigger | Badge |
|----------|-------------|---------|-------|
| **Onboarding** | First Steps | Complete onboarding | 🎯 |
| | Explorer | Visit all screens | 🗺️ |
| **Swipes** | Swiper | 10 swipes | 👆 |
| | Power Swiper | 100 swipes | 💪 |
| | Swipe Master | 1000 swipes | 🏆 |
| **Likes** | Collector | 10 likes | ❤️ |
| | Curator | 50 likes | 🎨 |
| | Connoisseur | 200 likes | 👑 |
| **Annotations** | First Mark | 1 annotation | ✏️ |
| | Detail Spotter | 10 annotations | 🔍 |
| | Expert Eye | 50 annotations | 👁️ |
| **Learning** | Student | Complete 1 module | 📖 |
| | Scholar | Complete 3 modules | 📚 |
| | Master | Complete all modules | 🎓 |
| **Special** | Family Player | View Family Board | 👨‍👩‍👧 |
| | Foreclosure Hunter | Filter ON + 10 likes | 🎯 |
| | PDF Pro | Export 5 PDFs | 📄 |
| | Offline Ready | Use offline mode | 📴 |

**Acceptance Criteria:**
- [ ] Achievements показываются как toast при получении
- [ ] Profile screen показывает все badges
- [ ] Locked achievements видны с условием разблокировки
- [ ] Share achievement в social media (optional)

---

### US-5: Interactive Guides (Coach Marks)

**As a** пользователь переключившийся в Expert mode
**I want** пройти guided tour по новым функциям
**So that** быстро освою advanced возможности

**Guided Tours:**

**Tour 1: Expert Mode Introduction**
```
Step 1: "Теперь свайп влево показывает контекст (историю property)"
        [Highlight: Card area]

Step 2: "Свайп вправо открывает детальные фото"
        [Highlight: Card area]

Step 3: "Like/Pass теперь через кнопки внизу"
        [Highlight: Action buttons]

Step 4: "Long press включает режим аннотаций"
        [Highlight: Card image]
```

**Tour 2: Annotation Tools**
```
Step 1: "Выберите инструмент: точка, линия или область"
        [Highlight: Toolbar]

Step 2: "Нарисуйте на фото"
        [Interactive: User draws]

Step 3: "Добавьте категорию или комментарий"
        [Highlight: Tag selector]

Step 4: "Ваши заметки увидит вся семья!"
        [Show: Family sync indicator]
```

**Acceptance Criteria:**
- [ ] Tours запускаются автоматически при первом входе в режим
- [ ] Spotlight эффект на текущем элементе
- [ ] Skip / Next / Back навигация
- [ ] Можно перезапустить из Settings

---

### US-6: Help Center

**As a** пользователь
**I want** найти ответ на вопрос в любой момент
**So that** не застреваю на проблемах

**Help Structure:**
```
❓ HELP CENTER
├── 🔍 Search (full-text)
│
├── 📱 App Basics
│   ├── Как свайпать
│   ├── Что означают цвета
│   ├── Beginner vs Expert mode
│   └── Как сменить регион
│
├── 🏠 Properties
│   ├── Что такое foreclosure
│   ├── Как читать карточку
│   ├── Что такое FVI/ИПП
│   └── Как экспортировать PDF
│
├── 🎨 Annotations
│   ├── Как отмечать детали
│   ├── Типы инструментов
│   └── Голосовые заметки
│
├── 👨‍👩‍👧 Family Features
│   ├── Как работает Family Board
│   ├── Как видеть чужие отметки
│   └── Как приглашать членов семьи
│
├── 💰 Tax Liens & Deeds
│   ├── Что такое Tax Lien
│   ├── Что такое Tax Deed
│   ├── Разница между ними
│   └── Как купить
│
└── ⚙️ Settings & Account
    ├── Как сменить режим
    ├── Offline mode
    └── Уведомления
```

**Acceptance Criteria:**
- [ ] Help доступен из любого экрана (? icon)
- [ ] Contextual help: при открытии из details → показать раздел Properties
- [ ] Search по всем статьям
- [ ] Offline доступ к Help content

---

### US-7: Skill Progression System

**As a** пользователь
**I want** видеть свой прогресс в освоении приложения
**So that** понимаю куда двигаться дальше

**Skill Levels:**
```
📊 YOUR SKILL PROFILE
├── Swipe Mastery:      ████████░░ 80%
├── Annotation Skills:  ███░░░░░░░ 30%
├── Filter Expert:      █████░░░░░ 50%
├── Family Collaborator:██░░░░░░░░ 20%
└── Investment Knowledge:████░░░░░░ 40%

🎯 NEXT MILESTONE: Complete "Annotation Tools" module to level up!
```

**Acceptance Criteria:**
- [ ] Skills показываются в Profile
- [ ] Level up notification при достижении milestone
- [ ] Recommendations для улучшения weak skills

---

## Wireframes

### Tooltip Design
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│     ┌───────────────────────────────────────┐                              │
│     │  [FVI: 85]                            │                              │
│     └───────────────────────────────────────┘                              │
│              │                                                              │
│              ▼                                                              │
│     ┌───────────────────────────────────────┐                              │
│     │ 💡 FVI показывает ценность для        │                              │
│     │    вашей семьи. Тапните для деталей.  │                              │
│     │                                        │                              │
│     │ [Понятно]  [Больше не показывать]     │                              │
│     └───────────────────────────────────────┘                              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Achievement Toast
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                                                                      │   │
│  │   🎉 Achievement Unlocked!                                          │   │
│  │                                                                      │   │
│  │   🏆 POWER SWIPER                                                   │   │
│  │   You've swiped 100 properties!                                     │   │
│  │                                                                      │   │
│  │   [View All Achievements]                    [Dismiss]              │   │
│  │                                                                      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Learning Center
```
┌─────────────────────────────────────────────────────────────────────────────┐
│  ←  Learning Center                                                         │
│                                                                             │
│  YOUR PROGRESS                                                              │
│  ████████░░░░░░░░░░░░ 40%                                                  │
│  8 of 20 lessons completed                                                  │
│                                                                             │
│  ─────────────────────────────────────────────────────────────────────────  │
│                                                                             │
│  📚 MODULES                                                                 │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ 🎯 Basics                                    ✅ Complete            │   │
│  │    3/3 lessons                                                      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ 🔍 Foreclosure Hunting                       ⏳ In Progress         │   │
│  │    2/4 lessons                                █████░░░              │   │
│  │                                                                      │   │
│  │    → Continue: "Признаки хорошего foreclosure"                      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ 🎨 Expert Annotations                        🔒 Locked              │   │
│  │    Requires: Expert Mode enabled                                    │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ 📊 FVI / ИПП Mastery                        ○ Not Started           │   │
│  │    0/4 lessons                                                      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Technical Constraints

- **Storage:** UserPreferences для tracked tooltips/achievements
- **Analytics:** Integration с Firebase Analytics для progress tracking
- **Offline:** Help content должен быть доступен offline
- **Localization:** Весь контент должен быть локализуем

---

## Dependencies

- `sdd-taxlien-swipe-app-onboarding` - должен быть завершен (является prerequisite)
- `sdd-taxlien-swipe-app-localizations` - для перевода tutorial content
- `sdd-taxlien-swipe-app-firebaseanalytics` - для tracking progress

---

## Out of Scope (This Iteration)

- Video tutorials (только text + images + animations)
- Peer-to-peer learning (tips from other users)
- AI-powered personalized recommendations
- Certification / quiz system
- Social sharing of achievements beyond basic

---

## Open Questions

- [ ] Нужны ли push notifications для nudges или только in-app?
- [ ] Сколько achievements показывать в Profile?
- [ ] Нужна ли leaderboard (семейный или глобальный)?
- [ ] Какой формат контента для lessons (markdown, HTML, native)?

---

## References

- `sdd-taxlien-swipe-app-onboarding` - Mini-tutorial reference
- `sdd-miw-gift` - Expert profiles, FVI concept
- Best practices: Duolingo, Headspace onboarding

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
