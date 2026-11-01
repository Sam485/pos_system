// // lib/shared/widgets/auth_gate.dart

// import 'package:flutter/material.dart';

// /// Wraps a screen so it's only rendered when the user is logged in.
// ///
// /// - While checking login state → spinner
// /// - If guest → inline "Sign in required" fallback (no bottom sheet)
// /// - If logged in → renders [child]
// class AuthGate extends StatefulWidget {
//   final Widget child;
//   final String? message;

//   const AuthGate({super.key, required this.child, this.message});

//   @override
//   State<AuthGate> createState() => _AuthGateState();
// }

// class _AuthGateState extends State<AuthGate> {
//   bool _checking = true;
//   bool _loggedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     _check();
//   }

//   Future<void> _check() async {
//     setState(() => _checking = true);

//     final ok = await AuthGuard.isFullyLoggedIn();
//     if (!mounted) return;

//     setState(() {
//       _loggedIn = ok;
//       _checking = false;
//     });
//   }

//   /// Navigate to Sign In and re-check on return.
//   Future<void> _goToSignIn() async {
//     await context.push(RouteNames.signIn);

//     if (!mounted) return;

//     // Re-check after the user returns from the sign-in screen
//     final ok = await AuthGuard.isFullyLoggedIn();
//     if (!mounted) return;

//     setState(() => _loggedIn = ok);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Still checking → spinner
//     if (_checking) {
//       return const Scaffold(
//         backgroundColor: AppColors.background,
//         body: Center(
//           child: CircularProgressIndicator(color: AppColors.primaryCoral),
//         ),
//       );
//     }

//     // Not logged in → inline fallback (no bottom sheet)
//     if (!_loggedIn) {
//       return Scaffold(
//         backgroundColor: AppColors.background,
//         body: _buildGuestFallback(),
//       );
//     }

//     // Logged in → show the real content
//     return widget.child;
//   }

//   Widget _buildGuestFallback() {
//     return SafeArea(
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryCoral.withValues(alpha: 0.08),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.lock_outline_rounded,
//                   size: 48,
//                   color: AppColors.primaryCoral,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 'Sign in required',
//                 style: AppTextStyles.heading2.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 widget.message ?? 'Please sign in to continue.',
//                 style: AppTextStyles.bodyMedium.copyWith(
//                   color: AppColors.textSecondary,
//                   height: 1.5,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 32),
//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton(
//                   onPressed: _goToSignIn,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryCoral,
//                     foregroundColor: Colors.white,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                   ),
//                   child: const Text(
//                     'Sign In',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: OutlinedButton(
//                   onPressed: () async {
//                     await context.push(RouteNames.signUp);
//                     if (!mounted) return;

//                     final ok = await AuthGuard.isFullyLoggedIn();
//                     if (!mounted) return;
//                     setState(() => _loggedIn = ok);
//                   },
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: AppColors.primaryCoral,
//                     side: BorderSide(
//                       color: AppColors.primaryCoral.withValues(alpha: 0.5),
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                   ),
//                   child: const Text(
//                     'Create an account',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
