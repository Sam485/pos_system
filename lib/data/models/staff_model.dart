import 'package:pos_system/data/enum/role_enum.dart';

class StaffModel {
  final String id;
  final String storeId;
  final String name;
  final String email;
  final RoleEnum role;
  final bool isActive;

  StaffModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
  });

  // data/models/staff_model.dart

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      // 👇 FIX: Parse the string to enum safely
      role: RoleEnum.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => RoleEnum.associate,
      ),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'email': email,
      'role': role,
      'is_active': isActive,
    };
  }

  StaffModel copyWith({
    String? id,
    String? storeId,
    String? name,
    String? email,
    RoleEnum? role,
    bool? isActive,
  }) {
    return StaffModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }
}
