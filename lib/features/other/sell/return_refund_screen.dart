// features/sell/return_refund_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/models/order_model.dart';
import 'package:pos_system/data/models/product_model.dart';
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

  final Map<String, bool> _selectedItems = {};
  final Map<String, int> _itemQuantities = {};

  bool _isRestockSelected = true;
  bool _isProcessing = false;

  // Guard so defaults are seeded only once
  bool _defaultsSeeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;

    final extra = GoRouterState.of(context).extra;
    if (extra is OrderModel) _order = extra;

    _isInitialized = true;
  }

  // ═════════════════════════════════════════════════════════════
  // Calculations
  // ═════════════════════════════════════════════════════════════

  int _refundedQtyFor(
    String orderItemId,
    List<Map<String, dynamic>> itemRefunds,
  ) {
    return itemRefunds
        .where((r) => r['order_item_id'] == orderItemId)
        .fold<int>(0, (sum, r) => sum + (r['quantity_refunded'] as int));
  }

  double _calculateRefundSubtotal(
    List<Map<String, dynamic>> orderItems,
    List<Map<String, dynamic>> itemRefunds,
  ) {
    double subtotal = 0.0;
    for (final item in orderItems) {
      final id = item['id'] as String;
      final originalQty = item['quantity'] as int;
      final refundedQty = _refundedQtyFor(id, itemRefunds);
      final availableQty = originalQty - refundedQty;

      if (_selectedItems[id] == true && availableQty > 0) {
        final qty = _itemQuantities[id] ?? 1;
        final unitPrice = (item['unit_price'] as num).toDouble();
        subtotal += unitPrice * qty;
      }
    }
    return subtotal;
  }

  // ═════════════════════════════════════════════════════════════
  // Refund processing
  // ═════════════════════════════════════════════════════════════

  Future<void> _processRefund(
    OrderProvider orderProvider,
    InventoryProvider inventoryProvider,
    List<Map<String, dynamic>> orderItems,
    List<Map<String, dynamic>> itemRefunds,
  ) async {
    if (_order == null) return;

    final itemsToRefund = <Map<String, dynamic>>[];

    for (final item in orderItems) {
      final id = item['id'] as String;
      final originalQty = item['quantity'] as int;
      final alreadyRefundedQty = _refundedQtyFor(id, itemRefunds);
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
      _showSnack(context.t('return_refund_error_no_selection'), isError: true);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final subtotal = _calculateRefundSubtotal(orderItems, itemRefunds);
      final orderSubtotal = _order!.subTotal;
      final totalProportion = orderSubtotal > 0
          ? subtotal / orderSubtotal
          : 0.0;

      final expectedDiscount = _order!.discountAmount * totalProportion;
      final expectedTax = _order!.taxAmount * totalProportion;
      final expectedTotalRefund = subtotal - expectedDiscount + expectedTax;

      final success = await orderProvider.processRefund(
        orderId: _order!.id,
        items: itemsToRefund,
        totalRefundAmount: expectedTotalRefund,
      );

      if (!success || !mounted) return;

      // Restock (only if the flag is on)
      if (_isRestockSelected) {
        for (final item in itemsToRefund) {
          await inventoryProvider.updateStock(
            variantId: item['variant_id'],
            quantityChange: item['quantity'] as int,
            reason: 'Customer Return',
            note: 'Returned from Order ${_order!.orderNumber}',
          );
        }
      }

      if (!mounted) return;

      // Find updated order and navigate
      final updatedOrder = orderProvider.salesHistory
          .where((o) => o.id == _order!.id)
          .firstOrNull;

      if (updatedOrder != null) {
        context.pushReplacementNamed(
          RouteNames.refundCompleteName,
          extra: updatedOrder,
        );
      } else {
        context.pop();
      }
    } catch (e) {
      _showSnack('$e', isError: true);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red.shade700 : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // Build
  // ═════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final c = AppTextStylesX(context).colors;
    final textStyles = AppTextStylesX(context);
    final orderProvider = context.watch<OrderProvider>();
    final inventoryProvider = context.watch<InventoryProvider>();
    final productProvider = context.watch<ProductProvider>();

    if (_order == null) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(child: Text(context.t('return_refund_not_found'))),
      );
    }

    final orderItems = orderProvider.orderItems;
    final itemRefunds = orderProvider.orderItemRefunds;

    // Seed defaults ONCE (previously re-ran every build)
    if (!_defaultsSeeded && orderItems.isNotEmpty) {
      _defaultsSeeded = true;
      for (final item in orderItems) {
        final id = item['id'] as String;
        final originalQty = item['quantity'] as int;
        final refundedQty = _refundedQtyFor(id, itemRefunds);
        final remainingQty = originalQty - refundedQty;

        _selectedItems[id] = remainingQty > 0;
        _itemQuantities[id] = remainingQty > 0 ? 1 : 0;
      }
    }

    final subtotal = _calculateRefundSubtotal(orderItems, itemRefunds);
    final orderSubtotal = _order!.subTotal;
    final totalProportion = orderSubtotal > 0 ? subtotal / orderSubtotal : 0.0;

    final proportionalDiscount = _order!.discountAmount * totalProportion;
    final proportionalTax = _order!.taxAmount * totalProportion;
    final totalRefund = subtotal - proportionalDiscount + proportionalTax;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(c, textStyles),
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

                    // ── Item rows ──
                    ..._buildItemRows(
                      orderItems: orderItems,
                      itemRefunds: itemRefunds,
                      inventoryProvider: inventoryProvider,
                      productProvider: productProvider,
                      c: c,
                      textStyles: textStyles,
                    ),

                    // ── Return reason ──
                    _buildReasonField(c, textStyles),
                    const SizedBox(height: 24),

                    // ── Restock checkbox ──
                    _buildRestockToggle(c, textStyles),
                    const SizedBox(height: 24),

                    // ── Summary ──
                    _buildSummaryCard(
                      subtotal: subtotal,
                      proportionalDiscount: proportionalDiscount,
                      proportionalTax: proportionalTax,
                      totalRefund: totalRefund,
                      c: c,
                      textStyles: textStyles,
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

            // ── Bottom action ──
            _buildBottomAction(
              orderProvider: orderProvider,
              inventoryProvider: inventoryProvider,
              orderItems: orderItems,
              itemRefunds: itemRefunds,
              totalRefund: totalRefund,
              c: c,
              textStyles: textStyles,
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // Builders
  // ═════════════════════════════════════════════════════════════

  Widget _buildAppBar(AppThemeColors c, AppTextStylesX textStyles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
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
                style: textStyles.heading2.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 2),
              Text(
                context.tp('return_refund_subtitle', {
                  'orderNumber': _order!.orderNumber,
                }),
                style: textStyles.bodySmall.copyWith(color: c.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildItemRows({
    required List<Map<String, dynamic>> orderItems,
    required List<Map<String, dynamic>> itemRefunds,
    required InventoryProvider inventoryProvider,
    required ProductProvider productProvider,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return orderItems.map((item) {
      final id = item['id'] as String;
      final variant = inventoryProvider.getVariantById(item['variant_id']);

      ProductModel? product;
      if (variant != null) {
        for (final p in productProvider.products) {
          if (p.id == variant.productId) {
            product = p;
            break;
          }
        }
        if (product == null && productProvider.products.isNotEmpty) {
          product = productProvider.products.first;
        }
      }

      final originalQty = item['quantity'] as int;
      final alreadyRefundedQty = _refundedQtyFor(id, itemRefunds);
      final remainingQty = originalQty - alreadyRefundedQty;

      // Clamp stored quantity to remaining (safe guard, not mutating during build)
      final currentQty = (_itemQuantities[id] ?? 1).clamp(
        1,
        remainingQty > 0 ? remainingQty : 1,
      );

      return Column(
        children: [
          _buildReturnItem(
            isSelected: _selectedItems[id] ?? false,
            onCheckboxChanged: remainingQty == 0
                ? null
                : (val) => setState(() => _selectedItems[id] = val ?? false),
            title: product?.name ?? context.t('return_refund_item_unknown'),
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
              'price': (item['unit_price'] as num).toStringAsFixed(2),
            }),
            quantity: currentQty,
            onQuantityChanged: (newQty) => setState(() {
              _itemQuantities[id] = newQty.clamp(1, remainingQty);
            }),
            maxQuantity: remainingQty,
            imageUrl: product?.imageUrl,
            alreadyRefundedQty: alreadyRefundedQty,
            c: c,
            textStyles: textStyles,
          ),
          const SizedBox(height: 16),
          Divider(color: c.border.withValues(alpha: 0.5), height: 1),
          const SizedBox(height: 16),
        ],
      );
    }).toList();
  }

  Widget _buildReasonField(AppThemeColors c, AppTextStylesX textStyles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t('return_refund_reason_label'),
          style: textStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              Icon(Icons.keyboard_arrow_down_rounded, color: c.textMuted),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRestockToggle(AppThemeColors c, AppTextStylesX textStyles) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isRestockSelected = !_isRestockSelected),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _isRestockSelected ? c.primaryCoral : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _isRestockSelected ? c.primaryCoral : c.border,
                width: 1.5,
              ),
            ),
            child: _isRestockSelected
                ? Icon(Icons.check, size: 16, color: c.textLight)
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
    );
  }

  Widget _buildSummaryCard({
    required double subtotal,
    required double proportionalDiscount,
    required double proportionalTax,
    required double totalRefund,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return Container(
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
          _summaryRow(
            context.t('return_refund_summary_subtotal'),
            '\$${subtotal.toStringAsFixed(2)}',
            c,
            textStyles,
          ),
          const SizedBox(height: 8),
          _summaryRow(
            context.t('return_refund_summary_discount'),
            '-\$${proportionalDiscount.toStringAsFixed(2)}',
            c,
            textStyles,
          ),
          const SizedBox(height: 8),
          _summaryRow(
            context.t('return_refund_summary_tax'),
            '\$${proportionalTax.toStringAsFixed(2)}',
            c,
            textStyles,
          ),
          const SizedBox(height: 16),
          Divider(color: c.border.withValues(alpha: 0.5), height: 1),
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
    );
  }

  Widget _summaryRow(
    String label,
    String value,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textStyles.bodySmall.copyWith(color: c.textSecondary),
        ),
        Text(
          value,
          style: textStyles.labelSmall.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildBottomAction({
    required OrderProvider orderProvider,
    required InventoryProvider inventoryProvider,
    required List<Map<String, dynamic>> orderItems,
    required List<Map<String, dynamic>> itemRefunds,
    required double totalRefund,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return Padding(
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
              disabledBackgroundColor: c.primaryCoral.withValues(alpha: 0.5),
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
                      Icon(Icons.undo_rounded, size: 20, color: c.textLight),
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
    );
  }

  // ═════════════════════════════════════════════════════════════
  // Item row
  // ═════════════════════════════════════════════════════════════

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
        // ── Checkbox ──
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

        // ── Thumbnail ──
        Container(
          width: 56,
          height: 56,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: c.surfaceLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildThumbnail(imageUrl, c),
          ),
        ),
        const SizedBox(width: 16),

        // ── Details ──
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
                              if (quantity > 1) {
                                onQuantityChanged(quantity - 1);
                              }
                            },
                            c: c,
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
                            c: c,
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

  Widget _buildThumbnail(String? imageUrl, AppThemeColors c) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Icon(Icons.image_outlined, color: c.textMuted);
    }
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.image_outlined, color: c.textMuted),
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2, color: c.textMuted),
        ),
      ),
      errorWidget: (context, url, error) =>
          Icon(Icons.image_outlined, color: c.textMuted),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required AppThemeColors c,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 16, color: c.textPrimary),
      ),
    );
  }
}
