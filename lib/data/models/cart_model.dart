// data/models/cart_model.dart

class CartModel {
  final String id;
  final String productId;
  final String variantId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String productName;
  final String imageUrl;
  final String variantName;

  CartModel({
    required this.id,
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.productName,
    required this.imageUrl,
    required this.variantName,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      variantId: json['variant_id'] as String? ?? '',
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      productName: json['product_name'] as String,
      imageUrl: json['image_url'] as String,
      variantName: json['variant_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'variant_id': variantId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'product_name': productName,
      'image_url': imageUrl,
      'variant_name': variantName,
    };
  }

  CartModel copyWith({
    String? id,
    String? productId,
    String? variantId,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    String? productName,
    String? imageUrl,
    String? variantName,
  }) {
    return CartModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      productName: productName ?? this.productName,
      imageUrl: imageUrl ?? this.imageUrl,
      variantName: variantName ?? this.variantName,
    );
  }
}
