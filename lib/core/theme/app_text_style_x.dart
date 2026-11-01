// core/theme/app_text_style_x.dart

import 'package:flutter/material.dart';

import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_styles.dart';

class AppTextStylesX {
  final BuildContext context;
  const AppTextStylesX(this.context);

  AppThemeColors get colors =>
      Theme.of(context).extension<AppThemeColors>() ?? AppThemeColors.light;

  TextStyle get displayLarge =>
      AppTextStyles.displayLargeOn(colors.textPrimary);
  TextStyle get displayMedium =>
      AppTextStyles.displayMediumOn(colors.textPrimary);

  TextStyle get heading1 => AppTextStyles.heading1On(colors.textPrimary);
  TextStyle get heading2 => AppTextStyles.heading2On(colors.textPrimary);

  TextStyle get bodyLarge => AppTextStyles.bodyLargeOn(colors.textPrimary);
  TextStyle get bodyMedium => AppTextStyles.bodyMediumOn(colors.textPrimary);
  TextStyle get bodySmall => AppTextStyles.bodySmallOn(colors.textSecondary);

  TextStyle get labelMedium => AppTextStyles.labelMediumOn(colors.textPrimary);
  TextStyle get labelSmall => AppTextStyles.labelSmallOn(colors.textSecondary);

  TextStyle get price => AppTextStyles.priceOn(colors.textPrimary);
  TextStyle get priceLarge => AppTextStyles.priceLargeOn(colors.primaryCoral);
  TextStyle get priceOld => AppTextStyles.priceOldOn(colors.textMuted);

  TextStyle get bannerTitle => AppTextStyles.bannerTitleOn(colors.textLight);
  TextStyle get bannerSubtitle =>
      AppTextStyles.bannerSubtitleOn(colors.textLight.withValues(alpha: 0.8));
}
