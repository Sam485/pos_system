// features/sell/detail/product_detail_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/models/product_model.dart';
import 'package:pos_system/data/models/variant_model.dart';
import 'package:pos_system/providers/cart_provider.dart';
import 'package:pos_system/providers/inventory_provider.dart';
import 'package:pos_system/providers/language_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductModel? _product;
  bool _isInitialized = false;

  VariantModel? _selectedVariant;
  int _quantity = 1;

  // Track the variant id the user *explicitly* chose, so we don't
  // overwrite it when variants arrive asynchronously.
  String? _userSelectedVariantId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra;
      if (extra is ProductModel) {
        _product = extra;
      }
      _isInitialized = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final inventoryProvider = context.read<InventoryProvider>();
        if (inventoryProvider.fullInventory.isEmpty) {
          inventoryProvider.fetchFullInventory();
        }
      });
    }
  }

  // ── Compute variants for the current product ─────────────────
  List<VariantModel> _variantsFor(InventoryProvider inv) {
    final pid = _product?.id;
    if (pid == null) return const [];
    return inv.variants.where((v) => v.productId == pid).toList();
  }

  // ── Compute stock for a given variant ────────────────────────
  int _stockFor(InventoryProvider inv, VariantModel? v) {
    if (v == null) return 0;
    return inv.fullInventory
            .where((i) => i.variantId == v.id)
            .firstOrNull
            ?.quantityAvailable ??
        0;
  }

  // ── Resolve the variant to use (no side effects) ─────────────
  //
  // Rule:
  //  1. If the user explicitly picked one and it's still available → use it.
  //  2. Otherwise → use the first variant.
  VariantModel? _resolveSelectedVariant(List<VariantModel> variants) {
    if (variants.isEmpty) return null;

    if (_userSelectedVariantId != null) {
      for (final v in variants) {
        if (v.id == _userSelectedVariantId) return v;
      }
    }
    return variants.first;
  }

  void _selectVariant(VariantModel v, InventoryProvider inv) {
    final newStock = _stockFor(inv, v);
    setState(() {
      _selectedVariant = v;
      _userSelectedVariantId = v.id;
      // Clamp quantity to new stock
      _quantity = _quantity.clamp(1, newStock == 0 ? 1 : newStock);
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();

    final c = AppTextStylesX(context).colors;
    final textStyles = AppTextStylesX(context);
    final inventoryProvider = context.watch<InventoryProvider>();
    final cartProvider = context.watch<CartProvider>();

    if (_product == null) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(child: Text(context.t('product_detail_not_found'))),
      );
    }

    final variants = _variantsFor(inventoryProvider);

    // Recompute the selected variant from state on every build.
    // No mutation here — the getter is pure.
    _selectedVariant = _resolveSelectedVariant(variants);

    final availableColors = variants.map((v) => v.color).toSet().toList();
    final availableSizes = variants.map((v) => v.size).toSet().toList();

    availableSizes.sort((a, b) {
      const order = {'XS': 0, 'S': 1, 'M': 2, 'L': 3, 'XL': 4};
      return (order[a] ?? 99).compareTo(order[b] ?? 99);
    });

    final currentStock = _stockFor(inventoryProvider, _selectedVariant);
    final unitPrice = _selectedVariant?.price ?? _product!.basePrice;
    final totalPrice = unitPrice * _quantity;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── App bar ─────────────────────────────────────
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
                  Text(
                    context.t('product_detail_title'),
                    style: textStyles.heading2.copyWith(fontSize: 20),
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

            // ── Body ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildImage(c),
                    const SizedBox(height: 20),
                    _buildCollectionRow(currentStock, c, textStyles),
                    const SizedBox(height: 12),
                    _buildNamePriceRow(unitPrice, c, textStyles),
                    const SizedBox(height: 12),
                    Text(
                      _product!.description,
                      style: textStyles.bodyMedium.copyWith(
                        color: c.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildColorSelector(
                      availableColors,
                      variants,
                      inventoryProvider,
                      c,
                      textStyles,
                    ),
                    const SizedBox(height: 24),
                    _buildSizeSelector(
                      availableSizes,
                      variants,
                      inventoryProvider,
                      currentStock,
                      c,
                      textStyles,
                    ),
                    const SizedBox(height: 24),
                    _buildQuantityRow(currentStock, c, textStyles),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── Add-to-cart button ──────────────────────────
            _buildAddButton(
              cartProvider,
              unitPrice,
              totalPrice,
              currentStock,
              c,
              textStyles,
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // Builder helpers
  // ═════════════════════════════════════════════════════════════

  Widget _buildImage(AppThemeColors c) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: c.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _product!.imageUrl.startsWith('assets/')
            ? Image.asset(
                _product!.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: c.textMuted,
                    size: 50,
                  ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: _product!.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: c.textMuted,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: c.textMuted,
                    size: 50,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildCollectionRow(
    int currentStock,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _product!.collectionName.toUpperCase(),
          style: textStyles.labelSmall.copyWith(
            color: c.textMuted,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: currentStock > 0 ? c.successBg : c.warningBg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            currentStock > 0
                ? context.t('product_detail_in_stock')
                : context.t('product_detail_out_of_stock'),
            style: textStyles.labelSmall.copyWith(
              color: currentStock > 0 ? c.successFg : c.warningFg,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNamePriceRow(
    double unitPrice,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _product!.name,
                style: textStyles.heading1.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.tp('product_detail_sku', {
                  'sku':
                      _selectedVariant?.sku ??
                      context.t('product_detail_sku_na'),
                }),
                style: textStyles.bodySmall.copyWith(
                  color: c.textMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Text(
          '\$${unitPrice.toStringAsFixed(2)}',
          style: textStyles.heading1.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector(
    List<String> availableColors,
    List<VariantModel> variants,
    InventoryProvider inventoryProvider,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tp('product_detail_color', {
            'color':
                _selectedVariant?.color ?? context.t('product_detail_sku_na'),
          }),
          style: textStyles.labelMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: availableColors.map((color) {
            final isSelected = _selectedVariant?.color == color;
            final swatchColor = _getColorForName(color);
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () {
                  // Prefer keeping the current size, fall back to first
                  final matching = variants.where(
                    (v) => v.color == color && v.size == _selectedVariant?.size,
                  );
                  final newVariant = matching.isNotEmpty
                      ? matching.first
                      : variants.firstWhere((v) => v.color == color);
                  _selectVariant(newVariant, inventoryProvider);
                },
                child: _buildColorCircle(swatchColor, isSelected, c),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSizeSelector(
    List<String> availableSizes,
    List<VariantModel> variants,
    InventoryProvider inventoryProvider,
    int currentStock,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tp('product_detail_size', {
                'size':
                    _selectedVariant?.size ??
                    context.t('product_detail_sku_na'),
              }),
              style: textStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              context.tp('product_detail_stock_available', {
                'count': '$currentStock',
                'store': context.t('product_detail_store_default'),
              }),
              style: textStyles.bodySmall.copyWith(
                color: currentStock > 0 ? c.successFg : c.warningFg,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: availableSizes.map((size) {
              final isSelected = _selectedVariant?.size == size;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    final matching = variants.where(
                      (v) =>
                          v.size == size && v.color == _selectedVariant?.color,
                    );
                    final newVariant = matching.isNotEmpty
                        ? matching.first
                        : variants.firstWhere((v) => v.size == size);
                    _selectVariant(newVariant, inventoryProvider);
                  },
                  child: Container(
                    width: 56,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? c.primaryCoral : c.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      size,
                      style: textStyles.labelMedium.copyWith(
                        color: isSelected ? c.textLight : c.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityRow(
    int currentStock,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.t('product_detail_quantity'),
          style: textStyles.labelMedium.copyWith(fontWeight: FontWeight.w600),
        ),
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
                  if (_quantity > 1) setState(() => _quantity--);
                },
                c: c,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$_quantity',
                  style: textStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildQuantityButton(
                icon: Icons.add,
                onTap: () {
                  if (currentStock == 0 || _quantity < currentStock) {
                    setState(() => _quantity++);
                  }
                },
                c: c,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(
    CartProvider cartProvider,
    double unitPrice,
    double totalPrice,
    int currentStock,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: ElevatedButton(
        onPressed: cartProvider.isLoading
            ? null
            : () => _handleAddToCart(cartProvider, unitPrice, currentStock),
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
                  Icon(Icons.add, size: 20, color: c.textLight),
                  const SizedBox(width: 8),
                  Text(
                    context.tp('product_detail_add_button', {
                      'count': '$_quantity',
                      'amount': totalPrice.toStringAsFixed(2),
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
    );
  }

  Future<void> _handleAddToCart(
    CartProvider cartProvider,
    double unitPrice,
    int currentStock,
  ) async {
    if (_selectedVariant == null) {
      _showSnack(
        context.t('product_detail_error_select_variant'),
        isError: true,
      );
      return;
    }
    if (currentStock == 0) {
      _showSnack(context.t('product_detail_error_out_of_stock'), isError: true);
      return;
    }
    if (_quantity > currentStock) {
      _showSnack(
        context.tp('product_detail_error_not_enough', {
          'count': '$currentStock',
        }),
        isError: true,
      );
      return;
    }

    final success = await cartProvider.addToCart(
      productId: _product!.id,
      variantId: _selectedVariant!.id,
      quantity: _quantity,
      unitPrice: unitPrice,
      productName: _product!.name,
      imageUrl: _product!.imageUrl,
      variantName: '${_selectedVariant!.color} / ${_selectedVariant!.size}',
    );

    if (!mounted) return;
    if (success) {
      _showSnack(context.t('product_detail_added_toast'), isSuccess: true);
      context.pop();
    } else {
      _showSnack(
        cartProvider.error ?? context.t('product_detail_failed_add'),
        isError: true,
      );
    }
  }

  void _showSnack(String msg, {bool isError = false, bool isSuccess = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError
            ? Colors.red
            : (isSuccess ? const Color(0xFF137333) : null),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // Small widgets & helpers
  // ═════════════════════════════════════════════════════════════

  Widget _buildColorCircle(Color color, bool isSelected, AppThemeColors c) {
    return Container(
      width: 36,
      height: 36,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? c.primaryCoral : Colors.transparent,
          width: 2,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: c.border, width: 1),
        ),
      ),
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
        padding: const EdgeInsets.all(12.0),
        child: Icon(icon, size: 16, color: c.textPrimary),
      ),
    );
  }

  Color _getColorForName(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('white')) return const Color(0xFFFFFFFF);
    if (lower.contains('navy')) return const Color(0xFF1C2A3A);
    if (lower.contains('sky') || lower.contains('blue')) {
      return const Color(0xFFC4D7EE);
    }
    if (lower.contains('sand') || lower.contains('beige')) {
      return const Color(0xFFE5D9C5);
    }
    return Colors.grey;
  }
}
