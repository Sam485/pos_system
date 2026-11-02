// features/sell/cart/check_out_flow/card_payment_decline_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/shared/helper/safe_pop.dart';

class CardPaymentDeclineScreen extends StatefulWidget {
  const CardPaymentDeclineScreen({super.key});

  @override
  State<CardPaymentDeclineScreen> createState() =>
      _CardPaymentDeclineScreenState();
}

class _CardPaymentDeclineScreenState extends State<CardPaymentDeclineScreen> {
  String _orderId = '#1048';
  double _amount = 130.68;
  String _customerName = 'Emma Miller';
  String _cardInfo = 'Visa •••• 4242';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic>) {
      _orderId = extra['orderId'] as String? ?? _orderId;
      _amount = (extra['amount'] as num?)?.toDouble() ?? _amount;
      _customerName = extra['customerName'] as String? ?? _customerName;
      _cardInfo = extra['cardInfo'] as String? ?? _cardInfo;
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
                children: [
                  IconButton(
                    onPressed: () => context.safePop(),
                    icon: Icon(Icons.arrow_back, color: c.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t('card_decline_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.tp('card_decline_subtitle', {
                          'orderId': _orderId,
                        }),
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
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
                    const SizedBox(height: 32),

                    // Icon (Red card)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: c.dangerBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.credit_card_outlined,
                        color: c.dangerFg,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Headings
                    Text(
                      context.t('card_decline_heading'),
                      style: textStyles.heading1.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.tp('card_decline_description', {
                        'customerName': _customerName,
                      }),
                      textAlign: TextAlign.center,
                      style: textStyles.bodyMedium.copyWith(
                        color: c.textSecondary,
                        height: 1.4,
                      ),
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
                                context.t('card_decline_still_to_pay'),
                                style: textStyles.labelMedium.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '\$${_amount.toStringAsFixed(2)}',
                                style: textStyles.heading1.copyWith(
                                  color: c.primaryCoral,
                                  fontSize: 24,
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

                          _buildSummaryRow(
                            context.t('card_decline_card_attempted'),
                            _cardInfo,
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            context.t('card_decline_customer'),
                            _customerName,
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            context.t('card_decline_status'),
                            context.t('card_decline_status_unpaid'),
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            context.t('card_decline_reader'),
                            context.t('card_decline_reader_default'),
                            c,
                            textStyles,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Warning Banner ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: c.warningBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: c.warningFg,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.t('card_decline_warning'),
                              style: textStyles.bodySmall.copyWith(
                                color: c.warningFg,
                                height: 1.4,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Footer Note ──
                    Text(
                      context.tp('card_decline_footer', {'orderId': _orderId}),
                      style: textStyles.bodySmall.copyWith(
                        color: c.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 20),
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
                    onPressed: () {
                      context.pop();
                    },
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
                        Icon(
                          Icons.refresh_rounded,
                          size: 20,
                          color: c.textLight,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.t('card_decline_retry_button'),
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
                      context.goNamed(RouteNames.checkoutName);
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
                      context.t('card_decline_choose_other_button'),
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
