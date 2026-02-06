import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:taxlien_swipe_app/l10n/app_localizations.dart';

/// Default locale for widget tests so results are independent of host system locale.
const Locale kTestLocaleEn = Locale('en');

/// Localization delegates for use in test MaterialApp / MaterialApp.router.
const List<LocalizationsDelegate<dynamic>> kTestLocalizationsDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

/// Wraps [child] in a [MaterialApp] with English locale and full localization.
/// Use in widget tests so that [AppLocalizations.of(context)] and locale-dependent
/// UI behave consistently (English) regardless of the host machine locale.
Widget wrapWithMaterialApp({
  required Widget child,
  Locale locale = kTestLocaleEn,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: kTestLocalizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}
