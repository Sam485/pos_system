// providers/inventory_provider.dart

import 'package:flutter/foundation.dart';
import 'package:pos_system/core/services/api_service.dart';
import 'package:pos_system/data/models/iventory_model.dart';
import 'package:pos_system/data/models/variant_model.dart'; // 👈 Import Variant

class InventoryProvider extends ChangeNotifier {
  final ApiService _apiService;
  InventoryProvider(this._apiService);

  // 👇 New: Full inventory list
  List<InventoryModel> _fullInventory = [];
  List<InventoryModel> get fullInventory => _fullInventory;

  // Existing: Low stock alerts (used by Home screen)
  List<InventoryModel> _lowStockAlerts = [];
  List<InventoryModel> get lowStockAlerts => _lowStockAlerts;

  List<VariantModel> _variants = [];
  List<VariantModel> get variants => _variants;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<bool> updateStock({
    required String variantId,
    required int quantityChange,
    required String reason,
    String? note,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.updateStock(
        variantId: variantId,
        quantityChange: quantityChange,
        reason: reason,
        note: note,
      );

      // 👇 FIX: Refresh BOTH lists so the Low Stock screen and Home screen update
      await Future.wait([fetchFullInventory(), fetchLowStockAlerts()]);

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateLocalInventory(String variantId, int newQuantity) {
    // 👇 FIX: Update low stock alerts
    final lowStockIndex = _lowStockAlerts.indexWhere(
      (item) => item.variantId == variantId,
    );
    if (lowStockIndex >= 0) {
      _lowStockAlerts[lowStockIndex] = _lowStockAlerts[lowStockIndex].copyWith(
        quantityAvailable: newQuantity,
      );
    }

    // 👇 FIX: Also update full inventory so the Stock Screen reflects changes
    final fullInvIndex = _fullInventory.indexWhere(
      (item) => item.variantId == variantId,
    );
    if (fullInvIndex >= 0) {
      _fullInventory[fullInvIndex] = _fullInventory[fullInvIndex].copyWith(
        quantityAvailable: newQuantity,
      );
    }

    notifyListeners();
  }

  // 👇 Fetch full inventory for the Stock screen
  Future<void> fetchFullInventory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.getFullInventory(),
        _apiService.getVariants(),
      ]);

      _fullInventory = results[0] as List<InventoryModel>;
      _variants = results[1] as List<VariantModel>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 👇 Existing: Fetch only low stock alerts (for Home screen)
  Future<void> fetchLowStockAlerts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.getLowStockAlerts(),
        _apiService.getVariants(),
      ]);

      _lowStockAlerts = results[0] as List<InventoryModel>;
      _variants = results[1] as List<VariantModel>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  VariantModel? getVariantById(String variantId) {
    try {
      return _variants.firstWhere((v) => v.id == variantId);
    } catch (_) {
      return null;
    }
  }

  // providers/inventory_provider.dart

  Future<bool> addVariant(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.addVariant(data);
      // Refresh the local list so the new variant appears
      await fetchLowStockAlerts();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
