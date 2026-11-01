import 'package:flutter/material.dart';
import 'package:pos_system/providers/setting_provider.dart';
import 'package:pos_system/shared/helper/safe_pop.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';

class ReceiptPreferencesScreen extends StatefulWidget {
  const ReceiptPreferencesScreen({super.key});

  @override
  State<ReceiptPreferencesScreen> createState() =>
      _ReceiptPreferencesScreenState();
}

class _ReceiptPreferencesScreenState extends State<ReceiptPreferencesScreen> {
  final TextEditingController _footerController = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().fetchSettings();
    });
  }

  @override
  void dispose() {
    _footerController.dispose();
    super.dispose();
  }

  // Pre-fill the footer once the settings are available
  void _populateFieldsFromProvider(SettingsProvider provider) {
    final settings = provider.settings;
    if (settings != null && !_isInitialized) {
      _footerController.text = settings.receiptFooter ?? '';
      _isInitialized = true;
    }
  }

  Future<void> _savePreferences() async {
    final settingsProvider = context.read<SettingsProvider>();

    // 👇 FIX: Save the footer text to the provider before saving
    settingsProvider.updateReceiptFooter(_footerController.text.trim());

    final success = await settingsProvider.saveSettings();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preferences saved successfully'),
          backgroundColor: Color(0xFF137333),
        ),
      );
      context.safePop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(settingsProvider.error ?? 'Failed to save preferences'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final settingsProvider = context.watch<SettingsProvider>();

    // Populate footer
    _populateFieldsFromProvider(settingsProvider);
    final settings = settingsProvider.settings;

    final isLoading = settingsProvider.isLoading && settings == null;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Skeletonizer(
          enabled: isLoading,
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
                      onPressed: () => context.safePop(),
                      icon: Icon(Icons.arrow_back, color: c.textSecondary),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Receipt preferences',
                          style: textStyles.heading2.copyWith(fontSize: 24),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'SoHo store · Print & digital',
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

                      // ── Receipt Header Preview ──
                      Text(
                        'RECEIPT HEADER',
                        style: textStyles.labelSmall.copyWith(
                          color: c.textSecondary,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F8FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'fold',
                              style: textStyles.heading1.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'SoHo · 120 Spring St, New York',
                              style: textStyles.bodySmall.copyWith(
                                color: c.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Receipt Footer Input ──
                      Text(
                        'Receipt footer',
                        style: textStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _footerController,
                        style: textStyles.bodyLarge,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: c.surfaceLight,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: c.primaryCoral,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Divider(
                        color: c.border.withValues(alpha: 0.5),
                        height: 1,
                      ),
                      const SizedBox(height: 16),

                      // ── Toggles ──
                      _buildToggleRow(
                        title: 'Show store logo',
                        subtitle: 'Use the fold wordmark',
                        value: settings?.showLogo ?? true,
                        onChanged: (val) => settingsProvider
                            .toggleReceiptSetting('show_logo', val),
                        c: c,
                        textStyles: textStyles,
                      ),
                      _buildToggleRow(
                        title: 'Show tax breakdown',
                        subtitle: 'Display sales tax separately',
                        value: settings?.showTaxBreakdown ?? true,
                        onChanged: (val) => settingsProvider
                            .toggleReceiptSetting('show_tax', val),
                        c: c,
                        textStyles: textStyles,
                      ),
                      _buildToggleRow(
                        title: 'Offer email receipts',
                        subtitle: 'Ask the customer after payment',
                        value: settings?.offerEmailReceipts ?? true,
                        onChanged: (val) => settingsProvider
                            .toggleReceiptSetting('offer_email', val),
                        c: c,
                        textStyles: textStyles,
                      ),
                      _buildToggleRow(
                        title: 'Automatically print receipts',
                        subtitle: (settings?.autoPrintReceipts ?? false)
                            ? 'On'
                            : 'Off · Print when requested',
                        value: settings?.autoPrintReceipts ?? false,
                        onChanged: (val) => settingsProvider
                            .toggleReceiptSetting('auto_print', val),
                        c: c,
                        textStyles: textStyles,
                        showDivider: false,
                      ),
                      const SizedBox(height: 24),

                      // ── Footer Note ──
                      Text(
                        'Receipt emails are transactional and don\'t subscribe customers to marketing.',
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // ── Bottom Action Buttons ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: settingsProvider.isLoading
                          ? null
                          : _savePreferences,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.primaryCoral,
                        foregroundColor: c.textLight,
                        disabledBackgroundColor: c.primaryCoral.withValues(
                          alpha: 0.5,
                        ),
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: settingsProvider.isLoading && !isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check, size: 20, color: c.textLight),
                                const SizedBox(width: 8),
                                Text(
                                  'Save preferences',
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
                    TextButton(
                      onPressed: () {
                        // Simulate printing a receipt
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Test receipt sent to printer'),
                            backgroundColor: Color(0xFF137333),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF4F8FF),
                        foregroundColor: c.primaryCoral,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.print_outlined,
                            size: 20,
                            color: c.primaryCoral,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Print test receipt',
                            style: textStyles.labelMedium.copyWith(
                              color: c.primaryCoral,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper Widget for Toggles ──
  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: c.textLight,
              activeTrackColor: c.primaryCoral,
              inactiveThumbColor: c.textLight,
              inactiveTrackColor: c.surfaceLight,
            ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: 16),
          Divider(color: c.border.withValues(alpha: 0.5), height: 1),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
