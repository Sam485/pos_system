import 'package:pos_system/data/enum/register_status_enum.dart';

class RegisterModel {
  final String id;
  final String storeId;
  final String name;
  final RegisterStatusEnum status;

  RegisterModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.status,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      // Correctly parse the String to Enum
      status: RegisterStatusEnum.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => RegisterStatusEnum.offline,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'store_id': storeId, 'name': name, 'status': status};
  }

  RegisterModel copyWith({
    String? id,
    String? storeId,
    String? name,
    RegisterStatusEnum? status,
  }) {
    return RegisterModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }
}
