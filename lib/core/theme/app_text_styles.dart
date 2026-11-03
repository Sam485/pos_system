// core/theme/app_text_styles.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  // ══════════════════════════════════════════════════════════════
  // Font families — both declared in pubspec.yaml.
  // ══════════════════════════════════════════════════════════════
  static const String _latinFamily = 'PlusJakartaSans';
  static const String _khmerFamily = 'Battambang'; // 👈 changed

  /// Picks the right family for the active language.
  static String familyFor(String languageCode) =>
      languageCode == 'km' ? _khmerFamily : _latinFamily;

  /// Central TextStyle factory.
  static TextStyle _s(
    String languageCode, {
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: familyFor(languageCode),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  // ══════════════════════════════════════════════════════════════
  // Static getters — ENGLISH fallbacks.
  // ══════════════════════════════════════════════════════════════
  static TextStyle get displayLarge => displayLargeFor('en');
  static TextStyle get displayMedium => displayMediumFor('en');
  static TextStyle get heading1 => heading1For('en');
  static TextStyle get heading2 => heading2For('en');
  static TextStyle get bodyLarge => bodyLargeFor('en');
  static TextStyle get bodyMedium => bodyMediumFor('en');
  static TextStyle get bodySmall => bodySmallFor('en');
  static TextStyle get labelMedium => labelMediumFor('en');
  static TextStyle get labelSmall => labelSmallFor('en');
  static TextStyle get price => priceFor('en');
  static TextStyle get priceLarge => priceLargeFor('en');
  static TextStyle get priceOld => priceOldFor('en');
  static TextStyle get bannerTitle => bannerTitleFor('en');
  static TextStyle get bannerSubtitle => bannerSubtitleFor('en');

  // ══════════════════════════════════════════════════════════════
  // Language-aware getters
  // ══════════════════════════════════════════════════════════════
  static TextStyle displayLargeFor(String lang) => _s(
    lang,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.28,
    letterSpacing: -0.4,
  );

  static TextStyle displayMediumFor(String lang) => _s(
    lang,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle heading1For(String lang) => _s(
    lang,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2For(String lang) => _s(
    lang,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLargeFor(String lang) => _s(
    lang,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMediumFor(String lang) => _s(
    lang,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmallFor(String lang) => _s(
    lang,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle labelMediumFor(String lang) => _s(
    lang,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle labelSmallFor(String lang) => _s(
    lang,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle priceFor(String lang) => _s(
    lang,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle priceLargeFor(String lang) => _s(
    lang,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryCoral,
  );

  static TextStyle priceOldFor(String lang) => _s(
    lang,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle bannerTitleFor(String lang) => _s(
    lang,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textLight,
    height: 1.2,
  );

  static TextStyle bannerSubtitleFor(String lang) => _s(
    lang,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight.withValues(alpha: 0.8),
    height: 1.4,
  );

  // ══════════════════════════════════════════════════════════════
  // Theme-aware variants
  // ══════════════════════════════════════════════════════════════
  static TextStyle displayLargeOn(String lang, Color color) =>
      displayLargeFor(lang).copyWith(color: color);

  static TextStyle displayMediumOn(String lang, Color color) =>
      displayMediumFor(lang).copyWith(color: color);

  static TextStyle heading1On(String lang, Color color) =>
      heading1For(lang).copyWith(color: color);

  static TextStyle heading2On(String lang, Color color) =>
      heading2For(lang).copyWith(color: color);

  static TextStyle bodyLargeOn(String lang, Color color) =>
      bodyLargeFor(lang).copyWith(color: color);

  static TextStyle bodyMediumOn(String lang, Color color) =>
      bodyMediumFor(lang).copyWith(color: color);

  static TextStyle bodySmallOn(String lang, Color color) =>
      bodySmallFor(lang).copyWith(color: color);

  static TextStyle labelMediumOn(String lang, Color color) =>
      labelMediumFor(lang).copyWith(color: color);

  static TextStyle labelSmallOn(String lang, Color color) =>
      labelSmallFor(lang).copyWith(color: color);

  static TextStyle priceOn(String lang, Color color) =>
      priceFor(lang).copyWith(color: color);

  static TextStyle priceLargeOn(String lang, Color color) =>
      priceLargeFor(lang).copyWith(color: color);

  static TextStyle priceOldOn(String lang, Color color) =>
      priceOldFor(lang).copyWith(color: color);

  static TextStyle bannerTitleOn(String lang, Color color) =>
      bannerTitleFor(lang).copyWith(color: color);

  static TextStyle bannerSubtitleOn(String lang, Color color) =>
      bannerSubtitleFor(lang).copyWith(color: color);
}
