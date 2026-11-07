// features/other/stock/manage_stock_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  ProductModel? _product;
  bool _isInitialized = false;

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
    if (_isInitialized) return;

    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic>) {
      _product = extra['product'] as ProductModel?;
      _selectedInventory = extra['inventory'] as InventoryModel?;
      _selectedVariant = extra['variant'] as VariantModel?;
    } else if (extra is ProductModel) {
      _product = extra;
    }

    // Seed localized defaults once (context is available here)
    _reasonController.text = context.t('manage_stock_reason_default');
    _noteController.text = context.t('manage_stock_note_default');

    _isInitialized = true;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _updateCalculation() => setState(() {});



  int get _difference {
    final qty = int.tryParse(_quantityController.text) ?? 0;
    return _isAddAction ? qty : -qty;
  }

  // ─────────────────────────────────────────────────────────────
  // Variant selection
  // ─────────────────────────────────────────────────────────────
  void _onSizeSelected(
    String size,
    InventoryProvider provider,
    List<VariantModel> productVariants,
  ) {
    final newVariant = productVariants.firstWhere(
      (v) => v.size == size,
      orElse: () => productVariants.first,
    );

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

  // ─────────────────────────────────────────────────────────────
  // Add variant sheet
  // ─────────────────────────────────────────────────────────────
  void _showAddVariantSheet(BuildContext context) {
    if (_product == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddVariantSheet(product: _product!),
    ).then((_) {
      if (!context.mounted) return;
      context.read<InventoryProvider>().fetchFullInventory();
      context.read<InventoryProvider>().fetchLowStockAlerts();
    });
  }

  // ═════════════════════════════════════════════════════════════
  // Build
  // ═════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final c = AppTextStylesX(context).colors;
    final textStyles = AppTextStylesX(context);
    final inventoryProvider = context.watch<InventoryProvider>();

    final productVariants = inventoryProvider.variants
        .where((v) => v.productId == _product?.id)
        .toList();

    // Resolve selected variant WITHOUT mutating state in build.
    // We compute the "effective" selection here and only update
    // state when the user taps a chip (via _onSizeSelected).
    final selectedVariant = _resolveSelectedVariant(productVariants);
    final selectedInventory = _resolveInventoryFor(
      selectedVariant,
      inventoryProvider,
    );

    // ── Derived values ──
    final currentStock = selectedInventory?.quantityAvailable ?? 0;
    final newStock = _isAddAction
        ? currentStock + (int.tryParse(_quantityController.text) ?? 0)
        : currentStock - (int.tryParse(_quantityController.text) ?? 0);

    final productInventory = inventoryProvider.fullInventory
        .where((inv) => productVariants.any((v) => v.id == inv.variantId))
        .toList();
    final totalProductUnits = productInventory.fold<int>(
      0,
      (sum, item) => sum + item.quantityAvailable,
    );

    final availableSizes = productVariants.map((v) => v.size).toSet().toList()
      ..sort((a, b) {
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

    final selectedSize =
        selectedVariant?.size ?? context.t('manage_stock_size_default');
    final selectedColor =
        selectedVariant?.color ?? context.t('manage_stock_color_default');
    final variantSku =
        selectedVariant?.sku ?? context.t('manage_stock_sku_default');
    final productName =
        _product?.name ?? context.t('manage_stock_product_default');

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(c, textStyles),
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  // ── Product header ──
                  SliverToBoxAdapter(
                    child: _buildProductHeader(
                      productName: productName,
                      totalProductUnits: totalProductUnits,
                      variantCount: productVariants.length,
                      c: c,
                      textStyles: textStyles,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // ── Stock by variant header ──
                  SliverToBoxAdapter(
                    child: _buildVariantHeader(
                      selectedColor: selectedColor,
                      c: c,
                      textStyles: textStyles,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  // ── Variant chips ──
                  SliverToBoxAdapter(
                    child: _buildVariantChips(
                      availableSizes: availableSizes,
                      selectedSize: selectedSize,
                      productVariants: productVariants,
                      inventoryProvider: inventoryProvider,
                      c: c,
                      textStyles: textStyles,
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

                  // ── Update form ──
                  SliverToBoxAdapter(
                    child: _buildUpdateForm(
                      selectedSize: selectedSize,
                      selectedColor: selectedColor,
                      variantSku: variantSku,
                      currentStock: currentStock,
                      newStock: newStock,
                      c: c,
                      textStyles: textStyles,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
            ),

            // ── Bottom save button ──
            _buildSaveButton(
              selectedVariant: selectedVariant,
              newStock: newStock,
              inventoryProvider: inventoryProvider,
              c: c,
              textStyles: textStyles,
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // Pure selection helpers (no state mutation)
  // ═════════════════════════════════════════════════════════════
  VariantModel? _resolveSelectedVariant(List<VariantModel> variants) {
    if (variants.isEmpty) return null;
    if (_selectedVariant != null) {
      for (final v in variants) {
        if (v.id == _selectedVariant!.id) return v;
      }
    }
    return variants.first;
  }

  InventoryModel? _resolveInventoryFor(
    VariantModel? variant,
    InventoryProvider provider,
  ) {
    if (variant == null) return null;
    for (final inv in provider.fullInventory) {
      if (inv.variantId == variant.id) return inv;
    }
    return _selectedInventory ??
        InventoryModel(
          id: '',
          variantId: variant.id,
          storeId: '',
          quantityAvailable: 0,
          lowStockThreshold: 5,
        );
  }

  // ═════════════════════════════════════════════════════════════
  // Builders
  // ═════════════════════════════════════════════════════════════
  Widget _buildAppBar(AppThemeColors c, AppTextStylesX textStyles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
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
                context.t('manage_stock_title'),
                style: textStyles.heading2.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 2),
              Text(
                context.t('manage_stock_store_default'),
                style: textStyles.bodySmall.copyWith(color: c.textMuted),
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
    );
  }

  Widget _buildProductHeader({
    required String productName,
    required int totalProductUnits,
    required int variantCount,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: c.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildProductThumbnail(c),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: textStyles.heading2.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  context.tp('manage_stock_product_units', {
                    'units': '$totalProductUnits',
                    'variants': '$variantCount',
                  }),
                  style: textStyles.bodySmall.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      context.t('manage_stock_view_details'),
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
    );
  }

  Widget _buildProductThumbnail(AppThemeColors c) {
    final url = _product?.imageUrl ?? '';
    if (url.isEmpty) {
      return Icon(Icons.image_outlined, color: c.textMuted);
    }
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            Icon(Icons.image_outlined, color: c.textMuted),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: c.textMuted),
        ),
      ),
      errorWidget: (_, _, _) => Icon(Icons.image_outlined, color: c.textMuted),
    );
  }

  Widget _buildVariantHeader({
    required String selectedColor,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.t('manage_stock_stock_by_variant'),
            style: textStyles.labelMedium.copyWith(fontWeight: FontWeight.w600),
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
                      Icon(Icons.add, size: 14, color: c.textLight),
                      const SizedBox(width: 4),
                      Text(
                        context.t('manage_stock_add_button'),
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
    );
  }

  Widget _buildVariantChips({
    required List<String> availableSizes,
    required String selectedSize,
    required List<VariantModel> productVariants,
    required InventoryProvider inventoryProvider,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: availableSizes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final size = availableSizes[index];
          final isSelected = size == selectedSize;

          final variantForSize = productVariants.firstWhere(
            (v) => v.size == size,
            orElse: () => productVariants.first,
          );

          final stockForSize =
              inventoryProvider.fullInventory
                  .where((i) => i.variantId == variantForSize.id)
                  .firstOrNull
                  ?.quantityAvailable ??
              0;

          return GestureDetector(
            onTap: () =>
                _onSizeSelected(size, inventoryProvider, productVariants),
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? c.primaryCoral.withValues(alpha: 0.12)
                    : c.surfaceLight,
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
                      color: isSelected ? c.primaryCoral : c.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$stockForSize',
                    style: textStyles.labelMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? c.primaryCoral : c.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpdateForm({
    required String selectedSize,
    required String selectedColor,
    required String variantSku,
    required int currentStock,
    required int newStock,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tp('manage_stock_update_title', {
              'size': selectedSize,
              'color': selectedColor,
            }),
            style: textStyles.heading2.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            context.tp('manage_stock_update_sku', {
              'sku': variantSku,
              'count': '$currentStock',
            }),
            style: textStyles.bodySmall.copyWith(color: c.textMuted),
          ),
          const SizedBox(height: 16),

          // ── Action toggles ──
          Row(
            children: [
              _buildActionToggle(
                label: context.t('manage_stock_action_add'),
                isActive: _isAddAction,
                onTap: () => setState(() => _isAddAction = true),
                c: c,
                textStyles: textStyles,
              ),
              const SizedBox(width: 8),
              _buildActionToggle(
                label: context.t('manage_stock_action_remove'),
                isActive: !_isAddAction,
                onTap: () => setState(() => _isAddAction = false),
                c: c,
                textStyles: textStyles,
              ),
              const SizedBox(width: 8),
              _buildActionToggle(
                label: context.t('manage_stock_action_set'),
                isActive: false,
                onTap: () {},
                c: c,
                textStyles: textStyles,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Inputs ──
          Text(
            context.t('manage_stock_quantity_label'),
            style: textStyles.labelSmall.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            style: textStyles.bodyLarge.copyWith(color: c.textPrimary),
            decoration: _inputDecoration(c),
          ),
          const SizedBox(height: 16),
          Text(
            context.t('manage_stock_reason_label'),
            style: textStyles.labelSmall.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _reasonController,
            style: textStyles.bodyLarge.copyWith(color: c.textPrimary),
            decoration: _inputDecoration(c).copyWith(
              suffixIcon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: c.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.t('manage_stock_note_label'),
            style: textStyles.labelSmall.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _noteController,
            style: textStyles.bodyLarge.copyWith(color: c.textPrimary),
            decoration: _inputDecoration(c, icon: Icons.description_outlined),
          ),
          const SizedBox(height: 24),

          // ── Summary card ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.surfaceTint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.t('manage_stock_current_available'),
                      style: textStyles.bodySmall,
                    ),
                    Text(
                      context.tp('manage_stock_current_units', {
                        'count': '$currentStock',
                      }),
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.t('manage_stock_after_update'),
                      style: textStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      context.tp('manage_stock_after_units', {
                        'count': '$newStock',
                      }),
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
            context.tp('manage_stock_last_movement', {
              'change': context.tp('manage_stock_last_movement_change', {
                'count': '1',
              }),
              'orderNumber': context.t('manage_stock_last_movement_order'),
              'time': context.t('manage_stock_last_movement_time'),
            }),
            style: textStyles.bodySmall.copyWith(
              color: c.textMuted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSaveButton({
    required VariantModel? selectedVariant,
    required int newStock,
    required InventoryProvider inventoryProvider,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    final change = _difference;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: ElevatedButton(
        onPressed: inventoryProvider.isLoading || selectedVariant == null
            ? null
            : () => _handleSave(
                selectedVariant: selectedVariant,
                newStock: newStock,
                inventoryProvider: inventoryProvider,
              ),
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
                    context.tp('manage_stock_save_button', {
                      'change': change > 0
                          ? context.tp('manage_stock_save_change_positive', {
                              'count': '$change',
                            })
                          : '$change',
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

  Future<void> _handleSave({
    required VariantModel selectedVariant,
    required int newStock,
    required InventoryProvider inventoryProvider,
  }) async {
    final success = await inventoryProvider.updateStock(
      variantId: selectedVariant.id,
      quantityChange: _difference,
      reason: _reasonController.text,
      note: _noteController.text,
    );

    if (!mounted) return;
    if (success) {
      inventoryProvider.updateLocalInventory(selectedVariant.id, newStock);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('manage_stock_update_success')),
          backgroundColor: AppTextStylesX(context).colors.successFg,
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            inventoryProvider.error ?? context.t('manage_stock_update_failed'),
          ),
          backgroundColor: AppTextStylesX(context).colors.dangerFg,
        ),
      );
    }
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
// BOTTOM SHEET: ADD VARIANT
// ══════════════════════════════════════════════════════════════════
class _AddVariantSheet extends StatefulWidget {
  final ProductModel product;

  const _AddVariantSheet({required this.product});

  @override
  State<_AddVariantSheet> createState() => _AddVariantSheetState();
}

class _AddVariantSheetState extends State<_AddVariantSheet> {
  final _colorController = TextEditingController();
  final _skuController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: '0');

  String _selectedSize = 'M';
  final List<String> _sizes = const [
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_colorController.text.isEmpty) {
      _colorController.text = context.t('manage_stock_color_default_input');
    }
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
      _showSnack(context.t('manage_stock_add_variant_error'), isError: true);
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

    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else {
      _showSnack(
        inventoryProvider.error ?? context.t('manage_stock_add_variant_failed'),
        isError: true,
      );
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError
            ? AppTextStylesX(context).colors.dangerFg
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppTextStylesX(context).colors;
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
              Text(
                context.t('manage_stock_add_variant_title'),
                style: textStyles.heading2.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 4),
              Text(
                widget.product.name,
                style: textStyles.bodySmall.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: 24),

              _label(context.t('manage_stock_color_label'), textStyles, c),
              const SizedBox(height: 8),
              TextFormField(
                controller: _colorController,
                style: textStyles.bodyLarge.copyWith(color: c.textPrimary),
                decoration: _inputDecoration(c, icon: Icons.palette_outlined),
              ),
              const SizedBox(height: 16),

              _label(context.t('manage_stock_size_label'), textStyles, c),
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
                    dropdownColor: c.cardBackground,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: c.textMuted,
                    ),
                    items: _sizes
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(
                              s,
                              style: textStyles.bodyLarge.copyWith(
                                color: c.textPrimary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedSize = v!),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _label(context.t('manage_stock_sku_label'), textStyles, c),
              const SizedBox(height: 8),
              TextFormField(
                controller: _skuController,
                style: textStyles.bodyLarge.copyWith(color: c.textPrimary),
                decoration: _inputDecoration(c, icon: Icons.qr_code_rounded),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label(
                          context.t('manage_stock_price_label'),
                          textStyles,
                          c,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: textStyles.bodyLarge.copyWith(
                            color: c.textPrimary,
                          ),
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
                        _label(
                          context.t('manage_stock_initial_stock_label'),
                          textStyles,
                          c,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                          style: textStyles.bodyLarge.copyWith(
                            color: c.textPrimary,
                          ),
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
                            context.t('manage_stock_save_variant_button'),
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

  Widget _label(String text, AppTextStylesX textStyles, AppThemeColors c) {
    return Text(
      text,
      style: textStyles.labelSmall.copyWith(
        fontWeight: FontWeight.w600,
        color: c.textPrimary,
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
