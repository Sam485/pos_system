// features/sell/receipt_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          // 👇 FIX: Fetch products AND order items AND payment
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
        body: Center(child: Text('Order not found')),
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
                        'Receipt',
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${order.orderNumber} · Alternative card checkout',
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
                        color: const Color(0xFFF8F9FA),
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
                            'SoHo · 120 Spring St, New York',
                            style: textStyles.bodySmall.copyWith(
                              color: c.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '$date · Register 01',
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
                              'Receipt ${order.orderNumber} · ${_customer?.firstName ?? "Guest"} ${_customer?.lastName ?? ""}',
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

                              // 👇 FIX: Safe product lookup
                              ProductModel? product;
                              if (variant != null &&
                                  productProvider.products.isNotEmpty) {
                                product = productProvider.products.firstWhere(
                                  (p) => p.id == variant.productId,
                                  orElse: () => productProvider.products.first,
                                );
                              }

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
                                            '${item['quantity']} × ${product?.name ?? variant?.name ?? "Item"}',
                                            style: textStyles.bodyMedium,
                                          ),
                                          Text(
                                            '${variant?.color ?? ""} / ${variant?.size ?? ""} · \$${(item['unit_price'] as num).toStringAsFixed(2)} each',
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
                            'Subtotal',
                            '\$${order.subTotal.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),
                          _buildSummaryRow(
                            'Welcome discount · 10%',
                            '-\$${order.discountAmount.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),
                          _buildSummaryRow(
                            'Sales tax · 10%',
                            '\$${order.taxAmount.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total paid',
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
                            '${_payment?['card_brand'] ?? 'Visa'} **** ${_payment?['card_last_four'] ?? '4242'}',
                            '\$${order.totalAmount.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),

                          const SizedBox(height: 16),
                          Text(
                            'Approved · Auth ${_payment?['auth_code'] ?? 'AUTH1048V'}',
                            style: textStyles.bodySmall.copyWith(
                              color: c.textMuted,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            'Thank you for shopping with fold.',
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
                        color: const Color(0xFFE6F4EA), // Light green
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.mail_outline,
                            color: const Color(0xFF137333),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Receipt delivered to ${_customer?.email ?? "customer"}.',
                              style: textStyles.bodySmall.copyWith(
                                color: const Color(0xFF137333),
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
                              const SnackBar(content: Text('Sending again...')),
                            );
                          },
                          child: Text(
                            'Send again',
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
                            'Change email address',
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
                        const SnackBar(
                          content: Text('Printing receipt...'),
                          backgroundColor: Color(0xFF137333),
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
                          'Print receipt',
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
                      backgroundColor: const Color(0xFFF4F8FF),
                      foregroundColor: c.primaryCoral,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Done',
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
