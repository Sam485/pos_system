// providers/order_provider.dart

import 'package:flutter/foundation.dart';
import 'package:pos_system/core/constants/app_constants.dart';
import 'package:pos_system/core/services/api_service.dart';
import 'package:pos_system/data/enum/order_status_enum.dart';
import 'package:pos_system/data/models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final ApiService _apiService;
  OrderProvider(this._apiService);

  List<OrderModel> _salesHistory = [];
  OrderModel? _currentOrder;
  bool _isLoading = false;
  String? _error;

  // ── Filter State ──
  String _filterDateRange = 'Custom';
  DateTime? _filterFromDate;
  DateTime? _filterToDate;
  String _filterStatus = 'All sales';
  String _filterPaymentMethod = 'All methods';
  List<Map<String, dynamic>> _orderItemRefunds = [];
  List<Map<String, dynamic>> get orderItemRefunds => _orderItemRefunds;

  List<OrderModel> get salesHistory => _salesHistory;
  OrderModel? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Map<String, dynamic>> _orderItems = [];
  List<Map<String, dynamic>> get orderItems => _orderItems;

  // ── Filter Getters ──
  String get filterDateRange => _filterDateRange;
  DateTime? get filterFromDate => _filterFromDate;
  DateTime? get filterToDate => _filterToDate;
  String get filterStatus => _filterStatus;
  String get filterPaymentMethod => _filterPaymentMethod;

  // ── Filtered List ──
  List<OrderModel> get filteredSales {
    return _salesHistory.where((order) {
      // 1. Date filter
      if (_filterFromDate != null && _filterToDate != null) {
        if (order.createdAt.isBefore(_filterFromDate!) ||
            order.createdAt.isAfter(
              _filterToDate!.add(const Duration(days: 1)),
            )) {
          return false;
        }
      }

      // 2. Status filter
      if (_filterStatus == 'Completed' && order.status.name != 'completed') {
        return false;
      }
      if (_filterStatus == 'Refunded' &&
          order.status.name != 'partiallyRefunded') {
        return false;
      }

      // 3. Payment method (would need payment data, skipping for now)

      return true;
    }).toList();
  }

  // ── Apply Filters ──
  void applyFilters({
    required String dateRange,
    DateTime? fromDate,
    DateTime? toDate,
    required String status,
    required String paymentMethod,
  }) {
    _filterDateRange = dateRange;
    _filterFromDate = fromDate;
    _filterToDate = toDate;
    _filterStatus = status;
    _filterPaymentMethod = paymentMethod;
    notifyListeners();
  }

  // ── Clear Filters ──
  void clearFilters() {
    _filterDateRange = 'Custom';
    _filterFromDate = null;
    _filterToDate = null;
    _filterStatus = 'All sales';
    _filterPaymentMethod = 'All methods';
    notifyListeners();
  }

  // ── Fetch Sales ──
  Future<void> fetchSalesHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _salesHistory = await _apiService.getSalesHistory();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Place Order ──
  Future<bool> placeOrder(Map<String, dynamic> orderData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newOrder = await _apiService.placeOrder(orderData);
      _currentOrder = newOrder;
      _salesHistory.insert(0, newOrder);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrderItems(String orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch both items and their refunds
      final results = await Future.wait([
        _apiService.getOrderItems(orderId),
        _apiService.getOrderItemRefunds(orderId),
      ]);

      _orderItems = results[0];
      _orderItemRefunds = results[1];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Inside providers/order_provider.dart

  Future<bool> processRefund({
    required String orderId,
    required List<Map<String, dynamic>> items,
    required double totalRefundAmount,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.processRefund({
        'order_id': orderId,
        'items': items,
        'total_refund_amount': totalRefundAmount,
      });

      // 👇 Update local state immediately using item-based logic
      final index = _salesHistory.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        final currentOrder = _salesHistory[index];

        // Check if all items have been returned locally
        // Since this is a mock, we can fetch the latest order status from mock data
        // or simulate it here. Ideally, you'd read the status from the API response.

        // For now, let's calculate based on the total refund:
        final newRefundedAmount =
            currentOrder.refundedAmount + totalRefundAmount;
        final isFullyRefunded =
            newRefundedAmount >= (currentOrder.totalAmount - 0.01);

        _salesHistory[index] = currentOrder.copyWith(
          status: isFullyRefunded
              ? OrderStatusEnum.fullyrefunded
              : OrderStatusEnum.partitallyrefunded,
          refundedAmount: newRefundedAmount,
        );
      }

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int get totalItemsSold {
    // 1. If order items are loaded for the current order, use that
    if (_orderItems.isNotEmpty) {
      return _orderItems.fold(
        0,
        (sum, item) => sum + (item['quantity'] as int),
      );
    }

    // 2. Otherwise, look up from mock data
    return _salesHistory.fold(0, (sum, order) {
      final items = MockData.orderItemsJson
          .where((i) => i['order_id'] == order.id)
          .toList();
      return sum + items.fold(0, (s, item) => s + (item['quantity'] as int));
    });
  }

  // Add this inside OrderProvider class
  Future<Map<String, dynamic>?> getPaymentDetails(String orderId) async {
    try {
      return await _apiService.getOrderPayment(orderId);
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }
}
