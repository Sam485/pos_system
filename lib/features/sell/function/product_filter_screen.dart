// features/sell/function/product_filter_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/language_provider.dart';
import 'package:pos_system/providers/product_provider.dart';

class ProductFilterScreen extends StatefulWidget {
  const ProductFilterScreen({super.key});

  @override
  State<ProductFilterScreen> createState() => _ProductFilterScreenState();
}

class _ProductFilterScreenState extends State<ProductFilterScreen> {
  // ── UI state (kept as *keys* rather than localized labels) ──
  String _selectedCategory = 'All';
  String _selectedSize = 'M';
  String _selectedColor = 'Any color';
  bool _inStockOnly = false;
  double _minPrice = 0;
  double _maxPrice = 1000;

  // Stable keys – these map to translation keys via `_categoryKey`, etc.
  static const List<String> _categories = [
    'All',
    'Tops',
    'Bottoms',
    'Knitwear',
    'Classics',
  ];
  static const List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL'];
  static const List<String> _colors = [
    'Any color',
    'White',
    'Sky',
    'Navy',
    'Sand',
  ];

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final provider = context.read<ProductProvider>();
      setState(() {
        _selectedCategory = provider.filterCategory;
        _selectedSize = provider.filterSize;
        _selectedColor = provider.filterColor;
        _minPrice = provider.filterMinPrice;
        _maxPrice = provider.filterMaxPrice;
        _inStockOnly = provider.filterInStockOnly;
      });
      _isInitialized = true;
    }
  }

  // ── Translation key maps (stable value → i18n key) ──
  String _categoryKey(String value) {
    switch (value) {
      case 'Tops':
        return 'product_filter_cat_tops';
      case 'Bottoms':
        return 'product_filter_cat_bottoms';
      case 'Knitwear':
        return 'product_filter_cat_knitwear';
      case 'Classics':
        return 'product_filter_cat_classics';
      case 'All':
      default:
        return 'product_filter_cat_all';
    }
  }

  String _colorKey(String value) {
    switch (value) {
      case 'White':
        return 'product_filter_color_white';
      case 'Sky':
        return 'product_filter_color_sky';
      case 'Navy':
        return 'product_filter_color_navy';
      case 'Sand':
        return 'product_filter_color_sand';
      case 'Any color':
      default:
        return 'product_filter_color_any';
    }
  }

  // Sizes are literal – no translation needed.
  String _sizeLabel(String size) => size;

  // ── Count matches against the *current* UI selection ──
  int _getMatchingCount(ProductProvider provider) {
    return provider.products.where((product) {
      if (_selectedCategory != 'All') {
        if (!product.collectionName.toLowerCase().contains(
          _selectedCategory.toLowerCase(),
        )) {
          return false;
        }
      }
      if (product.basePrice < _minPrice || product.basePrice > _maxPrice) {
        return false;
      }
      return true;
    }).length;
  }

  void _applyFilters() {
    context.read<ProductProvider>().applyFilters(
      category: _selectedCategory,
      size: _selectedSize,
      color: _selectedColor,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      inStockOnly: _inStockOnly,
    );
    context.pop();
  }

  void _clearAll() {
    setState(() {
      _selectedCategory = 'All';
      _selectedSize = 'M';
      _selectedColor = 'Any color';
      _minPrice = 0;
      _maxPrice = 1000;
      _inStockOnly = false;
    });
    context.read<ProductProvider>().clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    // 👇 Watch the language provider so this screen rebuilds on toggle.
    context.watch<LanguageProvider>();

    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final provider = context.watch<ProductProvider>();

    final matchingCount = _getMatchingCount(provider);

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
                        context.t('product_filter_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.t('product_filter_subtitle'),
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Category ──
                    _buildSectionTitle(
                      context.t('product_filter_category_title'),
                      textStyles,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        return _buildChip(
                          context.t(_categoryKey(cat)),
                          cat == _selectedCategory,
                          () => setState(() => _selectedCategory = cat),
                          c,
                          textStyles,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // ── Size ──
                    _buildSectionTitle(
                      context.t('product_filter_size_title'),
                      textStyles,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sizes.map((size) {
                        return _buildChip(
                          _sizeLabel(size),
                          size == _selectedSize,
                          () => setState(() => _selectedSize = size),
                          c,
                          textStyles,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // ── Color ──
                    _buildSectionTitle(
                      context.t('product_filter_color_title'),
                      textStyles,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _colors.map((color) {
                        return _buildChip(
                          context.t(_colorKey(color)),
                          color == _selectedColor,
                          () => setState(() => _selectedColor = color),
                          c,
                          textStyles,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // ── Price range ──
                    _buildSectionTitle(
                      context.t('product_filter_price_title'),
                      textStyles,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPriceInput(
                            label: context.t('product_filter_price_min'),
                            initialValue: _minPrice,
                            onChanged: (val) => setState(() => _minPrice = val),
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildPriceInput(
                            label: context.t('product_filter_price_max'),
                            initialValue: _maxPrice,
                            onChanged: (val) => setState(() => _maxPrice = val),
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── In-stock toggle ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.t('product_filter_instock_title'),
                                style: textStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.tp('product_filter_instock_sub', {
                                  'store': context.t(
                                    'product_filter_store_default',
                                  ),
                                }),
                                style: textStyles.bodySmall.copyWith(
                                  color: c.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _inStockOnly,
                          onChanged: (val) =>
                              setState(() => _inStockOnly = val),
                          activeThumbColor: c.textLight,
                          activeTrackColor: c.primaryCoral,
                          inactiveThumbColor: c.textLight,
                          inactiveTrackColor: c.surfaceLight,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Text(
                      context.t('product_filter_footer'),
                      style: textStyles.bodySmall.copyWith(
                        color: c.textMuted,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // ── Bottom Buttons ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primaryCoral,
                      foregroundColor: c.textLight,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      context.tp('product_filter_apply_button', {
                        'count': '$matchingCount',
                      }),
                      style: textStyles.labelMedium.copyWith(
                        color: c.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _clearAll,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF4F8FF),
                      foregroundColor: c.primaryCoral,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.t('product_filter_clear_button'),
                      style: textStyles.labelMedium.copyWith(
                        color: c.primaryCoral,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildSectionTitle(String title, AppTextStylesX textStyles) {
    return Text(
      title,
      style: textStyles.heading2.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? c.primaryCoral : c.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: textStyles.labelSmall.copyWith(
            color: isSelected ? c.textLight : c.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceInput({
    required String label,
    required double initialValue,
    required ValueChanged<double> onChanged,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: ValueKey('price_$label'), // rebuild when language changes
          initialValue: initialValue.toStringAsFixed(0),
          keyboardType: TextInputType.number,
          style: textStyles.bodyLarge,
          onChanged: (val) => onChanged(double.tryParse(val) ?? 0),
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: textStyles.bodyLarge.copyWith(color: c.textMuted),
            filled: true,
            fillColor: c.surfaceLight,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
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
              borderSide: BorderSide(color: c.primaryCoral, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
