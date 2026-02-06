// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'TaxLien Swipe';

  @override
  String get profileTitle => 'विशेषज्ञ प्रोफ़ाइल';

  @override
  String get language => 'भाषा';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get roles => 'भूमिकाएं';

  @override
  String get switchProfile => 'प्रोफ़ाइल बदलें';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get startOver => 'फिर से शुरू करें';

  @override
  String get noMoreProperties => 'कोई और संपत्ति नहीं!';

  @override
  String get checkBackLater => 'नई लिस्टिंग के लिए बाद में वापस आएं';

  @override
  String get dailyLimitReached => 'दैनिक सीमा समाप्त';

  @override
  String get maybeLater => 'बाद में';

  @override
  String get upgradeNow => 'अभी अपग्रेड करें';

  @override
  String get expert => 'विशेषज्ञ';

  @override
  String get foreclosureMode => 'फोरक्लोज़र मोड';

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
