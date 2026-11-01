import 'package:flutter/material.dart';
import 'package:pos_system/core/services/api_service.dart';
import 'package:pos_system/data/enum/register_session_enum.dart';
import 'package:pos_system/data/models/register_model.dart';
import 'package:pos_system/data/models/register_sessions.dart';

class RegisterProvider extends ChangeNotifier {
  final ApiService _apiService;
  RegisterProvider(this._apiService);

  List<RegisterModel> _registers = [];
  RegisterSessions? _activeSession;
  bool _isLoading = false;
  String? _error;

  List<RegisterModel> get registers => _registers;
  RegisterSessions? get activeSession => _activeSession;
  bool get isRegisterOpen => _activeSession?.status == RegisterSessionEnum.open;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRegisters() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _registers = await _apiService.getRegisters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> openRegister(String registerId, double openingFloat) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _activeSession = await _apiService.openRegister(
        registerId: registerId,
        openingFloat: openingFloat,
      );
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> closeRegister(double countedCash, {String? note}) async {
    if (_activeSession == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.closeRegister(
        sessionId: _activeSession!.id,
        countedCash: countedCash,
        note: note,
      );
      _activeSession = null; // Clear session
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
