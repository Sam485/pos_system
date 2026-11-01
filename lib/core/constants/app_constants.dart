// core/constants/app_constants.dart

abstract class AppConstants {
  static const String appName = 'fold POS';
  static const String appVersion = '2.4.0';
  static const String storeName = 'fold / SoHo';
  static const String storeAddress = '120 Spring St, New York';
  static const String storeHours = 'Open 08:00 - 21:00';
  static const double storeLat = 11.5564;
  static const double storeLng = 104.9282;

  // ── Tax & Fees ──
  static const double taxRate = 0.10; // 10%
  static const double deliveryFee = 0.00;

  // ── API ──
  static const String baseUrl =
      'https://api-fold-pos-production.up.railway.app';
  static const String apiVersion = 'v1';
  static const String apiBaseUrl = '$baseUrl/api/$apiVersion';
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  // ── Storage keys ──
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUser = 'user';
  static const String keyCartItems = 'cart_items';
  static const String keyFavoriteIds = 'favorite_ids';
}

abstract class ApiEndpoints {
  // ── Auth ──
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // ── Registers & Sessions ──
  static const String registers = '/registers';
  static const String openRegister = '/registers/open';
  static const String closeRegister = '/registers/close';

  // ── Products & Inventory ──
  static const String products = '/products';
  static String productById(String id) => '/products/$id';
  static const String lowStockAlerts = '/inventory/low-stock';
  static const String updateStock = '/inventory/update';

  // ── Customers ──
  static const String customers = '/customers';
  static String customerById(String id) => '/customers/$id';

  // ── Orders & Checkout ──
  static const String placeOrder = '/orders/place';
  static String orderById(String id) => '/orders/$id';
  static const String salesHistory = '/sales/history';

  // ── Refunds ──
  static const String refunds = '/refunds';

  // ── Staff ──
  static const String staff = '/staff';

  // ── Cart ──
  static const String cart = '/cart';
  static String updateCartItem(String id) => '/cart/$id';
  static String removeCartItem(String id) => '/cart/$id';
  static const String store = '/store';

  static const String fullInventory = '/inventory';
}

// ══════════════════════════════════════════════════════════════════
// MOCK DATA — JSON SOURCE
// ══════════════════════════════════════════════════════════════════
abstract class MockData {
  // ── Staff ──────────────────────────────────────────────────────
  static final List<Map<String, dynamic>> staffJson = [
    {
      "id": "staff_001",
      "store_id": "store_001",
      "name": "Alex Morgan",
      "email": "alex@foldstore.com",
      "role": "manager",
      "is_active": true,
    },
    {
      "id": "staff_002",
      "store_id": "store_001",
      "name": "Jamie Lee",
      "email": "jamie.lee@foldstore.com",
      "role": "associate",
      "is_active": true,
    },
    {
      "id": "staff_003",
      "store_id": "store_001",
      "name": "Taylor Reed",
      "email": "taylor.reed@foldstore.com",
      "role": "associate",
      "is_active": true,
    },
  ];

  // ── Registers ──────────────────────────────────────────────────
  static final List<Map<String, dynamic>> registersJson = [
    {
      "id": "reg_001",
      "store_id": "store_001",
      "name": "Register 01",
      "status": "ready",
    },
    {
      "id": "reg_002",
      "store_id": "store_001",
      "name": "Register 02",
      "status": "inUse",
    },
  ];

  // ── Register Session ───────────────────────────────────────────
  static final Map<String, dynamic> registerSessionJson = {
    "id": "sess_001",
    "register_id": "reg_001",
    "staff_id": "staff_001",
    "opening_float": 250.00,
    "open_at": "2026-10-19T09:00:00.000Z",
    "closing_counted_cash": null,
    "expected_cash": null,
    "difference": null,
    "close_at": null,
    "status": "open",
  };

