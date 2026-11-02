// core/theme/app_text_style_x.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_styles.dart';
import 'package:pos_system/providers/language_provider.dart';

class AppTextStylesX {
  final BuildContext context;
  const AppTextStylesX(this.context);

  AppThemeColors get colors =>
      Theme.of(context).extension<AppThemeColors>() ?? AppThemeColors.light;

  /// Active language code — 'en' or 'km'. Every getter below
  /// asks the AppTextStyles factory for the right font family.
  String get _lang => context.read<LanguageProvider>().currentLanguage;

  TextStyle get displayLarge =>
      AppTextStyles.displayLargeOn(_lang, colors.textPrimary);
  TextStyle get displayMedium =>
      AppTextStyles.displayMediumOn(_lang, colors.textPrimary);

  TextStyle get heading1 => AppTextStyles.heading1On(_lang, colors.textPrimary);
  TextStyle get heading2 => AppTextStyles.heading2On(_lang, colors.textPrimary);

  TextStyle get bodyLarge =>
      AppTextStyles.bodyLargeOn(_lang, colors.textPrimary);
  TextStyle get bodyMedium =>
      AppTextStyles.bodyMediumOn(_lang, colors.textPrimary);
  TextStyle get bodySmall =>
      AppTextStyles.bodySmallOn(_lang, colors.textSecondary);

  TextStyle get labelMedium =>
      AppTextStyles.labelMediumOn(_lang, colors.textPrimary);
  TextStyle get labelSmall =>
      AppTextStyles.labelSmallOn(_lang, colors.textSecondary);

  TextStyle get price => AppTextStyles.priceOn(_lang, colors.textPrimary);
  TextStyle get priceLarge =>
      AppTextStyles.priceLargeOn(_lang, colors.primaryCoral);
  TextStyle get priceOld => AppTextStyles.priceOldOn(_lang, colors.textMuted);

  TextStyle get bannerTitle =>
      AppTextStyles.bannerTitleOn(_lang, colors.textLight);
  TextStyle get bannerSubtitle => AppTextStyles.bannerSubtitleOn(
    _lang,
    colors.textLight.withValues(alpha: 0.8),
  );
}
