import 'package:flutter/material.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/providers/setting_provider.dart';
import 'package:pos_system/shared/helper/safe_pop.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';

class TaxesDiscountScreen extends StatefulWidget {
  const TaxesDiscountScreen({super.key});

  @override
  State<TaxesDiscountScreen> createState() => _TaxesDiscountScreenState();
}

class _TaxesDiscountScreenState extends State<TaxesDiscountScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().fetchSettings();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
    }
  }

  Future<void> _saveSettings() async {
    final c = context.colors;
    final settingsProvider = context.read<SettingsProvider>();
    final success = await settingsProvider.saveSettings();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('taxes_save_success')),
          backgroundColor: c.successFg,
        ),
      );
      context.safePop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            settingsProvider.error ?? context.t('taxes_save_failed'),
          ),
          backgroundColor: c.dangerFg,
        ),
      );
    }
  }

  // ── Edit tax rate dialog ──
  void _editTaxRate() {
    final settingsProvider = context.read<SettingsProvider>();
    final currentRate = (settingsProvider.settings?.taxRate ?? 0.10) * 100;
    final controller = TextEditingController(
      text: currentRate.toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (ctx) {
        final dc = ctx.colors;
        final ds = AppTextStylesX(ctx);
        return AlertDialog(
          backgroundColor: dc.cardBackground,
          title: Text(
            ctx.t('taxes_edit_rate_title'),
            style: ds.heading2.copyWith(fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: ds.bodyLarge,
            decoration: InputDecoration(
              suffixText: '%',
              suffixStyle: ds.bodyLarge,
              filled: true,
              fillColor: dc.surfaceLight,
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
                borderSide: BorderSide(color: dc.primaryCoral, width: 1.5),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                ctx.t('taxes_edit_rate_cancel'),
                style: TextStyle(color: dc.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                final newRate = double.tryParse(controller.text) ?? 10.0;
                settingsProvider.updateTaxRate(newRate / 100);
                Navigator.pop(ctx);
              },
              child: Text(
                ctx.t('taxes_edit_rate_save'),
                style: TextStyle(
                  color: dc.primaryCoral,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Create discount bottom sheet ──
  void _createDiscount() {
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    String type = 'percentage';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final sc = ctx.colors;
        final st = AppTextStylesX(ctx);
        return StatefulBuilder(
          builder: (ctx, setSheetState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ctx.t('taxes_create_sheet_title'),
                  style: st.heading2.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  style: st.bodyLarge,
                  decoration: _sheetInputDecoration(
                    sc,
                    label: ctx.t('taxes_create_name_label'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: valueController,
                        keyboardType: TextInputType.number,
                        style: st.bodyLarge,
                        decoration: _sheetInputDecoration(
                          sc,
                          label: ctx.t('taxes_create_value_label'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: sc.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: type,
                          dropdownColor: sc.cardBackground,
                          style: st.bodyLarge,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: sc.textMuted,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'percentage',
                              child: Text('%'),
                            ),
                            DropdownMenuItem(value: 'fixed', child: Text('\$')),
                          ],
                          onChanged: (val) {
                            setSheetState(() => type = val ?? 'percentage');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final provider = ctx.read<SettingsProvider>();
                    provider.createDiscount({
                      'name': nameController.text,
                      'description': type == 'percentage'
                          ? ctx.tp('taxes_create_description_percentage', {
                              'value': valueController.text,
                            })
                          : ctx.tp('taxes_create_description_fixed', {
                              'value': valueController.text,
                            }),
                      'type': type,
                      'value': double.tryParse(valueController.text) ?? 0,
                    });
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sc.primaryCoral,
                    foregroundColor: sc.textLight,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    ctx.t('taxes_create_action'),
                    style: st.labelMedium.copyWith(
                      color: sc.textLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Delete discount dialog ──
  void _deleteDiscount(String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) {
        final dc = ctx.colors;
        final ds = AppTextStylesX(ctx);
        return AlertDialog(
          backgroundColor: dc.cardBackground,
          title: Text(
            ctx.t('taxes_delete_dialog_title'),
            style: ds.heading2.copyWith(fontSize: 18),
          ),
          content: Text(
            ctx.tp('taxes_delete_dialog_body', {'name': name}),
            style: ds.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                ctx.t('taxes_delete_dialog_cancel'),
                style: TextStyle(color: dc.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                ctx.read<SettingsProvider>().deleteDiscount(id);
                Navigator.pop(ctx);
              },
              style: TextButton.styleFrom(foregroundColor: dc.dangerFg),
              child: Text(ctx.t('taxes_delete_dialog_delete')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final settingsProvider = context.watch<SettingsProvider>();

    final isLoading =
        settingsProvider.isLoading && settingsProvider.settings == null;

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
                          context.t('taxes_title'),
                          style: textStyles.heading2.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.tp('taxes_subtitle', {
                            'store': context.t('taxes_store_default'),
                          }),
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

                      // ── Tax Card ──
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: c.surfaceTint,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.t('taxes_sales_tax'),
                                  style: textStyles.labelMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _editTaxRate,
                                  child: Row(
                                    children: [
                                      Text(
                                        '${((settingsProvider.settings?.taxRate ?? 0.10) * 100).toStringAsFixed(0)}%',
                                        style: textStyles.heading2.copyWith(
                                          color: c.primaryCoral,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: c.primaryCoral,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                context.t('taxes_sales_tax_hint'),
                                style: textStyles.bodySmall.copyWith(
                                  color: c.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Divider(
                              color: c.border.withValues(alpha: 0.5),
                              height: 1,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.t('taxes_apply_tax_title'),
                                      style: textStyles.labelMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      context.t('taxes_apply_tax_sub'),
                                      style: textStyles.bodySmall.copyWith(
                                        color: c.textMuted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                // ✅ FIXED: was activeThumbColor / etc.
                                Switch(
                                  value:
                                      settingsProvider
                                          .settings
                                          ?.applySalesTax ??
                                      true,
                                  onChanged: (val) {
                                    settingsProvider.toggleSalesTax(val);
                                  },
                                  thumbColor: WidgetStateProperty.resolveWith(
                                    (states) => c.textLight,
                                  ),
                                  trackColor: WidgetStateProperty.resolveWith((
                                    states,
                                  ) {
                                    if (states.contains(WidgetState.selected)) {
                                      return c.primaryCoral;
                                    }
                                    return c.surfaceLight;
                                  }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Active Discounts Section ──
                      Text(
                        context.tp('taxes_active_discounts', {
                          'count': '${settingsProvider.discounts.length}',
                        }),
                        style: textStyles.labelSmall.copyWith(
                          color: c.textSecondary,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Discount Items
                      ...settingsProvider.discounts.map((discount) {
                        return _buildDiscountItem(
                          icon: discount.type == 'percentage'
                              ? Icons.percent_rounded
                              : Icons.local_offer_outlined,
                          title: discount.name,
                          subtitle: discount.description,
                          c: c,
                          textStyles: textStyles,
                          onDelete: () =>
                              _deleteDiscount(discount.id, discount.name),
                        );
                      }),

                      const SizedBox(height: 24),

                      // ── Require Approval Toggle ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.t('taxes_require_approval_title'),
                                style: textStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.t('taxes_require_approval_sub'),
                                style: textStyles.bodySmall.copyWith(
                                  color: c.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          // ✅ FIXED: was missing thumbColor + wrong params
                          Switch(
                            value:
                                settingsProvider.settings?.requireApproval ??
                                true,
                            onChanged: (val) {
                              settingsProvider.toggleApproval(val);
                            },
                            thumbColor: WidgetStateProperty.resolveWith(
                              (states) => c.textLight,
                            ),
                            trackColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return c.primaryCoral;
                              }
                              return c.surfaceLight;
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Create Discount Button ──
                      TextButton(
                        onPressed: _createDiscount,
                        style: TextButton.styleFrom(
                          backgroundColor: c.surfaceTint,
                          foregroundColor: c.primaryCoral,
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 20, color: c.primaryCoral),
                            const SizedBox(width: 8),
                            Text(
                              context.t('taxes_create_button'),
                              style: textStyles.labelMedium.copyWith(
                                color: c.primaryCoral,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Footer Note ──
                      Text(
                        context.t('taxes_footer_note'),
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

              // ── Bottom Action Button ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: ElevatedButton(
                  onPressed: settingsProvider.isLoading ? null : _saveSettings,
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
                              context.t('taxes_save_button'),
                              style: textStyles.labelMedium.copyWith(
                                color: c.textLight,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper Widget for Discount Item ──
  Widget _buildDiscountItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
    required VoidCallback onDelete,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: c.surfaceTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: c.primaryCoral, size: 20),
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
                        fontSize: 14,
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
              IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline, color: c.textMuted, size: 20),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(color: c.border.withValues(alpha: 0.5), height: 1),
      ],
    );
  }

  // Shared input decoration for the "create discount" sheet
  InputDecoration _sheetInputDecoration(
    AppThemeColors c, {
    required String label,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: c.textSecondary),
      filled: true,
      fillColor: c.surfaceLight,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
        borderSide: BorderSide(color: c.primaryCoral, width: 1.5),
      ),
    );
  }
}
