import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/models/order_model.dart';

class RefundCompleteScreen extends StatefulWidget {
  const RefundCompleteScreen({super.key});

  @override
  State<RefundCompleteScreen> createState() => _RefundCompleteScreenState();
}

class _RefundCompleteScreenState extends State<RefundCompleteScreen> {
  OrderModel? _order;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Read the order passed in
    if (_order == null) {
      final extra = GoRouterState.of(context).extra;
      if (extra is OrderModel) {
        _order = extra;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    // Fallback if no order was passed
    if (_order == null) {
      return Scaffold(
        body: Center(child: Text(context.t('refund_complete_no_order'))),
      );
    }

    final order = _order!;
    final refundedAmount = order.refundedAmount;
    final netSale = order.totalAmount - refundedAmount;

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
                    context.t('refund_complete_title'),
                    style: textStyles.heading2.copyWith(fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () => context.goNamed('sales'),
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
                    const SizedBox(height: 20),

                    Text(
                      context.t('refund_complete_cash_refunded'),
                      style: textStyles.bodyMedium.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      '\$${refundedAmount.toStringAsFixed(2)}',
                      style: textStyles.heading1.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: c.warningBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        context.t('refund_complete_partially_refunded'),
                        style: textStyles.labelSmall.copyWith(
                          color: c.warningFg,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: c.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            context.t('refund_complete_original_order'),
                            order.orderNumber,
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            context.t('refund_complete_reference'),
                            '#RF-${order.id.substring(order.id.length - 4)}',
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            context.t('refund_complete_method'),
                            context.t('refund_complete_method_cash'),
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            context.t('refund_complete_datetime'),
                            context.tp('refund_complete_datetime_value', {
                              'date':
                                  '${order.createdAt.month}/${order.createdAt.day}',
                              'time':
                                  '${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}',
                            }),
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            color: c.border.withValues(alpha: 0.5),
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            context.t('refund_complete_original_total'),
                            '\$${order.totalAmount.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            context.t('refund_complete_amount_refunded'),
                            '-\$${refundedAmount.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            color: c.border.withValues(alpha: 0.5),
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.t('refund_complete_net_sale'),
                                style: textStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '\$${netSale.toStringAsFixed(2)}',
                                style: textStyles.heading2.copyWith(
                                  color: c.primaryCoral,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                    onPressed: () {},
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
                        Icon(Icons.send_rounded, size: 20, color: c.textLight),
                        const SizedBox(width: 8),
                        Text(
                          context.t('refund_complete_send_receipt'),
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
                    onPressed: () => context.goNamed('sales'),
                    style: TextButton.styleFrom(
                      backgroundColor: c.surfaceTint,
                      foregroundColor: c.primaryCoral,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.t('refund_complete_back_sales'),
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

  Widget _buildDetailRow(
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
