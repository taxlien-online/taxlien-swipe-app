import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxlien_swipe_app/core/localization/language_constants.dart';
import 'package:taxlien_swipe_app/core/localization/locale_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleProvider', () {
    late LocaleProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = LocaleProvider();
    });

    test('loadSavedLocale with no prefs yields a supported locale', () async {
      await provider.loadSavedLocale();
      final supportedCodes = LanguageConstants.supportedLocales
          .map((l) => l.languageCode)
          .toList();
      expect(supportedCodes, contains(provider.locale.languageCode));
    });

    test('loadSavedLocale with language_code en yields English', () async {
      SharedPreferences.setMockInitialValues({'language_code': 'en'});
      provider = LocaleProvider();
      await provider.loadSavedLocale();
      expect(provider.locale.languageCode, 'en');
    });

    test('setLocale should update locale and persist it', () async {
      await provider.loadSavedLocale();

      const newLocale = Locale('ru');
      await provider.setLocale(newLocale);

      expect(provider.locale, newLocale);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('language_code'), 'ru');
    });

    test('setLocale should not update if locale is not supported', () async {
      await provider.loadSavedLocale();
      final initialLocale = provider.locale;

      const unsupportedLocale = Locale('fr'); // French is not in our list
      await provider.setLocale(unsupportedLocale);

      expect(provider.locale, initialLocale);
    });

    test('loadSavedLocale should restore persisted locale', () async {
      SharedPreferences.setMockInitialValues({'language_code': 'th'});

      await provider.loadSavedLocale();

      expect(provider.locale.languageCode, 'th');
    });
  });
}
