import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/register_provider.dart';
import 'package:pos_system/providers/cart_provider.dart';
import 'package:pos_system/providers/store_provider.dart';
import 'package:pos_system/providers/theme_provider.dart';
import 'package:pos_system/providers/language_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreProvider>().fetchStore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    final registerProvider = context.watch<RegisterProvider>();
    final storeProvider = context.watch<StoreProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageProvider>();
    final store = storeProvider.store;

    final session = registerProvider.activeSession;
    final isOpen = registerProvider.isRegisterOpen;

    if (storeProvider.isLoading && store == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Skeletonizer(
          enabled: storeProvider.isLoading && store == null,
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // ── Top App Bar ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.t('settings_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      IconButton(
                        onPressed: () =>
                            context.pushNamed(RouteNames.helpSupportName),
                        icon: Icon(
                          Icons.help_outline_rounded,
                          color: c.primaryCoral,
                          size: 26,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Store Profile Card ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: c.surfaceTint,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: c.primaryCoral,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.storefront,
                            color: c.textLight,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                store?.name ?? context.t('settings_loading'),
                                style: textStyles.heading2.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                store?.addressLine ??
                                    context.t('settings_no_address'),
                                style: textStyles.bodySmall.copyWith(
                                  color: c.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: c.successFg,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    context.t('settings_all_systems_online'),
                                    style: textStyles.labelSmall.copyWith(
                                      color: c.successFg,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── Store Operations ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    context.t('settings_section_operations'),
                    style: textStyles.labelSmall.copyWith(
                      color: c.textSecondary,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              SliverList(
                delegate: SliverChildListDelegate([
                  _buildMenuTile(
                    icon: Icons.store_outlined,
                    title: context.t('settings_menu_store_details'),
                    subtitle: store != null
                        ? context.tp('settings_menu_store_details_sub', {
                            'currency': store.currency,
                            'timezone': store.timeZone,
                          })
                        : context.t('settings_loading'),
                    c: c,
                    textStyles: textStyles,
                    onTap: () => context.pushNamed(RouteNames.storeDetailsName),
                  ),
                  _buildMenuTile(
                    icon: Icons.percent_rounded,
                    title: context.t('settings_menu_taxes'),
                    subtitle: context.tp('settings_menu_taxes_sub', {
                      'rate': '10',
                      'count': '3',
                    }),
                    c: c,
                    textStyles: textStyles,
                    onTap: () =>
                        context.pushNamed(RouteNames.taxesDiscountName),
                  ),
                  _buildMenuTile(
                    icon: Icons.receipt_long_outlined,
                    title: context.t('settings_menu_receipt'),
                    subtitle: context.t('settings_menu_receipt_sub'),
                    c: c,
                    textStyles: textStyles,
                    onTap: () =>
                        context.pushNamed(RouteNames.receiptPreferencesName),
                  ),
                  _buildMenuTile(
                    icon: Icons.print_outlined,
                    title: context.t('settings_menu_devices'),
                    subtitle: context.t('settings_menu_devices_sub'),
                    c: c,
                    textStyles: textStyles,
                    showDivider: false,
                    onTap: () =>
                        context.pushNamed(RouteNames.connectedDevicesName),
                  ),
                ]),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── Preferences Section ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    context.t('settings_section_preferences'),
                    style: textStyles.labelSmall.copyWith(
                      color: c.textSecondary,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              SliverList(
                delegate: SliverChildListDelegate([
                  _buildMenuTile(
                    icon: _themeIcon(themeProvider.themeMode),
                    title: context.t('settings_menu_theme'),
                    subtitle: _themeLabel(context, themeProvider.themeMode),
                    c: c,
                    textStyles: textStyles,
                    onTap: () => _showThemeSheet(context, themeProvider),
                  ),
                  _buildMenuTile(
                    icon: Icons.translate_rounded,
                    title: context.t('settings_menu_language'),
                    subtitle: languageProvider.currentLanguageName,
                    c: c,
                    textStyles: textStyles,
                    showDivider: false,
                    onTap: () => _showLanguageSheet(context, languageProvider),
                  ),
                ]),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── Team & Account ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    context.t('settings_section_team'),
                    style: textStyles.labelSmall.copyWith(
                      color: c.textSecondary,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              SliverList(
                delegate: SliverChildListDelegate([
                  _buildMenuTile(
                    icon: Icons.people_outline_rounded,
                    title: context.t('settings_menu_staff'),
                    subtitle: context.tp('settings_menu_staff_sub', {
                      'name': context.t('settings_menu_staff_name_fallback'),
                      'role': context.t('settings_menu_staff_role_fallback'),
                    }),
                    c: c,
                    textStyles: textStyles,
                    onTap: () =>
                        context.pushNamed(RouteNames.staffPermissionName),
                  ),
                  _buildMenuTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: context.t('settings_menu_close_register'),
                    subtitle: isOpen && session != null
                        ? context.tp('settings_menu_close_register_open', {
                            'time':
                                '${session.openAt.hour}:${session.openAt.minute.toString().padLeft(2, '0')}',
                          })
                        : context.t('settings_menu_close_register_closed'),
                    c: c,
                    textStyles: textStyles,
                    onTap: () =>
                        context.pushNamed(RouteNames.closeRegisterName),
                  ),
                  _buildMenuTile(
                    icon: Icons.logout_rounded,
                    title: context.t('settings_menu_sign_out'),
                    c: c,
                    textStyles: textStyles,
                    showDivider: false,
                    onTap: () {
                      context.read<CartProvider>().clearCart();
                      context.goNamed(RouteNames.loginName);
                    },
                  ),
                ]),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // ── Footer ──
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    context.tp('settings_footer', {
                      'version': context.t('settings_footer_version'),
                    }),
                    style: textStyles.bodySmall.copyWith(
                      color: c.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Theme helpers ──
  IconData _themeIcon(ThemeMode mode) => switch (mode) {
    ThemeMode.light => Icons.light_mode_outlined,
    ThemeMode.dark => Icons.dark_mode_outlined,
    ThemeMode.system => Icons.brightness_auto_outlined,
  };

  // ✅ FIXED: now takes BuildContext so labels can be localized
  String _themeLabel(BuildContext context, ThemeMode mode) => switch (mode) {
    ThemeMode.light => context.t('settings_theme_light'),
    ThemeMode.dark => context.t('settings_theme_dark'),
    ThemeMode.system => context.t('settings_theme_system'),
  };

  void _showThemeSheet(BuildContext context, ThemeProvider provider) {
    final c = context.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: c.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final sheetStyles = AppTextStylesX(ctx);
        final sheetColors = ctx.colors;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                ctx.t('settings_theme_sheet_title'),
                style: sheetStyles.heading2.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              for (final m in ThemeMode.values)
                RadioListTile<ThemeMode>(
                  value: m,
                  groupValue: provider.themeMode,
                  activeColor: sheetColors.primaryCoral,
                  title: Text(
                    _themeLabel(ctx, m),
                    style: sheetStyles.bodyMedium,
                  ),
                  onChanged: (v) async {
                    if (v != null) {
                      await provider.setThemeMode(v);
                    }
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageSheet(BuildContext context, LanguageProvider provider) {
    final c = context.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: c.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final sheetStyles = AppTextStylesX(ctx);
        final sheetColors = ctx.colors;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                ctx.t('settings_language_sheet_title'),
                style: sheetStyles.heading2.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              for (final code in LanguageProvider.languageNames.keys)
                RadioListTile<String>(
                  value: code,
                  groupValue: provider.currentLanguage,
                  activeColor: sheetColors.primaryCoral,
                  title: Text(
                    LanguageProvider.languageNames[code] ?? code,
                    style: sheetStyles.bodyMedium,
                  ),
                  onChanged: (v) async {
                    if (v != null) {
                      await provider.setLanguage(v);
                    }
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ── Menu tile ──
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: c.surfaceTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: c.primaryCoral, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: textStyles.bodySmall.copyWith(
                            color: c.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: c.textMuted, size: 24),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 72.0),
            child: Divider(color: c.border.withValues(alpha: 0.5), height: 1),
          ),
      ],
    );
  }
}
