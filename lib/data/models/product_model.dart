class ProductModel {
  final String id;
  final String storeId;
  final String name;
  final String description;
  final String collectionName;
  final String imageUrl;
  final double basePrice;

  ProductModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.collectionName,
    required this.imageUrl,
    required this.basePrice,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      collectionName: json['collection_name'] as String,
      imageUrl: json['image_url'] as String,
      basePrice: json['base_price'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'description': description,
      'collection_name': collectionName,
      'image_url': imageUrl,
      'base_price': basePrice,
    };
  }

  ProductModel copyWith({
    String? id,
    String? storeId,
    String? name,
    String? description,
    String? collectionName,
    String? imageUrl,
    double? basePrice,
  }) {
    return ProductModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      description: description ?? this.description,
      collectionName: collectionName ?? this.collectionName,
      imageUrl: imageUrl ?? this.imageUrl,
      basePrice: basePrice ?? this.basePrice,
    );
  }
}
