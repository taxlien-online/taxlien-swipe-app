// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'TaxLien Swipe';

  @override
  String get profileTitle => 'โปรไฟล์ผู้เชี่ยวชาญ';

  @override
  String get language => 'ภาษา';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get roles => 'บทบาท';

  @override
  String get switchProfile => 'เปลี่ยนโปรไฟล์';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get startOver => 'เริ่มใหม่';

  @override
  String get noMoreProperties => 'ไม่มีทรัพย์สินเพิ่มเติม!';

  @override
  String get checkBackLater => 'กลับมาตรวจสอบรายการใหม่ในภายหลัง';

  @override
  String get dailyLimitReached => 'ถึงขีดจำกัดรายวันแล้ว';

  @override
  String get maybeLater => 'ไว้วันหลัง';

  @override
  String get upgradeNow => 'อัปเกรดตอนนี้';

  @override
  String get expert => 'ผู้เชี่ยวชาญ';

  @override
  String get foreclosureMode => 'โหมดบังคับคดี';

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