  // ── Products ───────────────────────────────────────────────────
  static final List<Map<String, dynamic>> productsJson = [
    {
      "id": "prod_001",
      "store_id": "store_001",
      "name": "Essential cotton tee",
      "description":
          "Soft heavyweight cotton. A relaxed fit made for everyday wear.",
      "collection_name": "THE EVERYDAY COLLECTION",
      "image_url":
          "https://imgs.search.brave.com/apAc0Lnxg-Gn_U2SCqswFa8gDu6wcx5bzX9I54HRKt0/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL0kv/NzFjbnE5MHdiMkwu/anBn",
      "base_price": 32.00,
    },
    {
      "id": "prod_002",
      "store_id": "store_001",
      "name": "Everyday trouser",
      "description": "Relaxed fit trousers for daily wear.",
      "collection_name": "THE EVERYDAY COLLECTION",
      "image_url":
          "https://imgs.search.brave.com/4E9fNSNoagZpRqhrUGhMMzGW3Atsjvf95iEqpQMPGQQ/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jZG4u/cGl4YWJheS5jb20v/cGhvdG8vMjAyMy8w/NS8wNi8wMS8zNC90/LXNoaXJ0LTc5NzM0/MDVfNjQwLmpwZw",
      "base_price": 68.00,
    },
    {
      "id": "prod_003",
      "store_id": "store_001",
      "name": "Oxford shirt",
      "description": "Classic oxford shirt with a button-down collar.",
      "collection_name": "CLASSICS",
      "image_url":
          "https://imgs.search.brave.com/u3NIispKhjc9TvBwsz79n05cmrogpZR7ALkU0nyHl9o/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL0kv/ODFDWUhiem1QQ0wu/anBn",
      "base_price": 58.00,
    },
    {
      "id": "prod_004",
      "store_id": "store_001",
      "name": "Ribbed crewneck",
      "description": "Soft ribbed knit crewneck sweater.",
      "collection_name": "KNITWEAR",
      "image_url":
          "https://imgs.search.brave.com/y37ddUnwCwlebGj7uKuZ67dT56kFoT9Q5EyBozpkiHw/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly92aXNw/cm9uZXRpbWFnZXMt/MThkOGEua3hjZG4u/Y29tL1NpemUtR3Jh/cGhpYy1HcmF5LTIu/anBn",
      "base_price": 84.00,
    },
  ];

  // ══════════════════════════════════════════════════════════════
  // VARIANTS
  // ══════════════════════════════════════════════════════════════
  static final List<Map<String, dynamic>> variantsJson = [
    // Product 1 (Essential cotton tee) Variants
    {
      "id": "var_001",
      "product_id": "prod_001",
      "sku": "CT-WHT-M",
      "name": "White / M",
      "color": "White",
      "size": "M",
      "price": 32.00,
    },
    {
      "id": "var_002",
      "product_id": "prod_001",
      "sku": "CT-WHT-XL",
      "name": "White / XL",
      "color": "White",
      "size": "XL",
      "price": 32.00,
    },
    {
      "id": "var_003",
      "product_id": "prod_001",
      "sku": "CT-NVY-S",
      "name": "Navy / S",
      "color": "Navy",
      "size": "S",
      "price": 32.00,
    },
    // Product 2 (Everyday trouser) Variants
    {
      "id": "var_004",
      "product_id": "prod_002",
      "sku": "TR-SND-26",
      "name": "Sand / 26",
      "color": "Sand",
      "size": "26",
      "price": 68.00,
    },
    {
      "id": "var_005",
      "product_id": "prod_002",
      "sku": "TR-SND-34",
      "name": "Sand / 34",
      "color": "Sand",
      "size": "34",
      "price": 68.00,
    },
    // Product 3 (Oxford shirt) Variants
    {
      "id": "var_006",
      "product_id": "prod_003",
      "sku": "OX-SKY-M",
      "name": "Sky / M",
      "color": "Sky",
      "size": "M",
      "price": 58.00,
    },
    {
      "id": "var_007",
      "product_id": "prod_003",
      "sku": "OX-SKY-XL",
      "name": "Sky / XL",
      "color": "Sky",
      "size": "XL",
      "price": 58.00,
    },
    // Product 4 (Ribbed crewneck) Variants
    {
      "id": "var_008",
      "product_id": "prod_004",
      "sku": "RC-NVY-XS",
      "name": "Navy / XS",
      "color": "Navy",
      "size": "XS",
      "price": 84.00,
    },
  ];

