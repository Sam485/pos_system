import 'package:flutter/material.dart';
import 'package:pos_system/core/services/api_service.dart';
import 'package:pos_system/data/models/customer_model.dart';

class CustomerProvider extends ChangeNotifier {
  final ApiService _apiService;
  CustomerProvider(this._apiService);

  List<CustomerModel> _customers = [];
  CustomerModel? _selectedCustomer;
  bool _isLoading = false;
  String? _error;

  List<CustomerModel> get customers => _customers;
  CustomerModel? get selectedCustomer => _selectedCustomer;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCustomers({String? search}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _customers = await _apiService.getCustomers(search: search);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add this inside providers/customer_provider.dart

  Future<bool> updateCustomer(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedCustomer = await _apiService.updateCustomer(id, data);

      // Update the customer in the local list
      final index = _customers.indexWhere((c) => c.id == id);
      if (index >= 0) {
        _customers[index] = updatedCustomer;
      }

      // Update the selected customer if it's the same one
      if (_selectedCustomer?.id == id) {
        _selectedCustomer = updatedCustomer;
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

  Future<void> selectCustomer(CustomerModel? customer) async {
    _selectedCustomer = customer;
    notifyListeners();
  }

  Future<bool> createCustomer(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newCustomer = await _apiService.createCustomer(data);
      _customers.insert(0, newCustomer);
      _selectedCustomer = newCustomer;
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
