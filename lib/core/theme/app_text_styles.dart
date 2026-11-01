import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  // ══════════════════════════════════════════════════════════════
  // Static getters — LIGHT THEME fallbacks.
  //
  // These keep working exactly like before so you can migrate screens
  // gradually. On a dark-mode screen they'll render with light colors
  // until you switch to `context.text.<style>`.
  // ══════════════════════════════════════════════════════════════

  // ── Display ──────────────────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.28,
    letterSpacing: -0.4,
  );

  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ── Headings ─────────────────────────────────────────────────
  static TextStyle get heading1 => GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get heading2 => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // ── Body ─────────────────────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ── Label ────────────────────────────────────────────────────
  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ── Price ────────────────────────────────────────────────────
  static TextStyle get price => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get priceLarge => GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryCoral,
  );

  static TextStyle get priceOld => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    decoration: TextDecoration.lineThrough,
  );

  // ── Banner (text on dark gradients) ──────────────────────────
  static TextStyle get bannerTitle => GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textLight,
    height: 1.2,
  );

  static TextStyle get bannerSubtitle => GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight.withValues(alpha: 0.8),
    height: 1.4,
  );

  // ══════════════════════════════════════════════════════════════
  // THEME-AWARE variants — pass in the desired color.
  //
  // Use these when you want text that responds to the current theme:
  //
  //   final colors = context.colors;
  //   Text('Hi', style: AppTextStyles.heading1On(colors.textPrimary))
  //
  // Or, more conveniently, use the `context.text` extension below.
  // ══════════════════════════════════════════════════════════════

  static TextStyle displayLargeOn(Color color) =>
      displayLarge.copyWith(color: color);

  static TextStyle displayMediumOn(Color color) =>
      displayMedium.copyWith(color: color);

  static TextStyle heading1On(Color color) => heading1.copyWith(color: color);

  static TextStyle heading2On(Color color) => heading2.copyWith(color: color);

  static TextStyle bodyLargeOn(Color color) => bodyLarge.copyWith(color: color);

  static TextStyle bodyMediumOn(Color color) =>
      bodyMedium.copyWith(color: color);

  static TextStyle bodySmallOn(Color color) => bodySmall.copyWith(color: color);

  static TextStyle labelMediumOn(Color color) =>
      labelMedium.copyWith(color: color);

  static TextStyle labelSmallOn(Color color) =>
      labelSmall.copyWith(color: color);

  static TextStyle priceOn(Color color) => price.copyWith(color: color);

  static TextStyle priceLargeOn(Color color) =>
      priceLarge.copyWith(color: color);

  static TextStyle priceOldOn(Color color) => priceOld.copyWith(color: color);

  static TextStyle bannerTitleOn(Color color) =>
      bannerTitle.copyWith(color: color);

  static TextStyle bannerSubtitleOn(Color color) =>
      bannerSubtitle.copyWith(color: color);
}
