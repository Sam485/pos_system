// lib/core/services/local_storage.dart

import 'package:shared_preferences/shared_preferences.dart';

/// Simple wrapper around SharedPreferences for storing auth data.
class LocalStorage {
  LocalStorage._();

  // ── Keys ─────────────────────────────────────────────────────
  static const String _keyFirebaseUid = 'firebase_uid';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // ── Save ─────────────────────────────────────────────────────

  /// Save the Firebase UID and phone number after successful login.
  static Future<void> saveUser({
    required String firebaseUid,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFirebaseUid, firebaseUid);
    await prefs.setString(_keyUserPhone, phone);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // ── Read ─────────────────────────────────────────────────────

  /// Returns the saved Firebase UID, or null if not logged in.
  static Future<String?> getFirebaseUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFirebaseUid);
  }

  /// Returns the saved phone number, or null.
  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserPhone);
  }

  /// Returns true if a user session exists locally.
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // ── Clear ────────────────────────────────────────────────────

  /// Remove all saved auth data (used during logout).
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFirebaseUid);
    await prefs.remove(_keyUserPhone);
    await prefs.remove(_keyIsLoggedIn);
  }
}
