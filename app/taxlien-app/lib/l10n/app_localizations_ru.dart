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
      'FVI показывает ценность для вашей семьи. Нажмите на значок для деталей.';

  @override
  String get hintForeclosureTitle => '% Foreclosure';

  @override
  String get hintForeclosureBody =>
      'Вероятность приобретения объекта. 85%+ = высокая вероятность.';

  @override
  String get hintFilterTitle => 'Фильтры';

  @override
  String get hintFilterBody =>
      'Используйте фильтры для лучших совпадений по foreclosure.';

  @override
  String get hintGotIt => 'Понятно';

  @override
  String get hintDontShowAgain => 'Больше не показывать';

  @override
  String get disableAllHints => 'Отключить все подсказки';

  @override
  String get showHints => 'Показывать подсказки';

  @override
  String get nudgeExpertModeTitle => 'Готовы к большему?';

  @override
  String get nudgeExpertModeBody =>
      'Попробуйте режим Эксперт для дополнительного контроля.';

  @override
  String get nudgeAnnotationTitle => 'Пометки';

  @override
  String get nudgeAnnotationBody => 'Добавляйте пометки на фото для семьи.';

  @override
  String get nudgeForeclosureFilterTitle => 'Сузьте поиск';

  @override
  String get nudgeForeclosureFilterBody =>
      'Используйте фильтр foreclosure для лучших совпадений.';

  @override
  String get nudgeFamilyBoardTitle => 'Что нашла семья';

  @override
  String get nudgeFamilyBoardBody => 'Смотрите общую доску семьи с объектами.';

  @override
  String get nudgeTryIt => 'Попробовать';

  @override
  String get nudgeNotNow => 'Не сейчас';

  @override
  String get nudgeDefaultTitle => 'Подсказка';

  @override
  String get nudgeDefaultBody => 'Попробуйте эту функцию.';

  @override
  String get dealDetective => 'DEAL DETECTIVE';

  @override
  String get welcomeSubtitle => 'Найдите объекты foreclosure\nпо лучшей цене';

  @override
  String get startSetup => 'Начать настройку';

  @override
  String get orDivider => 'или';

  @override
  String get skipKnowSwipe => 'Я уже знаю как свайпать';

  @override
  String get hintsOff => 'Подсказки выключены';

  @override
  String get tapToTurnOffHints => 'Нажмите, чтобы отключить все подсказки';

  @override
  String get expertProfileSwitcher => 'Переключатель профиля эксперта';

  @override
  String get rolesList => 'Роли: Khun Pho, Denis, Anton, Vasilisa';

  @override
  String get account => 'Аккаунт';

  @override
  String get notSignedIn => 'Не выполнен вход';

  @override
  String get signIn => 'Войти';

  @override
  String get signOut => 'Выйти';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get signedOut => 'Вы вышли';

  @override
  String get deleteAccountConfirm =>
      'Вы уверены? Это удалит ваш аккаунт и облачные данные. Локальные данные могут сохраниться.';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get accountDeleted => 'Аккаунт удалён';

  @override
  String get signInAgain => 'Войдите снова';

  @override
  String get deleteAccountSignInAgain =>
      'Чтобы удалить аккаунт, выйдите, затем снова войдите и нажмите «Удалить аккаунт».';

  @override
  String get ok => 'OK';

  @override
  String get couldNotDeleteAccount =>
      'Не удалось удалить аккаунт. Попробуйте снова.';

  @override
  String get achievements => 'Достижения';

  @override
  String get undoLimitReached => 'Достигнут лимит отмен';

  @override
  String get upgradeToPremium => 'Перейти на Premium';

  @override
  String resetIn(String time) {
    return 'Сброс через: $time';
  }

  @override
  String get foreclosureModeOn => 'Режим Foreclosure: ВКЛ';

  @override
  String get foreclosureModeOff => 'Режим Foreclosure: ВЫКЛ';
}
