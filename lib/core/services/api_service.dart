// core/services/api_service.dart

import 'package:pos_system/data/models/cart_model.dart';
import 'package:pos_system/data/models/discount_model.dart';
import 'package:pos_system/data/models/notificatoin_model.dart';
import 'package:pos_system/data/models/setting_model.dart';
import 'package:pos_system/data/models/store_model.dart';
import 'package:pos_system/data/models/variant_model.dart';

import '../network/api_client.dart';
import '../constants/app_constants.dart';
import '../../data/models/product_model.dart';
import '../../data/models/customer_model.dart';
import '../../data/models/order_model.dart';
import '../../data/models/register_model.dart';
import '../../data/models/register_sessions.dart';
import '../../data/models/staff_model.dart';
import '../../data/models/iventory_model.dart';
import '../../data/models/payments_model.dart';

class ApiService {
  final ApiClient _client;

  // ── FLIP THIS TO FALSE WHEN YOUR REAL BACKEND IS READY ──
  static const bool useMockData = true;

  ApiService(this._client);

  Future<void> _mockDelay() =>
      Future.delayed(const Duration(milliseconds: 500));

  // ══════════════════════════════════════════════════════════════
  // AUTH
  // ══════════════════════════════════════════════════════════════
  Future<void> login({required String email, required String password}) async {
    if (useMockData) {
      await _mockDelay();
      return;
    }

    final res = await _client.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );
    final data = res['data'] as Map<String, dynamic>? ?? res;
    final token = data['access_token'] as String?;
    final refreshToken = data['refresh_token'] as String?;

