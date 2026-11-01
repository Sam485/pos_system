// features/other/stock/manage_stock_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/models/iventory_model.dart';
import 'package:pos_system/data/models/product_model.dart';
import 'package:pos_system/data/models/variant_model.dart';
import 'package:pos_system/providers/inventory_provider.dart';

class ManageStockScreen extends StatefulWidget {
  const ManageStockScreen({super.key});

  @override
  State<ManageStockScreen> createState() => _ManageStockScreenState();
}

class _ManageStockScreenState extends State<ManageStockScreen> {
  bool _isAddAction = true;

  final TextEditingController _quantityController = TextEditingController(
    text: '8',
  );
  final TextEditingController _reasonController = TextEditingController(
    text: 'Stock received',
  );
  final TextEditingController _noteController = TextEditingController(
    text: 'Delivery PO-0246',
  );

  // Data from Router
  ProductModel? _product;
  bool _isInitialized = false;

  // ── Active Selection State ──
  VariantModel? _selectedVariant;
  InventoryModel? _selectedInventory;

  @override
  void initState() {
    super.initState();
    _quantityController.addListener(_updateCalculation);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra;

      if (extra is Map<String, dynamic>) {
        _product = extra['product'] as ProductModel?;
        _selectedInventory = extra['inventory'] as InventoryModel?;
        _selectedVariant = extra['variant'] as VariantModel?;
      } else if (extra is ProductModel) {
        _product = extra;
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _updateCalculation() {
    setState(() {});
  }

  // ── Dynamic Calculations ──
  int get _currentStock => _selectedInventory?.quantityAvailable ?? 0;

  int get _newStock {
    final qty = int.tryParse(_quantityController.text) ?? 0;
    return _isAddAction ? _currentStock + qty : _currentStock - qty;
  }

  int get _difference {
    final qty = int.tryParse(_quantityController.text) ?? 0;
    return _isAddAction ? qty : -qty;
  }

  // ── Handle Variant Switching ──
  void _onSizeSelected(
    String size,
    InventoryProvider provider,
    List<VariantModel> productVariants,
  ) {
    final newVariant = productVariants.firstWhere(
      (v) => v.size == size,
      orElse: () => productVariants.first,
    );

    // Always get the freshest inventory from provider
    final newInventory = provider.fullInventory.firstWhere(
      (i) => i.variantId == newVariant.id,
      orElse: () => InventoryModel(
        id: '',
        variantId: newVariant.id,
        storeId: '',
        quantityAvailable: 0,
        lowStockThreshold: 5,
      ),
    );

    setState(() {
      _selectedVariant = newVariant;
      _selectedInventory = newInventory;
    });
  }

  // ── Show Add Variant Bottom Sheet ──
  void _showAddVariantSheet(BuildContext context) {
    if (_product == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddVariantSheet(product: _product!),
    ).then((_) {
      // 👇 Refresh BOTH lists so low stock alerts are updated
      context.read<InventoryProvider>().fetchFullInventory();
      context.read<InventoryProvider>().fetchLowStockAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final inventoryProvider = context.watch<InventoryProvider>();

    // 👇 1. Derive variants FIRST
    final productVariants = inventoryProvider.variants
        .where((v) => v.productId == _product?.id)
        .toList();

    // 👇 2. If the selected variant is no longer in the list, reset it
    if (_selectedVariant != null &&
        !productVariants.any((v) => v.id == _selectedVariant!.id)) {
      _selectedVariant = null;
      _selectedInventory = null;
    }

    // 👇 3. If no variant is selected, default to the first
    if (_selectedVariant == null && productVariants.isNotEmpty) {
      _selectedVariant = productVariants.first;
      _selectedInventory = inventoryProvider.fullInventory.firstWhere(
        (i) => i.variantId == _selectedVariant!.id,
        orElse: () => InventoryModel(
          id: '',
          variantId: _selectedVariant!.id,
          storeId: '',
          quantityAvailable: 0,
          lowStockThreshold: 5,
        ),
      );
    }

    // 👇 4. Keep selected inventory in sync with the provider's latest data
    if (_selectedVariant != null) {
      final latestInventory = inventoryProvider.fullInventory.firstWhere(
        (i) => i.variantId == _selectedVariant!.id,
        orElse: () =>
            _selectedInventory ??
            InventoryModel(
              id: '',
              variantId: _selectedVariant!.id,
              storeId: '',
              quantityAvailable: 0,
              lowStockThreshold: 5,
            ),
      );
      // Only update if the quantity changed to avoid unnecessary setState
      if (_selectedInventory?.quantityAvailable !=
          latestInventory.quantityAvailable) {
        _selectedInventory = latestInventory;
      }
    }

    // 👇 5. Calculate the TRUE total for the product header
    final productInventory = inventoryProvider.fullInventory
        .where((inv) => productVariants.any((v) => v.id == inv.variantId))
        .toList();
    final totalProductUnits = productInventory.fold(
      0,
      (sum, item) => sum + item.quantityAvailable,
    );

    // Extract unique sizes dynamically
    final availableSizes = productVariants.map((v) => v.size).toSet().toList();
    availableSizes.sort((a, b) {
      const order = {
        'XS': 0,
        'S': 1,
        'M': 2,
        'L': 3,
        'XL': 4,
        '26': 5,
        '28': 6,
        '30': 7,
        '32': 8,
        '34': 9,
      };
      return (order[a] ?? 99).compareTo(order[b] ?? 99);
    });

    final selectedSize = _selectedVariant?.size ?? 'M';
    final selectedColor = _selectedVariant?.color ?? 'White';
    final variantSku = _selectedVariant?.sku ?? 'CT-WHT-M';
    final productName = _product?.name ?? 'Essential cotton tee';

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
                        'Manage stock',
                        style: textStyles.heading2.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'SoHo store',
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

            // Main Content
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  // Product Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8EBEE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _product?.imageUrl ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.image_outlined,
                                      color: c.textMuted,
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
                                  productName,
                                  style: textStyles.heading2.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$totalProductUnits units · ${productVariants.length} variants',
                                  style: textStyles.bodySmall.copyWith(
                                    color: c.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      'View product details',
                                      style: textStyles.labelSmall.copyWith(
                                        color: c.primaryCoral,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.north_east_rounded,
                                      color: c.primaryCoral,
                                      size: 12,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Stock by Variant
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Stock by variant',
                            style: textStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => _showAddVariantSheet(context),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: c.primaryCoral,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 14,
                                        color: c.textLight,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Add',
                                        style: textStyles.labelSmall.copyWith(
                                          color: c.textLight,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                selectedColor,
                                style: textStyles.labelSmall.copyWith(
                                  color: c.primaryCoral,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: c.primaryCoral,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  // Variant Buttons
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 60,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        itemCount: availableSizes.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final size = availableSizes[index];
                          final isSelected = size == selectedSize;

                          final variantForSize = productVariants.firstWhere(
                            (v) => v.size == size,
                          );

                          // Use fullInventory to get the correct stock
                          final stockForSize = inventoryProvider.fullInventory
                              .firstWhere(
                                (i) => i.variantId == variantForSize.id,
                                orElse: () => InventoryModel(
                                  id: '',
                                  variantId: '',
                                  storeId: '',
                                  quantityAvailable: 0,
                                  lowStockThreshold: 5,
                                ),
                              )
                              .quantityAvailable;

                          return GestureDetector(
                            onTap: () => _onSizeSelected(
                              size,
                              inventoryProvider,
                              productVariants,
                            ),
                            child: Container(
                              width: 60,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFE8F0FE)
                                    : const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? c.primaryCoral.withValues(alpha: 0.5)
                                      : Colors.transparent,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    size,
                                    style: textStyles.labelSmall.copyWith(
                                      color: isSelected
                                          ? c.primaryCoral
                                          : c.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$stockForSize',
                                    style: textStyles.labelMedium.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? c.primaryCoral
                                          : c.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: c.border.withValues(alpha: 0.5),
                        height: 1,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Update Form
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Update $selectedSize · $selectedColor / $selectedSize',
                            style: textStyles.heading2.copyWith(fontSize: 20),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'SKU $variantSku · $_currentStock units currently available',
                            style: textStyles.bodySmall.copyWith(
                              color: c.textMuted,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Action Toggles
                          Row(
                            children: [
                              _buildActionToggle(
                                label: 'Add stock',
                                isActive: _isAddAction,
                                onTap: () =>
                                    setState(() => _isAddAction = true),
                                c: c,
                                textStyles: textStyles,
                              ),
                              const SizedBox(width: 8),
                              _buildActionToggle(
                                label: 'Remove',
                                isActive: !_isAddAction,
                                onTap: () =>
                                    setState(() => _isAddAction = false),
                                c: c,
                                textStyles: textStyles,
                              ),
                              const SizedBox(width: 8),
                              _buildActionToggle(
                                label: 'Set quantity',
                                isActive: false,
                                onTap: () {},
                                c: c,
                                textStyles: textStyles,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Inputs
                          Text(
                            'Quantity',
                            style: textStyles.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            style: textStyles.bodyLarge,
                            decoration: _inputDecoration(c),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Reason',
                            style: textStyles.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _reasonController,
                            style: textStyles.bodyLarge,
                            decoration: _inputDecoration(c).copyWith(
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: c.textMuted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Reference note',
                            style: textStyles.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _noteController,
                            style: textStyles.bodyLarge,
                            decoration: _inputDecoration(
                              c,
                              icon: Icons.description_outlined,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Summary
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F8FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Current available',
                                      style: textStyles.bodySmall,
                                    ),
                                    Text(
                                      '$_currentStock units',
                                      style: textStyles.labelSmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'After update',
                                      style: textStyles.labelMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '$_newStock units',
                                      style: textStyles.heading2.copyWith(
                                        color: c.primaryCoral,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Last movement: +1 return · #1048 · Today, 10:08 AM',
                            style: textStyles.bodySmall.copyWith(
                              color: c.textMuted,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: ElevatedButton(
                onPressed:
                    inventoryProvider.isLoading || _selectedVariant == null
                    ? null
                    : () async {
                        final success = await inventoryProvider.updateStock(
                          variantId: _selectedVariant!.id,
                          quantityChange: _difference,
                          reason: _reasonController.text,
                          note: _noteController.text,
                        );
                        if (success && context.mounted) {
                          inventoryProvider.updateLocalInventory(
                            _selectedVariant!.id,
                            _newStock,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Stock updated successfully'),
                              backgroundColor: Color(0xFF137333),
                            ),
                          );
                          context.pop();
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
                child: inventoryProvider.isLoading
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
                          Icon(Icons.check, size: 20, color: c.textLight),
                          const SizedBox(width: 8),
                          Text(
                            'Save stock update · ${_difference > 0 ? '+' : ''}$_difference units',
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

  Widget _buildActionToggle({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? c.primaryCoral : c.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: textStyles.labelSmall.copyWith(
            color: isActive ? c.textLight : c.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(AppThemeColors c, {IconData? icon}) {
    return InputDecoration(
      filled: true,
      fillColor: c.surfaceLight,
      prefixIcon: icon != null
          ? Icon(icon, color: c.textMuted, size: 20)
          : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// BOTTOM SHEET WIDGET
// ══════════════════════════════════════════════════════════════════
class _AddVariantSheet extends StatefulWidget {
  final ProductModel product;

  const _AddVariantSheet({required this.product});

  @override
  State<_AddVariantSheet> createState() => _AddVariantSheetState();
}

class _AddVariantSheetState extends State<_AddVariantSheet> {
  final TextEditingController _colorController = TextEditingController(
    text: 'White',
  );
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController(
    text: '0',
  );

  String _selectedSize = 'M';
  final List<String> _sizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    '26',
    '28',
    '30',
    '32',
    '34',
  ];

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.product.basePrice.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _colorController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _saveVariant() async {
    if (_colorController.text.isEmpty || _skuController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in color and SKU'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final inventoryProvider = context.read<InventoryProvider>();

    final success = await inventoryProvider.addVariant({
      'product_id': widget.product.id,
      'color': _colorController.text.trim(),
      'size': _selectedSize,
      'sku': _skuController.text.trim(),
      'price':
          double.tryParse(_priceController.text) ?? widget.product.basePrice,
      'initial_stock': int.tryParse(_stockController.text) ?? 0,
    });

    if (success && mounted) {
      Navigator.of(context).pop(); // Close the sheet
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(inventoryProvider.error ?? 'Failed to create variant'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final inventoryProvider = context.watch<InventoryProvider>();

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Add new variant',
                style: textStyles.heading2.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 4),
              Text(
                widget.product.name,
                style: textStyles.bodySmall.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: 24),

              // Color
              Text(
                'Color',
                style: textStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _colorController,
                style: textStyles.bodyLarge,
                decoration: _inputDecoration(c, icon: Icons.palette_outlined),
              ),
              const SizedBox(height: 16),

              // Size
              Text(
                'Size',
                style: textStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: c.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSize,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: c.textMuted,
                    ),
                    items: _sizes.map((size) {
                      return DropdownMenuItem(
                        value: size,
                        child: Text(size, style: textStyles.bodyLarge),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedSize = val!),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // SKU
              Text(
                'SKU',
                style: textStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _skuController,
                style: textStyles.bodyLarge,
                decoration: _inputDecoration(c, icon: Icons.qr_code_rounded),
              ),
              const SizedBox(height: 16),

              // Price & Initial Stock
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price',
                          style: textStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: c.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: textStyles.bodyLarge,
                          decoration: _inputDecoration(
                            c,
                            icon: Icons.attach_money_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Initial stock',
                          style: textStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: c.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                          style: textStyles.bodyLarge,
                          decoration: _inputDecoration(
                            c,
                            icon: Icons.numbers_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Save button
              ElevatedButton(
                onPressed: inventoryProvider.isLoading ? null : _saveVariant,
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
                child: inventoryProvider.isLoading
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
                          Icon(Icons.check, size: 20, color: c.textLight),
                          const SizedBox(width: 8),
                          Text(
                            'Save variant',
                            style: textStyles.labelMedium.copyWith(
                              color: c.textLight,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(AppThemeColors c, {IconData? icon}) {
    return InputDecoration(
      filled: true,
      fillColor: c.surfaceLight,
      prefixIcon: icon != null
          ? Icon(icon, color: c.textMuted, size: 20)
          : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
    );
  }
}
