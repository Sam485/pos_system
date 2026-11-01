// data/models/variant_model.dart

class VariantModel {
  final String id;
  final String productId;
  final String sku;
  final String name;
  final String color;
  final String size;
  final double price;

  VariantModel({
    required this.id,
    required this.productId,
    required this.sku,
    required this.name,
    required this.color,
    required this.size,
    required this.price,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      sku: json['sku'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      size: json['size'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'sku': sku,
      'name': name,
      'color': color,
      'size': size,
      'price': price,
    };
  }

  VariantModel copyWith({
    String? id,
    String? productId,
    String? sku,
    String? name,
    String? color,
    String? size,
    double? price,
  }) {
    return VariantModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      color: color ?? this.color,
      size: size ?? this.size,
      price: price ?? this.price,
    );
  }
}
