import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  static const String defaultLanguage = 'en';

  String _currentLanguage = defaultLanguage;

  // Available languages
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('km', 'KH'), // Khmer
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'km': 'ភាសាខ្មែរ',
  };

  static const Map<String, String> languageCodes = {'en': 'EN', 'km': 'KH'};

  String get currentLanguage => _currentLanguage;
  Locale get currentLocale => Locale(_currentLanguage);

  LanguageProvider() {
    _loadLanguage();
  }

  // ── Load saved language from SharedPreferences ─────────────────
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);
      if (savedLanguage != null &&
          supportedLocales.any((l) => l.languageCode == savedLanguage)) {
        _currentLanguage = savedLanguage;
      } else {
        // Use device language if available, fallback to default
        final deviceLocale = PlatformDispatcher.instance.locale;
        if (supportedLocales.any(
          (l) => l.languageCode == deviceLocale.languageCode,
        )) {
          _currentLanguage = deviceLocale.languageCode;
        }
        await _saveLanguage(_currentLanguage);
      }
      notifyListeners();
    } catch (e) {
      _currentLanguage = defaultLanguage;
    }
  }

  // ── Change language ────────────────────────────────────────────
  Future<void> setLanguage(String languageCode) async {
    if (!supportedLocales.any((l) => l.languageCode == languageCode)) {
      return;
    }

    if (_currentLanguage == languageCode) return;

    _currentLanguage = languageCode;
    await _saveLanguage(languageCode);
    notifyListeners();
  }

  // ── Save language to SharedPreferences ─────────────────────────
  Future<void> _saveLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      // ignore: empty_catches
    } catch (e) {}
  }

  // ── Toggle between English and Khmer ──────────────────────────
  Future<void> toggleLanguage() async {
    final newLanguage = _currentLanguage == 'en' ? 'km' : 'en';
    await setLanguage(newLanguage);
  }

  // ── Check if current language is Khmer ────────────────────────
  bool get isKhmer => _currentLanguage == 'km';

  // ── Check if current language is English ──────────────────────
  bool get isEnglish => _currentLanguage == 'en';

  // ── Get language name for current language ────────────────────
  String get currentLanguageName =>
      languageNames[_currentLanguage] ?? 'English';

  // ── Get language code for current language ────────────────────
  String get currentLanguageCode => languageCodes[_currentLanguage] ?? 'EN';

  // ── Reset language to default ─────────────────────────────────
  Future<void> resetToDefault() async {
    await setLanguage(defaultLanguage);
  }
}
