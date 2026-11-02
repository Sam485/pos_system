// features/sell/receipt_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/models/order_model.dart';
import 'package:pos_system/data/models/customer_model.dart';
import 'package:pos_system/data/models/product_model.dart';
import 'package:pos_system/providers/inventory_provider.dart';
import 'package:pos_system/providers/order_provider.dart';
import 'package:pos_system/providers/product_provider.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  OrderModel? _order;
  CustomerModel? _customer;
  bool _isInitialized = false;

  Map<String, dynamic>? _payment;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra;
      if (extra is Map<String, dynamic>) {
        _order = extra['order'] as OrderModel?;
        _customer = extra['customer'] as CustomerModel?;
      } else if (extra is OrderModel) {
        _order = extra;
      }

      if (_order != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final orderProvider = context.read<OrderProvider>();
          final productProvider = context.read<ProductProvider>();
          final inventoryProvider = context.read<InventoryProvider>();

          await Future.wait([
            orderProvider.fetchOrderItems(_order!.id),
            productProvider.fetchProducts(),
            if (inventoryProvider.variants.isEmpty)
              inventoryProvider.fetchFullInventory(),
          ]);

          final paymentData = await orderProvider.getPaymentDetails(_order!.id);
          if (mounted) {
            setState(() => _payment = paymentData);
          }
        });
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final inventoryProvider = context.watch<InventoryProvider>();
    final productProvider = context.watch<ProductProvider>();
    final orderProvider = context.watch<OrderProvider>();

    if (_order == null) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(child: Text(context.t('receipt_not_found'))),
      );
    }

    final order = _order!;
    final orderItems = orderProvider.orderItems;
    final date =
        '${order.createdAt.month} ${order.createdAt.day}, ${order.createdAt.year} · ${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')} ${order.createdAt.hour >= 12 ? 'PM' : 'AM'}';

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
                        context.t('receipt_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.tp('receipt_subtitle', {
                          'orderNumber': order.orderNumber,
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

            // ── Main Content ──
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // ── Receipt Card ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: c.surfaceLight,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          // Header
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
                            context.t('receipt_store_address'),
                            style: textStyles.bodySmall.copyWith(
                              color: c.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            context.tp('receipt_store_date_register', {
                              'date': date,
                            }),
                            style: textStyles.bodySmall.copyWith(
                              color: c.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Customer & Items
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              context.tp('receipt_customer_line', {
                                'orderNumber': order.orderNumber,
                                'customer':
                                    '${_customer?.firstName ?? context.t('receipt_guest')} ${_customer?.lastName ?? ""}'
                                        .trim(),
                              }),
                              style: textStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // If items haven't loaded yet, show a spinner
                          if (orderItems.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else
                            ...orderItems.map((item) {
                              final variant = inventoryProvider.getVariantById(
                                item['variant_id'],
                              );

                              ProductModel? product;
                              if (variant != null &&
                                  productProvider.products.isNotEmpty) {
                                product = productProvider.products.firstWhere(
                                  (p) => p.id == variant.productId,
                                  orElse: () => productProvider.products.first,
                                );
                              }

                              final itemName =
                                  product?.name ??
                                  variant?.name ??
                                  context.t('receipt_item_default_name');

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            context.tp('receipt_item_line', {
                                              'quantity': '${item['quantity']}',
                                              'name': itemName,
                                            }),
                                            style: textStyles.bodyMedium,
                                          ),
                                          Text(
                                            context.tp('receipt_item_variant', {
                                              'color': variant?.color ?? '',
                                              'size': variant?.size ?? '',
                                              'price':
                                                  (item['unit_price'] as num)
                                                      .toStringAsFixed(2),
                                            }),
                                            style: textStyles.bodySmall
                                                .copyWith(color: c.textMuted),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '\$${(item['total_price'] as num).toStringAsFixed(2)}',
                                      style: textStyles.bodyMedium,
                                    ),
                                  ],
                                ),
                              );
                            }),

                          const SizedBox(height: 16),
                          Divider(
                            color: c.border.withValues(alpha: 0.5),
                            height: 1,
                          ),
                          const SizedBox(height: 16),

                          // Totals
                          _buildSummaryRow(
                            context.t('receipt_subtotal'),
                            '\$${order.subTotal.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),
                          _buildSummaryRow(
                            context.t('receipt_discount'),
                            '-\$${order.discountAmount.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),
                          _buildSummaryRow(
                            context.t('receipt_sales_tax'),
                            '\$${order.taxAmount.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.t('receipt_total_paid'),
                                style: textStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '\$${order.totalAmount.toStringAsFixed(2)}',
                                style: textStyles.heading2.copyWith(
                                  color: c.primaryCoral,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                          Divider(
                            color: c.border.withValues(alpha: 0.5),
                            height: 1,
                          ),
                          const SizedBox(height: 16),

                          // Payment Method
                          _buildSummaryRow(
                            context.tp('receipt_card_line', {
                              'brand': _payment?['card_brand'] ?? 'Visa',
                              'last4': _payment?['card_last_four'] ?? '4242',
                            }),
                            '\$${order.totalAmount.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),

                          const SizedBox(height: 16),
                          Text(
                            context.tp('receipt_approved_auth', {
                              'auth': _payment?['auth_code'] ?? 'AUTH1048V',
                            }),
                            style: textStyles.bodySmall.copyWith(
                              color: c.textMuted,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            context.t('receipt_thank_you'),
                            style: textStyles.bodySmall.copyWith(
                              color: c.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Email Notification Banner ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: c.successBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.mail_outline,
                            color: c.successFg,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.tp('receipt_delivered_banner', {
                                'email':
                                    _customer?.email ??
                                    context.t('receipt_customer_fallback'),
                              }),
                              style: textStyles.bodySmall.copyWith(
                                color: c.successFg,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Action Links ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.t('receipt_sending_again'),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            context.t('receipt_send_again'),
                            style: textStyles.labelSmall.copyWith(
                              color: c.primaryCoral,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '·',
                          style: textStyles.bodySmall.copyWith(
                            color: c.textMuted,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            context.t('receipt_change_email'),
                            style: textStyles.labelSmall.copyWith(
                              color: c.primaryCoral,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── Bottom Buttons ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.t('receipt_printing')),
                          backgroundColor: c.successFg,
                        ),
                      );
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
                        Icon(Icons.print, size: 20, color: c.textLight),
                        const SizedBox(width: 8),
                        Text(
                          context.t('receipt_print_button'),
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
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: c.surfaceTint,
                      foregroundColor: c.primaryCoral,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.t('receipt_done_button'),
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

  Widget _buildSummaryRow(
    String label,
    String value,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textStyles.bodyMedium.copyWith(color: c.textSecondary),
          ),
          Text(
            value,
            style: textStyles.labelMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
