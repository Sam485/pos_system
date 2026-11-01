class CustomerModel {
  final String id;
  final String storeId;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? note;
  final bool marketingOtpIn;
  final int totalVisit;
  final double lifeTimeSpend;

  CustomerModel({
    required this.id,
    required this.storeId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.note,
    required this.marketingOtpIn,
    required this.totalVisit,
    required this.lifeTimeSpend,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] ?? '',
      note: json['note'] ?? '',
      marketingOtpIn: json['marketing_otp_in'] as bool,
      totalVisit: json['total_visit'] as int,
      lifeTimeSpend: json['life_time_spend'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'note': note,
      'marketing_otp_in': marketingOtpIn,
      'total_visit': totalVisit,
      'life_time_spend': lifeTimeSpend,
    };
  }

  CustomerModel copyWith(
    String? id,
    String? storeId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? note,
    bool? marketingOtpIn,
    int? totalVisit,
    double? lifeTimeSpend,
  ) {
    return CustomerModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      marketingOtpIn: marketingOtpIn ?? this.marketingOtpIn,
      totalVisit: totalVisit ?? this.totalVisit,
      lifeTimeSpend: lifeTimeSpend ?? this.lifeTimeSpend,
    );
  }
}
