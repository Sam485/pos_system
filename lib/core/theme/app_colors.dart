import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════════
// Light & Dark palette
// ══════════════════════════════════════════════════════════════════
abstract class AppColors {
  // ── Backgrounds ──────────────────────────────────────────────
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5F7FA);

  // ── Brand / Accent ───────────────────────────────────────────
  static const Color primaryCoral = Color(0xFF2674DC);
  static const Color primaryOrange = Color(0xFF162B40);
  static const Color deepGreen = Color(0xFF0F172A);
  static const Color green = Color(0xFF20826B);
  static const Color accentGreen = Color(0xFF162B40);
  static const Color lightMint = Color(0xFFEDF8F3);

  // ── Interactive Elements ─────────────────────────────────────
  static const Color searchBar = Color(0xFFF5F7FA);
  static const Color notification = Color(0xFF2674DC);
  static const Color favoriteActive = Color(0xFF2674DC);
  static const Color favoriteInactive = Color(0xFF738397);

  // ── Text ─────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF162B40);
  static const Color textSecondary = Color(0xFF526173);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF9BA8B5);

  // ── Border & Dividers ────────────────────────────────────────
  static const Color border = Color(0xFFE5EBF2);
  static const Color borderLight = Color(0xFFF0F4F8);

  // ── Nav ──────────────────────────────────────────────────────
  static const Color navBackground = Color(0xFFFFFFFF);
  static const Color navActive = Color(0xFF2674DC);
  static const Color navInactive = Color(0xFF9BA8B5);

  // ── Transparent ──────────────────────────────────────────────
  static const Color transparent = Colors.transparent;
}

