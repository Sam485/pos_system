// features/sell/transaction_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/shared/helper/safe_pop.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/models/order_model.dart';
import 'package:pos_system/data/models/customer_model.dart';
import 'package:pos_system/data/models/product_model.dart';
import 'package:pos_system/data/enum/order_status_enum.dart';
import 'package:pos_system/providers/inventory_provider.dart';
import 'package:pos_system/providers/order_provider.dart';
import 'package:pos_system/providers/product_provider.dart';

class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({super.key});

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  OrderModel? _order;
  CustomerModel? _customer;
  bool _isInitialized = false;

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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<OrderProvider>().fetchOrderItems(_order!.id);
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
        body: const Center(child: Text('Order not found.')),
      );
    }

    final order = _order!;
    final orderItems = orderProvider.orderItems;
    final orderItemRefunds = orderProvider.orderItemRefunds;

    // 👇 Check for all refund states
    final isFullyRefunded = order.status == OrderStatusEnum.fullyrefunded;
    final isPartiallyRefunded =
        order.status == OrderStatusEnum.partitallyrefunded;

    // ✅ FIXED: Use theme-aware badge colors from AppThemeColors
    Color statusColor;
    Color textColor;
    String statusLabel;

    if (isFullyRefunded) {
      statusColor = c.dangerBg;
      textColor = c.dangerFg;
      statusLabel = 'Fully refunded';
    } else if (isPartiallyRefunded) {
      statusColor = c.warningBg;
      textColor = c.warningFg;
      statusLabel = 'Partially refunded';
    } else {
      statusColor = c.successBg;
      textColor = c.successFg;
      statusLabel = 'Completed';
    }

    final customerName = _customer != null
        ? '${_customer!.firstName} ${_customer!.lastName}'
        : 'Guest customer';
    final customerEmail = _customer?.email ?? 'No email';
    final initials = _customer != null
        ? '${_customer!.firstName.isNotEmpty ? _customer!.firstName[0] : ''}${_customer!.lastName.isNotEmpty ? _customer!.lastName[0] : ''}'
              .toUpperCase()
        : 'GC';

    final date =
        '${order.createdAt.month}/${order.createdAt.day}/${order.createdAt.year}';
    final time =
        '${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}';

    final totalItems = orderItems.fold(
      0,
      (sum, item) => sum + (item['quantity'] as int),
    );

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
                        'Order ${order.orderNumber}',
                        style: textStyles.heading2.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$date · $time',
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_horiz, color: c.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // ── Main Scrollable Content ──
            Expanded(
              child: Skeletonizer(
                enabled: orderProvider.isLoading,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              statusLabel,
                              style: textStyles.labelSmall.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Sold by Alex · Register 01',
                            style: textStyles.bodySmall.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ✅ FIXED: Customer Card — surfaceTint + subtle border
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: c.surfaceTint,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: c.isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : const Color(0xFFE8F0FE),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                // ✅ FIXED: avatar bg
                                color: c.isDark
                                    ? Colors.white.withValues(alpha: 0.10)
                                    : const Color(0xFFE8F0FE),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                initials,
                                style: textStyles.labelSmall.copyWith(
                                  // ✅ FIXED: avatar text
                                  color: c.primaryCoral,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customerName,
                                    style: textStyles.labelMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    customerEmail,
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
                      const SizedBox(height: 24),

                      // 👇 Items List with Refund Tracking
                      if (orderItems.isEmpty && !orderProvider.isLoading)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'No items in this order',
                              style: textStyles.bodySmall.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                          ),
                        )
                      else
                        ...orderItems.map((item) {
                          final variant = inventoryProvider.getVariantById(
                            item['variant_id'],
                          );

                          // Find the product to get the image URL
                          final product = variant != null
                              ? productProvider.products.firstWhere(
                                  (p) => p.id == variant.productId,
                                  orElse: () =>
                                      productProvider.products.isNotEmpty
                                      ? productProvider.products.first
                                      : ProductModel(
                                          id: '',
                                          storeId: '',
                                          name: '',
                                          description: '',
                                          collectionName: '',
                                          imageUrl: '',
                                          basePrice: 0,
                                        ),
                                )
                              : null;

                          // 👇 Calculate returned quantities
                          final refundsForItem = orderItemRefunds.where(
                            (r) => r['order_item_id'] == item['id'],
                          );
                          final totalRefundedQty = refundsForItem.fold(
                            0,
                            (sum, r) => sum + (r['quantity_refunded'] as int),
                          );
                          final originalQty = item['quantity'] as int;
                          final remainingQty = originalQty - totalRefundedQty;

                          return Column(
                            children: [
                              _buildItemRow(
                                title: variant?.name ?? 'Unknown Variant',
                                variant: variant != null
                                    ? '${variant.color} / ${variant.size} · Qty $originalQty'
                                    : 'Qty $originalQty',
                                price:
                                    '\$${(item['total_price'] as num).toStringAsFixed(2)}',
                                imageUrl: product?.imageUrl,
                                refundedQty: totalRefundedQty,
                                remainingQty: remainingQty,
                                c: c,
                                textStyles: textStyles,
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }),

                      Divider(
                        color: c.border.withValues(alpha: 0.5),
                        height: 1,
                      ),
                      const SizedBox(height: 16),

                      // Order Summary
                      _buildSummaryRow(
                        'Subtotal · $totalItems items',
                        '\$${order.subTotal.toStringAsFixed(2)}',
                        c,
                        textStyles,
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        'Welcome discount · 10%',
                        '-\$${order.discountAmount.toStringAsFixed(2)}',
                        c,
                        textStyles,
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        'Sales tax · 10%',
                        '\$${order.taxAmount.toStringAsFixed(2)}',
                        c,
                        textStyles,
                      ),

                      // 👇 Refunded Amount Row
                      if (order.refundedAmount > 0) ...[
                        const SizedBox(height: 8),
                        _buildSummaryRow(
                          'Refunded amount',
                          '-\$${order.refundedAmount.toStringAsFixed(2)}',
                          c,
                          textStyles,
                          // ✅ FIXED: warningFg adapts to theme
                          valueColor: c.warningFg,
                        ),
                      ],

                      const SizedBox(height: 16),
                      Divider(
                        color: c.border.withValues(alpha: 0.5),
                        height: 1,
                      ),
                      const SizedBox(height: 16),

                      // Total Due
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Net total',
                            style: textStyles.labelMedium.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            // 👇 Show Net Total (Total - Refunded)
                            '\$${(order.totalAmount - order.refundedAmount).toStringAsFixed(2)}',
                            style: textStyles.heading1.copyWith(
                              color: c.primaryCoral,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ✅ FIXED: Payment Details Card — surfaceLight
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: c.surfaceLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.payments_outlined,
                                  color: c.primaryCoral,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Payment details',
                                  style: textStyles.labelMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildSummaryRow(
                              'Total paid',
                              '\$${order.totalAmount.toStringAsFixed(2)}',
                              c,
                              textStyles,
                            ),
                            if (order.refundedAmount > 0) ...[
                              const SizedBox(height: 8),
                              _buildSummaryRow(
                                'Refunded to customer',
                                '-\$${order.refundedAmount.toStringAsFixed(2)}',
                                c,
                                textStyles,
                                // ✅ FIXED
                                valueColor: c.warningFg,
                              ),
                            ],
                            const SizedBox(height: 16),
                            Divider(
                              color: c.border.withValues(alpha: 0.5),
                              height: 1,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Receipt sent to $customerEmail',
                              style: textStyles.bodySmall.copyWith(
                                color: c.textMuted,
                                fontSize: 12,
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
            ),

            // ── Bottom Action Buttons ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.pushNamed(
                        RouteNames.returnRefundName,
                        extra: order,
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
                        Icon(Icons.undo_rounded, size: 20, color: c.textLight),
                        const SizedBox(width: 8),
                        Text(
                          'Return items',
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
                      // 👇 FIX: Pass the full customer model to the receipt
                      context.pushNamed(
                        RouteNames.receiptName,
                        extra: {'order': order, 'customer': _customer},
                      );
                    },
                    style: TextButton.styleFrom(
                      // ✅ FIXED: was 0xFFF4F8FF
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
                        Icon(
                          Icons.send_rounded,
                          size: 18,
                          color: c.primaryCoral,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'View receipt', // Changed from 'Resend receipt' since it navigates
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
    );
  }

  // ── Helper Widgets ──

  Widget _buildItemRow({
    required String title,
    required String variant,
    required String price,
    String? imageUrl,
    required int refundedQty,
    required int remainingQty,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    final isFullyRefunded = remainingQty == 0 && refundedQty > 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            // ✅ FIXED: image placeholder bg
            color: c.isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE8EBEE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.shopping_bag_outlined, color: c.textMuted),
                  )
                : Icon(Icons.shopping_bag_outlined, color: c.textMuted),
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
                  decoration: isFullyRefunded
                      ? TextDecoration.lineThrough
                      : null,
                  color: isFullyRefunded ? c.textMuted : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                variant,
                style: textStyles.bodySmall.copyWith(
                  color: c.textMuted,
                  fontSize: 13,
                ),
              ),

              // 👇 Refund Badges
              if (refundedQty > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        // ✅ FIXED: refund badge bg
                        color: isFullyRefunded ? c.dangerBg : c.warningBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isFullyRefunded ? 'Refunded' : 'Returned: $refundedQty',
                        style: textStyles.labelSmall.copyWith(
                          // ✅ FIXED: refund badge fg
                          color: isFullyRefunded ? c.dangerFg : c.warningFg,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 8),
              Text(
                price,
                style: textStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  decoration: isFullyRefunded
                      ? TextDecoration.lineThrough
                      : null,
                  color: isFullyRefunded ? c.textMuted : null,
                ),
              ),
            ],
          ),
        ),
      ],
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
          style: textStyles.bodyMedium.copyWith(color: c.textSecondary),
        ),
        Text(
          value,
          style: textStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
