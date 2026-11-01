class DiscountModel {
  final String id;
  final String name;
  final String description;
  final String type;
  final double value;

  DiscountModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.value,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
    );
  }

  // 👇 Add toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'value': value,
    };
  }
}
