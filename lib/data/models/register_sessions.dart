import 'package:pos_system/data/enum/register_session_enum.dart';

class RegisterSessions {
  final String id;
  final String registerId;
  final String staffId;
  final double openingFloat;
  final DateTime openAt;
  final double? closingCountedCash;
  final double? expectedCash;
  final double? difference;
  final DateTime? closeAt;
  final RegisterSessionEnum status;

  RegisterSessions({
    required this.id,
    required this.registerId,
    required this.staffId,
    required this.openingFloat,
    required this.openAt,
    this.closingCountedCash,
    this.expectedCash,
    this.difference,
    this.closeAt,
    required this.status,
  });

  // In RegisterSessions:
  factory RegisterSessions.fromJson(Map<String, dynamic> json) {
    // Renamed from toJson
    return RegisterSessions(
      id: json['id'] as String,
      registerId: json['register_id'] as String,
      staffId: json['staff_id'] as String,
      openingFloat: (json['opening_float'] as num).toDouble(),
      openAt: DateTime.parse(json['open_at'] as String),
      closingCountedCash: json['closing_counted_cash'] != null
          ? (json['closing_counted_cash'] as num).toDouble()
          : null,
      expectedCash: json['expected_cash'] != null
          ? (json['expected_cash'] as num).toDouble()
          : null,
      difference: json['difference'] != null
          ? (json['difference'] as num).toDouble()
          : null,
      closeAt: json['close_at'] != null
          ? DateTime.parse(json['close_at'] as String)
          : null,
      status: RegisterSessionEnum.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => RegisterSessionEnum.close,
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'register_id': registerId,
      'staff_id': staffId,
      'opening_float': openingFloat,
      'open_at': openAt,
      'status': status,
    };
  }

  RegisterSessions copyWith({
    String? id,
    String? registerId,
    String? staffId,
    double? openingFloat,
    DateTime? openedAt,
    double? closingCountedCash,
    double? expectedCash,
    double? difference,
    DateTime? closedAt,
    RegisterSessionEnum? status,
  }) {
    return RegisterSessions(
      id: id ?? this.id,
      registerId: registerId ?? this.registerId,
      staffId: staffId ?? this.staffId,
      openingFloat: openingFloat ?? this.openingFloat,
      openAt: openAt,
      closingCountedCash: closingCountedCash ?? this.closingCountedCash,
      expectedCash: expectedCash ?? this.expectedCash,
      difference: difference ?? this.difference,
      closeAt: closeAt,
      status: status ?? this.status,
    );
  }
}