  // ── Inventory ──────────────────────────────────────────────────

  static final List<Map<String, dynamic>> inventoryJson = [
    // ── Essential cotton tee (prod_001) ──
    {
      "id": "inv_001",
      "variant_id": "var_001", // White / M
      "store_id": "store_001",
      "quantity_available": 18,
      "low_stock_threshold": 5,
    },
    {
      "id": "inv_002",
      "variant_id": "var_002", // White / XL
      "store_id": "store_001",
      "quantity_available": 2,
      "low_stock_threshold": 5,
    },
    {
      "id": "inv_003",
      "variant_id": "var_003", // Navy / S
      "store_id": "store_001",
      "quantity_available": 0,
      "low_stock_threshold": 5,
    },

    // ── Everyday trouser (prod_002) ──
    {
      "id": "inv_004",
      "variant_id": "var_004", // Sand / 26
      "store_id": "store_001",
      "quantity_available": 12,
      "low_stock_threshold": 5,
    },
    {
      "id": "inv_005",
      "variant_id": "var_005", // Sand / 34
      "store_id": "store_001",
      "quantity_available": 0,
      "low_stock_threshold": 5,
    },

    // ── Oxford shirt (prod_003) ──
    {
      "id": "inv_006",
      "variant_id": "var_006", // Sky / M
      "store_id": "store_001",
      "quantity_available": 4,
      "low_stock_threshold": 5,
    },
    {
      "id": "inv_007",
      "variant_id": "var_007", // Sky / XL
      "store_id": "store_001",
      "quantity_available": 1,
      "low_stock_threshold": 5,
    },

    // ── Ribbed crewneck (prod_004) ──
    {
      "id": "inv_008",
      "variant_id": "var_008", // Navy / XS
      "store_id": "store_001",
      "quantity_available": 42,
      "low_stock_threshold": 5,
    },
  ];
  // ── Customers ──────────────────────────────────────────────────
  static final List<Map<String, dynamic>> customersJson = [
    {
      "id": "cust_001",
      "store_id": "store_001",
      "first_name": "Emma",
      "last_name": "Miller",
      "email": "emma.miller@email.com",
      "phone": "+1 (212) 555-0148",
      "note": "Prefers relaxed fits and neutral colors.",
      "marketing_otp_in": false,
      "total_visit": 9,
      "life_time_spend": 723.00,
    },
    {
      "id": "cust_002",
      "store_id": "store_001",
      "first_name": "Oliver",
      "last_name": "James",
      "email": "oliver.james@email.com",
      "phone": "+1 (212) 555-0199",
      "note": null,
      "marketing_otp_in": true,
      "total_visit": 6,
      "life_time_spend": 412.50,
    },
    {
      "id": "cust_003",
      "store_id": "store_001",
      "first_name": "Ava",
      "last_name": "Chen",
      "email": "ava.chen@email.com",
      "phone": null,
      "note": null,
      "marketing_otp_in": false,
      "total_visit": 4,
      "life_time_spend": 189.20,
    },
  ];

  // ── Orders ─────────────────────────────────────────────────────
  static final List<Map<String, dynamic>> ordersJson = [
    {
      "id": "ord_1048",
      "order_number": "#1048",
      "store_id": "store_001",
      "register_session_id": "sess_001",
      "customer_id": "cust_001",
      "staff_id": "staff_001",
      "sub_total": 190.00,
      "discount_amount": 19.00,
      "tax_amount": 17.10,
      "total_amount": 188.10,
      "refunded_amount": 31.68,
      "status": "partitallyrefunded",
      "created_at": "2026-10-19T09:41:00.000Z",
    },
    {
      "id": "ord_1047",
      "order_number": "#1047",
      "store_id": "store_001",
      "register_session_id": "sess_001",
      "customer_id": "guest",
      "staff_id": "staff_001",
      "sub_total": 64.00,
      "discount_amount": 0.00,
      "tax_amount": 6.40,
      "total_amount": 70.4,
      "refunded_amount": 0.00,
      "status": "completed",
      "created_at": "2026-10-19T09:32:00.000Z",
    },
    {
      "id": "ord_1046",
      "order_number": "#1046",
      "store_id": "store_001",
      "register_session_id": "sess_001",
      "customer_id": "cust_002",
      "staff_id": "staff_002",
      "sub_total": 58.00,
      "discount_amount": 0.00,
      "tax_amount": 5.80,
      "total_amount": 63.80,
      "refunded_amount": 0.00,
      "status": "completed",
      "created_at": "2026-10-19T09:24:00.000Z",
    },
  ];

