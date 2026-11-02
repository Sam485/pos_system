import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/cart_provider.dart';
import 'package:pos_system/providers/order_provider.dart';

class CashPaymentScreen extends StatefulWidget {
  const CashPaymentScreen({super.key});

  @override
  State<CashPaymentScreen> createState() => _CashPaymentScreenState();
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {
  double _totalDue = 0.0;
  String? _customerId;
  String? _customerName;
  bool _isProcessing = false;
  bool _isInitialized = false;

  String _inputAmount = '';

  double get _cashReceived => double.tryParse(_inputAmount) ?? 0.0;
  double get _changeToGive => _cashReceived - _totalDue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    _isInitialized = true;

    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic>) {
      _totalDue = (extra['amount'] as num?)?.toDouble() ?? 0.0;
      _customerId = extra['customerId'] as String?;
      _inputAmount = _totalDue.toStringAsFixed(2);
    }

    final customer = context.read<CartProvider>().selectedCustomer;
    if (customer != null) {
      _customerName = customer.firstName;
    }
  }

  void _onKeyTap(String value) {
    String current = _inputAmount;
    if (current == _totalDue.toStringAsFixed(2)) {
      current = '';
    }

    if (value == 'del') {
      if (current.isNotEmpty) {
        current = current.substring(0, current.length - 1);
      }
    } else if (value == '.') {
      if (!current.contains('.')) {
        current += value;
      }
    } else {
      if (current.contains('.')) {
        final parts = current.split('.');
        if (parts[1].length < 2) {
          current += value;
        }
      } else {
        if (current == '0') {
          current = value;
        } else {
          current += value;
        }
      }
    }

    setState(() {
      _inputAmount = current;
    });
  }

  Future<void> _completePayment() async {
    setState(() => _isProcessing = true);

    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    final orderData = {
      'customer_id': _customerId,
      'subtotal': cartProvider.subtotal,
      'discount_amount': cartProvider.discountAmount,
      'tax_amount': cartProvider.tax,
      'total_amount': _totalDue,
      'payment_method': 'cash',
      'amount_tendered': _cashReceived,
      'change_given': _changeToGive,
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
      cartProvider.clearCart();
      context.goNamed(
        RouteNames.saleCompleteName,
        extra: {
          'amount': _totalDue,
          'method': 'Cash',
          'cashReceived': _cashReceived,
          'change': _changeToGive,
        },
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            orderProvider.error ?? context.t('cash_payment_failed'),
          ),
          backgroundColor: context.colors.dangerFg,
        ),
      );
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    final isSufficient = _changeToGive >= 0;
    final changeColor = isSufficient ? c.successFg : c.warningFg;
    final changeBg = isSufficient ? c.successBg : c.warningBg;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _isProcessing ? null : () => context.pop(),
                    icon: Icon(Icons.arrow_back, color: c.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t('cash_payment_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _customerName != null
                            ? context.tp('cash_payment_subtitle_customer', {
                                'name': _customerName!,
                              })
                            : context.t('cash_payment_subtitle_guest'),
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      context.t('cash_payment_total_due'),
                      style: textStyles.labelMedium.copyWith(
                        color: c.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_totalDue.toStringAsFixed(2)}',
                      style: textStyles.heading1.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.t('cash_payment_cash_received'),
                        style: textStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: c.surfaceTint,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: c.primaryCoral, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '\$',
                            style: textStyles.heading2.copyWith(
                              color: c.textMuted,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _inputAmount.isEmpty ? '0.00' : _inputAmount,
                              textAlign: TextAlign.right,
                              style: textStyles.heading1.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickAmountPill(
                          label: context.t('cash_payment_quick_exact'),
                          onTap: () => setState(
                            () => _inputAmount = _totalDue.toStringAsFixed(2),
                          ),
                          c: c,
                          textStyles: textStyles,
                        ),
                        _buildQuickAmountPill(
                          label: '\$140',
                          onTap: () => setState(() => _inputAmount = '140.00'),
                          c: c,
                          textStyles: textStyles,
                        ),
                        _buildQuickAmountPill(
                          label: '\$150',
                          onTap: () => setState(() => _inputAmount = '150.00'),
                          c: c,
                          textStyles: textStyles,
                        ),
                        _buildQuickAmountPill(
                          label: '\$200',
                          onTap: () => setState(() => _inputAmount = '200.00'),
                          c: c,
                          textStyles: textStyles,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: changeBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isSufficient
                                    ? context.t('cash_payment_change_title')
                                    : context.t(
                                        'cash_payment_insufficient_title',
                                      ),
                                style: textStyles.labelMedium.copyWith(
                                  color: changeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _customerName != null && isSufficient
                                    ? context.tp(
                                        'cash_payment_hand_change_named',
                                        {'name': _customerName!},
                                      )
                                    : isSufficient
                                    ? context.t(
                                        'cash_payment_hand_change_generic',
                                      )
                                    : context.t(
                                        'cash_payment_insufficient_hint',
                                      ),
                                style: textStyles.bodySmall.copyWith(
                                  color: changeColor.withValues(alpha: 0.8),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$${isSufficient ? _changeToGive.toStringAsFixed(2) : '0.00'}',
                            style: textStyles.heading2.copyWith(
                              color: isSufficient
                                  ? c.primaryCoral
                                  : c.warningFg,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildKeypad(c, textStyles),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: ElevatedButton(
                onPressed: _isProcessing || !isSufficient
                    ? null
                    : _completePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.primaryCoral,
                  foregroundColor: c.textLight,
                  disabledBackgroundColor: c.primaryCoral.withValues(
                    alpha: 0.5,
                  ),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, size: 20, color: c.textLight),
                          const SizedBox(width: 8),
                          Text(
                            context.tp('cash_payment_complete_button', {
                              'amount': _totalDue.toStringAsFixed(2),
                            }),
                            style: textStyles.labelMedium.copyWith(
                              color: c.textLight,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmountPill({
    required String label,
    required VoidCallback onTap,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: c.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                label,
                style: textStyles.labelSmall.copyWith(
                  color: c.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad(AppThemeColors c, AppTextStylesX textStyles) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', 'del'],
    ];

    return Column(
      children: keys.map((row) {
        return Row(
          children: row.map((key) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: InkWell(
                  onTap: () => _onKeyTap(key),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: c.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: key == 'del'
                          ? Icon(
                              Icons.backspace_outlined,
                              color: c.textPrimary,
                              size: 24,
                            )
                          : Text(
                              key,
                              style: textStyles.heading2.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
