// features/sell/function/product_filter_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/product_provider.dart';

class ProductFilterScreen extends StatefulWidget {
  const ProductFilterScreen({super.key});

  @override
  State<ProductFilterScreen> createState() => _ProductFilterScreenState();
}

class _ProductFilterScreenState extends State<ProductFilterScreen> {
  // UI state
  String _selectedCategory = 'All';
  String _selectedSize = 'M';
  String _selectedColor = 'Any color';
  bool _inStockOnly = false;
  double _minPrice = 0;
  double _maxPrice = 1000;

  final List<String> _categories = [
    'All',
    'Tops',
    'Bottoms',
    'Knitwear',
    'Classics',
  ];
  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL'];
  final List<String> _colors = ['Any color', 'White', 'Sky', 'Navy', 'Sand'];

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 👇 Read the current filter state from the provider
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

  // 👇 Count how many products match the CURRENT UI selection
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

  // 👇 Save filters to the provider and close the sheet
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

  @override
  Widget build(BuildContext context) {
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
                        'Product filters',
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Refine the catalog',
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
                    _buildSectionTitle('Category', textStyles),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        return _buildChip(
                          cat,
                          cat == _selectedCategory,
                          () => setState(() => _selectedCategory = cat),
                          c,
                          textStyles,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Size', textStyles),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sizes.map((size) {
                        return _buildChip(
                          size,
                          size == _selectedSize,
                          () => setState(() => _selectedSize = size),
                          c,
                          textStyles,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Color', textStyles),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _colors.map((color) {
                        return _buildChip(
                          color,
                          color == _selectedColor,
                          () => setState(() => _selectedColor = color),
                          c,
                          textStyles,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Price range', textStyles),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPriceInput(
                            label: 'Minimum',
                            initialValue: _minPrice,
                            onChanged: (val) => setState(() => _minPrice = val),
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildPriceInput(
                            label: 'Maximum',
                            initialValue: _maxPrice,
                            onChanged: (val) => setState(() => _maxPrice = val),
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'In-stock products only',
                              style: textStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hide unavailable variants at SoHo',
                              style: textStyles.bodySmall.copyWith(
                                color: c.textMuted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _inStockOnly,
                          onChanged: (val) =>
                              setState(() => _inStockOnly = val),
                          activeColor: c.textLight,
                          activeTrackColor: c.primaryCoral,
                          inactiveThumbColor: c.textLight,
                          inactiveTrackColor: c.surfaceLight,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Filters apply to the current search. Prices are before tax.',
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
                      'Show $matchingCount matching products',
                      style: textStyles.labelMedium.copyWith(
                        color: c.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'All';
                        _selectedSize = 'M';
                        _selectedColor = 'Any color';
                        _minPrice = 0;
                        _maxPrice = 1000;
                        _inStockOnly = false;
                      });
                      context.read<ProductProvider>().clearFilters();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF4F8FF),
                      foregroundColor: c.primaryCoral,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Clear all filters',
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
