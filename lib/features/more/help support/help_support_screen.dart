import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 👈 for context.watch
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/language_provider.dart'; // 👈 ADD THIS

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  Widget build(BuildContext context) {
    // 👇 Rebuild when the language changes
    context.watch<LanguageProvider>();

    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Top App Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: c.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t('help_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.t('help_subtitle'),
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Main Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Heading
                    Text(
                      context.t('help_heading'),
                      style: textStyles.heading1.copyWith(
                        fontSize: 26,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Search Help Center ──
                    Text(
                      context.t('help_search_label'),
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      readOnly: true,
                      onTap: () {},
                      style: textStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: context.t('help_search_hint'),
                        hintStyle: textStyles.bodyMedium.copyWith(
                          color: c.textMuted,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: c.textMuted,
                        ),
                        filled: true,
                        fillColor: c.surfaceLight,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Popular Guides Section ──
                    Text(
                      context.t('help_guides_header'),
                      style: textStyles.labelSmall.copyWith(
                        color: c.textSecondary,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Guides List
                    _buildGuideItem(
                      icon: Icons.credit_card_outlined,
                      title: context.t('help_guide_reader_title'),
                      subtitle: context.t('help_guide_reader_sub'),
                      c: c,
                      textStyles: textStyles,
                    ),
                    _buildGuideItem(
                      icon: Icons.undo_rounded,
                      title: context.t('help_guide_returns_title'),
                      subtitle: context.t('help_guide_returns_sub'),
                      c: c,
                      textStyles: textStyles,
                    ),
                    _buildGuideItem(
                      icon: Icons.receipt_long_outlined,
                      title: context.t('help_guide_reconcile_title'),
                      subtitle: context.t('help_guide_reconcile_sub'),
                      c: c,
                      textStyles: textStyles,
                    ),
                    _buildGuideItem(
                      icon: Icons.wifi_off_rounded,
                      title: context.t('help_guide_offline_title'),
                      subtitle: context.t('help_guide_offline_sub'),
                      c: c,
                      textStyles: textStyles,
                      showDivider: false,
                    ),
                    const SizedBox(height: 24),

                    // ── Prefer Email Card ──
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: c.surfaceTint,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.t('help_email_title'),
                            style: textStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.t('help_email_address'),
                            style: textStyles.bodyLarge.copyWith(
                              color: c.primaryCoral,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.t('help_email_hint'),
                            style: textStyles.bodySmall.copyWith(
                              color: c.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Footer Version ──
                    Center(
                      child: Text(
                        context.tp('help_footer_version', {
                          'version': context.t('help_footer_version_number'),
                          'store': context.t('help_footer_store'),
                          'register': context.t('help_footer_register'),
                        }),
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── Bottom Action Button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Chat logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primaryCoral,
                      foregroundColor: c.textLight,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 20,
                          color: c.textLight,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.t('help_chat_button'),
                          style: textStyles.labelMedium.copyWith(
                            color: c.textLight,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.t('help_chat_hours'),
                    style: textStyles.bodySmall.copyWith(
                      color: c.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper Widget for Guide Items ──
  Widget _buildGuideItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                // Icon Box
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: c.surfaceTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: c.primaryCoral, size: 22),
                ),
                const SizedBox(width: 16),

                // Text
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
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Chevron
                Icon(Icons.chevron_right_rounded, color: c.textMuted, size: 24),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(color: c.border.withValues(alpha: 0.5), height: 1),
      ],
    );
  }
}
