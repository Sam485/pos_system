// providers/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String themeKey = 'app_theme_mode';

  static const ThemeMode defaultThemeMode = ThemeMode.system;

  ThemeMode _themeMode;
  bool _isLoaded;

  ThemeProvider({
    ThemeMode initialMode = defaultThemeMode,
    bool initialLoaded = false,
  }) : _themeMode = initialMode,
       _isLoaded = initialLoaded {
    // If not already pre-loaded, fall back to the async load.
    // This keeps backwards compatibility — any existing caller that
    // does `ThemeProvider()` still works and loads from disk.
    if (!_isLoaded) {
      _loadTheme();
    }
  }

  // ── Getters ────────────────────────────────────────────────────
  ThemeMode get themeMode => _themeMode;
  bool get isLoaded => _isLoaded;
  bool get isLight => _themeMode == ThemeMode.light;
  bool get isDark => _themeMode == ThemeMode.dark;
  bool get isSystem => _themeMode == ThemeMode.system;

  bool isDarkActive(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
  }

  // ── Load saved theme from SharedPreferences ────────────────────
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(themeKey);

      if (saved != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (m) => m.name == saved,
          orElse: () => defaultThemeMode,
        );
      } else {
        await _saveTheme(_themeMode);
      }

      _isLoaded = true;
      notifyListeners();
    } catch (_) {
      _themeMode = defaultThemeMode;
      _isLoaded = true;
      notifyListeners();
    }
  }

  // ── Change theme ───────────────────────────────────────────────
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _saveTheme(mode);
    notifyListeners();
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(themeKey, mode.name);
    } catch (_) {}
  }

  // ── Convenience methods ────────────────────────────────────────
  Future<void> toggleDarkMode(bool enabled) async {
    await setThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> cycleThemeMode() async {
    final next = switch (_themeMode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
      ThemeMode.system => ThemeMode.light,
    };
    await setThemeMode(next);
  }

  Future<void> resetToDefault() async {
    await setThemeMode(defaultThemeMode);
  }
}
