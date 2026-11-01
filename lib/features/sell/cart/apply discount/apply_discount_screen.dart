import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/cart_provider.dart';

class ApplyDiscountScreen extends StatefulWidget {
  const ApplyDiscountScreen({super.key});

  @override
  State<ApplyDiscountScreen> createState() => _ApplyDiscountScreenState();
}

class _ApplyDiscountScreenState extends State<ApplyDiscountScreen> {
  // Toggle state (0 = Percentage, 1 = Fixed)
  int _discountType = 0;

  // Controllers
  final TextEditingController _percentageController = TextEditingController(
    text: '10',
  );
  final TextEditingController _nameController = TextEditingController(
    text: 'Welcome discount',
  );

  @override
  void dispose() {
    _percentageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final cartProvider = context.watch<CartProvider>();

    // Pull real subtotal and tax from the provider
    final subtotal = cartProvider.subtotal;
    final taxRate = 0.10; // 10% tax rate

    // Calculate discount dynamically
    double discountAmount = 0.0;
    if (_discountType == 0) {
      final percent = double.tryParse(_percentageController.text) ?? 0;
      discountAmount = subtotal * (percent / 100);
    } else {
      final fixed = double.tryParse(_percentageController.text) ?? 0;
      discountAmount = fixed > subtotal ? subtotal : fixed;
    }

    final taxableAmount = subtotal - discountAmount;
    final taxAmount = taxableAmount * taxRate;
    final newTotal = taxableAmount + taxAmount;

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
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.arrow_back, color: c.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order discount',
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${cartProvider.itemCount} items · Current subtotal \$${subtotal.toStringAsFixed(2)}',
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
                    const SizedBox(height: 8),

                    // Headings
                    Text(
                      'A little welcome goes a long\nway.',
                      style: textStyles.heading1.copyWith(
                        fontSize: 26,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Toggle Buttons ──
                    Row(
                      children: [
                        _buildToggleButton(
                          label: 'Percentage (%)',
                          isActive: _discountType == 0,
                          onTap: () => setState(() => _discountType = 0),
                          c: c,
                          textStyles: textStyles,
                        ),
                        const SizedBox(width: 8),
                        _buildToggleButton(
                          label: 'Fixed amount (\$)',
                          isActive: _discountType == 1,
                          onTap: () => setState(() => _discountType = 1),
                          c: c,
                          textStyles: textStyles,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Percentage Input ──
                    Text(
                      _discountType == 0
                          ? 'Discount percentage'
                          : 'Discount amount',
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _percentageController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: textStyles.bodyLarge,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        suffixIcon: _discountType == 0
                            ? Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Center(
                                  widthFactor: 1,
                                  child: Text('%', style: textStyles.bodyLarge),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Center(
                                  widthFactor: 1,
                                  child: Text(
                                    '\$',
                                    style: textStyles.bodyLarge,
                                  ),
                                ),
                              ),
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
                    const SizedBox(height: 8),
                    Text(
                      'Applied to all items before sales tax.',
                      style: textStyles.bodySmall.copyWith(
                        color: c.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Discount Name Input ──
                    Text(
                      'Discount name',
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      style: textStyles.bodyLarge,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.local_offer_outlined,
                          color: c.textMuted,
                          size: 20,
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

                    // ── Summary Card ──
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F8FF), // Light blue
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            'Subtotal',
                            '\$${subtotal.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            _discountType == 0
                                ? '${_nameController.text} · ${_percentageController.text}%'
                                : '${_nameController.text} · Fixed',
                            '-\$${discountAmount.toStringAsFixed(2)}',
                            c,
                            textStyles,
                            valueColor: const Color(0xFF137333), // Green
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            'Taxable amount',
                            '\$${taxableAmount.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            'Sales tax · 10%',
                            '\$${taxAmount.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            color: c.border.withValues(alpha: 0.5),
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'New total',
                                style: textStyles.labelMedium.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '\$${newTotal.toStringAsFixed(2)}',
                                style: textStyles.heading1.copyWith(
                                  color: c.primaryCoral,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Footer Note ──
                    Text(
                      'One order discount at a time. This replaces any existing order discount.',
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
                    onPressed: () {
                      // 👇 Call the provider to apply the discount
                      cartProvider.applyDiscount(
                        name: _nameController.text,
                        amount: discountAmount,
                        isPercentage: _discountType == 0,
                        value: double.tryParse(_percentageController.text) ?? 0,
                      );
                      context.pop();
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
                    child: Text(
                      'Apply discount · -\$${discountAmount.toStringAsFixed(2)}',
                      style: textStyles.labelMedium.copyWith(
                        color: c.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // 👇 Call the provider to remove the discount
                      cartProvider.removeDiscount();
                      context.pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF4F8FF),
                      foregroundColor: c.primaryCoral,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Remove discount',
                      style: textStyles.labelMedium.copyWith(
                        color: c.primaryCoral,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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

  // ── Helper Widgets ──

  Widget _buildToggleButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? c.primaryCoral : c.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: textStyles.labelSmall.copyWith(
            color: isActive ? c.textLight : c.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    AppThemeColors c,
    AppTextStylesX textStyles, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textStyles.bodySmall.copyWith(color: c.textSecondary),
        ),
        Text(
          value,
          style: textStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? c.textPrimary,
          ),
        ),
      ],
    );
  }
}
