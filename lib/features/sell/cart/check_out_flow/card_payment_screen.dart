import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/cart_provider.dart';
import 'package:pos_system/providers/order_provider.dart';

class CardPaymentScreen extends StatefulWidget {
  const CardPaymentScreen({super.key});

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  double _amount = 0.0;
  String? _customerName;
  String? _customerId;
  bool _isProcessing = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra;
      if (extra is Map<String, dynamic>) {
        _amount = (extra['amount'] as num?)?.toDouble() ?? 0.0;
        _customerId = extra['customerId'] as String?;
      }

      final customer = context.read<CartProvider>().selectedCustomer;
      if (customer != null) {
        _customerName = customer.firstName;
      }

      _isInitialized = true;
    }
  }

  Future<void> _completePayment() async {
    setState(() => _isProcessing = true);

    // Simulate card reader processing
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Build order data
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    final orderData = {
      'customer_id': _customerId,
      'subtotal': cartProvider.subtotal,
      'discount_amount': cartProvider.discountAmount,
      'tax_amount': cartProvider.tax,
      'total_amount': cartProvider.total,
      'payment_method': 'card',
      'items': cartProvider.items
          .map(
            (item) => {
              'variant_id': item.variantId,
              'quantity': item.quantity,
              'unit_price': item.unitPrice,
              'total_price': item.totalPrice,
            },
          )
          .toList(),
    };

    final success = await orderProvider.placeOrder(orderData);

    if (success && mounted) {
      final customer = cartProvider.selectedCustomer;
      final itemsSold = cartProvider.itemCount;

      cartProvider.clearCart();

      context.goNamed(
        RouteNames.saleCompleteName,
        extra: {
          'amount': _amount,
          'method': 'Card',
          'customerName': customer != null
              ? '${customer.firstName} ${customer.lastName}'
              : null,
          'customerEmail': customer?.email,
          'itemsSold': itemsSold,
        },
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            orderProvider.error ?? context.t('card_payment_failed'),
          ),
          backgroundColor: context.colors.dangerFg,
        ),
      );
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    final terminalShadow = c.isDark
        ? Colors.black.withValues(alpha: 0.35)
        : Colors.black.withValues(alpha: 0.02);

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
                    onPressed: _isProcessing ? null : () => context.pop(),
                    icon: Icon(Icons.arrow_back, color: c.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t('card_payment_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _customerName != null
                            ? context.tp('card_payment_subtitle_customer', {
                                'name': _customerName!,
                              })
                            : context.t('card_payment_subtitle_generic'),
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
                  children: [
                    const SizedBox(height: 8),

                    // Reader Connected Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: c.successBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: c.successFg,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            context.t('card_payment_reader_connected'),
                            style: textStyles.labelSmall.copyWith(
                              color: c.successFg,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Total Due
                    Text(
                      context.t('card_payment_total_due'),
                      style: textStyles.bodyMedium.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_amount.toStringAsFixed(2)}',
                      style: textStyles.heading1.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Visual Terminal Graphic
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: c.surfaceTint,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Container(
                          width: 140,
                          height: 220,
                          decoration: BoxDecoration(
                            color: c.cardBackground,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: c.isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : const Color(0xFFE8F0FE),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: terminalShadow,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Top Speaker
                              Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: c.isDark
                                      ? Colors.white.withValues(alpha: 0.12)
                                      : const Color(0xFFE8F0FE),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Screen with Tap to pay
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: c.surfaceTint,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.wifi_tethering_rounded,
                                      color: c.primaryCoral,
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      context.t('card_payment_tap_to_pay'),
                                      style: textStyles.labelSmall.copyWith(
                                        color: c.primaryCoral,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Bottom Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildTerminalButton(c),
                                  const SizedBox(width: 6),
                                  _buildTerminalButton(c),
                                  const SizedBox(width: 6),
                                  _buildTerminalButton(c),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Status Text
                    Text(
                      _isProcessing
                          ? context.t('card_payment_processing')
                          : context.t('card_payment_ready'),
                      style: textStyles.heading2.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _customerName != null
                          ? context.tp('card_payment_instruction_named', {
                              'name': _customerName!,
                            })
                          : context.t('card_payment_instruction_generic'),
                      textAlign: TextAlign.center,
                      style: textStyles.bodyMedium.copyWith(
                        color: c.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Waiting Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: c.primaryCoral,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isProcessing
                              ? context.t('card_payment_processing_payment')
                              : context.t('card_payment_waiting_card'),
                          style: textStyles.labelMedium.copyWith(
                            color: c.primaryCoral,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Divider(color: c.border.withValues(alpha: 0.5), height: 1),
                    const SizedBox(height: 16),

                    // Reader Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.t('card_payment_reader_label'),
                          style: textStyles.bodyMedium.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                        Text(
                          context.t('card_payment_reader_name'),
                          style: textStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Accepted Cards Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: c.surfaceTint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: c.primaryCoral,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.t('card_payment_accepted_cards'),
                              style: textStyles.bodySmall.copyWith(
                                color: c.textSecondary,
                                height: 1.4,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
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
                  // Simulate card tap button
                  if (!_isProcessing)
                    ElevatedButton(
                      onPressed: _completePayment,
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
                        context.tp('card_payment_simulate_button', {
                          'amount': _amount.toStringAsFixed(2),
                        }),
                        style: textStyles.labelMedium.copyWith(
                          color: c.textLight,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (_isProcessing)
                    Container(
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: c.primaryCoral.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        context.t('card_payment_processing'),
                        style: textStyles.labelMedium.copyWith(
                          color: c.textLight,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _isProcessing ? null : () => context.pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: c.surfaceTint,
                      foregroundColor: c.primaryCoral,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.t('card_payment_cancel_button'),
                      style: textStyles.labelMedium.copyWith(
                        color: c.primaryCoral,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.t('card_payment_footer'),
                    textAlign: TextAlign.center,
                    style: textStyles.bodySmall.copyWith(
                      color: c.textMuted,
                      fontSize: 11,
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

  // Helper widget for the terminal buttons at the bottom
  Widget _buildTerminalButton(AppThemeColors c) {
    return Container(
      width: 20,
      height: 6,
      decoration: BoxDecoration(
        color: c.isDark
            ? Colors.white.withValues(alpha: 0.12)
            : const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