    if (token != null && refreshToken != null) {
      _client.setTokens(token, refreshToken);
    }
  }

  Future<void> logout() async {
    if (useMockData) {
      await _mockDelay();
      return;
    }

    try {
      await _client.post(ApiEndpoints.logout);
    } catch (_) {}
    _client.clearTokens();
  }

  // ══════════════════════════════════════════════════════════════
  // REGISTERS
  // ══════════════════════════════════════════════════════════════
  Future<List<RegisterModel>> getRegisters() async {
    if (useMockData) {
      await _mockDelay();
      return MockData.registersJson
          .map((e) => RegisterModel.fromJson(e))
          .toList();
    }

    final res = await _client.get(ApiEndpoints.registers);
    final list = _extractList(res);
    return list
        .map((e) => RegisterModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<RegisterSessions> openRegister({
    required String registerId,
    required double openingFloat,
  }) async {
    if (useMockData) {
      await _mockDelay();
      final json = Map<String, dynamic>.from(MockData.registerSessionJson);
      json['register_id'] = registerId;
      json['opening_float'] = openingFloat;
      return RegisterSessions.fromJson(json);
    }

    final res = await _client.post(
      ApiEndpoints.openRegister,
      body: {'register_id': registerId, 'opening_float': openingFloat},
    );
    return RegisterSessions.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<void> closeRegister({
    required String sessionId,
    required double countedCash,
    String? note,
  }) async {
    if (useMockData) {
      await _mockDelay();
      return;
    }

    await _client.post(
      ApiEndpoints.closeRegister,
      body: {
        'session_id': sessionId,
        'counted_cash': countedCash,
        'note': note,
      },
    );
  }

  // ══════════════════════════════════════════════════════════════
  // PRODUCTS & INVENTORY
  // ══════════════════════════════════════════════════════════════
  Future<List<ProductModel>> getProducts({String? search}) async {
    if (useMockData) {
      await _mockDelay();
      final list = MockData.productsJson;
      if (search != null && search.isNotEmpty) {
        final filtered = list
            .where(
              (p) => (p['name'] as String).toLowerCase().contains(
                search.toLowerCase(),
              ),
            )
            .toList();
        return filtered.map((e) => ProductModel.fromJson(e)).toList();
      }
      return list.map((e) => ProductModel.fromJson(e)).toList();
    }

    final endpoint = search != null && search.isNotEmpty
        ? '${ApiEndpoints.products}?search=$search'
        : ApiEndpoints.products;
    final res = await _client.get(endpoint);
    final list = _extractList(res);
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> getProductById(String id) async {
    if (useMockData) {
      await _mockDelay();
      final json = MockData.productsJson.firstWhere((p) => p['id'] == id);
      return ProductModel.fromJson(json);
    }

    final res = await _client.get(ApiEndpoints.productById(id));
    return ProductModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  // core/services/api_service.dart

  Future<List<InventoryModel>> getLowStockAlerts() async {
    if (useMockData) {
      await _mockDelay();

      // 👇 Filter the mock data to only include items below or at threshold
      final filteredJson = MockData.inventoryJson.where((item) {
        final quantity = item['quantity_available'] as int;
        final threshold = item['low_stock_threshold'] as int;
        return quantity <= threshold;
      }).toList();

      return filteredJson.map((e) => InventoryModel.fromJson(e)).toList();
    }

    final res = await _client.get(ApiEndpoints.lowStockAlerts);
    final list = _extractList(res);
    return list
        .map((e) => InventoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // core/services/api_service.dart

  Future<List<InventoryModel>> getFullInventory() async {
    if (useMockData) {
      await _mockDelay();
      // 👇 Return ALL 8 items from MockData
      return MockData.inventoryJson
          .map((e) => InventoryModel.fromJson(e))
          .toList();
    }

    final res = await _client.get(ApiEndpoints.fullInventory);
    final list = _extractList(res);
    return list
        .map((e) => InventoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<InventoryModel> updateStock({
    required String variantId,
    required int quantityChange,
    required String reason,
    String? note,
  }) async {
    if (useMockData) {
      await _mockDelay();

      // 👇 Find the correct inventory item by variantId
      final index = MockData.inventoryJson.indexWhere(
        (item) => item['variant_id'] == variantId,
      );

      if (index == -1) {
        // Item doesn't exist in inventory yet — create a new one
        final newInventory = {
          "id": "inv_${DateTime.now().millisecondsSinceEpoch}",
          "variant_id": variantId,
          "store_id": "store_001",
          "quantity_available": quantityChange < 0 ? 0 : quantityChange,
          "low_stock_threshold": 5,
        };
        MockData.inventoryJson.add(newInventory);
        return InventoryModel.fromJson(newInventory);
      }

      // 👇 Update the existing item
      final json = MockData.inventoryJson[index];
      final newQuantity = (json['quantity_available'] as int) + quantityChange;

      json['quantity_available'] = newQuantity < 0 ? 0 : newQuantity;

      return InventoryModel.fromJson(json);
    }

    final res = await _client.post(
      ApiEndpoints.updateStock,
      body: {
        'variant_id': variantId,
        'quantity_change': quantityChange,
        'reason': reason,
        'note': note,
      },
    );
    return InventoryModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  // core/services/api_service.dart

  Future<VariantModel> addVariant(Map<String, dynamic> data) async {
    if (useMockData) {
      await _mockDelay();

      // Create a new variant JSON
      final newVariantJson = {
        "id": "var_${DateTime.now().millisecondsSinceEpoch}",
        "product_id": data['product_id'],
        "sku": data['sku'] ?? 'NEW-SKU',
        "name": "${data['color']} / ${data['size']}",
        "color": data['color'],
        "size": data['size'],
        "price": (data['price'] as num).toDouble(),
      };

      // Add to mock data
      MockData.variantsJson.add(newVariantJson);

      // Create an empty inventory record for this new variant
      MockData.inventoryJson.add({
        "id": "inv_${DateTime.now().millisecondsSinceEpoch}",
        "variant_id": newVariantJson['id'],
        "store_id": "store_001",
        "quantity_available": data['initial_stock'] ?? 0,
        "low_stock_threshold": 5,
      });

      return VariantModel.fromJson(newVariantJson);
    }

    final res = await _client.post('/variants', body: data);
    return VariantModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  // ══════════════════════════════════════════════════════════════
  // CUSTOMERS
  // ══════════════════════════════════════════════════════════════
  Future<List<CustomerModel>> getCustomers({String? search}) async {
    if (useMockData) {
      await _mockDelay();
      final list = MockData.customersJson;
      if (search != null && search.isNotEmpty) {
        final filtered = list
            .where(
              (c) => '${c['first_name']} ${c['last_name']}'
                  .toLowerCase()
                  .contains(search.toLowerCase()),
            )
            .toList();
        return filtered.map((e) => CustomerModel.fromJson(e)).toList();
      }
      return list.map((e) => CustomerModel.fromJson(e)).toList();
    }

    final endpoint = search != null && search.isNotEmpty
        ? '${ApiEndpoints.customers}?search=$search'
        : ApiEndpoints.customers;
    final res = await _client.get(endpoint);
    final list = _extractList(res);
    return list
        .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CustomerModel> getCustomerById(String id) async {
    if (useMockData) {
      await _mockDelay();
      final json = MockData.customersJson.firstWhere((c) => c['id'] == id);
      return CustomerModel.fromJson(json);
    }

    final res = await _client.get(ApiEndpoints.customerById(id));
    return CustomerModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<CustomerModel> createCustomer(Map<String, dynamic> data) async {
    if (useMockData) {
      await _mockDelay();
      final newJson = {
        'id': 'cust_${DateTime.now().millisecondsSinceEpoch}',
        'store_id': 'store_001',
        'first_name': data['first_name'] ?? '',
        'last_name': data['last_name'] ?? '',
        'email': data['email'] ?? '',
        'phone': data['phone'],
        'note': data['note'],
        'marketing_otp_in': data['marketing_otp_in'] ?? false,
        'total_visit': 0,
        'life_time_spend': 0.0,
      };
      return CustomerModel.fromJson(newJson);
    }

    final res = await _client.post(ApiEndpoints.customers, body: data);
    return CustomerModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<CustomerModel> updateCustomer(
    String id,
    Map<String, dynamic> data,
  ) async {
    if (useMockData) {
      await _mockDelay();
      // Simulate updating by finding the customer and returning the updated copy
      final json = MockData.customersJson.firstWhere(
        (c) => c['id'] == id,
        orElse: () => MockData.customersJson.first,
      );

      final updatedJson = Map<String, dynamic>.from(json);
      updatedJson.addAll(data);

      return CustomerModel.fromJson(updatedJson);
    }

    final res = await _client.put(ApiEndpoints.customerById(id), body: data);
    return CustomerModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  // ══════════════════════════════════════════════════════════════
  // ORDERS & CHECKOUT
  // ══════════════════════════════════════════════════════════════
  // core/services/api_service.dart

  Future<OrderModel> placeOrder(Map<String, dynamic> orderData) async {
    if (useMockData) {
      await _mockDelay();

      final orderId = "ord_${DateTime.now().millisecondsSinceEpoch}";
      final orderNumber = "#${1000 + MockData.ordersJson.length + 1}";

      // 1. Create the new order header
      final newOrderJson = {
        "id": orderId,
        "order_number": orderNumber,
        "store_id": "store_001",
        "register_session_id": "sess_001",
        "customer_id": orderData['customer_id'] ?? 'guest',
        "staff_id": "staff_001",
        "sub_total": orderData['subtotal'] ?? 0.0,
        "discount_amount": orderData['discount_amount'] ?? 0.0,
        "tax_amount": orderData['tax_amount'] ?? 0.0,
        "total_amount": orderData['total_amount'] ?? 0.0,
        "refunded_amount": 0.0,
        "status": "completed",
        "created_at": DateTime.now().toIso8601String(),
      };

      MockData.ordersJson.insert(0, newOrderJson);

      // 👇 2. SAVE THE ORDER ITEMS
      final items = orderData['items'] as List<dynamic>? ?? [];
      for (var item in items) {
        MockData.orderItemsJson.add({
          "id":
              "oi_${DateTime.now().millisecondsSinceEpoch}_${item['variant_id']}",
          "order_id": orderId,
          "variant_id": item['variant_id'],
          "quantity": item['quantity'],
          "unit_price": item['unit_price'],
          "total_price":
              (item['unit_price'] as num) * (item['quantity'] as num),
        });
      }

      return OrderModel.fromJson(newOrderJson);
    }

    final res = await _client.post(ApiEndpoints.placeOrder, body: orderData);
    return OrderModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<List<OrderModel>> getSalesHistory() async {
    if (useMockData) {
      await _mockDelay();
      return MockData.ordersJson.map((e) => OrderModel.fromJson(e)).toList();
    }

    final res = await _client.get(ApiEndpoints.salesHistory);
    final list = _extractList(res);
    return list
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<OrderModel> getOrderById(String id) async {
    if (useMockData) {
      await _mockDelay();
      final json = MockData.ordersJson.firstWhere((o) => o['id'] == id);
      return OrderModel.fromJson(json);
    }

    final res = await _client.get(ApiEndpoints.orderById(id));
    return OrderModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<List<Map<String, dynamic>>> getOrderItems(String orderId) async {
    if (useMockData) {
      await _mockDelay();
      // 👇 Filter MockData by order ID
      return MockData.orderItemsJson
          .where((item) => item['order_id'] == orderId)
          .toList();
    }
    final res = await _client.get('/orders/$orderId/items');
    return List<Map<String, dynamic>>.from(res['data']);
  }

  // ══════════════════════════════════════════════════════════════
  // REFUNDS
  // ══════════════════════════════════════════════════════════════
  Future<PaymentsModel> processRefund(Map<String, dynamic> refundData) async {
    if (useMockData) {
      await _mockDelay();
      final orderId = refundData['order_id'] as String?;
      final items = refundData['items'] as List<dynamic>? ?? [];

      if (orderId != null) {
        // 1. Save individual item refunds
        for (var item in items) {
          MockData.orderItemRefundsJson.add({
            "id":
                "ref_${DateTime.now().millisecondsSinceEpoch}_${item['order_item_id']}",
            "order_item_id": item['order_item_id'],
            "quantity_refunded": item['quantity'],
            "refunded_at": DateTime.now().toIso8601String(),
          });
        }

        // 2. Check if ALL items are now fully refunded
        // Get all items for this order
        final allOrderItems = MockData.orderItemsJson
            .where((i) => i['order_id'] == orderId)
            .toList();

        bool allItemsFullyReturned = true;

        for (var orderItem in allOrderItems) {
          final itemId = orderItem['id'];
          final originalQty = orderItem['quantity'] as int;

          // Calculate total refunded for this specific item
          final totalRefundedForItem = MockData.orderItemRefundsJson
              .where((r) => r['order_item_id'] == itemId)
              .fold(0, (sum, r) => sum + (r['quantity_refunded'] as int));

          // If this item isn't fully returned, the order isn't fully refunded
          if (totalRefundedForItem < originalQty) {
            allItemsFullyReturned = false;
            break;
          }
        }

        // 3. Update the order status
        final index = MockData.ordersJson.indexWhere((o) => o['id'] == orderId);
        if (index >= 0) {
          final order = MockData.ordersJson[index];

          // Add up the refund amount
          double refundAmount = 0.0;
          for (var item in items) {
            refundAmount += (item['amount'] as num).toDouble();
          }
          final currentRefunded =
              (order['refunded_amount'] as num?)?.toDouble() ?? 0.0;

          order['refunded_amount'] = currentRefunded + refundAmount;

          // 👇 Use the item-based check instead of dollar amount
          order['status'] = allItemsFullyReturned
              ? 'fullyrefunded'
              : 'partitallyrefunded';
        }
      }

      return PaymentsModel.fromJson(MockData.paymentJson);
    }

    final res = await _client.post(ApiEndpoints.refunds, body: refundData);
    return PaymentsModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<List<Map<String, dynamic>>> getOrderItemRefunds(String orderId) async {
    if (useMockData) {
      await _mockDelay();

      // Get all order items for this order
      final orderItemIds = MockData.orderItemsJson
          .where((i) => i['order_id'] == orderId)
          .map((i) => i['id'])
          .toList();

      // Return refunds that match those items
      return MockData.orderItemRefundsJson
          .where((r) => orderItemIds.contains(r['order_item_id']))
          .toList();
    }

    final res = await _client.get('/orders/$orderId/refunds');
    return List<Map<String, dynamic>>.from(res['data']);
  }

  // ══════════════════════════════════════════════════════════════
  // STAFF
  // ══════════════════════════════════════════════════════════════
  Future<List<StaffModel>> getStaff() async {
    if (useMockData) {
      await _mockDelay();
      return MockData.staffJson.map((e) => StaffModel.fromJson(e)).toList();
    }

    final res = await _client.get(ApiEndpoints.staff);
    final list = _extractList(res);
    return list
        .map((e) => StaffModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ══════════════════════════════════════════════════════════════
  // VARIANTS (NEW)
  // ══════════════════════════════════════════════════════════════
  Future<List<VariantModel>> getVariants() async {
    if (useMockData) {
      await _mockDelay();
      return MockData.variantsJson
          .map((e) => VariantModel.fromJson(e))
          .toList();
    }

    final res = await _client.get('/variants');
    final list = _extractList(res);
    return list
        .map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ══════════════════════════════════════════════════════════════
  // CART (NEW)
  // ══════════════════════════════════════════════════════════════
  // Note: For mock mode, we need a static in-memory list to persist cart items.
  static final List<Map<String, dynamic>> _mockCart = [];

  Future<List<CartModel>> getCart() async {
    if (useMockData) {
      await _mockDelay();
      return _mockCart.map((e) => CartModel.fromJson(e)).toList();
    }

    final res = await _client.get(ApiEndpoints.cart);
    final list = _extractList(res);
    return list
        .map((e) => CartModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CartModel> addToCart(Map<String, dynamic> data) async {
    if (useMockData) {
      await _mockDelay();
      final newItem = {
        'id': 'cart_${DateTime.now().millisecondsSinceEpoch}',
        'product_id': data['product_id'],
        'variant_id': data['variant_id'] ?? '',
        'quantity': data['quantity'] ?? 1,
        'unit_price': data['unit_price'] ?? 0.0,
        'total_price': (data['unit_price'] ?? 0.0) * (data['quantity'] ?? 1),
        'product_name': data['product_name'] ?? 'Product',
        'image_url': data['image_url'] ?? '',
        'variant_name': data['variant_name'] ?? '',
      };
      _mockCart.add(newItem);
      return CartModel.fromJson(newItem);
    }

    final res = await _client.post(ApiEndpoints.cart, body: data);
    return CartModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<void> updateCartItem(String cartItemId, int quantity) async {
    if (useMockData) {
      await _mockDelay();
      final index = _mockCart.indexWhere((item) => item['id'] == cartItemId);
      if (index >= 0) {
        _mockCart[index]['quantity'] = quantity;
        _mockCart[index]['total_price'] =
            (_mockCart[index]['unit_price'] as double) * quantity;
      }
      return;
    }

    await _client.patch(
      ApiEndpoints.updateCartItem(cartItemId),
      body: {'quantity': quantity},
    );
  }

  Future<void> removeCartItem(String cartItemId) async {
    if (useMockData) {
      await _mockDelay();
      _mockCart.removeWhere((item) => item['id'] == cartItemId);
      return;
    }

    await _client.delete(ApiEndpoints.removeCartItem(cartItemId));
  }

  Future<void> clearCart() async {
    if (useMockData) {
      await _mockDelay();
      _mockCart.clear();
      return;
    }

    await _client.delete(ApiEndpoints.cart);
  }

  // ══════════════════════════════════════════════════════════════
  // PRIVATE HELPERS
  // ══════════════════════════════════════════════════════════════
  List<dynamic> _extractList(dynamic res) {
    if (res == null) return [];
    if (res is List) return res;
    if (res is Map) {
      if (res['data'] is List) return res['data'];
      for (final key in [
        'orders',
        'products',
        'customers',
        'staff',
        'registers',
        'inventory',
      ]) {
        if (res[key] is List) return res[key];
      }
      if (res['data'] is Map) return [res['data']];
    }
    return [];
  }

  // ══════════════════════════════════════════════════════════════
  // STORE
  // ══════════════════════════════════════════════════════════════
  Future<StoreModel> getStore() async {
    if (useMockData) {
      await _mockDelay();
      return StoreModel.fromJson(MockData.storeJson);
    }

    final res = await _client.get(ApiEndpoints.store);
    return StoreModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<StoreModel> updateStore(Map<String, dynamic> data) async {
    if (useMockData) {
      await _mockDelay();
      // Update the static mock data
      MockData.storeJson.addAll(data);
      return StoreModel.fromJson(MockData.storeJson);
    }

    final res = await _client.put(ApiEndpoints.store, body: data);
    return StoreModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  // In core/services/api_service.dart

  Future<SettingsModel> getSettings() async {
    if (useMockData) {
      await _mockDelay();
      return SettingsModel(
        taxRate: 0.10,
        applySalesTax: true,
        requireApproval: true,
        receiptFooter: 'Thank you for shopping at fold!',
        showLogo: true,
        showTaxBreakdown: true,
        offerEmailReceipts: true,
        autoPrintReceipts: false,
      );
    }
    final res = await _client.get('/settings');
    return SettingsModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<SettingsModel> updateSettings(Map<String, dynamic> data) async {
    if (useMockData) {
      await _mockDelay();
      return SettingsModel.fromJson(data);
    }
    final res = await _client.put('/settings', body: data);
    return SettingsModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<List<DiscountModel>> getDiscounts() async {
    if (useMockData) {
      await _mockDelay();
      return MockData.discountsJson
          .map((e) => DiscountModel.fromJson(e))
          .toList();
    }
    final res = await _client.get('/discounts');
    final list = _extractList(res);
    return list
        .map((e) => DiscountModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DiscountModel> createDiscount(Map<String, dynamic> data) async {
    if (useMockData) {
      await _mockDelay();
      final newDiscount = {
        "id": "disc_${DateTime.now().millisecondsSinceEpoch}",
        "name": data['name'] ?? 'New Discount',
        "description": data['description'] ?? '',
        "type": data['type'] ?? 'percentage',
        "value": (data['value'] as num?)?.toDouble() ?? 0.0,
      };
      MockData.discountsJson.add(newDiscount);
      return DiscountModel.fromJson(newDiscount);
    }

    final res = await _client.post('/discounts', body: data);
    return DiscountModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<void> deleteDiscount(String id) async {
    if (useMockData) {
      await _mockDelay();
      MockData.discountsJson.removeWhere((d) => d['id'] == id);
      return;
    }
    await _client.delete('/discounts/$id');
  }

  Future<List<NotificationModel>> getNotifications() async {
    if (useMockData) {
      await _mockDelay();
      return [
        NotificationModel(
          id: 'n1',
          title: 'New sale completed',
          message: 'Order #1048 was completed by Alex.',
          type: 'order',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        NotificationModel(
          id: 'n2',
          title: 'Low stock alert',
          message: 'Oxford shirt is running low (4 left).',
          type: 'system',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        NotificationModel(
          id: 'n3',
          title: 'Register closed',
          message: 'Register 02 was closed successfully.',
          type: 'system',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];
    }
    final res = await _client.get('/notifications');
    final list = _extractList(res);
    return list
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> markNotificationRead(String id) async {
    if (useMockData) {
      await _mockDelay();
      return;
    }
    await _client.patch('/notifications/$id/read');
  }

  // ══════════════════════════════════════════════════════════════
  // STAFF (UPDATED)
  // ══════════════════════════════════════════════════════════════
  Future<StaffModel> updateStaff(String id, Map<String, dynamic> data) async {
    if (useMockData) {
      await _mockDelay();
      final index = MockData.staffJson.indexWhere((s) => s['id'] == id);
      if (index >= 0) {
        MockData.staffJson[index].addAll(data);
        return StaffModel.fromJson(MockData.staffJson[index]);
      }
      throw Exception('Staff member not found');
    }

    final res = await _client.put('/staff/$id', body: data);
    return StaffModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  Future<void> deleteStaff(String id) async {
    if (useMockData) {
      await _mockDelay();
      MockData.staffJson.removeWhere((s) => s['id'] == id);
      return;
    }

    await _client.delete('/staff/$id');
  }

  // ══════════════════════════════════════════════════════════════
  // DISCOUNTS (CREATE / DELETE)
  // ══════════════════════════════════════════════════════════════

  // Add this inside ApiService class
  Future<Map<String, dynamic>> getOrderPayment(String orderId) async {
    if (useMockData) {
      await _mockDelay();
      // Return a mock Visa payment for order #1048
      return {
        "id": "pay_001",
        "order_id": orderId,
        "method": "card",
        "card_last_four": "4242",
        "card_brand": "Visa",
        "auth_code": "AUTH1048V",
        "status": "approved",
        "amount": 130.68,
      };
    }
    final res = await _client.get('/orders/$orderId/payment');
    return res['data'] as Map<String, dynamic>;
  }
}
