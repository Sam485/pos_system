// providers/app_providers.dart

import 'package:flutter/foundation.dart';
import 'package:pos_system/core/services/api_service.dart';

// ══════════════════════════════════════════════════════════════════
// 1. AUTH PROVIDER
// ══════════════════════════════════════════════════════════════════
class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  AuthProvider(this._apiService);

  bool _isLoading = false;
  String? _error;
  String? _currentUserId;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUserId != null;
  String? get currentUserId => _currentUserId; // 👈 New getter

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.login(email: email, password: password);
      _currentUserId = 'staff_001'; // In a real app, parse from API response
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    _currentUserId = null;
    notifyListeners();
  }
}
