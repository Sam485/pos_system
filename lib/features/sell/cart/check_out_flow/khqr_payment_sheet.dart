// features/wallet/screens/khqr_payment_screen.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:khqr_sdk/khqr_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/route_names.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_style_x.dart';
import '../../../../../providers/cart_provider.dart';
import '../../../../../providers/order_provider.dart';

// ── Config ────────────────────────────────────────────────────────
class KhqrConfig {
  static const bakongAccountId = 'lik_tong@bkrt';
  static const merchantName = 'sen dy';
  static const merchantCity = 'Phnom Penh';
  static const acquiringBank = 'ACLEDA Bank';
  static const merchantId = '123456789';
  static const bakongToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7ImlkIjoiOGU5OGRhNTA0NmUyNDc0MiJ9LCJpYXQiOjE3Nzg5OTIyNjIsImV4cCI6MTc4Njc2ODI2Mn0.icrn-H2qO9KQI6ij8TmDNISShkRAjqO4L4W2hNVOTOo';
  static const checkTxUrl =
      'https://api-bakong.nbc.gov.kh/v1/check_transaction_by_md5';
  static const pollIntervalSec = 5;
  static const qrExpiryMinutes = 10;

  static const bakongBlue = Color(0xFF1565C0);
}

// ── KHQR Screen Widget ────────────────────────────────────────────
class KhqrPaymentScreen extends StatefulWidget {
  final double amount;
  final String qrString;
  final String md5;
  final VoidCallback onSuccess;

  const KhqrPaymentScreen({
    super.key,
    required this.amount,
    required this.qrString,
    required this.md5,
    required this.onSuccess,
  });

  @override
  State<KhqrPaymentScreen> createState() => _KhqrPaymentScreenState();
}

class _KhqrPaymentScreenState extends State<KhqrPaymentScreen> {
  String _status = 'waiting';
  String? _errorMsg;
  Timer? _pollTimer;
  Timer? _expiryTimer;
  int _secondsLeft = KhqrConfig.qrExpiryMinutes * 60;
  bool _isProcessingOrder = false;

  @override
  void initState() {
    super.initState();
    _startPolling();
    _startExpiryCountdown();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _expiryTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _checkPayment();
    _pollTimer = Timer.periodic(
      Duration(seconds: KhqrConfig.pollIntervalSec),
      (_) => _checkPayment(),
    );
  }

