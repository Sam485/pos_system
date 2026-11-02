import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/customer_provider.dart';
import 'package:pos_system/data/models/customer_model.dart';

class CustomerDirectoryScreen extends StatefulWidget {
  const CustomerDirectoryScreen({super.key});

  @override
  State<CustomerDirectoryScreen> createState() =>
      _CustomerDirectoryScreenState();
}

class _CustomerDirectoryScreenState extends State<CustomerDirectoryScreen> {
  // Search and filter state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilterIndex = 0; // 0 = All, 1 = Recently added, 2 = Returning

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

    // Filter the customer list
    final filteredCustomers = customerProvider.customers.where((customer) {
      // 1. Apply Search Filter
      final matchesSearch =
          _searchQuery.isEmpty ||
          '${customer.firstName} ${customer.lastName}'.toLowerCase().contains(
            _searchQuery,
          ) ||
          customer.email.toLowerCase().contains(_searchQuery) ||
          (customer.phone?.contains(_searchQuery) ?? false);

      if (!matchesSearch) return false;

      // 2. Apply Tab Filter
      if (_selectedFilterIndex == 1) {
        // "Recently added" - e.g., first 10 customers or created this week
        // Mocking this with a simple index check for now
        final index = customerProvider.customers.indexOf(customer);
        return index < 10;
      }
      if (_selectedFilterIndex == 2) {
        // "Returning" - customers with more than 1 visit
        return customer.totalVisit > 1;
      }

      return true; // All customers
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t('customers_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.tp('customers_subtitle', {
                          'count': '${customerProvider.customers.length}',
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
              child: Skeletonizer(
                enabled: customerProvider.isLoading,
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    // Search Input
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              context.t('customers_search_label'),
                              style: textStyles.labelSmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: c.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: context.t('customers_search_hint'),
                                hintStyle: textStyles.bodyMedium.copyWith(
                                  color: c.textMuted,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: c.textMuted,
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
                          ],
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
                              context.t('customers_filter_all'),
                              isActive: _selectedFilterIndex == 0,
                              onTap: () =>
                                  setState(() => _selectedFilterIndex = 0),
                              c: c,
                              textStyles: textStyles,
                            ),
                            _buildFilterChip(
                              context.t('customers_filter_recent'),
                              isActive: _selectedFilterIndex == 1,
                              onTap: () =>
                                  setState(() => _selectedFilterIndex = 1),
                              c: c,
                              textStyles: textStyles,
                            ),
                            _buildFilterChip(
                              context.t('customers_filter_returning'),
                              isActive: _selectedFilterIndex == 2,
                              onTap: () =>
                                  setState(() => _selectedFilterIndex = 2),
                              c: c,
                              textStyles: textStyles,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // Customer List
                    if (filteredCustomers.isEmpty &&
                        !customerProvider.isLoading)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Center(
                            child: Text(
                              context.t('customers_empty'),
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
                            return _buildCustomerItem(customer, c, textStyles);
                          }, childCount: filteredCustomers.length),
                        ),
                      ),

                    // Bottom padding for the button
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            ),

            // ── Bottom Action Button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed(RouteNames.addCustomerName);
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
                      Icons.person_add_alt_1_outlined,
                      size: 20,
                      color: c.textLight,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.t('customers_add_button'),
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

  // ── Helper Widgets ──

  Widget _buildFilterChip(
    String label, {
    required bool isActive,
    required VoidCallback onTap,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
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

  Widget _buildCustomerItem(
    CustomerModel customer,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    // Generate initials
    final initials =
        '${customer.firstName.isNotEmpty ? customer.firstName[0] : ''}${customer.lastName.isNotEmpty ? customer.lastName[0] : ''}'
            .toUpperCase();

    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteNames.customerProfileName,
          extra: customer, // Pass the customer to the profile screen
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: c.border.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          children: [
            // Avatar — ✅ theme-aware now
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.isDark
                    ? Colors.white.withValues(alpha: 0.10)
                    : const Color(0xFFE8F0FE),
                shape: BoxShape.circle,
              ),
              child: Text(
                initials,
                style: textStyles.labelMedium.copyWith(
                  color: c.primaryCoral,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
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
                    '${customer.firstName} ${customer.lastName}',
                    style: textStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    customer.email,
                    style: textStyles.bodySmall.copyWith(
                      color: c.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.tp('customers_visits_lifetime', {
                      'visits': '${customer.totalVisit}',
                      'amount': customer.lifeTimeSpend.toStringAsFixed(2),
                    }),
                    style: textStyles.bodySmall.copyWith(
                      color: c.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(Icons.chevron_right_rounded, color: c.textMuted, size: 24),
          ],
        ),
      ),
    );
  }
}
