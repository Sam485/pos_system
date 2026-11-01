// features/sell/cart/check_out_flow/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/cart_provider.dart';
import 'package:pos_system/providers/register_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentMethod = 0;

  String get _paymentMethodString {
    switch (_selectedPaymentMethod) {
      case 0:
        return 'cash';
      case 1:
        return 'card';
      case 2:
        return 'KHQR';
      default:
        return 'cash';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final cartProvider = context.watch<CartProvider>();
    final registerProvider = context.watch<RegisterProvider>();

    // 🚨 GUARD: Block checkout if no register is open
    if (!registerProvider.isRegisterOpen) {
      return Scaffold(
        backgroundColor: c.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 64,
                    color: c.primaryCoral,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No open register',
                    style: textStyles.heading2.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You need to open a register before completing this sale.',
                    textAlign: TextAlign.center,
                    style: textStyles.bodyMedium.copyWith(color: c.textMuted),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () =>
                        context.goNamed(RouteNames.storeRegisterName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primaryCoral,
                      foregroundColor: c.textLight,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Open a Register',
                      style: textStyles.labelMedium.copyWith(
                        color: c.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ── Dynamic Data from Cart ──
    final customer = cartProvider.selectedCustomer;
    final subtotal = cartProvider.subtotal;
    final discountAmount = cartProvider.discountAmount;
    final taxableAmount = subtotal - discountAmount;
    final taxAmount = taxableAmount * 0.10;
    final totalDue = taxableAmount + taxAmount;
    final totalItems = cartProvider.itemCount;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
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
                        'Checkout',
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$totalItems items · New sale',
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  // Customer Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F8FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE8F0FE),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8F0FE),
                                shape: BoxShape.circle,
                              ),
                              child: customer != null
                                  ? Text(
                                      '${customer.firstName.isNotEmpty ? customer.firstName[0] : ''}${customer.lastName.isNotEmpty ? customer.lastName[0] : ''}'
                                          .toUpperCase(),
                                      style: textStyles.labelSmall.copyWith(
                                        color: const Color(0xFF1967D2),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person_outline,
                                      color: c.primaryCoral,
                                      size: 20,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customer != null
                                        ? '${customer.firstName} ${customer.lastName}'
                                        : 'Guest Customer',
                                    style: textStyles.labelMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    customer != null
                                        ? customer.email
                                        : 'No email attached',
                                    style: textStyles.bodySmall.copyWith(
                                      color: c.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: c.primaryCoral,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // Order Summary
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order summary',
                                style: textStyles.heading2.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.pop(),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Edit cart',
                                  style: textStyles.labelSmall.copyWith(
                                    color: c.primaryCoral,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          ...cartProvider.items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _buildSummaryRow(
                                '${item.quantity} × ${item.productName}',
                                '\$${item.totalPrice.toStringAsFixed(2)}',
                                c,
                                textStyles,
                              ),
                            );
                          }),

                          const SizedBox(height: 16),
                          Divider(
                            color: c.border.withValues(alpha: 0.5),
                            height: 1,
                          ),
                          const SizedBox(height: 16),

                          _buildTotalRow(
                            'Subtotal · $totalItems items',
                            '\$${subtotal.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),

                          if (cartProvider.hasDiscount) ...[
                            const SizedBox(height: 8),
                            _buildTotalRow(
                              '${cartProvider.discountName}${cartProvider.isPercentageDiscount ? ' · ${cartProvider.discountValue}%' : ''}',
                              '-\$${discountAmount.toStringAsFixed(2)}',
                              c,
                              textStyles,
                              valueColor: const Color(0xFF137333),
                            ),
                          ],

                          const SizedBox(height: 8),
                          _buildTotalRow(
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
                                'Total due',
                                style: textStyles.labelMedium.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '\$${totalDue.toStringAsFixed(2)}',
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
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Payment Method
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How would they like to pay?',
                            style: textStyles.labelMedium.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildPaymentOption(
                            index: 0,
                            icon: Icons.payments_outlined,
                            title: 'Cash',
                            subtitle: 'Accept cash & calculate change',
                            c: c,
                            textStyles: textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildPaymentOption(
                            index: 1,
                            icon: Icons.credit_card_outlined,
                            title: 'Card',
                            subtitle: 'Tap, insert or swipe',
                            c: c,
                            textStyles: textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildPaymentOption(
                            index: 2,
                            icon: Icons.qr_code_2_rounded,
                            title: 'KHQR',
                            subtitle: 'Scan QR code via banking app',
                            c: c,
                            textStyles: textStyles,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),

            // Bottom Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 👇 FIX: Pass ALL data needed for the payment screen
                      final paymentExtra = {
                        'amount': totalDue,
                        'customerId': customer?.id,
                        'customerName': customer != null
                            ? '${customer.firstName} ${customer.lastName}'
                            : 'Guest',
                        'customerEmail': customer?.email,
                        'itemsSold': totalItems,
                        'items': cartProvider
                            .cartItemsJson, // 👈 Map<String, dynamic>
                        'subtotal': subtotal,
                        'discount_amount': discountAmount,
                        'tax_amount': taxAmount,
                        'total_amount': totalDue,
                      };

                      switch (_paymentMethodString) {
                        case 'cash':
                          context.pushNamed(
                            RouteNames.cashPaymentName,
                            extra: paymentExtra,
                          );
                          break;
                        case 'card':
                          context.pushNamed(
                            RouteNames.cardPaymentName,
                            extra: paymentExtra,
                          );
                          break;
                        case 'KHQR':
                          context.pushNamed(
                            RouteNames.khQRPaymentName,
                            extra: paymentExtra,
                          );
                          break;
                      }
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
                      'Continue with $_paymentMethodString · \$${totalDue.toStringAsFixed(2)}',
                      style: textStyles.labelMedium.copyWith(
                        color: c.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Stock updates automatically after payment.',
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

  Widget _buildSummaryRow(
    String label,
    String value,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: textStyles.bodyMedium.copyWith(color: c.textSecondary),
          ),
        ),
        Text(
          value,
          style: textStyles.labelMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildTotalRow(
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
            fontSize: 13,
            color: valueColor ?? c.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    final isSelected = _selectedPaymentMethod == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4F8FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? c.primaryCoral : c.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFE8F0FE)
                    : const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? c.primaryCoral : c.textMuted,
                size: 20,
              ),
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: textStyles.bodySmall.copyWith(
                      color: c.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? c.primaryCoral : c.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
