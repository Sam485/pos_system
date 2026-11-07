// features/home/stock/stock_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/models/iventory_model.dart';
import 'package:pos_system/data/models/product_model.dart';
import 'package:pos_system/providers/inventory_provider.dart';
import 'package:pos_system/providers/language_provider.dart';
import 'package:pos_system/providers/product_provider.dart';

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
      if (!mounted) return;
      context.read<ProductProvider>().fetchProducts();
      context.read<InventoryProvider>().fetchFullInventory();
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase().trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.wait([
      context.read<ProductProvider>().fetchProducts(),
      context.read<InventoryProvider>().fetchFullInventory(),
    ]);
  }

  // ═════════════════════════════════════════════════════════════
  // Build
  // ═════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();

    final c = AppTextStylesX(context).colors;
    final textStyles = AppTextStylesX(context);

    final productProvider = context.watch<ProductProvider>();
    final inventoryProvider = context.watch<InventoryProvider>();

    final isLoading = productProvider.isLoading || inventoryProvider.isLoading;

    // ── Group full inventory by product ID ──
    final inventoryByProduct = <String, List<InventoryModel>>{};
    for (final inv in inventoryProvider.fullInventory) {
      final variant = inventoryProvider.getVariantById(inv.variantId);
      if (variant != null) {
        inventoryByProduct.putIfAbsent(variant.productId, () => []).add(inv);
      }
    }

    // ── Summary stats ──
    final totalProducts = productProvider.products.length;
    final totalUnits = inventoryProvider.fullInventory.fold<int>(
      0,
      (sum, item) => sum + item.quantityAvailable,
    );

    var lowStockCount = 0;
    var outOfStockCount = 0;

    for (final product in productProvider.products) {
      final stockItems = inventoryByProduct[product.id] ?? const [];
      final totalStock = stockItems.fold<int>(
        0,
        (sum, item) => sum + item.quantityAvailable,
      );

      if (totalStock == 0) {
        outOfStockCount++;
      } else if (totalStock <= 5) {
        lowStockCount++;
      }
    }

    // ── Filter ──
    final filteredProducts = productProvider.products.where((product) {
      if (_searchQuery.isNotEmpty) {
        final nameMatches = product.name.toLowerCase().contains(_searchQuery);
        final variantMatches = inventoryProvider.variants
            .where((v) => v.productId == product.id)
            .any(
              (v) =>
                  v.sku.toLowerCase().contains(_searchQuery) ||
                  v.color.toLowerCase().contains(_searchQuery) ||
                  v.size.toLowerCase().contains(_searchQuery) ||
                  v.name.toLowerCase().contains(_searchQuery),
            );
        if (!nameMatches && !variantMatches) return false;
      }

      if (_selectedFilterIndex == 0) return true;

      final stockItems = inventoryByProduct[product.id] ?? const [];
      final totalStock = stockItems.fold<int>(
        0,
        (sum, item) => sum + item.quantityAvailable,
      );

      if (_selectedFilterIndex == 1) {
        return totalStock > 0 && totalStock <= 5;
      }
      return totalStock == 0;
    }).toList();

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(c, textStyles),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                color: c.primaryCoral,
                backgroundColor: c.background,
                child: Skeletonizer(
                  enabled: isLoading,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    slivers: [
                      // ── Search bar ──
                      SliverToBoxAdapter(child: _buildSearchBar(c, textStyles)),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),

                      // ── Summary cards ──
                      SliverToBoxAdapter(
                        child: _buildSummaryRow(
                          totalProducts: totalProducts,
                          totalUnits: totalUnits,
                          lowStockCount: lowStockCount,
                          c: c,
                          textStyles: textStyles,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),

                      // ── Filter chips ──
                      SliverToBoxAdapter(
                        child: _buildFilterRow(
                          lowStockCount: lowStockCount,
                          outOfStockCount: outOfStockCount,
                          c: c,
                          textStyles: textStyles,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),

                      // ── List header ──
                      SliverToBoxAdapter(
                        child: _buildListHeader(
                          count: filteredProducts.length,
                          c: c,
                          textStyles: textStyles,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 12)),

                      // ── Product list ──
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final product = filteredProducts[index];
                            final stockItems =
                                inventoryByProduct[product.id] ?? const [];
                            return _buildInventoryItem(
                              product,
                              stockItems,
                              c,
                              textStyles,
                            );
                          }, childCount: filteredProducts.length),
                        ),
                      ),

                      // ── Empty state ──
                      if (filteredProducts.isEmpty && !isLoading)
                        SliverToBoxAdapter(
                          child: _buildEmptyState(c, textStyles),
                        ),

                      const SliverToBoxAdapter(child: SizedBox(height: 40)),
                    ],
                  ),
                ),
              ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t('stock_title'),
                style: textStyles.heading2.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(
                context.t('stock_store_default'),
                style: textStyles.bodySmall.copyWith(color: c.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppThemeColors c, AppTextStylesX textStyles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _searchController,
        style: textStyles.bodyMedium.copyWith(color: c.textPrimary),
        decoration: InputDecoration(
          hintText: context.t('stock_search_hint'),
          hintStyle: textStyles.bodyMedium.copyWith(color: c.textMuted),
          prefixIcon: Icon(Icons.search_rounded, color: c.textMuted),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded, color: c.textMuted, size: 20),
                  onPressed: () => _searchController.clear(),
                )
              : Icon(Icons.document_scanner_outlined, color: c.primaryCoral),
          filled: true,
          fillColor: c.surfaceLight,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
            borderSide: BorderSide(color: c.primaryCoral, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required int totalProducts,
    required int totalUnits,
    required int lowStockCount,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: '$totalProducts',
              subtitle: context.t('stock_summary_products'),
              bgColor: c.surfaceTint,
              textColor: c.textPrimary,
              textStyles: textStyles,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: '$totalUnits',
              subtitle: context.t('stock_summary_units'),
              bgColor: c.surfaceTint,
              textColor: c.textPrimary,
              textStyles: textStyles,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: '$lowStockCount',
              subtitle: context.t('stock_summary_low'),
              bgColor: c.warningBg,
              textColor: c.warningFg,
              textStyles: textStyles,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow({
    required int lowStockCount,
    required int outOfStockCount,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          _buildFilterChip(
            context.t('stock_filter_all'),
            isActive: _selectedFilterIndex == 0,
            onTap: () => setState(() => _selectedFilterIndex = 0),
            c: c,
            textStyles: textStyles,
          ),
          _buildFilterChip(
            context.tp('stock_filter_low', {'count': '$lowStockCount'}),
            isActive: _selectedFilterIndex == 1,
            onTap: () => setState(() => _selectedFilterIndex = 1),
            c: c,
            textStyles: textStyles,
          ),
          _buildFilterChip(
            context.tp('stock_filter_out', {'count': '$outOfStockCount'}),
            isActive: _selectedFilterIndex == 2,
            onTap: () => setState(() => _selectedFilterIndex = 2),
            c: c,
            textStyles: textStyles,
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader({
    required int count,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              _searchQuery.isNotEmpty
                  ? context.tp('stock_list_results_for', {
                      'count': '$count',
                      'query': _searchQuery,
                    })
                  : context.tp('stock_list_count', {'count': '$count'}),
              style: textStyles.bodySmall.copyWith(color: c.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppThemeColors c, AppTextStylesX textStyles) {
    return Padding(
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
                  ? context.tp('stock_empty_search', {'query': _searchQuery})
                  : context.t('stock_empty_filter'),
              textAlign: TextAlign.center,
              style: textStyles.bodyMedium.copyWith(color: c.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // Reusable widgets
  // ═════════════════════════════════════════════════════════════

  Widget _buildSummaryCard({
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color textColor,
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
              fontSize: 20,
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
    final totalStock = stockItems.fold<int>(
      0,
      (sum, item) => sum + item.quantityAvailable,
    );

    final Color stockColor;
    final String stockLabel;

    if (totalStock == 0) {
      stockColor = c.dangerFg;
      stockLabel = context.t('stock_status_out');
    } else if (totalStock <= 5) {
      stockColor = c.warningFg;
      stockLabel = context.tp('stock_status_low', {'count': '$totalStock'});
    } else {
      stockColor = c.successFg;
      stockLabel = context.tp('stock_status_ok', {'count': '$totalStock'});
    }

    final variantCount = stockItems.isNotEmpty
        ? stockItems.length
        : _getVariantCount(product.id, context);

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
            _buildThumbnail(product.imageUrl, c),
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
                    context.tp('stock_item_variants_from', {
                      'count': '$variantCount',
                      'price': product.basePrice.toStringAsFixed(2),
                    }),
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

  Widget _buildThumbnail(String url, AppThemeColors c) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: c.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildThumbnailContent(url, c),
      ),
    );
  }

  Widget _buildThumbnailContent(String url, AppThemeColors c) {
    if (url.isEmpty) {
      return Center(
        child: Icon(
          Icons.image_outlined,
          color: c.textMuted.withValues(alpha: 0.5),
        ),
      );
    }
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Center(
          child: Icon(
            Icons.image_outlined,
            color: c.textMuted.withValues(alpha: 0.5),
          ),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2, color: c.textMuted),
        ),
      ),
      errorWidget: (_, _, _) => Center(
        child: Icon(
          Icons.image_outlined,
          color: c.textMuted.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  int _getVariantCount(String productId, BuildContext context) {
    return context
        .read<InventoryProvider>()
        .variants
        .where((v) => v.productId == productId)
        .length;
  }
}
