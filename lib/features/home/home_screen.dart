// features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/enum/order_status_enum.dart';
import 'package:pos_system/providers/customer_provider.dart';
import 'package:pos_system/providers/inventory_provider.dart';
import 'package:pos_system/providers/order_provider.dart';
import 'package:pos_system/providers/register_provider.dart';
import 'package:pos_system/providers/store_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    final registerProvider = context.read<RegisterProvider>();
    final inventoryProvider = context.read<InventoryProvider>();
    final customerProvider = context.read<CustomerProvider>();
    final orderProvider = context.read<OrderProvider>();
    final storeProvider = context.read<StoreProvider>();

    await Future.wait([
      registerProvider.fetchRegisters(),
      inventoryProvider.fetchLowStockAlerts(),
      inventoryProvider.fetchFullInventory(),
      customerProvider.fetchCustomers(),
      orderProvider.fetchSalesHistory(),
      storeProvider.fetchStore(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    final registerProvider = context.watch<RegisterProvider>();
    final inventoryProvider = context.watch<InventoryProvider>();
    final customerProvider = context.watch<CustomerProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final storeProvider = context.watch<StoreProvider>();

    final isLoading =
        registerProvider.isLoading ||
        inventoryProvider.isLoading ||
        customerProvider.isLoading ||
        orderProvider.isLoading ||
        storeProvider.isLoading;

    final bool isRegisterOpen = registerProvider.isRegisterOpen;
    final session = registerProvider.activeSession;

    // Net Sales = Total - Refunded
    final double todaySales = orderProvider.salesHistory
        .where(
          (o) =>
              o.status == OrderStatusEnum.completed ||
              o.status == OrderStatusEnum.partitallyrefunded ||
              o.status == OrderStatusEnum.fullyrefunded,
        )
        .fold(0.0, (sum, o) {
          final net = o.totalAmount - o.refundedAmount;
          return sum + (net < 0 ? 0.0 : net);
        });

    final int totalTransactions = orderProvider.salesHistory.length;
    final double avgSale = totalTransactions > 0
        ? todaySales / totalTransactions
        : 0.0;

    final int itemsSold = orderProvider.totalItemsSold;
    final int lowStockCount = inventoryProvider.lowStockAlerts.length;
    final int customerCount = customerProvider.customers.length;

    final storeName = storeProvider.store?.name ?? context.t('home_loading');

    // Theme-aware colors, resolve once per build
    final surfaceTint = c.surfaceTint;
    final successBg = c.successBg;
    final warningBg = c.warningBg;
    final successFg = c.successFg;
    final warningFg = c.warningFg;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          color: c.primaryCoral,
          child: Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            storeName,
                            style: textStyles.heading2.copyWith(fontSize: 22),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.t('home_date_placeholder'),
                            style: textStyles.labelSmall.copyWith(
                              color: c.textMuted,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          context.pushNamed(RouteNames.notificationName);
                        },
                        icon: Icon(
                          Icons.notifications_none_rounded,
                          color: c.primaryCoral,
                          size: 28,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Greeting
                  Text(
                    context.t('home_greeting'),
                    style: textStyles.heading1.copyWith(
                      fontSize: 28,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Status Badges
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isRegisterOpen ? successBg : warningBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isRegisterOpen
                              ? context.t('home_register_open')
                              : context.t('home_register_closed'),
                          style: textStyles.labelSmall.copyWith(
                            color: isRegisterOpen ? successFg : warningFg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        session != null
                            ? context.t('home_register_since')
                            : context.t('home_no_active_session'),
                        style: textStyles.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sales Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: surfaceTint,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.t('home_todays_net_sales'),
                              style: textStyles.bodyMedium.copyWith(
                                color: c.textSecondary,
                              ),
                            ),
                            Icon(
                              Icons.trending_up_rounded,
                              color: c.primaryCoral,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${todaySales.toStringAsFixed(2)}',
                          style: textStyles.displayLarge.copyWith(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: successBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_upward,
                                    size: 12,
                                    color: successFg,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    context.t('home_trend_up'),
                                    style: textStyles.labelSmall.copyWith(
                                      color: successFg,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              context.t('home_vs_last_monday'),
                              style: textStyles.bodySmall.copyWith(
                                color: c.textMuted,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatItem(
                              '$totalTransactions',
                              context.t('home_stat_transactions'),
                              textStyles,
                              c,
                            ),
                            _buildStatItem(
                              '\$${avgSale.toStringAsFixed(2)}',
                              context.t('home_stat_avg_sale'),
                              textStyles,
                              c,
                            ),
                            _buildStatItem(
                              '$itemsSold',
                              context.t('home_stat_items_sold'),
                              textStyles,
                              c,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Start New Sale Button
                  ElevatedButton(
                    onPressed: () {
                      if (!registerProvider.isRegisterOpen) {
                        context.pushNamed(RouteNames.storeRegisterName);
                        return;
                      }
                      context.pushNamed(RouteNames.sellName);
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
                        Icon(Icons.add, size: 20, color: c.textLight),
                        const SizedBox(width: 8),
                        Text(
                          context.t('home_start_new_sale'),
                          style: textStyles.labelMedium.copyWith(
                            color: c.textLight,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Glance Section
                  Text(
                    context.t('home_glance_title'),
                    style: textStyles.heading2.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 16),

                  _buildGlanceItem(
                    icon: Icons.inventory_2_outlined,
                    title: context.tp('home_glance_low_stock', {
                      'count': '$lowStockCount',
                    }),
                    subtitle: context.t('home_glance_low_stock_sub'),
                    c: c,
                    textStyles: textStyles,
                    onTap: () => context.pushNamed(RouteNames.lowStockName),
                  ),
                  _buildGlanceItem(
                    icon: Icons.people_outline_rounded,
                    title: context.t('home_glance_customers'),
                    subtitle: context.tp('home_glance_customers_sub', {
                      'count': '$customerCount',
                    }),
                    c: c,
                    textStyles: textStyles,
                    onTap: () =>
                        context.pushNamed(RouteNames.customerDirectoryName),
                  ),
                  _buildGlanceItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: context.t('home_glance_cash_drawer'),
                    subtitle: session != null
                        ? context.tp('home_glance_cash_drawer_open', {
                            'amount':
                                '\$${session.openingFloat.toStringAsFixed(2)}',
                          })
                        : context.t('home_glance_cash_drawer_closed'),
                    c: c,
                    textStyles: textStyles,
                    showDivider: false,
                    onTap: () => context.pushNamed(RouteNames.openRegisterName),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    AppTextStylesX textStyles,
    AppThemeColors c,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: textStyles.labelMedium.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: textStyles.bodySmall.copyWith(
            color: c.textMuted,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildGlanceItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 4.0,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: c.surfaceTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: c.primaryCoral, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle, style: textStyles.bodySmall),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: c.textMuted, size: 24),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(color: c.border.withValues(alpha: 0.5), height: 1),
      ],
    );
  }
}
