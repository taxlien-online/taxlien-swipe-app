// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'TaxLien Swipe';

  @override
  String get profileTitle => '专家个人资料';

  @override
  String get language => '语言';

  @override
  String get settings => '设置';

  @override
  String get roles => '角色';

  @override
  String get switchProfile => '切换个人资料';

  @override
  String get retry => '重试';

  @override
  String get startOver => '重新开始';

  @override
  String get noMoreProperties => '没有更多房产！';

  @override
  String get checkBackLater => '稍后回来查看新列表';

  @override
  String get dailyLimitReached => '达到每日限制';

  @override
  String get maybeLater => '以后再说';

  @override
  String get upgradeNow => '现在升级';

  @override
  String get expert => '专家';

  @override
  String get foreclosureMode => '法拍模式';

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