  void _startExpiryCountdown() {
    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        _expiryTimer?.cancel();
        _pollTimer?.cancel();
        if (_status == 'waiting') setState(() => _status = 'expired');
      }
    });
  }

  Future<void> _checkPayment() async {
    if (_status != 'waiting' || _isProcessingOrder) return;
    try {
      final res = await http
          .post(
            Uri.parse(KhqrConfig.checkTxUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${KhqrConfig.bakongToken}',
            },
            body: jsonEncode({'md5': widget.md5}),
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;
      final body = jsonDecode(res.body) as Map<String, dynamic>;

      if (body['responseCode'] == 0 && body['data'] != null) {
        _pollTimer?.cancel();
        _expiryTimer?.cancel();
        setState(() => _status = 'paid');
        // 👇 Automatically place the order when payment is confirmed
        _placeOrder();
      } else if (body['responseCode'] != 0 && body['responseCode'] != 1) {
        setState(() {
          _status = 'error';
          _errorMsg = body['responseMessage']?.toString();
        });
      }
    } on TimeoutException {
      // Keep polling
    }
  }

  Future<void> _placeOrder() async {
    if (_isProcessingOrder) return;
    setState(() => _isProcessingOrder = true);

    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    final orderData = {
      'customer_id': cartProvider.selectedCustomer?.id,
      'subtotal': cartProvider.subtotal,
      'discount_amount': cartProvider.discountAmount,
      'tax_amount': cartProvider.tax,
      'total_amount': widget.amount,
      'payment_method': 'khqr',
      'transaction_reference': widget.md5,
      'items': cartProvider.items
          .map(
            (item) => {
              'variant_id': item.variantId,
              'quantity': item.quantity,
              'unit_price': item.unitPrice,
              'total_price': item.totalPrice,
            },
          )
          .toList(),
    };

    final success = await orderProvider.placeOrder(orderData);

    if (success && mounted) {
      final customer = cartProvider.selectedCustomer;
      final itemsSold = cartProvider.itemCount;

      cartProvider.clearCart();

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        context.goNamed(
          RouteNames.saleCompleteName,
          extra: {
            'amount': widget.amount,
            'method': 'KHQR',
            'customerName': customer != null
                ? '${customer.firstName} ${customer.lastName}'
                : null,
            'customerEmail': customer?.email,
            'itemsSold': itemsSold,
          },
        );
      }
    } else if (mounted) {
      // If placing order fails, still show the payment as successful
      // but display an error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.error ?? 'Failed to create order'),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() => _isProcessingOrder = false);
  }

  String get _timerText {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.close_rounded, color: c.textPrimary),
        ),
        title: Text(
          'Scan to pay',
          style: textStyles.heading2.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Info
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: KhqrConfig.bakongBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.qr_code_2_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bakong · KHQR',
                          style: textStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Scan with any banking app',
                          style: textStyles.bodySmall.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: c.primaryCoral.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '\$ ${widget.amount.toStringAsFixed(2)}',
                      style: textStyles.labelMedium.copyWith(
                        color: c.primaryCoral,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Dynamic State Content
              if (_status == 'waiting') _buildWaiting(c, textStyles),
              if (_status == 'paid') _buildSuccess(c, textStyles),
              if (_status == 'expired') _buildExpired(c, textStyles),
              if (_status == 'error') _buildError(c, textStyles),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaiting(AppThemeColors c, AppTextStylesX textStyles) {
    final isExpiringSoon = _secondsLeft < 60;
    final accent = isExpiringSoon ? c.primaryOrange : c.textSecondary;

    return Column(
      children: [
        // QR Container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: KhqrCardWidget(
            width: 280,
            amount: widget.amount,
            qr: widget.qrString,
            receiverName: KhqrConfig.merchantName,
          ),
        ),
        const SizedBox(height: 24),

        // Timer
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isExpiringSoon
                  ? Icons.warning_amber_rounded
                  : Icons.access_time_outlined,
              size: 16,
              color: accent,
            ),
            const SizedBox(width: 6),
            Text(
              '${context.t('qr_expires_in')} $_timerText',
              style: textStyles.labelSmall.copyWith(color: accent),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Loading Indicator
        CircularProgressIndicator(color: c.primaryCoral, strokeWidth: 2.5),
        const SizedBox(height: 16),
        Text(
          context.t('waiting_for_payment'),
          style: textStyles.labelMedium.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          'Please do not close this screen',
          style: textStyles.bodySmall.copyWith(color: c.textMuted),
        ),
      ],
    );
  }

  Widget _buildSuccess(AppThemeColors c, AppTextStylesX textStyles) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: c.green.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: c.green,
            size: 56,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          context.t('payment_successful'),
          style: textStyles.heading1.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          'Payment of \$${widget.amount.toStringAsFixed(2)} received.',
          style: textStyles.bodyMedium.copyWith(color: c.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        if (_isProcessingOrder)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: c.primaryCoral,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Creating order...',
                style: textStyles.labelSmall.copyWith(color: c.textMuted),
              ),
            ],
          ),
        const SizedBox(height: 32),
        _primaryButton(
          context: context,
          label: context.t('done'),
          onPressed: _isProcessingOrder
              ? null
              : () {
                  Navigator.of(context).pop();
                  widget.onSuccess();
                },
          c: c,
          textStyles: textStyles,
        ),
      ],
    );
  }

  Widget _buildExpired(AppThemeColors c, AppTextStylesX textStyles) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: c.primaryOrange.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.timer_off_outlined,
            color: c.primaryOrange,
            size: 56,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          context.t('qr_expired'),
          style: textStyles.heading1.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          context.t('generate_new_qr'),
          style: textStyles.bodyMedium.copyWith(color: c.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _primaryButton(
          context: context,
          label: context.t('generate_new_qr'),
          onPressed: () => context.pop(),
          c: c,
          textStyles: textStyles,
        ),
      ],
    );
  }

  Widget _buildError(AppThemeColors c, AppTextStylesX textStyles) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: c.primaryCoral.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.error_outline_rounded,
            color: c.primaryCoral,
            size: 56,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          context.t('something_went_wrong'),
          style: textStyles.heading1.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          _errorMsg ?? context.t('unable_to_verify_payment'),
          style: textStyles.bodyMedium.copyWith(color: c.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _primaryButton(
          context: context,
          label: context.t('close'),
          onPressed: () => context.pop(),
          c: c,
          textStyles: textStyles,
        ),
      ],
    );
  }

  Widget _primaryButton({
    required BuildContext context,
    required String label,
    required VoidCallback? onPressed,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primaryCoral,
          foregroundColor: Colors.white,
          disabledBackgroundColor: c.primaryCoral.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: textStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
