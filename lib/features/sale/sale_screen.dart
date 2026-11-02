// features/sale/sale_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/order_provider.dart';
import 'package:pos_system/providers/customer_provider.dart';
import 'package:pos_system/data/models/order_model.dart';
import 'package:pos_system/data/models/customer_model.dart';
import 'package:pos_system/data/enum/order_status_enum.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilterIndex = 0; // 0: All, 1: Completed, 2: Refunded

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchSalesHistory();
      context.read<CustomerProvider>().fetchCustomers();
    });
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final orderProvider = context.watch<OrderProvider>();
    final customerProvider = context.watch<CustomerProvider>();

    final baseSales = orderProvider.filteredSales;

    final filteredSales = baseSales.where((sale) {
      final customer = customerProvider.customers.firstWhere(
        (c) => c.id == sale.customerId,
        orElse: () => CustomerModel(
          id: '',
          storeId: '',
          firstName: 'Guest',
          lastName: 'Customer',
          email: '',
          marketingOtpIn: false,
          totalVisit: 0,
          lifeTimeSpend: 0,
        ),
      );

      final customerName = '${customer.firstName} ${customer.lastName}'
          .toLowerCase();
      final matchesSearch =
          _searchQuery.isEmpty ||
          sale.orderNumber.toLowerCase().contains(_searchQuery) ||
          customerName.contains(_searchQuery);

      if (!matchesSearch) return false;

      if (_selectedFilterIndex == 1) {
        return sale.status == OrderStatusEnum.completed;
      }
      if (_selectedFilterIndex == 2) {
        return sale.status == OrderStatusEnum.partitallyrefunded ||
            sale.status == OrderStatusEnum.fullyrefunded;
      }

      return true;
    }).toList();

    final double totalSales = filteredSales.fold(
      0.0,
      (sum, o) => sum + (o.totalAmount - o.refundedAmount),
    );
    final int totalTransactions = filteredSales.length;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Skeletonizer(
          enabled: orderProvider.isLoading || customerProvider.isLoading,
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // Top App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sales',
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.download_rounded,
                          color: c.primaryCoral,
                          size: 26,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: _searchController,
                    style: textStyles.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Search order or customer',
                      hintStyle: textStyles.bodyMedium.copyWith(
                        color: c.textMuted,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: c.textMuted,
                      ),
                      suffixIcon: Icon(
                        Icons.document_scanner_outlined,
                        color: c.primaryCoral,
                      ),
                      filled: true,
                      fillColor: c.surfaceLight,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Filter Chips
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    children: [
                      _buildFilterChip(
                        'All sales',
                        _selectedFilterIndex == 0,
                        () => setState(() => _selectedFilterIndex = 0),
                        c,
                        textStyles,
                      ),
                      _buildFilterChip(
                        'Completed',
                        _selectedFilterIndex == 1,
                        () => setState(() => _selectedFilterIndex = 1),
                        c,
                        textStyles,
                      ),
                      _buildFilterChip(
                        'Refunded',
                        _selectedFilterIndex == 2,
                        () => setState(() => _selectedFilterIndex = 2),
                        c,
                        textStyles,
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Date Selector
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: InkWell(
                    onTap: () =>
                        context.pushNamed(RouteNames.saleFilterDateRangeName),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: c.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: c.primaryCoral,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            orderProvider.filterDateRange == 'Custom'
                                ? 'Today · Oct 19, 2026'
                                : orderProvider.filterDateRange,
                            style: textStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: c.textMuted,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Summary Cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Net sales',
                          '\$${totalSales.toStringAsFixed(2)}',
                          c,
                          textStyles,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Transactions',
                          '$totalTransactions',
                          c,
                          textStyles,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'TODAY · $totalTransactions TRANSACTIONS',
                    style: textStyles.labelSmall.copyWith(
                      color: c.textSecondary,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              // Sales List
              if (filteredSales.isEmpty && !orderProvider.isLoading)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: Text(
                        'No transactions found.',
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
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final sale = filteredSales[index];
                      return _buildSaleItem(
                        sale,
                        customerProvider,
                        c,
                        textStyles,
                      );
                    }, childCount: filteredSales.length),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isActive,
    VoidCallback onTap,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? c.primaryCoral : c.surfaceLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: textStyles.labelSmall.copyWith(
                color: isActive ? c.textLight : c.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // 👇 theme-aware
        color: c.surfaceTint,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyles.bodyMedium.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: textStyles.heading1.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleItem(
    OrderModel sale,
    CustomerProvider customerProvider,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    final customer = customerProvider.customers.firstWhere(
      (c) => c.id == sale.customerId,
      orElse: () => CustomerModel(
        id: '',
        storeId: '',
        firstName: 'Guest',
        lastName: 'Customer',
        email: '',
        marketingOtpIn: false,
        totalVisit: 0,
        lifeTimeSpend: 0,
      ),
    );
    final customerName = customer.id.isEmpty
        ? 'Guest customer'
        : '${customer.firstName} ${customer.lastName}';

    final isFullyRefunded = sale.status == OrderStatusEnum.fullyrefunded;
    final isPartiallyRefunded =
        sale.status == OrderStatusEnum.partitallyrefunded;
    final isRefunded = isFullyRefunded || isPartiallyRefunded;

    // 👇 Theme-aware status colors
    Color statusColor;
    Color textColor;
    String statusLabel;

    if (isFullyRefunded) {
      statusColor = c.dangerBg;
      textColor = c.dangerFg;
      statusLabel = 'Fully refunded';
    } else if (isPartiallyRefunded) {
      statusColor = c.warningBg;
      textColor = c.warningFg;
      statusLabel = 'Partially refunded';
    } else {
      statusColor = c.successBg;
      textColor = c.successFg;
      statusLabel = 'Completed';
    }

    final time =
        '${sale.createdAt.hour}:${sale.createdAt.minute.toString().padLeft(2, '0')}';

    final netAmount = sale.totalAmount - sale.refundedAmount;

    return InkWell(
      onTap: () => context.pushNamed(
        RouteNames.transactionDetailName,
        extra: {'order': sale, 'customer': customer},
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: c.border.withValues(alpha: 0.5)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sale.orderNumber,
                  style: textStyles.labelMedium.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${netAmount.toStringAsFixed(2)}',
                      style: textStyles.labelMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isFullyRefunded
                            ? c.textMuted
                            : isPartiallyRefunded
                            ? c.primaryCoral
                            : c.textPrimary,
                        decoration: isFullyRefunded
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (isRefunded)
                      Text(
                        'Was \$${sale.totalAmount.toStringAsFixed(2)}',
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: textStyles.bodySmall.copyWith(
                        color: c.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$time · Payment via card',
                      style: textStyles.bodySmall.copyWith(
                        color: c.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusLabel,
                    style: textStyles.labelSmall.copyWith(
                      color: textColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
