class OrderItemsModel {
  final String id;
  final String orderId;
  final String variantId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItemsModel({
    required this.id,
    required this.orderId,
    required this.variantId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItemsModel.fromJson(Map<String, dynamic> json) {
    return OrderItemsModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      variantId: json['variant_id'] as String,
      quantity: json['quantity'] as int,
      unitPrice: json['unit_price'] as double,
      totalPrice: json['total_price'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'variant_id': variantId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }

  OrderItemsModel copyWith({
    String? id,
    String? orderId,
    String? variantId,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
  }) {
    return OrderItemsModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
