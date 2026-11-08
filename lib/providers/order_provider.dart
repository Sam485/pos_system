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
      // 1. Date filter — resolve from either explicit dates OR the preset
      DateTime? start = _filterFromDate;
      DateTime? end = _filterToDate;

      if (start == null && end == null) {
        final now = DateTime.now();
        switch (_filterDateRange) {
          case 'Today':
            start = DateTime(now.year, now.month, now.day);
            end = start.add(const Duration(days: 1));
            break;
          case 'Yesterday':
            start = DateTime(
              now.year,
              now.month,
              now.day,
            ).subtract(const Duration(days: 1));
            end = start.add(const Duration(days: 1));
            break;
          case 'This week':
            final monday = now.subtract(Duration(days: now.weekday - 1));
            start = DateTime(monday.year, monday.month, monday.day);
            end = start.add(const Duration(days: 7));
            break;
          default:
            // 'Custom' with no dates → no date filtering
            break;
        }
      }

      if (start != null && order.createdAt.isBefore(start)) return false;
      if (end != null &&
          order.createdAt.isAfter(
            end.subtract(const Duration(milliseconds: 1)),
          )) {
        return false;
      }

      // 2. Status filter
      switch (_filterStatus) {
        case 'Completed':
          if (order.status != OrderStatusEnum.completed) return false;
          break;
        case 'Refunded':
          if (order.status != OrderStatusEnum.partitallyrefunded &&
              order.status != OrderStatusEnum.fullyrefunded) {
            return false;
          }
          break;
        case 'All sales':
        default:
          break;
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

  // ─────────────────────────────────────────────────────────────
  // Fetch order items — ENRICHED with refund data
  //
  // Each item returned here now contains:
  //   • returned_qty        (int)  — total units refunded so far
  //   • is_fully_returned   (bool) — true if every unit was refunded
  //
  // This is what the receipt screen reads to decide what to show.
  // ─────────────────────────────────────────────────────────────
  Future<void> fetchOrderItems(String orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch items and refunds in parallel
      final results = await Future.wait([
        _apiService.getOrderItems(orderId),
        _apiService.getOrderItemRefunds(orderId),
      ]);

      final rawItems = results[0];
      final refunds = results[1];

      // Build a lookup: order_item_id → total qty refunded
      final Map<String, int> returnedQtyByItem = {};
      for (final r in refunds) {
        final itemId = r['order_item_id'] as String?;
        final qty = (r['quantity_refunded'] as num?)?.toInt() ?? 0;
        if (itemId != null && qty > 0) {
          returnedQtyByItem[itemId] = (returnedQtyByItem[itemId] ?? 0) + qty;
        }
      }

      // Enrich each item with `returned_qty` and `is_fully_returned`
      _orderItems = rawItems.map((raw) {
        final itemId = raw['id'] as String?;
        final returnedQty = itemId != null
            ? (returnedQtyByItem[itemId] ?? 0)
            : 0;
        final originalQty = (raw['quantity'] as num?)?.toInt() ?? 0;

        return <String, dynamic>{
          ...raw,
          'returned_qty': returnedQty,
          'is_fully_returned': returnedQty >= originalQty,
        };
      }).toList();

      // Keep the raw refunds list for anything that needs it directly
      _orderItemRefunds = refunds;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Process Refund ──
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

      // Update the local sales-history entry right away
      final index = _salesHistory.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        final currentOrder = _salesHistory[index];
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

      // Refresh the enriched items list for the affected order so
      // any open receipt reflects the return immediately.
      await fetchOrderItems(orderId);

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
        (sum, item) => sum + ((item['quantity'] as num?)?.toInt() ?? 0),
      );
    }

    // 2. Otherwise, look up from mock data
    return _salesHistory.fold(0, (sum, order) {
      final items = MockData.orderItemsJson
          .where((i) => i['order_id'] == order.id)
          .toList();
      return sum +
          items.fold(
            0,
            (s, item) => s + ((item['quantity'] as num?)?.toInt() ?? 0),
          );
    });
  }

  Future<Map<String, dynamic>?> getPaymentDetails(String orderId) async {
    try {
      return await _apiService.getOrderPayment(orderId);
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }
}
