// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'TaxLien Swipe';

  @override
  String get profileTitle => 'Профиль эксперта';

  @override
  String get language => 'Язык';

  @override
  String get settings => 'Настройки';

  @override
  String get roles => 'Роли';

  @override
  String get switchProfile => 'Сменить профиль';

  @override
  String get retry => 'Повторить';

  @override
  String get startOver => 'Начать заново';

  @override
  String get noMoreProperties => 'Объекты закончились!';

  @override
  String get checkBackLater => 'Зайдите позже для новых объявлений';

  @override
  String get dailyLimitReached => 'Дневной лимит исчерпан';

  @override
  String get maybeLater => 'Возможно позже';

  @override
  String get upgradeNow => 'Обновить сейчас';

  @override
  String get expert => 'Эксперт';

  @override
  String get foreclosureMode => 'Режим Foreclosure';

  @override
  String get hintFviTitle => 'FVI';

  @override
  String get hintFviBody =>
      'FVI shows value for your family. Tap the badge for details.';

  @override
  String get hintForeclosureTitle => 'Foreclosure %';

  @override
  String get hintForeclosureBody =>
      'Probability of acquiring the property. 85%+ = high chance.';

  @override
  String get hintFilterTitle => 'Filters';

  @override
  String get hintFilterBody =>
      'Use filters to find the best foreclosure matches.';

  @override
  String get hintGotIt => 'Got it';

  @override
  String get hintDontShowAgain => 'Don\'t show again';

  @override
  String get disableAllHints => 'Disable all hints';

  @override
  String get showHints => 'Show hints';
}
