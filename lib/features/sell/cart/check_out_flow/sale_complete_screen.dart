import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/order_provider.dart';
import 'package:pos_system/providers/cart_provider.dart';

class SaleCompleteScreen extends StatefulWidget {
  const SaleCompleteScreen({super.key});

  @override
  State<SaleCompleteScreen> createState() => _SaleCompleteScreenState();
}

class _SaleCompleteScreenState extends State<SaleCompleteScreen> {
  final TextEditingController _emailController = TextEditingController();

  // Data from Router
  double _amount = 0.0;
  String _paymentMethod = 'Cash';
  double? _cashReceived;
  double? _changeGiven;
  String? _customerName;
  String? _customerEmail;
  int _itemsSold = 0;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra;

      if (extra is Map<String, dynamic>) {
        _amount = (extra['amount'] as num?)?.toDouble() ?? 0.0;
        _paymentMethod = extra['method'] as String? ?? 'Cash';
        _cashReceived = (extra['cashReceived'] as num?)?.toDouble();
        _changeGiven = (extra['change'] as num?)?.toDouble();
        _customerName = extra['customerName'] as String?;
        _customerEmail = extra['customerEmail'] as String?;
        _itemsSold = (extra['itemsSold'] as num?)?.toInt() ?? 0;
      } else if (extra is double) {
        _amount = extra;
        _paymentMethod = 'KHQR';
      }

      if (_customerEmail != null) {
        _emailController.text = _customerEmail!;
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Localized display name for the payment method
  String _localizedPaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return context.t('sale_complete_method_cash');
      case 'card':
        return context.t('sale_complete_method_card');
      case 'khqr':
        return context.t('sale_complete_method_khqr');
      default:
        return method.toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Top App Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.t('sale_complete_title'),
                    style: textStyles.heading2.copyWith(fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () => context.goNamed(RouteNames.homeName),
                    icon: Icon(
                      Icons.close_rounded,
                      color: c.primaryCoral,
                      size: 28,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // ── Main Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: c.surfaceTint,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: c.primaryCoral,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.t('sale_complete_heading'),
                      style: textStyles.heading1.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tp('sale_complete_confirmed_at', {
                        'time': TimeOfDay.now().format(context),
                      }),
                      style: textStyles.bodySmall.copyWith(color: c.textMuted),
                    ),
                    const SizedBox(height: 32),

                    // ── Receipt Summary Card ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: c.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.tp('sale_complete_paid_in', {
                                  'method': _localizedPaymentMethod(
                                    _paymentMethod,
                                  ),
                                }),
                                style: textStyles.labelMedium.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '\$${_amount.toStringAsFixed(2)}',
                                style: textStyles.heading1.copyWith(
                                  color: c.primaryCoral,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Divider(
                            color: c.border.withValues(alpha: 0.5),
                            height: 1,
                          ),
                          const SizedBox(height: 16),

                          if (_paymentMethod == 'Cash' &&
                              _cashReceived != null) ...[
                            _buildSummaryRow(
                              context.t('sale_complete_cash_received'),
                              '\$${_cashReceived!.toStringAsFixed(2)}',
                              c,
                              textStyles,
                            ),
                            const SizedBox(height: 12),
                            _buildSummaryRow(
                              context.t('sale_complete_change_given'),
                              '\$${(_changeGiven ?? 0).toStringAsFixed(2)}',
                              c,
                              textStyles,
                            ),
                            const SizedBox(height: 12),
                          ],

                          _buildSummaryRow(
                            context.t('sale_complete_customer'),
                            _customerName ?? context.t('sale_complete_guest'),
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            context.t('sale_complete_items_sold'),
                            context.tp('sale_complete_items_count', {
                              'count': '$_itemsSold',
                            }),
                            c,
                            textStyles,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Send Receipt Section ──
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.t('sale_complete_send_receipt'),
                        style: textStyles.heading2.copyWith(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.t('sale_complete_email_label'),
                        style: textStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      style: textStyles.bodyLarge,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail_outline_rounded,
                          color: c.textMuted,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: c.surfaceLight,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: c.primaryCoral,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_emailController.text.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.tp('sale_complete_sent_toast', {
                                    'email': _emailController.text,
                                  }),
                                ),
                                backgroundColor: c.successFg,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.surfaceTint,
                          foregroundColor: c.primaryCoral,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send_rounded,
                              size: 18,
                              color: c.primaryCoral,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              context.t('sale_complete_send_button'),
                              style: textStyles.labelMedium.copyWith(
                                color: c.primaryCoral,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: c.textPrimary,
                              side: BorderSide(color: c.border),
                              minimumSize: const Size(0, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.print_outlined,
                                  size: 11,
                                  color: c.primaryCoral,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  context.t('sale_complete_print_button'),
                                  style: textStyles.labelMedium.copyWith(
                                    color: c.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: c.textPrimary,
                              side: BorderSide(color: c.border),
                              minimumSize: const Size(0, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.share_outlined,
                                  size: 11,
                                  color: c.primaryCoral,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  context.t('sale_complete_share_button'),
                                  style: textStyles.labelMedium.copyWith(
                                    color: c.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Bottom Action Buttons ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => context.goNamed(RouteNames.sellName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primaryCoral,
                      foregroundColor: c.textLight,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 20, color: c.textLight),
                        const SizedBox(width: 8),
                        Text(
                          context.t('sale_complete_start_new'),
                          style: textStyles.labelMedium.copyWith(
                            color: c.textLight,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      final orderProvider = context.read<OrderProvider>();
                      final cartProvider = context.read<CartProvider>();
                      final currentOrder = orderProvider.currentOrder;

                      context.pushNamed(
                        RouteNames.transactionDetailName,
                        extra: {
                          'order': currentOrder,
                          'customer': cartProvider.selectedCustomer,
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: c.surfaceTint,
                      foregroundColor: c.primaryCoral,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.t('sale_complete_view_txn'),
                      style: textStyles.labelMedium.copyWith(
                        color: c.primaryCoral,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textStyles.bodyMedium.copyWith(color: c.textSecondary),
        ),
        Text(
          value,
          style: textStyles.labelMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
