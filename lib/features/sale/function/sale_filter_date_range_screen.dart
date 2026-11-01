// features/sale/function/sale_filter_date_range_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  // UI state
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
      // Load current filters from provider
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
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  int _getMatchingCount(OrderProvider provider) {
    return provider.salesHistory.where((order) {
      // Status
      if (_selectedStatus == 'Completed' && order.status.name != 'completed')
        return false;
      if (_selectedStatus == 'Refunded' &&
          order.status.name != 'partiallyRefunded')
        return false;

      // Date
      if (_fromDate != null && order.createdAt.isBefore(_fromDate!))
        return false;
      if (_toDate != null &&
          order.createdAt.isAfter(_toDate!.add(const Duration(days: 1))))
        return false;

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
                        'Filter sales',
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'SoHo store',
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
                    _buildSectionTitle('Date range', textStyles),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _dateRanges.map((label) {
                        return _buildChip(
                          label,
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
                            label: 'From',
                            controller: _fromDateController,
                            onTap: () => _pickDate(isFrom: true),
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDateInput(
                            label: 'To',
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
                      'Includes the full day · New York store time',
                      style: textStyles.bodySmall.copyWith(
                        color: c.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Status
                    _buildSectionTitle('Sale status', textStyles),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _statuses.map((label) {
                        return _buildChip(
                          label,
                          label == _selectedStatus,
                          () => setState(() => _selectedStatus = label),
                          c,
                          textStyles,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All sales includes partially refunded transactions.',
                      style: textStyles.bodySmall.copyWith(
                        color: c.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Payment Method
                    _buildSectionTitle('Payment method', textStyles),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _paymentMethods.map((label) {
                        return _buildChip(
                          label,
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
                      'Staff member',
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
                          Text('All staff', style: textStyles.bodyLarge),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F8FF),
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
                              'Oct 19 snapshot after refund #RF-0108: \$1,941.50 net sales across 25 transactions.',
                              style: textStyles.bodySmall.copyWith(
                                color: c.primaryCoral,
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
                      'Show $matchingCount transactions',
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
                      backgroundColor: const Color(0xFFF4F8FF),
                      foregroundColor: c.primaryCoral,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Reset filters',
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
