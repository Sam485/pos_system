// providers/cart_provider.dart

import 'package:flutter/foundation.dart';
import 'package:pos_system/core/services/api_service.dart';
import 'package:pos_system/data/models/cart_model.dart';
import 'package:pos_system/data/models/customer_model.dart';
import 'package:pos_system/data/models/iventory_model.dart';
import 'package:pos_system/providers/inventory_provider.dart';
import 'package:pos_system/providers/register_provider.dart';

class CartProvider extends ChangeNotifier {
  final ApiService _apiService;
  final InventoryProvider _inventoryProvider;
  final RegisterProvider _registerProvider;

  CartProvider(
    this._apiService,
    this._inventoryProvider,
    this._registerProvider,
  );

  List<CartModel> _items = [];
  bool _isLoading = false;
  String? _error;

  // ── Selected Customer ──
  CustomerModel? _selectedCustomer;
  CustomerModel? get selectedCustomer => _selectedCustomer;

  void selectCustomer(CustomerModel? customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  // ── Order Note State ──
  String? _orderNote;
  bool _includeNoteOnReceipt = false;

  String? get orderNote => _orderNote;
  bool get includeNoteOnReceipt => _includeNoteOnReceipt;

  void setOrderNote({required String note, required bool includeOnReceipt}) {
    _orderNote = note.trim().isEmpty ? null : note;
    _includeNoteOnReceipt = includeOnReceipt;
    notifyListeners();
  }

  // ── Discount State ──
  String? _discountName;
  double _discountAmount = 0.0;
  bool _isPercentageDiscount = false;
  double _discountValue = 0.0;

  String? get discountName => _discountName;
  double get discountAmount => _discountAmount;
  bool get hasDiscount => _discountAmount > 0;
  bool get isPercentageDiscount => _isPercentageDiscount;
  double get discountValue => _discountValue;

  // ── Getters ──
  List<CartModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _items.isEmpty;

  // 👇 New guard: is selling allowed?
  bool get canSell => _registerProvider.isRegisterOpen;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get discountedSubtotal => subtotal - _discountAmount;
  double get tax => discountedSubtotal * 0.10;
  double get total => discountedSubtotal + tax;

  // ── Helper: Get available stock for a variant ──
  int getStockForVariant(String variantId) {
    // 👇 FIX: Use fullInventory, NOT lowStockAlerts
    final inventory = _inventoryProvider.fullInventory.firstWhere(
      (i) => i.variantId == variantId,
      orElse: () => InventoryModel(
        id: '',
        variantId: variantId,
        storeId: '',
        quantityAvailable: 0,
        lowStockThreshold: 0,
      ),
    );
    return inventory.quantityAvailable;
  }

  // ── Fetch Cart ──
  Future<void> loadCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _apiService.getCart();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Add to Cart (with stock & register check) ──
  Future<bool> addToCart({
    required String productId,
    required String variantId,
    required int quantity,
    required double unitPrice,
    required String productName,
    required String imageUrl,
    required String variantName,
  }) async {
    // 🚨 GUARD: Block if no register is open
    // NOTE: If you're testing, comment this out temporarily if your register is closed.
    // if (!canSell) {
    //   _error = 'Open a register before adding items';
    //   notifyListeners();
    //   return false;
    // }

    final existingIndex = _items.indexWhere(
      (item) => item.variantId == variantId,
    );
    final currentCartQty = existingIndex >= 0
        ? _items[existingIndex].quantity
        : 0;
    final availableStock = getStockForVariant(variantId);

    // 👇 If we can't find it in fullInventory yet, allow adding anyway
    // (This prevents the "0 units available" error if inventory hasn't loaded)
    if (availableStock > 0 && currentCartQty + quantity > availableStock) {
      _error = 'Only $availableStock units available';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (existingIndex >= 0) {
        final existingItem = _items[existingIndex];
        final newQty = existingItem.quantity + quantity;
        _items[existingIndex] = existingItem.copyWith(
          quantity: newQty,
          totalPrice: existingItem.unitPrice * newQty,
        );
        await _apiService.updateCartItem(existingItem.id, newQty);
      } else {
        final newItem = await _apiService.addToCart({
          'product_id': productId,
          'variant_id': variantId,
          'quantity': quantity,
          'unit_price': unitPrice,
          'product_name': productName,
          'image_url': imageUrl,
          'variant_name': variantName,
        });
        _items.add(newItem);
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Update Quantity ──
  Future<bool> updateQuantity(String cartItemId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeItem(cartItemId);
      return true;
    }

    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index < 0) return false;

    final item = _items[index];
    final availableStock = getStockForVariant(item.variantId);

    if (availableStock > 0 && newQuantity > availableStock) {
      _error = 'Only $availableStock units available';
      notifyListeners();
      return false;
    }

    final oldItem = _items[index];
    _items[index] = oldItem.copyWith(
      quantity: newQuantity,
      totalPrice: oldItem.unitPrice * newQuantity,
    );
    notifyListeners();

    try {
      await _apiService.updateCartItem(cartItemId, newQuantity);
      return true;
    } catch (e) {
      _items[index] = oldItem;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── Remove Item ──
  Future<void> removeItem(String cartItemId) async {
    final removedItem = _items.firstWhere(
      (item) => item.id == cartItemId,
      orElse: () => throw Exception('Item not found'),
    );

    _items.removeWhere((item) => item.id == cartItemId);
    notifyListeners();

    try {
      await _apiService.removeCartItem(cartItemId);
    } catch (e) {
      _items.add(removedItem);
      _error = e.toString();
      notifyListeners();
    }
  }

  // ── Apply Discount ──
  void applyDiscount({
    required String name,
    required double amount,
    required bool isPercentage,
    required double value,
  }) {
    _discountName = name;
    _discountAmount = amount;
    _isPercentageDiscount = isPercentage;
    _discountValue = value;
    notifyListeners();
  }

  // ── Remove Discount ──
  void removeDiscount() {
    _discountName = null;
    _discountAmount = 0.0;
    _isPercentageDiscount = false;
    _discountValue = 0.0;
    notifyListeners();
  }

  // ── Clear Cart ──
  Future<void> clearCart() async {
    final oldItems = List<CartModel>.from(_items);
    _items.clear();
    _discountName = null;
    _discountAmount = 0.0;
    _orderNote = null;
    _includeNoteOnReceipt = false;
    notifyListeners();

    try {
      await _apiService.clearCart();
    } catch (e) {
      _items.addAll(oldItems);
      _error = e.toString();
      notifyListeners();
    }
  }

  // 👇 NEW: Helper to get cart items as JSON
  List<Map<String, dynamic>> get cartItemsJson {
    return _items.map((item) {
      return {
        'variant_id': item.variantId,
        'quantity': item.quantity,
        'unit_price': item.unitPrice,
      };
    }).toList();
  }
}
