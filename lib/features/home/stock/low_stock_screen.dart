// features/home/stock/low_stock_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/inventory_provider.dart';
import 'package:pos_system/providers/product_provider.dart';
import 'package:pos_system/data/models/product_model.dart';
import 'package:pos_system/data/models/iventory_model.dart';
import 'package:pos_system/data/models/variant_model.dart';

class LowStockScreen extends StatefulWidget {
  const LowStockScreen({super.key});

  @override
  State<LowStockScreen> createState() => _LowStockScreenState();
}

class _LowStockScreenState extends State<LowStockScreen> {
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryProvider>().fetchFullInventory();
      context.read<InventoryProvider>().fetchLowStockAlerts();
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    final inventoryProvider = context.watch<InventoryProvider>();
    final productProvider = context.watch<ProductProvider>();

    // Build the list with the CORRECT product per inventory item
    final List<Map<String, dynamic>> combinedAlerts = [];
    for (final inv in inventoryProvider.lowStockAlerts) {
      final variant = inventoryProvider.getVariantById(inv.variantId);
      if (variant == null) continue;

      final product = productProvider.products.firstWhere(
        (p) => p.id == variant.productId,
        orElse: () => productProvider.products.isNotEmpty
            ? productProvider.products.first
            : ProductModel(
                id: '',
                storeId: '',
                name: context.t('low_stock_unknown_product'),
                description: '',
                collectionName: '',
                imageUrl: '',
                basePrice: 0,
              ),
      );

      combinedAlerts.add({
        'inventory': inv,
        'product': product,
        'variant': variant,
      });
    }

    final filteredAlerts = combinedAlerts.where((alert) {
      final inv = alert['inventory'] as InventoryModel;
      if (_selectedFilterIndex == 0) return true;
      if (_selectedFilterIndex == 1) {
        return inv.quantityAvailable > 0 &&
            inv.quantityAvailable <= inv.lowStockThreshold;
      }
      if (_selectedFilterIndex == 2) return inv.quantityAvailable == 0;
      return true;
    }).toList();

    // Correct counts
    final int lowStockCount = combinedAlerts.where((a) {
      final inv = a['inventory'] as InventoryModel;
      return inv.quantityAvailable > 0 &&
          inv.quantityAvailable <= inv.lowStockThreshold;
    }).length;

    final int outOfStockCount = combinedAlerts.where((a) {
      final inv = a['inventory'] as InventoryModel;
      return inv.quantityAvailable == 0;
    }).length;

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
                        context.t('low_stock_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.tp('low_stock_subtitle', {
                          'count': '${combinedAlerts.length}',
                          'store': context.t('low_stock_store_fallback'),
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

            // Main Content
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  // Filter Chips
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 38,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        children: [
                          _buildFilterChip(
                            context.tp('low_stock_filter_all', {
                              'count': '${combinedAlerts.length}',
                            }),
                            isActive: _selectedFilterIndex == 0,
                            onTap: () =>
                                setState(() => _selectedFilterIndex = 0),
                            c: c,
                            textStyles: textStyles,
                          ),
                          _buildFilterChip(
                            context.tp('low_stock_filter_low', {
                              'count': '$lowStockCount',
                            }),
                            isActive: _selectedFilterIndex == 1,
                            onTap: () =>
                                setState(() => _selectedFilterIndex = 1),
                            c: c,
                            textStyles: textStyles,
                          ),
                          _buildFilterChip(
                            context.tp('low_stock_filter_out', {
                              'count': '$outOfStockCount',
                            }),
                            isActive: _selectedFilterIndex == 2,
                            onTap: () =>
                                setState(() => _selectedFilterIndex = 2),
                            c: c,
                            textStyles: textStyles,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // List Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        context.tp('low_stock_header_availability', {
                          'date': 'OCT 19, 10:30 AM',
                        }),
                        style: textStyles.labelSmall.copyWith(
                          color: c.textSecondary,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  // List
                  if (filteredAlerts.isEmpty && !inventoryProvider.isLoading)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Center(
                          child: Text(
                            context.t('low_stock_empty'),
                            style: textStyles.bodyMedium.copyWith(
                              color: c.textMuted,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return _buildAlertItem(
                            filteredAlerts[index],
                            inventoryProvider,
                            c,
                            textStyles,
                          );
                        }, childCount: filteredAlerts.length),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label, {
    required bool isActive,
    required VoidCallback onTap,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? c.primaryCoral : c.surfaceLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: textStyles.labelSmall.copyWith(
                color: isActive ? c.textLight : c.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertItem(
    Map<String, dynamic> alert,
    InventoryProvider inventoryProvider,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    final InventoryModel inventory = alert['inventory'];
    final ProductModel product = alert['product'];
    final VariantModel variant = alert['variant'];

    final bool isOut = inventory.quantityAvailable == 0;
    // ✅ FIXED: was 0xFFDC2626 / 0xFFD97706
    final Color statusColor = isOut ? c.dangerFg : c.warningFg;

    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteNames.manageStockName,
          extra: {
            'inventory': inventory,
            'product': product,
            'variant': variant,
            'isFromLowStock': true,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: c.border.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                // ✅ FIXED: was 0xFFE8EBEE
                color: c.isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFE8EBEE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl,
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
                    product.name,
                    style: textStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${variant.color} / ${variant.size} · ${variant.sku}',
                    style: textStyles.bodySmall.copyWith(
                      color: c.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isOut
                      ? context.t('low_stock_status_out')
                      : context.tp('low_stock_status_left', {
                          'count': '${inventory.quantityAvailable}',
                        }),
                  style: textStyles.labelMedium.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.tp('low_stock_status_min', {
                    'count': '${inventory.lowStockThreshold}',
                  }),
                  style: textStyles.bodySmall.copyWith(
                    color: c.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: c.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
