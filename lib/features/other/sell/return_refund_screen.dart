import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/data/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/models/order_model.dart';
import 'package:pos_system/providers/inventory_provider.dart';
import 'package:pos_system/providers/order_provider.dart';
import 'package:pos_system/providers/product_provider.dart';

class ReturnRefundScreen extends StatefulWidget {
  const ReturnRefundScreen({super.key});

  @override
  State<ReturnRefundScreen> createState() => _ReturnRefundScreenState();
}

class _ReturnRefundScreenState extends State<ReturnRefundScreen> {
  OrderModel? _order;
  bool _isInitialized = false;

  // State maps to track dynamic items
  final Map<String, bool> _selectedItems = {};
  final Map<String, int> _itemQuantities = {};

  bool _isRestockSelected = true;
  bool _isProcessing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra;
      if (extra is OrderModel) {
        _order = extra;
      }
      _isInitialized = true;
    }
  }

  double _calculateRefundSubtotal(
    List<Map<String, dynamic>> orderItems,
    List<Map<String, dynamic>> itemRefunds,
  ) {
    double subtotal = 0.0;
    for (var item in orderItems) {
      final id = item['id'] as String;
      final originalQty = item['quantity'] as int;
      final refundedQty = itemRefunds
          .where((r) => r['order_item_id'] == id)
          .fold(0, (sum, r) => sum + (r['quantity_refunded'] as int));
      final availableQty = originalQty - refundedQty;

      if (_selectedItems[id] == true && availableQty > 0) {
        final qty = _itemQuantities[id] ?? 1;
        final unitPrice = (item['unit_price'] as num).toDouble();
        subtotal += unitPrice * qty;
      }
    }
    return subtotal;
  }

  Future<void> _processRefund(
    OrderProvider orderProvider,
    InventoryProvider inventoryProvider,
    List<Map<String, dynamic>> orderItems,
    List<Map<String, dynamic>> itemRefunds,
  ) async {
    if (_order == null) return;

    final List<Map<String, dynamic>> itemsToRefund = [];

    for (var item in orderItems) {
      final id = item['id'] as String;
      final originalQty = item['quantity'] as int;
      final alreadyRefundedQty = itemRefunds
          .where((r) => r['order_item_id'] == id)
          .fold(0, (sum, r) => sum + (r['quantity_refunded'] as int));
      final remainingQty = originalQty - alreadyRefundedQty;

      if (_selectedItems[id] == true && remainingQty > 0) {
        final qtyToRefund = _itemQuantities[id] ?? 1;
        final unitPrice = (item['unit_price'] as num).toDouble();
        final itemTotalPrice = unitPrice * qtyToRefund;

        final itemProportion = _order!.subTotal > 0
            ? itemTotalPrice / _order!.subTotal
            : 0.0;

        final proportionalDiscount = _order!.discountAmount * itemProportion;
        final proportionalTax = _order!.taxAmount * itemProportion;

        final exactRefund =
            itemTotalPrice - proportionalDiscount + proportionalTax;

        itemsToRefund.add({
          'order_item_id': id,
          'variant_id': item['variant_id'],
          'quantity': qtyToRefund,
          'amount': exactRefund,
        });
      }
    }

    if (itemsToRefund.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('return_refund_error_no_selection'))),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final subtotal = _calculateRefundSubtotal(orderItems, itemRefunds);

      final orderSubtotal = _order!.subTotal;
      final totalProportion = orderSubtotal > 0
          ? (subtotal / orderSubtotal)
          : 0.0;

      final expectedDiscount = _order!.discountAmount * totalProportion;
      final expectedTax = _order!.taxAmount * totalProportion;
      final expectedTotalRefund = subtotal - expectedDiscount + expectedTax;

      final success = await orderProvider.processRefund(
        orderId: _order!.id,
        items: itemsToRefund,
        totalRefundAmount: expectedTotalRefund,
      );

      if (success) {
        if (_isRestockSelected) {
          for (var item in itemsToRefund) {
            await inventoryProvider.updateStock(
              variantId: item['variant_id'],
              quantityChange: item['quantity'] as int,
              reason: 'Customer Return',
              note: 'Returned from Order ${_order!.orderNumber}',
            );
          }
        }

        if (mounted) {
          final updatedOrder = context
              .read<OrderProvider>()
              .salesHistory
              .firstWhere((o) => o.id == _order!.id);
          context.pushReplacementNamed(
            RouteNames.refundCompleteName,
            extra: updatedOrder,
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final orderProvider = context.watch<OrderProvider>();
    final inventoryProvider = context.watch<InventoryProvider>();
    final productProvider = context.watch<ProductProvider>();

    if (_order == null) {
      return Scaffold(
        body: Center(child: Text(context.t('return_refund_not_found'))),
      );
    }

    final orderItems = orderProvider.orderItems;
    final itemRefunds = orderProvider.orderItemRefunds;

    if (orderItems.isNotEmpty && _selectedItems.isEmpty) {
      for (var item in orderItems) {
        final id = item['id'] as String;
        _selectedItems[id] = true;
        _itemQuantities[id] = 1;
      }
    }

    // ── Calculations for UI ──
    final subtotal = _calculateRefundSubtotal(orderItems, itemRefunds);

    final orderSubtotal = _order!.subTotal;
    final totalProportion = orderSubtotal > 0
        ? (subtotal / orderSubtotal)
        : 0.0;

    final proportionalDiscount = _order!.discountAmount * totalProportion;
    final proportionalTax = _order!.taxAmount * totalProportion;
    final totalRefund = subtotal - proportionalDiscount + proportionalTax;

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
                        context.t('return_refund_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.tp('return_refund_subtitle', {
                          'orderNumber': _order!.orderNumber,
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
                    const SizedBox(height: 8),
                    Text(
                      context.t('return_refund_intro'),
                      style: textStyles.bodyMedium.copyWith(
                        color: c.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Dynamic Items List ──
                    ...orderItems.map((item) {
                      final id = item['id'] as String;
                      final variant = inventoryProvider.getVariantById(
                        item['variant_id'],
                      );

                      final product = variant != null
                          ? productProvider.products.firstWhere(
                              (p) => p.id == variant.productId,
                              orElse: () => productProvider.products.isNotEmpty
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

                      final originalQty = item['quantity'] as int;
                      final alreadyRefundedQty = itemRefunds
                          .where((r) => r['order_item_id'] == id)
                          .fold(
                            0,
                            (sum, r) => sum + (r['quantity_refunded'] as int),
                          );
                      final remainingQty = originalQty - alreadyRefundedQty;

                      if ((_itemQuantities[id] ?? 1) > remainingQty) {
                        _itemQuantities[id] = remainingQty > 0
                            ? remainingQty
                            : 1;
                      }
                      if (remainingQty == 0) {
                        _selectedItems[id] = false;
                      }

                      return Column(
                        children: [
                          _buildReturnItem(
                            isSelected: _selectedItems[id] ?? false,
                            onCheckboxChanged: remainingQty == 0
                                ? null
                                : (val) => setState(
                                    () => _selectedItems[id] = val ?? false,
                                  ),
                            title:
                                product?.name ??
                                context.t('return_refund_item_unknown'),
                            variant: variant != null
                                ? context.tp('return_refund_item_variant', {
                                    'color': variant.color,
                                    'size': variant.size,
                                    'qty': '$originalQty',
                                  })
                                : context.tp('return_refund_item_qty_only', {
                                    'qty': '$originalQty',
                                  }),
                            price: context.tp('return_refund_item_price', {
                              'price': (item['unit_price'] as num)
                                  .toStringAsFixed(2),
                            }),
                            quantity: _itemQuantities[id] ?? 1,
                            onQuantityChanged: (newQty) =>
                                setState(() => _itemQuantities[id] = newQty),
                            maxQuantity: remainingQty,
                            imageUrl: product?.imageUrl,
                            alreadyRefundedQty: alreadyRefundedQty,
                            c: c,
                            textStyles: textStyles,
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            color: c.border.withValues(alpha: 0.5),
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),

                    // ── Return Reason ──
                    Text(
                      context.t('return_refund_reason_label'),
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: c.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.t('return_refund_reason_default'),
                            style: textStyles.bodyLarge,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: c.textMuted,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Restock Checkbox ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => setState(
                            () => _isRestockSelected = !_isRestockSelected,
                          ),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _isRestockSelected
                                  ? c.primaryCoral
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _isRestockSelected
                                    ? c.primaryCoral
                                    : c.border,
                                width: 1.5,
                              ),
                            ),
                            child: _isRestockSelected
                                ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: c.textLight,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.t('return_refund_restock_title'),
                                style: textStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.t('return_refund_restock_sub'),
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
                    const SizedBox(height: 24),

                    // ── Refund Summary ──
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
                            context.t('return_refund_summary_title'),
                            style: textStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.t('return_refund_summary_subtotal'),
                                style: textStyles.bodySmall.copyWith(
                                  color: c.textSecondary,
                                ),
                              ),
                              Text(
                                '\$${subtotal.toStringAsFixed(2)}',
                                style: textStyles.labelSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.t('return_refund_summary_discount'),
                                style: textStyles.bodySmall.copyWith(
                                  color: c.textSecondary,
                                ),
                              ),
                              Text(
                                '-\$${proportionalDiscount.toStringAsFixed(2)}',
                                style: textStyles.labelSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.t('return_refund_summary_tax'),
                                style: textStyles.bodySmall.copyWith(
                                  color: c.textSecondary,
                                ),
                              ),
                              Text(
                                '\$${proportionalTax.toStringAsFixed(2)}',
                                style: textStyles.labelSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
                                context.t('return_refund_summary_total'),
                                style: textStyles.labelMedium.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '\$${totalRefund.toStringAsFixed(2)}',
                                style: textStyles.heading2.copyWith(
                                  color: c.primaryCoral,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.tp('return_refund_payment_note', {
                        'date': context.t('return_refund_payment_note_date'),
                      }),
                      style: textStyles.bodySmall.copyWith(
                        color: c.textMuted,
                        fontSize: 12,
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
                    onPressed: _isProcessing
                        ? null
                        : () => _processRefund(
                            orderProvider,
                            inventoryProvider,
                            orderItems,
                            itemRefunds,
                          ),
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
                    child: _isProcessing
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
                              Icon(
                                Icons.undo_rounded,
                                size: 20,
                                color: c.textLight,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                context.tp('return_refund_action', {
                                  'amount': totalRefund.toStringAsFixed(2),
                                }),
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
                    context.t('return_refund_footer'),
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

  // ── Helper Widget for Item Row ──
  Widget _buildReturnItem({
    required bool isSelected,
    required ValueChanged<bool?>? onCheckboxChanged,
    required String title,
    required String variant,
    required String price,
    required int quantity,
    required ValueChanged<int> onQuantityChanged,
    required int maxQuantity,
    required int alreadyRefundedQty,
    String? imageUrl,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    final isFullyReturned = maxQuantity == 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkbox
        GestureDetector(
          onTap: isFullyReturned ? null : () => onCheckboxChanged!(!isSelected),
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: isFullyReturned
                  ? c.surfaceLight
                  : isSelected
                  ? c.primaryCoral
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isFullyReturned
                    ? c.border
                    : isSelected
                    ? c.primaryCoral
                    : c.border,
                width: 1.5,
              ),
            ),
            child: isSelected && !isFullyReturned
                ? Icon(Icons.check, size: 16, color: c.textLight)
                : null,
          ),
        ),
        const SizedBox(width: 12),

        // Thumbnail
        Container(
          width: 56,
          height: 56,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
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
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(Icons.image_outlined, color: c.textMuted),
                    ),
                  )
                : Center(child: Icon(Icons.image_outlined, color: c.textMuted)),
          ),
        ),
        const SizedBox(width: 16),

        // Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  decoration: isFullyReturned
                      ? TextDecoration.lineThrough
                      : null,
                  color: isFullyReturned ? c.textMuted : null,
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

              if (alreadyRefundedQty > 0) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: c.warningBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isFullyReturned
                        ? context.t('return_refund_item_fully_returned')
                        : context.tp('return_refund_item_already_returned', {
                            'qty': '$alreadyRefundedQty',
                          }),
                    style: textStyles.labelSmall.copyWith(
                      color: c.warningFg,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 8),

              // Price and Quantity Stepper
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price,
                    style: textStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      decoration: isFullyReturned
                          ? TextDecoration.lineThrough
                          : null,
                      color: isFullyReturned ? c.textMuted : null,
                    ),
                  ),

                  if (isSelected && !isFullyReturned)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: c.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          _buildQuantityButton(
                            icon: Icons.remove,
                            onTap: () {
                              if (quantity > 1) onQuantityChanged(quantity - 1);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '$quantity',
                              style: textStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _buildQuantityButton(
                            icon: Icons.add,
                            onTap: () {
                              if (quantity < maxQuantity) {
                                onQuantityChanged(quantity + 1);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
