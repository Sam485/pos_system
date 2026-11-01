class InventoryModel {
  final String id;
  final String variantId;
  final String storeId;
  final int quantityAvailable;
  final int lowStockThreshold;

  InventoryModel({
    required this.id,
    required this.variantId,
    required this.storeId,
    required this.quantityAvailable,
    required this.lowStockThreshold,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'] as String,
      variantId: json['variant_id'] as String,
      storeId: json['store_id'] as String,
      quantityAvailable: json['quantity_available'] as int,
      lowStockThreshold: json['low_stock_threshold'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variant_id': variantId,
      'store_id': storeId,
      'quantity_available': quantityAvailable,
      'low_stock_threshold': lowStockThreshold,
    };
  }

  // ── copyWith Method ──
  // Creates a new instance of InventoryModel, replacing
  // only the fields you provide with new values.
  InventoryModel copyWith({
    String? id,
    String? variantId,
    String? storeId,
    int? quantityAvailable,
    int? lowStockThreshold,
  }) {
    return InventoryModel(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      storeId: storeId ?? this.storeId,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
    );
  }
}
