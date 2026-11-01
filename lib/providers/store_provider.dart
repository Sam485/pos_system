// providers/store_provider.dart

import 'package:flutter/foundation.dart';
import 'package:pos_system/core/services/api_service.dart';
import 'package:pos_system/data/models/store_model.dart';

class StoreProvider extends ChangeNotifier {
  final ApiService _apiService;
  StoreProvider(this._apiService);

  StoreModel? _store;
  bool _isLoading = false;
  String? _error;

  StoreModel? get store => _store;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStore() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _store = await _apiService.getStore();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateStore(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _store = await _apiService.updateStore(data);
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
