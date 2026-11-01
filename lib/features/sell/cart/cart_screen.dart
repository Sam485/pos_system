// features/sell/cart/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/cart_provider.dart';
import 'package:pos_system/providers/setting_provider.dart';
import 'package:pos_system/data/models/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().loadCart();
      // 👇 Ensure discounts are loaded
      final settingsProvider = context.read<SettingsProvider>();
      if (settingsProvider.discounts.isEmpty) {
        settingsProvider.fetchSettings();
      }
    });
  }

  // 👇 NEW: Show discount picker bottom sheet
  void _showDiscountPicker() {
    final cartProvider = context.read<CartProvider>();
    final settingsProvider = context.read<SettingsProvider>();
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: c.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Apply discount',
                        style: textStyles.heading2.copyWith(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded, color: c.textMuted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    children: [
                      // 👇 No discount option
                      _buildDiscountOption(
                        title: 'No discount',
                        subtitle: 'Remove any applied discount',
                        isSelected: !cartProvider.hasDiscount,
                        onTap: () {
                          cartProvider.removeDiscount();
                          Navigator.pop(context);
                        },
                        c: c,
                        textStyles: textStyles,
                      ),
                      const SizedBox(height: 8),
                      // 👇 Existing discounts
                      ...settingsProvider.discounts.map((discount) {
                        final isSelected =
                            cartProvider.discountName == discount.name;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildDiscountOption(
                            title: discount.name,
                            subtitle: discount.description,
                            isSelected: isSelected,
                            onTap: () {
                              // 👇 Calculate discount amount from subtotal
                              double amount = 0.0;
                              if (discount.type == 'percentage') {
                                amount =
                                    cartProvider.subtotal *
                                    (discount.value / 100);
                              } else {
                                amount = discount.value;
                              }

                              // 👇 Guard: Don't allow discount larger than subtotal
                              if (amount > cartProvider.subtotal) {
                                amount = cartProvider.subtotal;
                              }

                              cartProvider.applyDiscount(
                                name: discount.name,
                                amount: amount,
                                isPercentage: discount.type == 'percentage',
                                value: discount.value,
                              );
                              Navigator.pop(context);
                            },
                            c: c,
                            textStyles: textStyles,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDiscountOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4F8FF) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? c.primaryCoral : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? c.primaryCoral : c.textMuted,
              size: 22,
            ),
            const SizedBox(width: 12),
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final cartProvider = context.watch<CartProvider>();

    final subtotal = cartProvider.subtotal;
    final discountAmount = cartProvider.discountAmount;
    final taxableAmount = subtotal - discountAmount;
    final taxAmount = taxableAmount * 0.10;
    final totalDue = taxableAmount + taxAmount;
    final totalItems = cartProvider.itemCount;
    final customer = cartProvider.selectedCustomer;

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
                        'Cart',
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
              child: cartProvider.items.isEmpty
                  ? _buildEmptyState(c, textStyles)
                  : CustomScrollView(
                      physics: const ClampingScrollPhysics(),
                      slivers: [
                        // 1. Customer Banner (Dynamic)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: InkWell(
                              onTap: () {
                                context.pushNamed(
                                  RouteNames.customerSelectionName,
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F8FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    if (customer != null)
                                      Container(
                                        width: 40,
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFE8F0FE),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '${customer.firstName.isNotEmpty ? customer.firstName[0] : ''}${customer.lastName.isNotEmpty ? customer.lastName[0] : ''}'
                                              .toUpperCase(),
                                          style: textStyles.labelSmall.copyWith(
                                            color: const Color(0xFF1967D2),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    else
                                      Icon(
                                        Icons.person_add_alt_1_rounded,
                                        color: c.primaryCoral,
                                        size: 22,
                                      ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            customer != null
                                                ? '${customer.firstName} ${customer.lastName}'
                                                : 'Add a customer',
                                            style: textStyles.labelMedium
                                                .copyWith(
                                                  color: c.primaryCoral,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            customer != null
                                                ? customer.email
                                                : 'Send receipts & make it personal',
                                            style: textStyles.bodySmall
                                                .copyWith(
                                                  color: c.textSecondary,
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: c.primaryCoral,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),

                        // 2. Cart Items List
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final item = cartProvider.items[index];
                              return _buildCartItem(
                                item,
                                c,
                                textStyles,
                                cartProvider,
                              );
                            }, childCount: cartProvider.items.length),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),

                        // 👇 3. Order Discount (Tappable to open picker)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order discount',
                                      style: textStyles.labelMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _showDiscountPicker,
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        cartProvider.hasDiscount
                                            ? 'Change'
                                            : 'Apply',
                                        style: textStyles.labelSmall.copyWith(
                                          color: c.primaryCoral,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: _showDiscountPicker,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8F9FA),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.local_offer_outlined,
                                          color: c.primaryCoral,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartProvider.hasDiscount
                                                    ? cartProvider
                                                              .discountName ??
                                                          'Discount'
                                                    : 'No discount applied',
                                                style: textStyles.labelMedium
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                cartProvider.hasDiscount
                                                    ? '${cartProvider.isPercentageDiscount ? "${cartProvider.discountValue}% off" : "Fixed amount"} · -\$${cartProvider.discountAmount.toStringAsFixed(2)}'
                                                    : 'Tap to select a discount',
                                                style: textStyles.bodySmall
                                                    .copyWith(
                                                      color: c.textMuted,
                                                      fontSize: 12,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (cartProvider.hasDiscount)
                                          IconButton(
                                            onPressed: () =>
                                                cartProvider.removeDiscount(),
                                            icon: Icon(
                                              Icons.close_rounded,
                                              color: c.textMuted,
                                              size: 20,
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          )
                                        else
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: c.textMuted,
                                            size: 20,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),

                        // 4. Add Note Button
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: InkWell(
                              onTap: () =>
                                  context.pushNamed(RouteNames.orderNoteName),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.note_add_outlined,
                                    color: c.primaryCoral,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Add an order note',
                                    style: textStyles.labelSmall.copyWith(
                                      color: c.primaryCoral,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),

                        // 5. Order Summary
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Column(
                              children: [
                                _buildSummaryRow(
                                  'Subtotal · $totalItems items',
                                  '\$${subtotal.toStringAsFixed(2)}',
                                  c,
                                  textStyles,
                                ),
                                const SizedBox(height: 8),
                                if (cartProvider.hasDiscount) ...[
                                  _buildSummaryRow(
                                    '${cartProvider.discountName}${cartProvider.isPercentageDiscount ? ' · ${cartProvider.discountValue}%' : ''}',
                                    '-\$${cartProvider.discountAmount.toStringAsFixed(2)}',
                                    c,
                                    textStyles,
                                    valueColor: const Color(0xFF137333),
                                  ),
                                  const SizedBox(height: 8),
                                ],
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total due',
                                      style: textStyles.heading2.copyWith(
                                        fontSize: 18,
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
                        const SliverToBoxAdapter(child: SizedBox(height: 100)),
                      ],
                    ),
            ),

            // ── Bottom Action Button ──
            if (cartProvider.items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: ElevatedButton(
                  onPressed: cartProvider.isLoading
                      ? null
                      : () {
                          context.pushNamed(
                            RouteNames.checkoutName,
                            extra: {
                              'subtotal': subtotal,
                              'discount': discountAmount,
                              'tax': taxAmount,
                              'total': totalDue,
                              'customerId': customer?.id,
                            },
                          );
                        },
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
                  child: cartProvider.isLoading
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
                              Icons.arrow_forward_rounded,
                              size: 20,
                              color: c.textLight,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Continue to checkout',
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
    );
  }

  // ── Helper Widgets ──

  Widget _buildEmptyState(AppThemeColors c, AppTextStylesX textStyles) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: c.textMuted),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: textStyles.heading2.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            'Add products to start a new sale.',
            style: textStyles.bodySmall.copyWith(color: c.textMuted),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: c.primaryCoral,
              foregroundColor: c.textLight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    CartModel item,
    AppThemeColors c,
    AppTextStylesX textStyles,
    CartProvider provider,
  ) {
    final availableStock = provider.getStockForVariant(item.variantId);
    final isMaxStock = item.quantity >= availableStock;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EBEE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(Icons.image_outlined, color: c.textMuted),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: textStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.variantName.isNotEmpty ? item.variantName : 'Standard',
                  style: textStyles.bodySmall.copyWith(
                    color: c.textMuted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${item.totalPrice.toStringAsFixed(2)}',
                  style: textStyles.heading2.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
                        if (item.quantity > 1) {
                          provider.updateQuantity(item.id, item.quantity - 1);
                        } else {
                          provider.removeItem(item.id);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.quantity}',
                        style: textStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildQuantityButton(
                      icon: Icons.add,
                      onTap: isMaxStock
                          ? null
                          : () => provider.updateQuantity(
                              item.id,
                              item.quantity + 1,
                            ),
                      color: isMaxStock ? c.textMuted : null,
                    ),
                  ],
                ),
              ),
              if (isMaxStock)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Max stock reached',
                    style: textStyles.labelSmall.copyWith(
                      color: const Color(0xFFD97706),
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 16, color: color ?? Colors.black),
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
          style: textStyles.bodyMedium.copyWith(color: c.textSecondary),
        ),
        Text(
          value,
          style: textStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? c.textPrimary,
          ),
        ),
      ],
    );
  }
}
