// features/sell/sell_screen.dart

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import 'package:hyper_render_clipboard/hyper_render_clipboard.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/models/product_model.dart';
import 'package:pos_system/data/models/variant_model.dart';
import 'package:pos_system/providers/cart_provider.dart';
import 'package:pos_system/providers/inventory_provider.dart';
import 'package:pos_system/providers/language_provider.dart';
import 'package:pos_system/providers/product_provider.dart';
import 'package:pos_system/providers/register_provider.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  bool _redirected = false;

  bool _isSelectionMode = false;
  final Set<String> _selectedUrls = <String>{};
  final SuperClipboardHandler _clipboardHandler = SuperClipboardHandler();
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final registerProvider = context.read<RegisterProvider>();
      if (!registerProvider.isRegisterOpen) {
        if (!_redirected) {
          _redirected = true;
          context.goNamed(RouteNames.storeRegisterName);
        }
        return;
      }
      _loadProducts();
    });
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    await context.read<ProductProvider>().fetchProducts();
  }

  // ─────────────────────────────────────────────────────────────
  // Selection helpers
  // ─────────────────────────────────────────────────────────────
  void _enterSelectionMode(String url) {
    setState(() {
      _isSelectionMode = true;
      _selectedUrls.add(url);
    });
  }

  void _toggleSelection(String url) {
    setState(() {
      if (_selectedUrls.contains(url)) {
        _selectedUrls.remove(url);
      } else {
        _selectedUrls.add(url);
      }
      if (_selectedUrls.isEmpty) _isSelectionMode = false;
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedUrls.clear();
    });
  }

  void _selectAll(List<ProductModel> products) {
    setState(() {
      _selectedUrls
        ..clear()
        ..addAll(products.map((p) => p.imageUrl));
    });
  }

  // ─────────────────────────────────────────────────────────────
  // Copy logic
  // ─────────────────────────────────────────────────────────────
  Future<void> _copySelected() async {
    if (_selectedUrls.isEmpty || _isBusy) return;

    setState(() => _isBusy = true);
    try {
      int copied = 0;
      for (final url in _selectedUrls) {
        try {
          if (url.startsWith('assets/')) {
            final data = await rootBundle.load(url);
            final ok = await _clipboardHandler.copyImageBytes(
              data.buffer.asUint8List(),
              mimeType: 'image/png',
            );
            if (ok) copied++;
          } else {
            await _clipboardHandler.copyImageFromUrl(url);
            copied++;
          }
        } catch (e) {
          debugPrint('Failed to copy $url: $e');
        }
      }

      if (copied == 0) {
        // ignore: use_build_context_synchronously
        _showSnack(context.t('sell_snack_nothing_copied'), isError: true);
        return;
      }
      if (copied == 1) {
        // ignore: use_build_context_synchronously
        _showSnack(context.t('sell_snack_copied_one'));
      } else {
        // ignore: use_build_context_synchronously
        _showSnack(context.tp('sell_snack_copied_many', {'count': '$copied'}));
      }
      _exitSelectionMode();
    } catch (e) {
      _showSnack(
        // ignore: use_build_context_synchronously
        context.tp('sell_snack_copy_failed', {'error': '$e'}),
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red.shade700 : null,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Quick-add bottom sheet
  // ─────────────────────────────────────────────────────────────
  Future<void> _showAddToCartSheet(ProductModel product) async {
    if (_isBusy) return;

    // Ensure variants/inventory are loaded before opening so the sheet
    // can render the swatches immediately.
    final inv = context.read<InventoryProvider>();
    if (inv.fullInventory.isEmpty && !inv.isLoading) {
      // Fire-and-forget; the sheet also watches and will rebuild.
      inv.fetchFullInventory();
    }

    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _QuickAddSheet(product: product),
    );

    if (!mounted || added != true) return;
    _showSnack(context.t('product_detail_added_toast'));
  }

  // ─────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();

    final c = AppTextStylesX(context).colors;
    final textStyles = AppTextStylesX(context);
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();
    final registerProvider = context.watch<RegisterProvider>();

    // ── Register closed guard ──────────────────────────────────
    if (!registerProvider.isRegisterOpen) {
      return Scaffold(
        backgroundColor: c.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 64,
                    color: c.primaryCoral,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.t('sell_guard_title'),
                    style: textStyles.heading2.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.t('sell_guard_hint'),
                    textAlign: TextAlign.center,
                    style: textStyles.bodyMedium.copyWith(color: c.textMuted),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      _redirected = false;
                      context.goNamed(RouteNames.storeRegisterName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primaryCoral,
                      foregroundColor: c.textLight,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.t('sell_guard_button'),
                      style: textStyles.labelMedium.copyWith(
                        color: c.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final displayProducts = productProvider.filteredProducts;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // ── Top app bar ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: [
                      if (_isSelectionMode)
                        IconButton(
                          onPressed: _exitSelectionMode,
                          icon: Icon(Icons.close_rounded, color: c.textPrimary),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isSelectionMode
                                  ? context.tp('sell_title_selected', {
                                      'count': '${_selectedUrls.length}',
                                    })
                                  : context.t('sell_title_new'),
                              style: textStyles.heading2.copyWith(fontSize: 20),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isSelectionMode
                                  ? context.t('sell_subtitle_selection_hint')
                                  : context.tp('sell_subtitle_store_register', {
                                      'store': context.t('sell_store_default'),
                                      'register': context.t(
                                        'sell_register_default',
                                      ),
                                    }),
                              style: textStyles.bodySmall.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!_isSelectionMode)
                        IconButton(
                          onPressed: () {
                            context.pushNamed(RouteNames.barcodeScannerName);
                          },
                          icon: Icon(
                            Icons.qr_code_scanner_rounded,
                            color: c.primaryCoral,
                            size: 28,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        )
                      else
                        TextButton(
                          onPressed: () => _selectAll(displayProducts),
                          child: Text(
                            context.t('sell_select_all'),
                            style: textStyles.labelMedium.copyWith(
                              color: c.primaryCoral,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ── Search bar ──
                if (!_isSelectionMode) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      readOnly: true,
                      onTap: () =>
                          context.pushNamed(RouteNames.searchProductName),
                      decoration: InputDecoration(
                        hintText: context.t('sell_search_hint'),
                        hintStyle: textStyles.bodyMedium.copyWith(
                          color: c.textMuted,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: c.textMuted,
                        ),
                        suffixIcon: Icon(
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Error banner ──
                if (productProvider.error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.tp('sell_error_load', {
                                'error': '${productProvider.error}',
                              }),
                              style: textStyles.bodySmall.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Grid ──
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadProducts,
                    color: c.primaryCoral,
                    child: Skeletonizer(
                      enabled: productProvider.isLoading,
                      child: _buildProductGridView(
                        displayProducts,
                        productProvider,
                        c,
                        textStyles,
                      ),
                    ),
                  ),
                ),

                // ── Bottom bar ──
                if (_isSelectionMode)
                  _buildSelectionBottomBar(c, textStyles)
                else if (cartProvider.itemCount > 0)
                  _buildCartBottomBar(cartProvider, c, textStyles),
              ],
            ),

            // ── Busy overlay ──
            if (_isBusy)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: false,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.15),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionBottomBar(AppThemeColors c, AppTextStylesX textStyles) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isBusy ? null : _exitSelectionMode,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                side: BorderSide(color: c.surfaceLight),
              ),
              child: Text(
                context.t('sell_cancel'),
                style: textStyles.labelMedium.copyWith(
                  color: c.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _selectedUrls.isEmpty || _isBusy
                  ? null
                  : _copySelected,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primaryCoral,
                foregroundColor: c.textLight,
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: c.primaryCoral.withValues(alpha: 0.4),
              ),
              child: _isBusy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _selectedUrls.length <= 1
                          ? context.t('sell_copy_image')
                          : context.tp('sell_copy_images', {
                              'count': '${_selectedUrls.length}',
                            }),
                      style: textStyles.labelMedium.copyWith(
                        color: c.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartBottomBar(
    CartProvider cartProvider,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: ElevatedButton(
        onPressed: () => context.pushNamed(RouteNames.cartName),
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primaryCoral,
          foregroundColor: c.textLight,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: c.primaryCoral.withValues(alpha: 0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_bag_outlined, size: 20, color: c.textLight),
                const SizedBox(width: 8),
                Text(
                  context.tp('sell_view_cart', {
                    'count': '${cartProvider.itemCount}',
                  }),
                  style: textStyles.labelMedium.copyWith(
                    color: c.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              '\$${cartProvider.total.toStringAsFixed(2)}',
              style: textStyles.heading2.copyWith(
                color: c.textLight,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGridView(
    List<ProductModel> displayProducts,
    ProductProvider provider,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tp('sell_products_count', {
                  'count': '${displayProducts.length}',
                }),
                style: textStyles.bodySmall.copyWith(color: c.textSecondary),
              ),
              InkWell(
                onTap: () => context.pushNamed(RouteNames.productFilterName),
                child: Icon(
                  Icons.tune_rounded,
                  color: c.primaryCoral,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: displayProducts.isEmpty && !provider.isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 48,
                        color: c.textMuted,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.t('sell_empty_title'),
                        style: textStyles.bodyMedium.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.t('sell_empty_hint'),
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    // Adapt columns to available width.
                    final width = constraints.maxWidth;
                    final crossAxisCount = width >= 900
                        ? 4
                        : width >= 600
                        ? 3
                        : 2;

                    return GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: ClampingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: displayProducts.length,
                      itemBuilder: (context, index) {
                        final product = displayProducts[index];
                        return _buildProductCard(product, c, textStyles);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
    ProductModel product,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    final isSelected = _selectedUrls.contains(product.imageUrl);
    final isAsset = product.imageUrl.startsWith('assets/');

    return GestureDetector(
      onLongPress: () {
        if (!_isSelectionMode && !_isBusy) {
          _enterSelectionMode(product.imageUrl);
        }
      },
      onTap: () {
        if (_isBusy) return;
        if (_isSelectionMode) {
          _toggleSelection(product.imageUrl);
        } else {
          context.pushNamed(RouteNames.productDetailName, extra: product);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          // 👇 Use the tinted surface instead of pure white so the card
          //    separates from the pure-white scaffold in light mode.
          color: c.isDark ? c.cardBackground : c.surfaceTint,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? c.primaryCoral.withValues(alpha: 0.6)
                : c.border, // 👈 stronger border in light mode
            width: isSelected ? 1.8 : 1.2,
          ),
          boxShadow: [
            // 👇 Stronger, softer shadow — the main driver of card
            //    separation in light mode.
            BoxShadow(
              color: Colors.black.withValues(alpha: c.isDark ? 0.35 : 0.10),
              blurRadius: c.isDark ? 12 : 16,
              spreadRadius: c.isDark ? 0 : 1,
              offset: const Offset(0, 6),
            ),
            // Colored glow when selected
            if (isSelected)
              BoxShadow(
                color: c.primaryCoral.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image ──
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: c.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      // 👇 subtle inner border on the image well
                      border: Border.all(
                        color: c.border.withValues(alpha: 0.5),
                        width: 0.8,
                      ),
                    ),
                    child: GestureDetector(
                      // Disable image tap while in selection mode so the
                      // outer card's onTap handles the toggle instead.
                      onTap: _isBusy || _isSelectionMode
                          ? null
                          : () => context.pushNamed(
                              RouteNames.productDetailName,
                              extra: product,
                            ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: isAsset
                            ? Image.asset(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                      child: Icon(
                                        Icons.image_outlined,
                                        color: c.textMuted,
                                      ),
                                    ),
                              )
                            : CachedNetworkImage(
                                imageUrl: product.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
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
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // ── Name ──
                Text(
                  product.name,
                  style: textStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: c.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // ── Collection ──
                Text(
                  product.collectionName,
                  style: textStyles.bodySmall.copyWith(
                    color: c.textMuted,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // ── Price + Add ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.basePrice.toStringAsFixed(2)}',
                      style: textStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: c.primaryCoral,
                      ),
                    ),
                    InkWell(
                      onTap: _isSelectionMode
                          ? null
                          : () => _showAddToCartSheet(product),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: c.primaryCoral.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.add, color: c.primaryCoral, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ── Selection indicator ──
            if (_isSelectionMode)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? c.primaryCoral : c.cardBackground,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? c.primaryCoral
                          : c.textMuted.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Icon(
                    isSelected ? Icons.check : Icons.circle_outlined,
                    size: 16,
                    color: isSelected ? Colors.white : c.textMuted,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════
// Quick-add bottom sheet
// ═════════════════════════════════════════════════════════════════
class _QuickAddSheet extends StatefulWidget {
  const _QuickAddSheet({required this.product});
  final ProductModel product;

  @override
  State<_QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<_QuickAddSheet> {
  VariantModel? _selectedVariant;
  int _quantity = 1;
  String? _userSelectedVariantId;
  bool _isSubmitting = false;

  List<VariantModel> _variantsFor(InventoryProvider inv) =>
      inv.variants.where((v) => v.productId == widget.product.id).toList();

  int _stockFor(InventoryProvider inv, VariantModel? v) {
    if (v == null) return 0;
    return inv.fullInventory
            .where((i) => i.variantId == v.id)
            .firstOrNull
            ?.quantityAvailable ??
        0;
  }

  VariantModel? _resolveSelected(List<VariantModel> variants) {
    if (variants.isEmpty) return null;
    if (_userSelectedVariantId != null) {
      for (final v in variants) {
        if (v.id == _userSelectedVariantId) return v;
      }
    }
    return variants.first;
  }

  void _selectVariant(VariantModel v, int stock) {
    setState(() {
      _selectedVariant = v;
      _userSelectedVariantId = v.id;
      _quantity = _quantity.clamp(1, stock == 0 ? 1 : stock);
    });
  }

  Future<void> _submit(CartProvider cart, double unitPrice, int stock) async {
    if (_selectedVariant == null || stock == 0 || _isSubmitting) return;
    setState(() => _isSubmitting = true);
    final ok = await cart.addToCart(
      productId: widget.product.id,
      variantId: _selectedVariant!.id,
      quantity: _quantity,
      unitPrice: unitPrice,
      productName: widget.product.name,
      imageUrl: widget.product.imageUrl,
      variantName: '${_selectedVariant!.color} / ${_selectedVariant!.size}',
    );
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cart.error ?? context.t('product_detail_failed_add')),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();
    final c = AppTextStylesX(context).colors;
    final textStyles = AppTextStylesX(context);
    final inv = context.watch<InventoryProvider>();
    final cart = context.watch<CartProvider>();

    final variants = _variantsFor(inv);
    _selectedVariant = _resolveSelected(variants);

    final colors = variants.map((v) => v.color).toSet().toList();
    final sizes = variants.map((v) => v.size).toSet().toList()
      ..sort((a, b) {
        const order = {'XS': 0, 'S': 1, 'M': 2, 'L': 3, 'XL': 4};
        return (order[a] ?? 99).compareTo(order[b] ?? 99);
      });

    final stock = _stockFor(inv, _selectedVariant);
    final unitPrice = _selectedVariant?.price ?? widget.product.basePrice;
    final total = unitPrice * _quantity;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: c.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── drag handle ──
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
              const SizedBox(height: 16),

              // ── header: thumb + name + price ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: c.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: c.border.withValues(alpha: 0.5),
                        width: 0.8,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: widget.product.imageUrl.startsWith('assets/')
                          ? Image.asset(
                              widget.product.imageUrl,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: widget.product.imageUrl,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: textStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.product.collectionName,
                          style: textStyles.bodySmall.copyWith(
                            color: c.textMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${unitPrice.toStringAsFixed(2)}',
                          style: textStyles.labelMedium.copyWith(
                            color: c.primaryCoral,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_rounded, color: c.textMuted),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── loading / empty states ──
              if (inv.isLoading && variants.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (variants.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    context.t('product_detail_error_select_variant'),
                    style: textStyles.bodySmall.copyWith(color: c.textMuted),
                  ),
                )
              else ...[
                // ── color selector ──
                Text(
                  context.tp('product_detail_color', {
                    'color':
                        _selectedVariant?.color ??
                        context.t('product_detail_sku_na'),
                  }),
                  style: textStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  children: colors.map((color) {
                    final isSel = _selectedVariant?.color == color;
                    return GestureDetector(
                      onTap: () {
                        final match = variants.where(
                          (v) =>
                              v.color == color &&
                              v.size == _selectedVariant?.size,
                        );
                        final next = match.isNotEmpty
                            ? match.first
                            : variants.firstWhere((v) => v.color == color);
                        _selectVariant(next, _stockFor(inv, next));
                      },
                      child: _colorDot(_colorForName(color), isSel, c),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // ── size selector ──
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
                        'count': '$stock',
                        'store': context.t('product_detail_store_default'),
                      }),
                      style: textStyles.bodySmall.copyWith(
                        color: stock > 0 ? c.successFg : c.warningFg,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: sizes.map((size) {
                    final isSel = _selectedVariant?.size == size;
                    return GestureDetector(
                      onTap: () {
                        final match = variants.where(
                          (v) =>
                              v.size == size &&
                              v.color == _selectedVariant?.color,
                        );
                        final next = match.isNotEmpty
                            ? match.first
                            : variants.firstWhere((v) => v.size == size);
                        _selectVariant(next, _stockFor(inv, next));
                      },
                      child: Container(
                        width: 56,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSel ? c.primaryCoral : c.surfaceTint,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSel ? c.primaryCoral : c.border,
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          size,
                          style: textStyles.labelMedium.copyWith(
                            color: isSel ? c.textLight : c.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // ── quantity + submit ──
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: c.border, width: 1.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          _qtyBtn(Icons.remove, () {
                            if (_quantity > 1) {
                              setState(() => _quantity--);
                            }
                          }, c),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              '$_quantity',
                              style: textStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _qtyBtn(Icons.add, () {
                            if (stock == 0 || _quantity < stock) {
                              setState(() => _quantity++);
                            }
                          }, c),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: stock == 0 || _isSubmitting
                            ? null
                            : () => _submit(cart, unitPrice, stock),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.primaryCoral,
                          foregroundColor: c.textLight,
                          disabledBackgroundColor: c.primaryCoral.withValues(
                            alpha: 0.5,
                          ),
                          minimumSize: const Size(0, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                context.tp('product_detail_add_button', {
                                  'count': '$_quantity',
                                  'amount': total.toStringAsFixed(2),
                                }),
                                style: textStyles.labelMedium.copyWith(
                                  color: c.textLight,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, AppThemeColors c) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(icon, size: 16, color: c.textPrimary),
      ),
    );
  }

  Widget _colorDot(Color color, bool isSelected, AppThemeColors c) {
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

  // Same mapping as ProductDetailScreen._getColorForName
  Color _colorForName(String name) {
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
