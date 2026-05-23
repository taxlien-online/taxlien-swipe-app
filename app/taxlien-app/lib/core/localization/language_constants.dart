import 'package:flutter/material.dart';

class LanguageConstants {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('zh'),
    Locale('hi'),
    Locale('bn'),
    Locale('ru'),
    Locale('th'),
  ];

  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'zh':
        return '中文';
      case 'hi':
        return 'हिन्दी';
      case 'bn':
        return 'বাংলা';
      case 'ru':
        return 'Русский';
      case 'th':
        return 'ไทย';
      default:
        return 'English';
    }
  }
}
