// features/sell/sell_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import 'package:hyper_render_clipboard/hyper_render_clipboard.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/cart_provider.dart';
import 'package:pos_system/providers/language_provider.dart';
import 'package:pos_system/providers/product_provider.dart';
import 'package:pos_system/providers/register_provider.dart';
import 'package:pos_system/data/models/product_model.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  bool _redirected = false;

  // ── Selection state ──
  bool _isSelectionMode = false;
  final Set<String> _selectedUrls = <String>{};

  // ── Clipboard helper ──
  final SuperClipboardHandler _clipboardHandler = SuperClipboardHandler();

  // ── Busy state ──
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final registerProvider = context.read<RegisterProvider>();

      // 👇 If register is closed, redirect once
      if (!registerProvider.isRegisterOpen) {
        if (!_redirected) {
          _redirected = true;
          context.goNamed(RouteNames.storeRegisterName);
        }
        return;
      }

      // 👇 Only load products if register is open
      _loadProducts();
    });
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    final provider = context.read<ProductProvider>();
    await provider.fetchProducts();
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
      if (_selectedUrls.isEmpty) {
        _isSelectionMode = false;
      }
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
  // Build
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // 👇 Rebuild when language changes
    context.watch<LanguageProvider>();

    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();
    final registerProvider = context.watch<RegisterProvider>();

    // 👇 If register closed, show a clear message with a button
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

    // 👇 Use the provider's filtered products
    final displayProducts = productProvider.filteredProducts;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // ── Top App Bar ──
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
                        )
                      else
                        const SizedBox.shrink(),
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

                // ── Search Bar (hidden while selecting) ──
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

                // ── Error State ──
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

                // ── Product Grid ──
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
                  Padding(
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
                              shadowColor: c.primaryCoral.withValues(
                                alpha: 0.4,
                              ),
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
                  )
                else if (cartProvider.itemCount > 0)
                  Padding(
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
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 20,
                                color: c.textLight,
                              ),
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
                  ),
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
              : GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: displayProducts.length,
                  itemBuilder: (context, index) {
                    final product = displayProducts[index];
                    return _buildProductCard(product, c, textStyles);
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
        if (!_isSelectionMode) _enterSelectionMode(product.imageUrl);
      },
      onTap: () {
        if (_isSelectionMode) {
          _toggleSelection(product.imageUrl);
        } else {
          context.pushNamed(RouteNames.productDetailName, extra: product);
        }
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EBEE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
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
                        : Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: c.textMuted,
                                  ),
                                ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.name,
                style: textStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                product.collectionName,
                style: textStyles.bodySmall.copyWith(
                  color: c.textMuted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product.basePrice.toStringAsFixed(2)}',
                    style: textStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  InkWell(
                    onTap: _isSelectionMode
                        ? null
                        : () => context.pushNamed(
                            RouteNames.productDetailName,
                            extra: product,
                          ),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F8FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.add, color: c.primaryCoral, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_isSelectionMode)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? c.primaryCoral : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? c.primaryCoral : Colors.white70,
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
    );
  }
}
