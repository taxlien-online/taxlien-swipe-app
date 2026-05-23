import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_constants.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _languageCodeKey = 'language_code';
  
  Locale? _locale;

  Locale get locale {
    return _locale ?? const Locale('en');
  }

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey);
    
    if (languageCode != null) {
      _locale = Locale(languageCode);
    } else {
      // Fallback to system locale if supported
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      if (isSupported(systemLocale)) {
        _locale = Locale(systemLocale.languageCode);
      } else {
        _locale = const Locale('en');
      }
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (!isSupported(locale)) return;

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, locale.languageCode);
  }

  bool isSupported(Locale locale) {
    return LanguageConstants.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }
}
