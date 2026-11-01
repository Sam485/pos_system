class RefundsModel {
  final String id;
  final String orderId;
  final String paymentId;
  final String staffId;
  final double amount;
  final String reason;
  final bool restockItems;
  final DateTime createdAt;

  RefundsModel({
    required this.id,
    required this.orderId,
    required this.paymentId,
    required this.staffId,
    required this.amount,
    required this.reason,
    required this.restockItems,
    required this.createdAt,
  });

  factory RefundsModel.fromJson(Map<String, dynamic> json) {
    return RefundsModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      paymentId: json['payment_id'] as String,
      staffId: json['staff_id'] as String,
      amount: json['amount'] as double,
      reason: json['reason'] as String,
      restockItems: json['restock_items'] as bool,
      createdAt: json['created_at'] as DateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'payment_id': paymentId,
      'staff_id': staffId,
      'amount': amount,
      'reason': reason,
      'restock_items': restockItems,
      'created_at': createdAt,
    };
  }

  RefundsModel copyWith(
    String? id,
    String? orderId,
    String? paymentId,
    String? staffId,
    double? amount,
    String? reason,
    bool? restockItems,
    DateTime? createdAt,
  ) {
    return RefundsModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      paymentId: paymentId ?? this.paymentId,
      staffId: staffId ?? this.staffId,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      restockItems: restockItems ?? this.restockItems,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
