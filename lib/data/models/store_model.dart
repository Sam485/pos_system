class StoreModel {
  final String id;
  final String name;
  final String addressLine;
  final String city;
  final String zipCode;
  final String phone;
  final String currency;
  final String timeZone;

  StoreModel({
    required this.id,
    required this.name,
    required this.addressLine,
    required this.city,
    required this.zipCode,
    required this.phone,
    required this.currency,
    required this.timeZone,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] ?? '',
      name: json['name'] as String,
      addressLine: json['address_line'] as String,
      city: json['city'] as String,
      zipCode: json['zip_code'] as String,
      phone: json['phone'] as String,
      currency: json['currency'] as String,
      timeZone: json['time_zone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address_line': addressLine,
      'city': city,
      'zip_code': zipCode,
      'phone': phone,
      'currency': currency,
      'time_zone': timeZone,
    };
  }

  StoreModel copyWith({
    String? id,
    String? name,
    String? addressLine,
    String? city,
    String? zipCode,
    String? phone,
    String? currency,
    String? timeZone,
  }) {
    return StoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      phone: phone ?? this.phone,
      currency: currency ?? this.currency,
      timeZone: timeZone ?? this.timeZone,
    );
  }
}
