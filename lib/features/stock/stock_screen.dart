// features/home/stock/stock_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/inventory_provider.dart';
import 'package:pos_system/providers/product_provider.dart';
import 'package:pos_system/data/models/product_model.dart';
import 'package:pos_system/data/models/iventory_model.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  // 0 = All, 1 = Low Stock, 2 = Out of Stock
  int _selectedFilterIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
      context.read<InventoryProvider>().fetchFullInventory();
    });
    _searchController.addListener(() {
      setState(
        () => _searchQuery = _searchController.text.toLowerCase().trim(),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    final productProvider = context.watch<ProductProvider>();
    final inventoryProvider = context.watch<InventoryProvider>();

    final isLoading = productProvider.isLoading || inventoryProvider.isLoading;

    // ── Group full inventory by product ID ──
    final Map<String, List<InventoryModel>> inventoryByProduct = {};
    for (final inv in inventoryProvider.fullInventory) {
      final variant = inventoryProvider.getVariantById(inv.variantId);
      if (variant != null) {
        inventoryByProduct.putIfAbsent(variant.productId, () => []).add(inv);
      }
    }

    // ── Calculate Summary Stats ──
    int totalProducts = productProvider.products.length;
    int totalUnits = inventoryProvider.fullInventory.fold(
      0,
      (sum, item) => sum + item.quantityAvailable,
    );

    int lowStockCount = 0;
    int outOfStockCount = 0;

    for (var product in productProvider.products) {
      final stockItems = inventoryByProduct[product.id] ?? [];
      final totalStock = stockItems.fold(
        0,
        (sum, item) => sum + item.quantityAvailable,
      );

      if (totalStock == 0) {
        outOfStockCount++;
      } else if (totalStock <= 5) {
        lowStockCount++;
      }
    }

    // ── Filter products (search + chip filter) ──
    final filteredProducts = productProvider.products.where((product) {
      // 👇 1. Apply search filter
      if (_searchQuery.isNotEmpty) {
        final nameMatches = product.name.toLowerCase().contains(_searchQuery);

        // Check if any variant matches SKU, color, or size
        final variants = inventoryProvider.variants
            .where((v) => v.productId == product.id)
            .toList();

        final variantMatches = variants.any(
          (v) =>
              v.sku.toLowerCase().contains(_searchQuery) ||
              v.color.toLowerCase().contains(_searchQuery) ||
              v.size.toLowerCase().contains(_searchQuery) ||
              v.name.toLowerCase().contains(_searchQuery),
        );

        if (!nameMatches && !variantMatches) return false;
      }

      // 👇 2. Apply chip filter
      if (_selectedFilterIndex == 0) return true; // All

      final stockItems = inventoryByProduct[product.id] ?? [];
      final totalStock = stockItems.fold(
        0,
        (sum, item) => sum + item.quantityAvailable,
      );

      if (_selectedFilterIndex == 1) {
        return totalStock > 0 && totalStock <= 5; // Low stock
      } else {
        return totalStock == 0; // Out of stock
      }
    }).toList();

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inventory',
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SoHo store',
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
              child: Skeletonizer(
                enabled: isLoading,
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    // 👇 Search Bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search product, SKU or barcode',
                            hintStyle: textStyles.bodyMedium.copyWith(
                              color: c.textMuted,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: c.textMuted,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: c.textMuted,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                  )
                                : Icon(
                                    Icons.document_scanner_outlined,
                                    color: c.primaryCoral,
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
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                    // Summary Cards
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                title: '$totalProducts',
                                subtitle: 'Products',
                                bgColor: const Color(0xFFF4F8FF),
                                textColor: c.textPrimary,
                                c: c,
                                textStyles: textStyles,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSummaryCard(
                                title: '$totalUnits',
                                subtitle: 'Units on hand',
                                bgColor: const Color(0xFFF4F8FF),
                                textColor: c.textPrimary,
                                c: c,
                                textStyles: textStyles,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSummaryCard(
                                title: '$lowStockCount',
                                subtitle: 'Low stock',
                                bgColor: const Color(0xFFFFF4E5),
                                textColor: const Color(0xFFD97706),
                                c: c,
                                textStyles: textStyles,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

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
                              'All stock',
                              isActive: _selectedFilterIndex == 0,
                              onTap: () =>
                                  setState(() => _selectedFilterIndex = 0),
                              c: c,
                              textStyles: textStyles,
                            ),
                            _buildFilterChip(
                              'Low stock · $lowStockCount',
                              isActive: _selectedFilterIndex == 1,
                              onTap: () =>
                                  setState(() => _selectedFilterIndex = 1),
                              c: c,
                              textStyles: textStyles,
                            ),
                            _buildFilterChip(
                              'Out of stock · $outOfStockCount',
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _searchQuery.isNotEmpty
                                  ? '${filteredProducts.length} results for "$_searchQuery"'
                                  : '${filteredProducts.length} products · Updated just now',
                              style: textStyles.bodySmall.copyWith(
                                color: c.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),

                    // Product List
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final product = filteredProducts[index];
                          final stockItems =
                              inventoryByProduct[product.id] ?? [];
                          return _buildInventoryItem(
                            product,
                            stockItems,
                            c,
                            textStyles,
                          );
                        }, childCount: filteredProducts.length),
                      ),
                    ),

                    // Empty State
                    if (filteredProducts.isEmpty && !isLoading)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  _searchQuery.isNotEmpty
                                      ? Icons.search_off_rounded
                                      : Icons.inventory_2_outlined,
                                  size: 48,
                                  color: c.textMuted.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'No products match "$_searchQuery"'
                                      : 'No products match this filter.',
                                  textAlign: TextAlign.center,
                                  style: textStyles.bodyMedium.copyWith(
                                    color: c.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
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

  Widget _buildSummaryCard({
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color textColor,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyles.heading1.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: textStyles.bodySmall.copyWith(
              color: textColor.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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

  Widget _buildInventoryItem(
    ProductModel product,
    List<InventoryModel> stockItems,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    final totalStock = stockItems.fold(
      0,
      (sum, item) => sum + item.quantityAvailable,
    );

    Color stockColor;
    String stockLabel;

    if (totalStock == 0) {
      stockColor = const Color(0xFFDC2626);
      stockLabel = '0 available · Out of stock';
    } else if (totalStock <= 5) {
      stockColor = const Color(0xFFD97706);
      stockLabel = '$totalStock available · Reorder soon';
    } else {
      stockColor = const Color(0xFF137333);
      stockLabel = '$totalStock available';
    }

    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteNames.manageStockName,
          extra: {
            'product': product,
            'inventory': stockItems.isNotEmpty ? stockItems.first : null,
            'isFromLowStock': false,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: c.border.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
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
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: c.textMuted.withValues(alpha: 0.5),
                    ),
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
                    '${stockItems.isNotEmpty ? stockItems.length : _getVariantCount(product.id, context)} variants · From \$${product.basePrice.toStringAsFixed(2)}',
                    style: textStyles.bodySmall.copyWith(
                      color: c.textMuted,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stockLabel,
                    style: textStyles.labelMedium.copyWith(
                      color: stockColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: c.textMuted, size: 24),
          ],
        ),
      ),
    );
  }

  int _getVariantCount(String productId, BuildContext context) {
    final inventoryProvider = context.read<InventoryProvider>();
    return inventoryProvider.variants
        .where((v) => v.productId == productId)
        .length;
  }
}
