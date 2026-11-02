// features/sell/detail/product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/models/product_model.dart';
import 'package:pos_system/data/models/variant_model.dart';
import 'package:pos_system/providers/cart_provider.dart';
import 'package:pos_system/providers/inventory_provider.dart';

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
        final inventoryProvider = context.read<InventoryProvider>();
        if (inventoryProvider.fullInventory.isEmpty) {
          inventoryProvider.fetchFullInventory();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final inventoryProvider = context.watch<InventoryProvider>();
    final cartProvider = context.watch<CartProvider>();

    final variants = inventoryProvider.variants
        .where((v) => v.productId == _product?.id)
        .toList();

    if (_selectedVariant == null && variants.isNotEmpty) {
      _selectedVariant = variants.first;
    }

    final availableColors = variants.map((v) => v.color).toSet().toList();
    final availableSizes = variants.map((v) => v.size).toSet().toList();

    availableSizes.sort((a, b) {
      const order = {'XS': 0, 'S': 1, 'M': 2, 'L': 3, 'XL': 4};
      return (order[a] ?? 99).compareTo(order[b] ?? 99);
    });

    final currentStock = _selectedVariant != null
        ? inventoryProvider.fullInventory
                  .where((i) => i.variantId == _selectedVariant!.id)
                  .firstOrNull
                  ?.quantityAvailable ??
              0
        : 0;

    final unitPrice = _selectedVariant?.price ?? _product?.basePrice ?? 0.0;
    final totalPrice = unitPrice * _quantity;

    if (_product == null) {
      return Scaffold(
        backgroundColor: c.background,
        body: const Center(child: Text('Product not found.')),
      );
    }

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
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
                    'Product details',
                    style: textStyles.heading2.copyWith(fontSize: 24),
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
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: c.surfaceLight, // 👈 theme-aware
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          _product!.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: c.textMuted,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            // 👇 theme-aware status badge
                            color: currentStock > 0 ? c.successBg : c.warningBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            currentStock > 0 ? 'In stock' : 'Out of stock',
                            style: textStyles.labelSmall.copyWith(
                              color: currentStock > 0
                                  ? c.successFg
                                  : c.warningFg,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
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
                                'SKU ${_selectedVariant?.sku ?? 'N/A'}',
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
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _product!.description,
                      style: textStyles.bodyMedium.copyWith(
                        color: c.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Color · ${_selectedVariant?.color ?? "N/A"}',
                      style: textStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: availableColors.map((color) {
                        final isSelected = _selectedVariant?.color == color;
                        final Color swatchColor = _getColorForName(color);
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              final newVariant = variants.firstWhere(
                                (v) =>
                                    v.color == color &&
                                    v.size == _selectedVariant?.size,
                                orElse: () => variants.firstWhere(
                                  (v) => v.color == color,
                                ),
                              );
                              setState(() => _selectedVariant = newVariant);
                            },
                            child: _buildColorCircle(
                              swatchColor,
                              isSelected,
                              c,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Size · ${_selectedVariant?.size ?? "N/A"}',
                          style: textStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$currentStock available at SoHo',
                          style: textStyles.bodySmall.copyWith(
                            // 👈 theme-aware stock count color
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
                        children: List.generate(availableSizes.length, (index) {
                          final size = availableSizes[index];
                          final isSelected = _selectedVariant?.size == size;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                final newVariant = variants.firstWhere(
                                  (v) =>
                                      v.size == size &&
                                      v.color == _selectedVariant?.color,
                                  orElse: () => variants.firstWhere(
                                    (v) => v.size == size,
                                  ),
                                );
                                setState(() => _selectedVariant = newVariant);
                              },
                              child: Container(
                                width: 56,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? c.primaryCoral
                                      : c.surfaceLight, // 👈 theme-aware
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  size,
                                  style: textStyles.labelMedium.copyWith(
                                    color: isSelected
                                        ? c.textLight
                                        : c.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity',
                          style: textStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
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
                                  if (_quantity > 1) {
                                    setState(() => _quantity--);
                                  }
                                },
                                c: c,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
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
                                  if (currentStock == 0 ||
                                      _quantity < currentStock) {
                                    setState(() => _quantity++);
                                  }
                                },
                                c: c,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: ElevatedButton(
                onPressed: cartProvider.isLoading
                    ? null
                    : () async {
                        if (_selectedVariant == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a variant'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (currentStock == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Out of stock'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (_quantity > currentStock) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Only $currentStock units available',
                              ),
                              backgroundColor: Colors.red,
                            ),
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
                          variantName:
                              '${_selectedVariant!.color} / ${_selectedVariant!.size}',
                        );

                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to cart'),
                              backgroundColor: Color(0xFF137333),
                            ),
                          );
                          context.pop();
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                cartProvider.error ?? 'Failed to add to cart',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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
                          Icon(Icons.add, size: 20, color: c.textLight),
                          const SizedBox(width: 8),
                          Text(
                            'Add $_quantity to cart · \$${totalPrice.toStringAsFixed(2)}',
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
    required AppThemeColors c, // 👈 added
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        // 👈 explicit color so the +/− icons are visible on dark
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