// ══════════════════════════════════════════════════════════════════
// ThemeExtension — the runtime-aware palette
// ══════════════════════════════════════════════════════════════════
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  // Backgrounds
  final Color background;
  final Color cardBackground;
  final Color surfaceLight;

  // Brand / Accent
  final Color primaryCoral;
  final Color primaryOrange;
  final Color deepGreen;
  final Color green;
  final Color accentGreen;
  final Color lightMint;

  // Interactive
  final Color searchBar;
  final Color notification;
  final Color favoriteActive;
  final Color favoriteInactive;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textLight;
  final Color textMuted;

  // Border
  final Color border;
  final Color borderLight;

  // Nav
  final Color navBackground;
  final Color navActive;
  final Color navInactive;

  const AppThemeColors({
    required this.background,
    required this.cardBackground,
    required this.surfaceLight,
    required this.primaryCoral,
    required this.primaryOrange,
    required this.deepGreen,
    required this.green,
    required this.accentGreen,
    required this.lightMint,
    required this.searchBar,
    required this.notification,
    required this.favoriteActive,
    required this.favoriteInactive,
    required this.textPrimary,
    required this.textSecondary,
    required this.textLight,
    required this.textMuted,
    required this.border,
    required this.borderLight,
    required this.navBackground,
    required this.navActive,
    required this.navInactive,
  });

  // ── Light ─────────────────────────────────────────────────────
  static const AppThemeColors light = AppThemeColors(
    background: AppColors.background,
    cardBackground: AppColors.cardBackground,
    surfaceLight: AppColors.surfaceLight,

    primaryCoral: AppColors.primaryCoral,
    primaryOrange: AppColors.primaryOrange,
    deepGreen: AppColors.deepGreen,
    green: AppColors.green,
    accentGreen: AppColors.accentGreen,
    lightMint: AppColors.lightMint,

    searchBar: AppColors.searchBar,
    notification: AppColors.notification,
    favoriteActive: AppColors.favoriteActive,
    favoriteInactive: AppColors.favoriteInactive,

    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textLight: AppColors.textLight,
    textMuted: AppColors.textMuted,

    border: AppColors.border,
    borderLight: AppColors.borderLight,

    navBackground: AppColors.navBackground,
    navActive: AppColors.navActive,
    navInactive: AppColors.navInactive,
  );

  // ── Dark ──────────────────────────────────────────────────────
  static const AppThemeColors dark = AppThemeColors(
    background: Color(0xFF162B40),
    cardBackground: Color(0xFF1E344A),
    surfaceLight: Color(0xFF2A4259),

    primaryCoral: Color(0xFF2674DC),
    primaryOrange: Color(0xFF738397),
    deepGreen: Color(0xFF0B1320),
    green: Color(0xFF20826B),
    accentGreen: Color(0xFF2674DC),
    lightMint: Color(0xFF1E344A),

    searchBar: Color(0xFF1E344A),
    notification: Color(0xFF2674DC),
    favoriteActive: Color(0xFF2674DC),
    favoriteInactive: Color(0xFF738397),

    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFEDF5FF),
    textLight: Color(0xFFFFFFFF),
    textMuted: Color(0xFF738397),

    border: Color(0xFF2A4259),
    borderLight: Color(0xFF1E344A),

    navBackground: Color(0xFF162B40),
    navActive: Color(0xFF2674DC),
    navInactive: Color(0xFF738397),
  );

  // ══════════════════════════════════════════════════════════════
  // ✨ NEW — Theme-aware derived colors
  //
  // These fix the "white card on dark mode" bug. Use them anywhere
  // you previously hardcoded Color(0xFFF4F8FF), Color(0xFFE6F4EA),
  // or Color(0xFFFFF4E5).
  // ══════════════════════════════════════════════════════════════

  /// True when this palette is the dark variant.
  /// Derived from [background] brightness so no extra constructor
  /// field is required.
  bool get isDark => background.computeLuminance() < 0.5;

  /// Soft tint for cards / icon backgrounds — replaces the hardcoded
  /// `Color(0xFFF4F8FF)`.
  ///
  /// Light: pale blue-grey (matches your original design)
  /// Dark:  subtle white overlay on the dark navy background
  Color get surfaceTint =>
      isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF4F8FF);

  /// Success badge background (e.g. "Register open").
  Color get successBg => isDark
      ? const Color(0xFF137333).withValues(alpha: 0.22)
      : const Color(0xFFE6F4EA);

  /// Success badge foreground / text.
  Color get successFg =>
      isDark ? const Color(0xFF6EE7B7) : const Color(0xFF137333);

  /// Warning badge background (e.g. "Register closed").
  Color get warningBg => isDark
      ? const Color(0xFFD97706).withValues(alpha: 0.22)
      : const Color(0xFFFFF4E5);

  /// Warning badge foreground / text.
  Color get warningFg =>
      isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);

  /// Danger badge background (e.g. "Fully refunded").
  Color get dangerBg => isDark
      ? const Color(0xFFDC2626).withValues(alpha: 0.22)
      : const Color(0xFFFEE2E2);

  /// Danger badge foreground / text.
  Color get dangerFg =>
      isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626);

  // ══════════════════════════════════════════════════════════════
  // ThemeExtension required overrides
  // ══════════════════════════════════════════════════════════════
  @override
  AppThemeColors copyWith({
    Color? background,
    Color? cardBackground,
    Color? surfaceLight,
    Color? primaryCoral,
    Color? primaryOrange,
    Color? deepGreen,
    Color? green,
    Color? accentGreen,
    Color? lightMint,
    Color? searchBar,
    Color? notification,
    Color? favoriteActive,
    Color? favoriteInactive,
    Color? textPrimary,
    Color? textSecondary,
    Color? textLight,
    Color? textMuted,
    Color? border,
    Color? borderLight,
    Color? navBackground,
    Color? navActive,
    Color? navInactive,
  }) {
    return AppThemeColors(
      background: background ?? this.background,
      cardBackground: cardBackground ?? this.cardBackground,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      primaryCoral: primaryCoral ?? this.primaryCoral,
      primaryOrange: primaryOrange ?? this.primaryOrange,
      deepGreen: deepGreen ?? this.deepGreen,
      green: green ?? this.green,
      accentGreen: accentGreen ?? this.accentGreen,
      lightMint: lightMint ?? this.lightMint,
      searchBar: searchBar ?? this.searchBar,
      notification: notification ?? this.notification,
      favoriteActive: favoriteActive ?? this.favoriteActive,
      favoriteInactive: favoriteInactive ?? this.favoriteInactive,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textLight: textLight ?? this.textLight,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      navBackground: navBackground ?? this.navBackground,
      navActive: navActive ?? this.navActive,
      navInactive: navInactive ?? this.navInactive,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      background: Color.lerp(background, other.background, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      primaryCoral: Color.lerp(primaryCoral, other.primaryCoral, t)!,
      primaryOrange: Color.lerp(primaryOrange, other.primaryOrange, t)!,
      deepGreen: Color.lerp(deepGreen, other.deepGreen, t)!,
      green: Color.lerp(green, other.green, t)!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      lightMint: Color.lerp(lightMint, other.lightMint, t)!,
      searchBar: Color.lerp(searchBar, other.searchBar, t)!,
      notification: Color.lerp(notification, other.notification, t)!,
      favoriteActive: Color.lerp(favoriteActive, other.favoriteActive, t)!,
      favoriteInactive: Color.lerp(
        favoriteInactive,
        other.favoriteInactive,
        t,
      )!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textLight: Color.lerp(textLight, other.textLight, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
      navActive: Color.lerp(navActive, other.navActive, t)!,
      navInactive: Color.lerp(navInactive, other.navInactive, t)!,
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// Convenience helper — read the palette from any BuildContext
// ══════════════════════════════════════════════════════════════════
extension AppColorsX on BuildContext {
  AppThemeColors get colors =>
      Theme.of(this).extension<AppThemeColors>() ?? AppThemeColors.light;
}
