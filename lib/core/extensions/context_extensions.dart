// extensions/context_extensions.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';
import '../utils/app_localizations.dart';

extension ContextExtensions on BuildContext {
  // ══════════════════════════════════════════════════════════════
  // Short forms (used everywhere)
  // ══════════════════════════════════════════════════════════════

  /// Plain translation.
  ///
  /// Example: `context.t('my_cart')`
  String t(String key) {
    try {
      final languageProvider = Provider.of<LanguageProvider>(
        this,
        listen: false,
      );
      return AppLocalizations.translate(
        key,
        locale: languageProvider.currentLanguage,
      );
    } catch (_) {
      return AppLocalizations.translate(key, locale: 'en');
    }
  }

  /// Translation with `{placeholder}` substitution.
  ///
  /// Example: `context.tp('items_count', {'count': '3'})`
  String tp(String key, Map<String, String> params) {
    try {
      final languageProvider = Provider.of<LanguageProvider>(
        this,
        listen: false,
      );
      return AppLocalizations.translateWithParams(
        key,
        params,
        locale: languageProvider.currentLanguage,
      );
    } catch (_) {
      return AppLocalizations.translateWithParams(key, params, locale: 'en');
    }
  }

  /// Pluralization helper.
  ///
  /// Example: `context.tn('items_count', 3)`
  String tn(String key, int count) {
    try {
      final languageProvider = Provider.of<LanguageProvider>(
        this,
        listen: false,
      );
      return AppLocalizations.plural(
        key,
        count,
        locale: languageProvider.currentLanguage,
      );
    } catch (_) {
      return AppLocalizations.plural(key, count, locale: 'en');
    }
  }

  // ══════════════════════════════════════════════════════════════
  // Long forms (older call sites; keep for backwards compatibility)
  // ══════════════════════════════════════════════════════════════

  String trWithParams(String key, Map<String, String> params) {
    try {
      final languageProvider = Provider.of<LanguageProvider>(
        this,
        listen: false,
      );
      return AppLocalizations.translateWithParams(
        key,
        params,
        locale: languageProvider.currentLanguage,
      );
    } catch (_) {
      return AppLocalizations.translateWithParams(key, params, locale: 'en');
    }
  }

  /// Safe version for callbacks — same as `t`, kept for legacy code.
  String trSafe(String key) => t(key);

  String trWithParamsSafe(String key, Map<String, String> params) =>
      tp(key, params);
}