  // ── Payments ───────────────────────────────────────────────────
  static final Map<String, dynamic> paymentJson = {
    "id": "pay_001",
    "order_id": "ord_1048",
    "method": "cash",
    "amount": 130.68,
    "status": "completed",
    "transaction_reference": null,
    "change_given": 19.32,
    "created_at": "2026-10-19T09:41:00.000Z",
  };

  static final Map<String, dynamic> storeJson = {
    "id": "store_001",
    "name": "fold / SoHo",
    "address_line": "120 Spring St",
    "city": "New York",
    "zip_code": "10012",
    "phone": "+1 (212) 555-0100",
    "currency": "USD - \$",
    "time_zone": "New York",
  };

  static final List<Map<String, dynamic>> orderItemsJson = [
    // ══════════════════════════════════════════════════════════════
    // Order #1048 (Emma Miller) - 3 Items
    // ══════════════════════════════════════════════════════════════
    {
      "id": "oi_001",
      "order_id": "ord_1048",
      "variant_id": "var_001", // Essential cotton tee (White / M)
      "quantity": 2,
      "unit_price": 32.00,
      "total_price": 64.00,
    },
    {
      "id": "oi_002",
      "order_id": "ord_1048",
      "variant_id": "var_004", // Everyday trouser (Sand / 26)
      "quantity": 1,
      "unit_price": 68.00,
      "total_price": 68.00,
    },
    {
      "id": "oi_003",
      "order_id": "ord_1048",
      "variant_id": "var_007", // Oxford shirt (Sky / XL)
      "quantity": 1,
      "unit_price": 58.00,
      "total_price": 58.00,
    },

    // ══════════════════════════════════════════════════════════════
    // Order #1047 (Guest customer) - 1 Item
    // ══════════════════════════════════════════════════════════════
    {
      "id": "oi_004",
      "order_id": "ord_1047",
      "variant_id": "var_002", // Essential cotton tee (White / XL)
      "quantity": 2,
      "unit_price": 32.00,
      "total_price": 64.00,
    },

    // ══════════════════════════════════════════════════════════════
    // Order #1046 (Oliver James) - 1 Item
    // ══════════════════════════════════════════════════════════════
    {
      "id": "oi_005",
      "order_id": "ord_1046",
      "variant_id": "var_006", // Oxford shirt (Sky / M)
      "quantity": 1,
      "unit_price": 58.00,
      "total_price": 58.00,
    },
  ];

  static final List<Map<String, dynamic>> orderItemRefundsJson = [
    // 1 of the 2 Essential cotton tees from Order #1048 was returned
    {
      "id": "ref_001",
      "order_item_id": "oi_001",
      "quantity_refunded": 1,
      "refunded_at": "2026-10-19T10:08:00.000Z",
    },
  ];
  // ── Discounts ──────────────────────────────────────────────────
  static final List<Map<String, dynamic>> discountsJson = [
    {
      "id": "disc_001",
      "name": "Welcome discount",
      "description": "10% off · Whole order",
      "type": "percentage",
      "value": 10.0,
    },
    {
      "id": "disc_002",
      "name": "Staff discount",
      "description": "20% off · Staff purchases only",
      "type": "percentage",
      "value": 20.0,
    },
    {
      "id": "disc_003",
      "name": "Loyalty thank-you",
      "description": "\$5.00 off · Orders of \$50 or more",
      "type": "fixed",
      "value": 5.0,
    },
  ];
}
