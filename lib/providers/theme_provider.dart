// providers/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';

  /// Default to following the system setting on first launch.
  static const ThemeMode defaultThemeMode = ThemeMode.system;

  ThemeMode _themeMode = defaultThemeMode;
  bool _isLoaded = false;

  // ── Getters ────────────────────────────────────────────────────
  ThemeMode get themeMode => _themeMode;

  /// True once the saved preference has been loaded from disk.
  /// Useful for showing a splash screen until the theme is ready,
  /// so the app doesn't flash the wrong theme on cold start.
  bool get isLoaded => _isLoaded;

  bool get isLight => _themeMode == ThemeMode.light;
  bool get isDark => _themeMode == ThemeMode.dark;
  bool get isSystem => _themeMode == ThemeMode.system;

  /// Convenience for the App Preferences toggle — treats `system` as
  /// "whatever the OS currently reports".
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

  // ── Constructor ────────────────────────────────────────────────
  ThemeProvider() {
    _loadTheme();
  }

  // ── Load saved theme from SharedPreferences ────────────────────
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_themeKey);

      if (saved != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (m) => m.name == saved,
          orElse: () => defaultThemeMode,
        );
      } else {
        // First launch — persist the default so subsequent reads are cheap.
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

  // ── Save theme to SharedPreferences ────────────────────────────
  Future<void> _saveTheme(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.name);
    } catch (_) {
      // Ignore write errors — the in-memory value still works.
    }
  }

  // ── Convenience methods ────────────────────────────────────────
  Future<void> toggleDarkMode(bool enabled) async {
    await setThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }

  /// Cycle light → dark → system (handy for a debug button).
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
