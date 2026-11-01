// core/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/features/auth/forget_password_screen.dart';
import 'package:pos_system/features/auth/login_screen.dart';
import 'package:pos_system/features/home/new%20sale/open_register_screen.dart';
import 'package:pos_system/features/auth/password_recovery_screen.dart';
import 'package:pos_system/features/home/new%20sale/store_register_selection_screen.dart';
import 'package:pos_system/features/home/customer/customer_profile_screen.dart';
import 'package:pos_system/features/more/close%20register/close_register_screen.dart';
import 'package:pos_system/features/more/connected%20devices/connected_devices_screen.dart';
import 'package:pos_system/features/more/help%20support/help_support_screen.dart';
import 'package:pos_system/features/more/receipt%20preferences/receipt_preferences_screen.dart';
import 'package:pos_system/features/more/staff%20permissions/other/invite_staff_screen.dart';
import 'package:pos_system/features/more/staff%20permissions/other/manage_staff_screen.dart';
import 'package:pos_system/features/more/staff%20permissions/staff_permissions_screen.dart';
import 'package:pos_system/features/more/store%20details/store_details_screen.dart';
import 'package:pos_system/features/more/taxes%20discount/taxes_discount_screen.dart';
import 'package:pos_system/features/other/customer/add_customer_screen.dart';
import 'package:pos_system/features/other/customer/edit_customer_screen.dart';
import 'package:pos_system/features/home/home_screen.dart';
import 'package:pos_system/features/home/customer/customer_directory_screen.dart';
import 'package:pos_system/features/home/stock/low_stock_screen.dart';
import 'package:pos_system/features/more/setting_screen.dart';
import 'package:pos_system/features/other/notifications/notification_screen.dart';
import 'package:pos_system/features/other/scanner/scan_barcode_screen.dart';
import 'package:pos_system/features/other/sell/receipt_screen.dart';
import 'package:pos_system/features/other/sell/refund_complete_screen.dart';
import 'package:pos_system/features/other/sell/return_refund_screen.dart';
import 'package:pos_system/features/other/stock/manage_stock_screen.dart';
import 'package:pos_system/features/other/sell/transaction_detail_screen.dart';
import 'package:pos_system/features/sale/function/sale_filter_date_range_screen.dart';
import 'package:pos_system/features/sale/sale_screen.dart';
import 'package:pos_system/features/sell/cart/add%20customer/customer_selection_screen.dart';
import 'package:pos_system/features/sell/cart/apply%20discount/apply_discount_screen.dart';
import 'package:pos_system/features/sell/cart/cart_screen.dart';
import 'package:pos_system/features/sell/cart/check_out_flow/card_payment_screen.dart';
import 'package:pos_system/features/sell/cart/check_out_flow/carrd_payment_decline_screen.dart';
import 'package:pos_system/features/sell/cart/check_out_flow/cash_payment_screen.dart';
import 'package:pos_system/features/sell/cart/check_out_flow/checkout_screen.dart';
import 'package:pos_system/features/sell/cart/check_out_flow/sale_complete_screen.dart';
import 'package:pos_system/features/sell/cart/order%20note/order_note_screen.dart';
import 'package:pos_system/features/sell/detail/product_detail_screen.dart';
import 'package:pos_system/features/sell/function/product_filter_screen.dart';
import 'package:pos_system/features/sell/function/search_product_screen.dart';
import 'package:pos_system/features/sell/sell_screen.dart';
import 'package:pos_system/features/stock/stock_screen.dart';

