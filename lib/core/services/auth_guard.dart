// lib/core/guards/auth_guard.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/services/local_storage.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_styles.dart';

/// The user's choice from the auth prompt sheet.
/// Public so widgets like `AuthGate` can react to it.
enum AuthChoice { signIn, signUp }

class AuthGuard {
  AuthGuard._();

  // ══════════════════════════════════════════════════════════════
  // STATE CHECKS
  // ══════════════════════════════════════════════════════════════

  static bool get hasFirebaseUser => FirebaseAuth.instance.currentUser != null;

  static User? get currentUser => FirebaseAuth.instance.currentUser;

  static String? get firebaseUid => FirebaseAuth.instance.currentUser?.uid;

  static bool get isLoggedIn => hasFirebaseUser;

  /// Returns true if a valid Firebase session exists.
  ///
  /// Self-heals the local storage: if Firebase has a user but the saved UID
  /// is missing (e.g., after reinstall), it re-saves it automatically.
  static Future<bool> isFullyLoggedIn() async {
    final fbUid = FirebaseAuth.instance.currentUser?.uid;
    if (fbUid == null || fbUid.isEmpty) return false;

    final savedUid = await LocalStorage.getFirebaseUid();

    // Self-heal: Firebase has a user but no saved UID
    if (savedUid == null || savedUid.isEmpty) {
      final phone = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';
      await LocalStorage.saveUser(firebaseUid: fbUid, phone: phone);
      return true;
    }

    return fbUid == savedUid;
  }

  static Future<String?> getActiveUid() async {
    final fbUid = FirebaseAuth.instance.currentUser?.uid;
    if (fbUid != null && fbUid.isNotEmpty) return fbUid;
    return LocalStorage.getFirebaseUid();
  }

  static Future<String?> getSavedUid() => LocalStorage.getFirebaseUid();
  static Future<String?> getSavedPhone() => LocalStorage.getUserPhone();

  // ══════════════════════════════════════════════════════════════
  // PUBLIC PROMPT — used by AuthGate and require()
  // ══════════════════════════════════════════════════════════════

  /// Shows the Sign In / Sign Up prompt sheet.
  /// Returns the user's choice, or null if dismissed.
  static Future<AuthChoice?> showAuthPrompt(
    BuildContext context, {
    String? message,
  }) {
    return showModalBottomSheet<AuthChoice>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AuthPromptSheet(message: message),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // REQUIRE — wrap any single action
  // ══════════════════════════════════════════════════════════════

  /// If logged in → runs [action] immediately.
  /// If guest → shows the Sign In / Sign Up prompt.
  ///            After successful login → runs [action].
  static Future<void> require(
    BuildContext context, {
    required VoidCallback action,
    String? message,
  }) async {
    // 1. Fast path
    final ok = await isFullyLoggedIn();
    if (ok) {
      action();
      return;
    }

    if (!context.mounted) return;

    // 2. Show the prompt
    final choice = await showAuthPrompt(context, message: message);

    if (choice == null) return;
    if (!context.mounted) return;

    // 3. Navigate to Sign In / Sign Up
    if (choice == AuthChoice.signIn) {
      await context.push(RouteNames.login);
    } else {
      // await context.push();
    }

    // 4. After returning, re-check and run the action if logged in
    if (!context.mounted) return;
    final nowLoggedIn = await isFullyLoggedIn();
    if (nowLoggedIn) {
      action();
    }
  }

  // ══════════════════════════════════════════════════════════════
  // LOGOUT
  // ══════════════════════════════════════════════════════════════

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await LocalStorage.clearUser();
  }
}

// ══════════════════════════════════════════════════════════════════
// SIGN IN / SIGN UP PROMPT SHEET
// ══════════════════════════════════════════════════════════════════
class _AuthPromptSheet extends StatelessWidget {
  final String? message;

  const _AuthPromptSheet({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryCoral.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 36,
                color: AppColors.primaryCoral,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'Sign in required',
              style: AppTextStyles.heading2.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                message ?? 'Please sign in to continue.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),

            // Sign In button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, AuthChoice.signIn),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCoral,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Sign Up button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, AuthChoice.signUp),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryCoral,
                  side: BorderSide(
                    color: AppColors.primaryCoral.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Create an account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Cancel
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Maybe later',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
