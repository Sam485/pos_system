import 'package:pos_system/data/enum/order_status_enum.dart';

class OrderModel {
  final String id;
  final String orderNumber;
  final String storeId;
  final String registerSessionId;
  final String? customerId;
  final String staffId;
  final double subTotal;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final double refundedAmount;
  final OrderStatusEnum status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.storeId,
    required this.registerSessionId,
    required this.customerId,
    required this.staffId,
    required this.subTotal,
    required this.discountAmount,
    required this.taxAmount,
    required this.totalAmount,
    this.refundedAmount = 0.0,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      storeId: json['store_id'] as String,
      registerSessionId: json['register_session_id'] as String,
      customerId: json['customer_id'] as String?,
      staffId: json['staff_id'] as String,
      subTotal: (json['sub_total'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num).toDouble(),
      taxAmount: (json['tax_amount'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      refundedAmount: (json['refunded_amount'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatusEnum.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatusEnum.completed,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'store_id': storeId,
      'register_session_id': registerSessionId,
      'customer_id': customerId,
      'staff_id': staffId,
      'sub_total': subTotal, // 👈 Fixed typo (was 'subtotal')
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'total_amount': totalAmount,
      'refunded_amount': refundedAmount, // 👈 Added missing field
      'status': status.name, // 👈 Fixed: Save as String
      'created_at': createdAt.toIso8601String(), // 👈 Fixed: Save as String
    };
  }

  // 👇 Fixed: Added curly braces {} for named parameters
  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? storeId,
    String? registerSessionId,
    String? customerId,
    String? staffId,
    double? subTotal,
    double? discountAmount,
    double? taxAmount,
    double? totalAmount,
    double? refundedAmount,
    OrderStatusEnum? status,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      storeId: storeId ?? this.storeId,
      registerSessionId: registerSessionId ?? this.registerSessionId,
      customerId: customerId ?? this.customerId,
      staffId: staffId ?? this.staffId,
      subTotal: subTotal ?? this.subTotal,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      refundedAmount: refundedAmount ?? this.refundedAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
