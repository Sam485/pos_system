// providers/staff_provider.dart

import 'package:flutter/foundation.dart';
import 'package:pos_system/core/services/api_service.dart';
import 'package:pos_system/data/enum/role_enum.dart';
import 'package:pos_system/data/models/staff_model.dart';

class StaffProvider extends ChangeNotifier {
  final ApiService _apiService;
  StaffProvider(this._apiService);

  List<StaffModel> _staffList = [];
  bool _isLoading = false;
  String? _error;

  List<StaffModel> get staffList => _staffList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStaff() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _staffList = await _apiService.getStaff();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> inviteStaff(String email, RoleEnum role) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final newStaff = StaffModel(
        id: 'staff_${DateTime.now().millisecondsSinceEpoch}',
        storeId: 'store_001',
        name: email.split('@')[0],
        email: email,
        role: role,
        isActive: true,
      );

      _staffList.add(newStaff);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 👇 UPDATED: Uses API service
  Future<bool> updateStaff(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedStaff = await _apiService.updateStaff(id, data);

      final index = _staffList.indexWhere((s) => s.id == id);
      if (index >= 0) {
        _staffList[index] = updatedStaff;
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

  // 👇 NEW: Delete staff member
  Future<bool> deleteStaff(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteStaff(id);

      _staffList.removeWhere((s) => s.id == id);

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
