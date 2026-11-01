import 'package:flutter/material.dart';
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
    final settingsProvider = context.read<SettingsProvider>();
    final success = await settingsProvider.saveSettings();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully'),
          backgroundColor: Color(0xFF137333),
        ),
      );
      context.safePop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(settingsProvider.error ?? 'Failed to save settings'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 👇 NEW: Edit tax rate
  void _editTaxRate() {
    final settingsProvider = context.read<SettingsProvider>();
    final currentRate = (settingsProvider.settings?.taxRate ?? 0.10) * 100;
    final controller = TextEditingController(
      text: currentRate.toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sales tax rate'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            suffixText: '%',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newRate = double.tryParse(controller.text) ?? 10.0;
              settingsProvider.updateTaxRate(newRate / 100);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // 👇 NEW: Create discount
  void _createDiscount() {
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    String type = 'percentage';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create a discount',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: valueController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Value',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: type,
                  items: const [
                    DropdownMenuItem(value: 'percentage', child: Text('%')),
                    DropdownMenuItem(value: 'fixed', child: Text('\$')),
                  ],
                  onChanged: (val) => type = val ?? 'percentage',
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final provider = context.read<SettingsProvider>();
                provider.createDiscount({
                  'name': nameController.text,
                  'description': type == 'percentage'
                      ? '${valueController.text}% off · Whole order'
                      : '\$${valueController.text} off',
                  'type': type,
                  'value': double.tryParse(valueController.text) ?? 0,
                });
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  // 👇 NEW: Delete discount
  void _deleteDiscount(String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete discount?'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SettingsProvider>().deleteDiscount(id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFDC2626),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
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
                          'Taxes & discounts',
                          style: textStyles.heading2.copyWith(fontSize: 24),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'SoHo store',
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
                          color: const Color(0xFFF4F8FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sales tax',
                                  style: textStyles.labelMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                // 👇 NEW: Tappable to edit tax rate
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
                                'Added at checkout after order discounts.',
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
                                      'Apply sales tax',
                                      style: textStyles.labelMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'All taxable products',
                                      style: textStyles.bodySmall.copyWith(
                                        color: c.textMuted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value:
                                      settingsProvider
                                          .settings
                                          ?.applySalesTax ??
                                      true,
                                  onChanged: (val) {
                                    settingsProvider.toggleSalesTax(val);
                                  },
                                  activeThumbColor: c.textLight,
                                  activeTrackColor: c.primaryCoral,
                                  inactiveThumbColor: c.textLight,
                                  inactiveTrackColor: c.surfaceLight,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Active Discounts Section ──
                      Text(
                        '${settingsProvider.discounts.length} ACTIVE DISCOUNTS',
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
                                'Require approval above 20%',
                                style: textStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Store manager approval for custom discounts',
                                style: textStyles.bodySmall.copyWith(
                                  color: c.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value:
                                settingsProvider.settings?.requireApproval ??
                                true,
                            onChanged: (val) {
                              settingsProvider.toggleApproval(val);
                            },
                            activeTrackColor: c.primaryCoral,
                            inactiveThumbColor: c.textLight,
                            inactiveTrackColor: c.surfaceLight,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Create Discount Button ──
                      TextButton(
                        onPressed: _createDiscount,
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
                            Icon(Icons.add, size: 20, color: c.primaryCoral),
                            const SizedBox(width: 8),
                            Text(
                              'Create a discount',
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
                        'One order discount per sale. Changes only apply to new checkouts; past receipts stay unchanged.',
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
                              'Save settings',
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
                  color: const Color(0xFFF4F8FF),
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
}
