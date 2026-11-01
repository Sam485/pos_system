class RefundItemsModel {
  final String id; // Changed from iid to id for consistency
  final String refundId;
  final String orderItemId;
  final int quantity;

  RefundItemsModel({
    required this.id,
    required this.refundId,
    required this.orderItemId,
    required this.quantity,
  });

  factory RefundItemsModel.fromJson(Map<String, dynamic> json) {
    return RefundItemsModel(
      id: json['id'] as String,
      refundId: json['refund_id'] as String,
      orderItemId: json['order_item_id'] as String,
      quantity: json['quantity'] as int, // Fixed typo from 'qauntity'
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'refund_id': refundId,
    'order_item_id': orderItemId,
    'quantity': quantity,
  };

  RefundItemsModel copyWith({
    String? id,
    String? refundId,
    String? orderItemId,
    int? quantity,
  }) {
    return RefundItemsModel(
      id: id ?? this.id,
      refundId: refundId ?? this.refundId,
      orderItemId: orderItemId ?? this.orderItemId,
      quantity: quantity ?? this.quantity,
    );
  }
}