import '../../shared/widgets/scaffold_with_nav.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteNames.home, // '/'
  debugLogDiagnostics: false,

  onException: (context, state, router) {
    debugPrint('Router exception: ${state.error} on ${state.uri}');
    if (state.uri.toString() != RouteNames.home) {
      router.go(RouteNames.home);
    }
  },

  routes: [
    // ══════════════════════════════════════════════════════════════
    // ONBOARDING — full screen, NO nav bar
    // ══════════════════════════════════════════════════════════════
    GoRoute(
      path: RouteNames.login,
      name: RouteNames.loginName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.storeRegister,
      name: RouteNames.storeRegisterName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const StoreRegisterSelectionScreen(),
    ),
    GoRoute(
      path: RouteNames.openRegister,
      name: RouteNames.openRegisterName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OpenRegisterScreen(),
    ),
    GoRoute(
      path: RouteNames.forgetPassword,
      name: RouteNames.forgetPasswordName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ForgetPasswordScreen(),
    ),
    GoRoute(
      path: RouteNames.passwordRecovery,
      name: RouteNames.passwrodRecoveryName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PasswordRecoveryScreen(),
    ),
    GoRoute(
      path: RouteNames.lowStock,
      name: RouteNames.lowStockName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LowStockScreen(),
    ),
    GoRoute(
      path: RouteNames.manageStock,
      name: RouteNames.manageStockName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ManageStockScreen(),
    ),
    GoRoute(
      path: RouteNames.customerDirectory,
      name: RouteNames.customerDirectoryName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CustomerDirectoryScreen(),
    ),
    GoRoute(
      path: RouteNames.customerProfile,
      name: RouteNames.customerProfileName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CustomerProfileScreen(),
    ),
    GoRoute(
      path: RouteNames.editCustomer,
      name: RouteNames.editCustomerName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const EditCustomerScreen(),
    ),
    GoRoute(
      path: RouteNames.cart,
      name: RouteNames.cartName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: RouteNames.customerSelection,
      name: RouteNames.customerSelectionName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CustomerSelectionScreen(),
    ),
    GoRoute(
      path: RouteNames.addCustomer,
      name: RouteNames.addCustomerName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AddCustomerScreen(),
    ),
    GoRoute(
      path: RouteNames.checkout,
      name: RouteNames.checkoutName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: RouteNames.cashPayment,
      name: RouteNames.cashPaymentName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CashPaymentScreen(),
    ),
    GoRoute(
      path: RouteNames.cardPayment,
      name: RouteNames.cardPaymentName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CardPaymentScreen(),
    ),

    // ── KHQR PAYMENT REMOVED (used via showKhqrPaymentScreen helper) ──
    GoRoute(
      path: RouteNames.saleComplete,
      name: RouteNames.saleCompleteName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SaleCompleteScreen(),
    ),
    GoRoute(
      path: RouteNames.transactionDetail,
      name: RouteNames.transactionDetailName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TransactionDetailScreen(),
    ),
    GoRoute(
      path: RouteNames.returnRefund,
      name: RouteNames.returnRefundName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ReturnRefundScreen(),
    ),
    GoRoute(
      path: RouteNames.refundComplete,
      name: RouteNames.refundCompleteName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RefundCompleteScreen(),
    ),
    GoRoute(
      path: RouteNames.applyDiscount,
      name: RouteNames.applyDiscountName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ApplyDiscountScreen(),
    ),
    GoRoute(
      path: RouteNames.orderNote,
      name: RouteNames.orderNoteName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OrderNoteScreen(),
    ),
    GoRoute(
      path: RouteNames.productFilter,
      name: RouteNames.productFilterName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProductFilterScreen(),
    ),
    GoRoute(
      path: RouteNames.searchProduct,
      name: RouteNames.searchProductName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SearchProductsScreen(),
    ),
    GoRoute(
      path: RouteNames.saleFilterDateRange,
      name: RouteNames.saleFilterDateRangeName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SaleFilterDateRangeScreen(),
    ),
    GoRoute(
      path: RouteNames.storeDetails,
      name: RouteNames.storeDetailsName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const StoreDetailsScreen(),
    ),
    GoRoute(
      path: RouteNames.taxesDiscount,
      name: RouteNames.taxesDiscountName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TaxesDiscountScreen(),
    ),
    GoRoute(
      path: RouteNames.receiptPreferences,
      name: RouteNames.receiptPreferencesName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ReceiptPreferencesScreen(),
    ),
    GoRoute(
      path: RouteNames.connectedDevices,
      name: RouteNames.connectedDevicesName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ConnectedDevicesScreen(),
    ),
    GoRoute(
      path: RouteNames.staffPermission,
      name: RouteNames.staffPermissionName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const StaffPermissionsScreen(),
    ),
    GoRoute(
      path: RouteNames.closeRegister,
      name: RouteNames.closeRegisterName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CloseRegisterScreen(),
    ),
    GoRoute(
      path: RouteNames.helpSupport,
      name: RouteNames.helpSupportName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const HelpSupportScreen(),
    ),
    GoRoute(
      path: RouteNames.productDetail,
      name: RouteNames.productDetailName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProductDetailScreen(),
    ),
    GoRoute(
      path: RouteNames.inviteStaff,
      name: RouteNames.inviteStaffName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const InviteStaffScreen(),
    ),
    GoRoute(
      path: RouteNames.manageStaff,
      name: RouteNames.manageStaffName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ManageStaffScreen(),
    ),
    GoRoute(
      path: RouteNames.barcodeScanner,
      name: RouteNames.barcodeScannerName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ScanBarcodeScreen(),
    ),
    GoRoute(
      path: RouteNames.notification,
      name: RouteNames.notificationName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: RouteNames.cardPayment,
      name: RouteNames.cardPaymentDeclineName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CardPaymentDeclineScreen(),
    ),
    GoRoute(
      path: RouteNames.receipt,
      name: RouteNames.receiptName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ReceiptScreen(),
    ),

    // ══════════════════════════════════════════════════════════════
    // SHELL WITH BOTTOM NAV (StatefulShellRoute)
    // ══════════════════════════════════════════════════════════════
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNav(child: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.home,
              name: RouteNames.homeName,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomeScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.sell,
              name: RouteNames.sellName,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SellScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.sale,
              name: RouteNames.saleName,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SaleScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.stock,
              name: RouteNames.stockName,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: StockScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.more,
              name: RouteNames.moreName,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SettingScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
