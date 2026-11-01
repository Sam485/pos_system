class OrderDiscountModel {
  final String id;
  final String orderId;
  final String name;
  final String type;
  final double value;

  OrderDiscountModel({
    required this.id,
    required this.orderId,
    required this.name,
    required this.type,
    required this.value,
  });

  factory OrderDiscountModel.fromJson(Map<String, dynamic> json) {
    return OrderDiscountModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      value: json['value'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'name': name,
      'type': type,
      'value': value,
    };
  }

  OrderDiscountModel copyWith({
    String? id,
    String? orderId,
    String? name,
    String? type,
    double? value,
  }) {
    return OrderDiscountModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }
}
