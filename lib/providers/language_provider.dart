// providers/language_provider.dart

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  // Public so `main()` can read the same key when pre-loading.
  static const String languageKey = 'app_language';
  static const String defaultLanguage = 'en';

  String _currentLanguage;
  bool _isLoaded;

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

  /// True once the saved preference has been loaded from disk.
  /// Useful for showing a splash gate until language is ready.
  bool get isLoaded => _isLoaded;

  // ── Constructor ────────────────────────────────────────────────
  // Allows pre-loading from `main()` so the first frame uses the
  // correct language. If `initialLoaded` is false (default), falls
  // back to async loading for backwards compatibility.
  LanguageProvider({
    String initialLanguage = defaultLanguage,
    bool initialLoaded = false,
  }) : _currentLanguage = initialLanguage,
       _isLoaded = initialLoaded {
    if (!_isLoaded) {
      _loadLanguage();
    }
  }

  // ── Load saved language from SharedPreferences ─────────────────
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(languageKey);

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

      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      _currentLanguage = defaultLanguage;
      _isLoaded = true;
      notifyListeners();
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
      await prefs.setString(languageKey, languageCode);
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
