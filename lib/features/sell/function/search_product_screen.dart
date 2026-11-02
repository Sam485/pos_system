// features/sell/function/search_product_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/inventory_provider.dart';
import 'package:pos_system/providers/language_provider.dart';
import 'package:pos_system/providers/product_provider.dart';
import 'package:pos_system/data/models/product_model.dart';
import 'package:pos_system/data/models/variant_model.dart';
import 'package:pos_system/data/models/iventory_model.dart';

class SearchProductsScreen extends StatefulWidget {
  const SearchProductsScreen({super.key});

  @override
  State<SearchProductsScreen> createState() => _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
      context.read<InventoryProvider>().fetchLowStockAlerts();
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 👇 Rebuild when the language changes
    context.watch<LanguageProvider>();

    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final productProvider = context.watch<ProductProvider>();
    final inventoryProvider = context.watch<InventoryProvider>();

    final isLoading = productProvider.isLoading || inventoryProvider.isLoading;

    // 👇 Filter products by name, collection, or variant SKU
    final searchResults = productProvider.products.where((product) {
      if (_searchQuery.isEmpty) return true;

      if (product.name.toLowerCase().contains(_searchQuery)) return true;

      if (product.collectionName.toLowerCase().contains(_searchQuery)) {
        return true;
      }

      final variants = inventoryProvider.variants.where(
        (v) => v.productId == product.id,
      );
      for (var v in variants) {
        if (v.sku.toLowerCase().contains(_searchQuery)) return true;
      }

      return false;
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
                        context.t('search_products_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.tp('search_products_subtitle', {
                          'store': context.t('search_products_store_default'),
                          'orderNumber': context.t(
                            'search_products_order_default',
                          ),
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

            // ── Search Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.t('search_products_label'),
                    style: textStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: context.t('search_products_hint'),
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
                                Icons.clear,
                                color: c.textMuted,
                                size: 20,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
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
                        borderSide: BorderSide(
                          color: c.primaryCoral,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Dynamic Content Area (Results) ──
            Expanded(
              child: Skeletonizer(
                enabled: isLoading,
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    // Results Header (Count + Filters button)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _searchQuery.isNotEmpty
                                    ? context
                                          .tp('search_products_results_for', {
                                            'count': '${searchResults.length}',
                                            'query': _searchQuery,
                                          })
                                    : context.tp('search_products_results', {
                                        'count': '${searchResults.length}',
                                      }),
                                style: textStyles.bodySmall.copyWith(
                                  color: c.textSecondary,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                context.pushNamed(RouteNames.productFilterName);
                              },
                              icon: Icon(
                                Icons.tune_rounded,
                                color: c.primaryCoral,
                                size: 18,
                              ),
                              label: Text(
                                context.t('search_products_filters'),
                                style: textStyles.labelMedium.copyWith(
                                  color: c.primaryCoral,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),

                    // Empty State
                    if (searchResults.isEmpty && !isLoading)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Center(
                            child: Text(
                              context.tp('search_products_empty', {
                                'query': _searchQuery,
                              }),
                              style: textStyles.bodyMedium.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      // Results List
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final product = searchResults[index];
                            return _buildSearchResultItem(
                              product,
                              inventoryProvider,
                              c,
                              textStyles,
                            );
                          }, childCount: searchResults.length),
                        ),
                      ),

                    // Matching text note
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                        child: Text(
                          context.t('search_products_match_note'),
                          style: textStyles.bodySmall.copyWith(
                            color: c.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper Widget: Search Result List Item ──
  Widget _buildSearchResultItem(
    ProductModel product,
    InventoryProvider inventoryProvider,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    final variants = inventoryProvider.variants
        .where((v) => v.productId == product.id)
        .toList();
    VariantModel? displayVariant = variants.isNotEmpty ? variants.first : null;

    if (_searchQuery.isNotEmpty) {
      final matching = variants.where(
        (v) => v.sku.toLowerCase().contains(_searchQuery),
      );
      if (matching.isNotEmpty) {
        displayVariant = matching.first;
      }
    }

    int stock = 0;
    if (displayVariant != null) {
      final inv = inventoryProvider.lowStockAlerts.firstWhere(
        (i) => i.variantId == displayVariant!.id,
        orElse: () => InventoryModel(
          id: '',
          variantId: '',
          storeId: '',
          quantityAvailable: 0,
          lowStockThreshold: 5,
        ),
      );
      stock = inv.quantityAvailable;
    }

    return InkWell(
      onTap: () {
        context.pushNamed(RouteNames.productDetailName, extra: product);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: c.border.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Image
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

            // Details
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
                    displayVariant != null
                        ? context.tp('search_products_variant_line', {
                            'color': displayVariant.color,
                            'size': displayVariant.size,
                            'sku': displayVariant.sku,
                          })
                        : context.t('search_products_no_variants'),
                    style: textStyles.bodySmall.copyWith(
                      color: c.textMuted,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '\$${product.basePrice.toStringAsFixed(2)}',
                        style: textStyles.heading2.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.tp('search_products_stock_available', {
                          'count': '$stock',
                        }),
                        style: textStyles.labelMedium.copyWith(
                          color: c.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Add Button
            InkWell(
              onTap: () {
                context.pushNamed(RouteNames.productDetailName, extra: product);
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.add, color: c.primaryCoral, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
