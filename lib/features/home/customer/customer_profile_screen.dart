import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/models/customer_model.dart';
import 'package:pos_system/data/models/order_model.dart';
import 'package:pos_system/providers/order_provider.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  CustomerModel? _customer;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra;
      if (extra is CustomerModel) {
        _customer = extra;

        // Fetch this customer's specific history
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<OrderProvider>().fetchSalesHistory();
        });
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final orderProvider = context.watch<OrderProvider>();

    // Filter order history for this specific customer
    final customerOrders = orderProvider.salesHistory
        .where((o) => o.customerId == _customer?.id)
        .toList();

    final fullName = _customer != null
        ? '${_customer!.firstName} ${_customer!.lastName}'
        : context.t('profile_guest_name');

    final initials = _customer != null
        ? '${_customer!.firstName.isNotEmpty ? _customer!.firstName[0] : ''}${_customer!.lastName.isNotEmpty ? _customer!.lastName[0] : ''}'
              .toUpperCase()
        : 'GC';

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
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.arrow_back, color: c.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t('profile_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        fullName,
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
              child: Skeletonizer(
                enabled: orderProvider.isLoading,
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    // 1. Profile Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: Row(
                          children: [
                            // Avatar — ✅ theme-aware
                            Container(
                              width: 64,
                              height: 64,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: c.isDark
                                    ? Colors.white.withValues(alpha: 0.10)
                                    : const Color(0xFFE8F0FE),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                initials,
                                style: textStyles.heading2.copyWith(
                                  color: c.primaryCoral,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fullName,
                                    style: textStyles.heading2.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _customer?.email ??
                                        context.t('profile_no_email'),
                                    style: textStyles.bodySmall.copyWith(
                                      color: c.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _customer?.phone ??
                                        context.t('profile_no_phone'),
                                    style: textStyles.bodySmall.copyWith(
                                      color: c.textMuted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                    // 2. Summary Cards — ✅ theme-aware bg
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: c.surfaceTint,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              // Visits
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_customer?.totalVisit ?? 0}',
                                      style: textStyles.heading1.copyWith(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      context.t('profile_stat_visits'),
                                      style: textStyles.bodySmall.copyWith(
                                        color: c.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Divider
                              Container(
                                width: 1,
                                height: 40,
                                color: c.border.withValues(alpha: 0.5),
                              ),
                              const SizedBox(width: 20),
                              // Lifetime Spend
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${(_customer?.lifeTimeSpend ?? 0).toStringAsFixed(2)}',
                                      style: textStyles.heading1.copyWith(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      context.t('profile_stat_lifetime'),
                                      style: textStyles.bodySmall.copyWith(
                                        color: c.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                    // 3. Info Note
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          context.t('profile_info_note'),
                          style: textStyles.bodySmall.copyWith(
                            color: c.textMuted,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                    // 4. Purchase History Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          context.tp('profile_history_header', {
                            'shown': '${customerOrders.length}',
                            'total': '${_customer?.totalVisit ?? 0}',
                          }),
                          style: textStyles.labelSmall.copyWith(
                            color: c.textSecondary,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),

                    // 5. Purchase History List
                    if (customerOrders.isEmpty && !orderProvider.isLoading)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Center(
                            child: Text(
                              context.t('profile_history_empty'),
                              style: textStyles.bodyMedium.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final order = customerOrders[index];
                            return _buildHistoryItem(order, c, textStyles);
                          }, childCount: customerOrders.length),
                        ),
                      ),

                    // Bottom padding for the button
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            ),

            // ── Bottom Action Button — ✅ theme-aware bg
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Edit Customer, passing the customer data
                  context.pushNamed(
                    RouteNames.editCustomerName,
                    extra: _customer,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.surfaceTint,
                  foregroundColor: c.primaryCoral,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_outlined, size: 20, color: c.primaryCoral),
                    const SizedBox(width: 8),
                    Text(
                      context.t('profile_edit_button'),
                      style: textStyles.labelMedium.copyWith(
                        color: c.primaryCoral,
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

  // ── Helper Widgets ──

  Widget _buildHistoryItem(
    OrderModel order,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    // Determine if refunded based on status
    final isRefunded =
        order.status.name == 'partiallyRefunded' ||
        order.status.name == 'refunded';

    // Format date
    final date =
        '${order.createdAt.month}/${order.createdAt.day}/${order.createdAt.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ✅ FIXED: was 0xFFF8F9FA
        color: isRefunded ? c.surfaceLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isRefunded
            ? null
            : Border(
                bottom: BorderSide(color: c.border.withValues(alpha: 0.5)),
              ),
      ),
      child: Column(
        children: [
          // Top Row: ID, Date, Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    order.orderNumber,
                    style: textStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '· $date',
                    style: textStyles.bodySmall.copyWith(
                      color: c.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                '\$${order.totalAmount.toStringAsFixed(2)}',
                style: textStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Bottom Row: Method, Refund info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Box (only for non-refunded items based on UI)
              if (!isRefunded) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // ✅ FIXED: was 0xFFF4F8FF
                    color: c.surfaceTint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: c.primaryCoral,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Text Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isRefunded)
                      Text(
                        context.t('profile_payment_via_card'),
                        style: textStyles.bodySmall.copyWith(
                          color: c.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    if (isRefunded) const SizedBox(height: 8),
                    if (isRefunded)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          // ✅ FIXED: was 0xFFFFF4E5
                          color: c.warningBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          context.t('profile_status_partially_refunded'),
                          style: textStyles.labelSmall.copyWith(
                            // ✅ FIXED: was 0xFFD97706
                            color: c.warningFg,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    if (!isRefunded)
                      Text(
                        context.tp('profile_status_short', {
                          'status': order.status.name,
                          'time':
                              '${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}',
                        }),
                        style: textStyles.bodySmall.copyWith(
                          color: c.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
