// features/sale/function/sale_filter_date_range_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/order_provider.dart';

class SaleFilterDateRangeScreen extends StatefulWidget {
  const SaleFilterDateRangeScreen({super.key});

  @override
  State<SaleFilterDateRangeScreen> createState() =>
      _SaleFilterDateRangeScreenState();
}

class _SaleFilterDateRangeScreenState extends State<SaleFilterDateRangeScreen> {
  // UI state — these stay English; they're the source of truth for the provider.
  String _selectedDateRange = 'Custom';
  final List<String> _dateRanges = [
    'Today',
    'Yesterday',
    'This week',
    'Custom',
  ];

  String _selectedStatus = 'All sales';
  final List<String> _statuses = ['All sales', 'Completed', 'Refunded'];

  String _selectedPaymentMethod = 'All methods';
  final List<String> _paymentMethods = ['All methods', 'Cash', 'Card'];

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  DateTime? _fromDate;
  DateTime? _toDate;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final provider = context.read<OrderProvider>();
      _selectedDateRange = provider.filterDateRange;
      _selectedStatus = provider.filterStatus;
      _selectedPaymentMethod = provider.filterPaymentMethod;
      _fromDate = provider.filterFromDate;
      _toDate = provider.filterToDate;

      if (_fromDate != null) {
        _fromDateController.text = _formatDate(_fromDate!);
      }
      if (_toDate != null) {
        _toDateController.text = _formatDate(_toDate!);
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final monthKeys = [
      'sale_filter_month_jan',
      'sale_filter_month_feb',
      'sale_filter_month_mar',
      'sale_filter_month_apr',
      'sale_filter_month_may',
      'sale_filter_month_jun',
      'sale_filter_month_jul',
      'sale_filter_month_aug',
      'sale_filter_month_sep',
      'sale_filter_month_oct',
      'sale_filter_month_nov',
      'sale_filter_month_dec',
    ];
    return context.tp('sale_filter_date_format', {
      'month': context.t(monthKeys[date.month - 1]),
      'day': '${date.day}',
      'year': '${date.year}',
    });
  }

  int _getMatchingCount(OrderProvider provider) {
    return provider.salesHistory.where((order) {
      // Status — comparison against English state values
      if (_selectedStatus == 'Completed' && order.status.name != 'completed') {
        return false;
      }
      if (_selectedStatus == 'Refunded' &&
          order.status.name != 'partiallyRefunded') {
        return false;
      }

      // Date
      if (_fromDate != null && order.createdAt.isBefore(_fromDate!)) {
        return false;
      }
      if (_toDate != null &&
          order.createdAt.isAfter(_toDate!.add(const Duration(days: 1)))) {
        return false;
      }

      return true;
    }).length;
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (_fromDate ?? DateTime.now())
          : (_toDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          _fromDateController.text = _formatDate(picked);
        } else {
          _toDate = picked;
          _toDateController.text = _formatDate(picked);
        }
      });
    }
  }

  void _applyFilters() {
    context.read<OrderProvider>().applyFilters(
      dateRange: _selectedDateRange,
      fromDate: _fromDate,
      toDate: _toDate,
      status: _selectedStatus,
      paymentMethod: _selectedPaymentMethod,
    );
    context.pop();
  }

  // ── Display-label helpers ──
  // The state values must stay English (they're passed to the provider and
  // compared against DB values). These helpers translate the *display* only.

  String _localizedRange(String englishValue) {
    switch (englishValue) {
      case 'Today':
        return context.t('sale_filter_range_today');
      case 'Yesterday':
        return context.t('sale_filter_range_yesterday');
      case 'This week':
        return context.t('sale_filter_range_week');
      case 'Custom':
        return context.t('sale_filter_range_custom');
      default:
        return englishValue;
    }
  }

  String _localizedStatus(String englishValue) {
    switch (englishValue) {
      case 'All sales':
        return context.t('sale_filter_status_all');
      case 'Completed':
        return context.t('sale_filter_status_completed');
      case 'Refunded':
        return context.t('sale_filter_status_refunded');
      default:
        return englishValue;
    }
  }

  String _localizedMethod(String englishValue) {
    switch (englishValue) {
      case 'All methods':
        return context.t('sale_filter_method_all');
      case 'Cash':
        return context.t('sale_filter_method_cash');
      case 'Card':
        return context.t('sale_filter_method_card');
      default:
        return englishValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final provider = context.watch<OrderProvider>();

    final matchingCount = _getMatchingCount(provider);

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
                        context.t('sale_filter_title'),
                        style: textStyles.heading2.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.t('sale_filter_store_default'),
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Main Content ──
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Date Range
                    _buildSectionTitle(
                      context.t('sale_filter_date_range_title'),
                      textStyles,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _dateRanges.map((label) {
                        return _buildChip(
                          _localizedRange(label),
                          label == _selectedDateRange,
                          () => setState(() => _selectedDateRange = label),
                          c,
                          textStyles,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // From / To
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateInput(
                            label: context.t('sale_filter_from_label'),
                            controller: _fromDateController,
                            onTap: () => _pickDate(isFrom: true),
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDateInput(
                            label: context.t('sale_filter_to_label'),
                            controller: _toDateController,
                            onTap: () => _pickDate(isFrom: false),
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.t('sale_filter_date_note'),
                      style: textStyles.bodySmall.copyWith(
                        color: c.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Status
                    _buildSectionTitle(
                      context.t('sale_filter_status_title'),
                      textStyles,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _statuses.map((label) {
                        return _buildChip(
                          _localizedStatus(label),
                          label == _selectedStatus,
                          () => setState(() => _selectedStatus = label),
                          c,
                          textStyles,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.t('sale_filter_status_note'),
                      style: textStyles.bodySmall.copyWith(
                        color: c.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Payment Method
                    _buildSectionTitle(
                      context.t('sale_filter_method_title'),
                      textStyles,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _paymentMethods.map((label) {
                        return _buildChip(
                          _localizedMethod(label),
                          label == _selectedPaymentMethod,
                          () => setState(() => _selectedPaymentMethod = label),
                          c,
                          textStyles,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Staff
                    Text(
                      context.t('sale_filter_staff_label'),
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: c.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            color: c.textMuted,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            context.t('sale_filter_staff_all'),
                            style: textStyles.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: c.surfaceTint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: c.primaryCoral,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.t('sale_filter_info_banner'),
                              style: textStyles.bodySmall.copyWith(
                                color: c.textSecondary,
                                height: 1.4,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── Bottom Buttons ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primaryCoral,
                      foregroundColor: c.textLight,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      context.tp('sale_filter_show_button', {
                        'count': '$matchingCount',
                      }),
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
                      setState(() {
                        _selectedDateRange = 'Custom';
                        _selectedStatus = 'All sales';
                        _selectedPaymentMethod = 'All methods';
                        _fromDate = null;
                        _toDate = null;
                        _fromDateController.clear();
                        _toDateController.clear();
                      });
                      context.read<OrderProvider>().clearFilters();
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
                      context.t('sale_filter_reset_button'),
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

  Widget _buildSectionTitle(String title, AppTextStylesX textStyles) {
    return Text(
      title,
      style: textStyles.heading2.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? c.primaryCoral : c.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: textStyles.labelSmall.copyWith(
            color: isSelected ? c.textLight : c.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDateInput({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          style: textStyles.bodyLarge,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.calendar_today_outlined,
              color: c.textMuted,
              size: 20,
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
              borderSide: BorderSide(color: c.primaryCoral, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
