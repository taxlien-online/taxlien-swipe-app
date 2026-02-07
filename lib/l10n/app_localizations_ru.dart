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

  @override
  String get nudgeExpertModeTitle => 'Ready for more?';

  @override
  String get nudgeExpertModeBody => 'Try Expert mode for more controls.';

  @override
  String get nudgeAnnotationTitle => 'Mark it up';

  @override
  String get nudgeAnnotationBody =>
      'Add annotations on photos for your family.';

  @override
  String get nudgeForeclosureFilterTitle => 'Narrow it down';

  @override
  String get nudgeForeclosureFilterBody =>
      'Use the foreclosure filter for better matches.';

  @override
  String get nudgeFamilyBoardTitle => 'See what family found';

  @override
  String get nudgeFamilyBoardBody =>
      'Check the Family Board for shared properties.';

  @override
  String get nudgeTryIt => 'Try it';

  @override
  String get nudgeNotNow => 'Not now';
}
