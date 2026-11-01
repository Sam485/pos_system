// providers/product_provider.dart

import 'package:flutter/foundation.dart';
import 'package:pos_system/core/services/api_service.dart';
import 'package:pos_system/data/models/product_model.dart';
import 'package:pos_system/providers/inventory_provider.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService;
  ProductProvider(this._apiService);

  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _error;

  // ── Filter State ──
  String _filterCategory = 'All';
  String _filterSize = 'M';
  String _filterColor = 'Any color';
  double _filterMinPrice = 0;
  double _filterMaxPrice = 1000000;
  bool _filterInStockOnly = false;

  // ── Getters ──
  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String get filterCategory => _filterCategory;
  String get filterSize => _filterSize;
  String get filterColor => _filterColor;
  double get filterMinPrice => _filterMinPrice;
  double get filterMaxPrice => _filterMaxPrice;
  bool get filterInStockOnly => _filterInStockOnly;

  // ── Filtered List ──
  List<ProductModel> get filteredProducts {
    return _products.where((product) {
      // 1. Category filter
      if (_filterCategory != 'All') {
        if (!product.collectionName.toLowerCase().contains(
          _filterCategory.toLowerCase(),
        )) {
          return false;
        }
      }
      // 2. Price filter
      if (product.basePrice < _filterMinPrice ||
          product.basePrice > _filterMaxPrice) {
        return false;
      }
      return true;
    }).toList();
  }

  // providers/product_provider.dart

   ProductModel? findProductBySku(
    String query,
    InventoryProvider inventoryProvider,
  ) {
    final search = query.trim().toLowerCase();
    if (search.isEmpty) return null;

    // 1. Find the variant that matches the SKU
    final variant = inventoryProvider.variants
        .where((v) => v.sku.toLowerCase() == search)
        .firstOrNull;

    // 2. If we found a variant, return its parent product
    if (variant != null) {
      return _products.where((p) => p.id == variant.productId).firstOrNull;
    }

    // 3. Fallback: Try matching the product name or ID directly
    return _products
        .where(
          (p) =>
              p.id.toLowerCase() == search ||
              p.name.toLowerCase().contains(search),
        )
        .firstOrNull;
  }

  // ── Fetch ──
  Future<void> fetchProducts({String? search}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts(search: search);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Apply Filters ──
  void applyFilters({
    required String category,
    required String size,
    required String color,
    required double minPrice,
    required double maxPrice,
    required bool inStockOnly,
  }) {
    _filterCategory = category;
    _filterSize = size;
    _filterColor = color;
    _filterMinPrice = minPrice;
    _filterMaxPrice = maxPrice;
    _filterInStockOnly = inStockOnly;
    notifyListeners();
  }

  // ── Clear Filters ──
  void clearFilters() {
    _filterCategory = 'All';
    _filterSize = 'M';
    _filterColor = 'Any color';
    _filterMinPrice = 0;
    _filterMaxPrice = 1000000;
    _filterInStockOnly = false;
    notifyListeners();
  }
}
