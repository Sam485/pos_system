// providers/setting_provider.dart

import 'package:flutter/foundation.dart';
import 'package:pos_system/core/services/api_service.dart';
import 'package:pos_system/data/models/discount_model.dart';
import 'package:pos_system/data/models/setting_model.dart';

class SettingsProvider extends ChangeNotifier {
  final ApiService _apiService;
  SettingsProvider(this._apiService);

  SettingsModel? _settings;
  List<DiscountModel> _discounts = [];
  bool _isLoading = false;
  String? _error;

  SettingsModel? get settings => _settings;
  List<DiscountModel> get discounts => _discounts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.getSettings(),
        _apiService.getDiscounts(),
      ]);
      _settings = results[0] as SettingsModel;
      _discounts = results[1] as List<DiscountModel>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleSalesTax(bool value) {
    if (_settings != null) {
      _settings = _settings!.copyWith(applySalesTax: value);
      notifyListeners();
    }
  }

  void toggleApproval(bool value) {
    if (_settings != null) {
      _settings = _settings!.copyWith(requireApproval: value);
      notifyListeners();
    }
  }

  // 👇 NEW: Update tax rate
  void updateTaxRate(double rate) {
    if (_settings != null) {
      _settings = _settings!.copyWith(taxRate: rate);
      notifyListeners();
    }
  }

  // 👇 NEW: Save settings
  Future<bool> saveSettings() async {
    if (_settings == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.updateSettings(_settings!.toJson());
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 👇 NEW: Create a discount
  Future<bool> createDiscount(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newDiscount = await _apiService.createDiscount(data);
      _discounts.add(newDiscount);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 👇 NEW: Delete a discount
  Future<bool> deleteDiscount(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteDiscount(id);
      _discounts.removeWhere((d) => d.id == id);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleReceiptSetting(String key, bool value) {
    if (_settings == null) return;

    switch (key) {
      case 'show_logo':
        _settings = _settings!.copyWith(showLogo: value);
        break;
      case 'show_tax':
        _settings = _settings!.copyWith(showTaxBreakdown: value);
        break;
      case 'offer_email':
        _settings = _settings!.copyWith(offerEmailReceipts: value);
        break;
      case 'auto_print':
        _settings = _settings!.copyWith(autoPrintReceipts: value);
        break;
    }
    notifyListeners();
  }

  // 👇 NEW: Update receipt footer text
  void updateReceiptFooter(String footer) {
    if (_settings != null) {
      _settings = _settings!.copyWith(receiptFooter: footer);
      notifyListeners();
    }
  }
}
