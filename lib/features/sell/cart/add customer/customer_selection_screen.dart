import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/customer_provider.dart';
import 'package:pos_system/providers/cart_provider.dart';
import 'package:pos_system/data/models/customer_model.dart';

class CustomerSelectionScreen extends StatefulWidget {
  const CustomerSelectionScreen({super.key});

  @override
  State<CustomerSelectionScreen> createState() =>
      _CustomerSelectionScreenState();
}

class _CustomerSelectionScreenState extends State<CustomerSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  CustomerModel? _selectedCustomer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().fetchCustomers();
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
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
    final customerProvider = context.watch<CustomerProvider>();
    final cartProvider = context.read<CartProvider>();

    // Filter customers based on search
    final filteredCustomers = customerProvider.customers.where((customer) {
      if (_searchQuery.isEmpty) return true;
      return '${customer.firstName} ${customer.lastName}'
              .toLowerCase()
              .contains(_searchQuery) ||
          customer.email.toLowerCase().contains(_searchQuery);
    }).toList();

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
                  Text(
                    context.t('customer_select_title'),
                    style: textStyles.heading2.copyWith(fontSize: 24),
                  ),
                ],
              ),
            ),

            // ── Main Scrollable Content ──
            Expanded(
              child: Skeletonizer(
                enabled: customerProvider.isLoading,
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    // 1. Search Input
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        child: TextFormField(
                          controller: _searchController,
                          style: textStyles.bodyLarge,
                          decoration: InputDecoration(
                            hintText: context.t('customer_search_hint'),
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
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),

                    // 2. Results Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.tp('customer_matching_count', {
                                'count': '${filteredCustomers.length}',
                              }),
                              style: textStyles.bodySmall.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.pushNamed(RouteNames.addCustomerName);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                context.t('customer_new_button'),
                                style: textStyles.labelSmall.copyWith(
                                  color: c.primaryCoral,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),

                    // 3. Customer List
                    if (filteredCustomers.isEmpty &&
                        !customerProvider.isLoading)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Center(
                            child: Text(
                              context.t('customer_no_results'),
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
                            final customer = filteredCustomers[index];
                            return _buildCustomerListItem(
                              customer,
                              c,
                              textStyles,
                            );
                          }, childCount: filteredCustomers.length),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // 4. Insight Card (shown if a customer is selected)
                    if (_selectedCustomer != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: c.surfaceLight,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.t('customer_insight_title'),
                                  style: textStyles.labelSmall.copyWith(
                                    color: c.primaryCoral,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _selectedCustomer!.totalVisit > 1
                                      ? context.t('customer_insight_familiar')
                                      : context.t('customer_insight_welcome'),
                                  style: textStyles.heading2.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  context.tp('customer_insight_spent', {
                                    'name': _selectedCustomer!.firstName,
                                    'amount': _selectedCustomer!.lifeTimeSpend
                                        .toStringAsFixed(2),
                                  }),
                                  style: textStyles.bodySmall.copyWith(
                                    color: c.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
                    onPressed: _selectedCustomer == null
                        ? null
                        : () {
                            cartProvider.selectCustomer(_selectedCustomer);
                            context.pop();
                          },
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
                    child: Text(
                      _selectedCustomer != null
                          ? context.tp('customer_use_button', {
                              'name':
                                  '${_selectedCustomer!.firstName} ${_selectedCustomer!.lastName}',
                            })
                          : context.t('customer_select_prompt'),
                      style: textStyles.labelMedium.copyWith(
                        color: c.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      cartProvider.selectCustomer(null);
                      context.pop();
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
                      context.t('customer_continue_guest'),
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

  // ── Helper Widgets ──

  Widget _buildCustomerListItem(
    CustomerModel customer,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    final isSelected = _selectedCustomer?.id == customer.id;
    final initials =
        '${customer.firstName.isNotEmpty ? customer.firstName[0] : ''}${customer.lastName.isNotEmpty ? customer.lastName[0] : ''}'
            .toUpperCase();

    return GestureDetector(
      onTap: () => setState(() => _selectedCustomer = customer),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? c.surfaceTint : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (c.isDark
                      ? Colors.white.withValues(alpha: 0.10)
                      : const Color(0xFFE8F0FE))
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.isDark
                    ? Colors.white.withValues(alpha: 0.10)
                    : const Color(0xFFE8F0FE),
                shape: BoxShape.circle,
              ),
              child: Text(
                initials,
                style: textStyles.labelSmall.copyWith(
                  color: c.primaryCoral,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${customer.firstName} ${customer.lastName}',
                    style: textStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    customer.email,
                    style: textStyles.bodySmall.copyWith(
                      color: c.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.tp('customer_visits_lifetime', {
                      'visits': '${customer.totalVisit}',
                      'amount': customer.lifeTimeSpend.toStringAsFixed(2),
                    }),
                    style: textStyles.bodySmall.copyWith(
                      color: c.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Trailing Icon
            if (isSelected)
              Icon(
                Icons.radio_button_checked_rounded,
                color: c.primaryCoral,
                size: 20,
              )
            else
              Icon(Icons.chevron_right_rounded, color: c.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
