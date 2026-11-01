import 'package:pos_system/data/enum/payment_method_enum.dart';
import 'package:pos_system/data/enum/payment_status_enum.dart';

class PaymentsModel {
  final String? id;
  final String orderId;
  final PaymentMethodEnum method;
  final double amount;
  final PaymentStatusEnum status;
  final String? transactionReference;
  final double? changeGiven;
  final DateTime createdAt;

  PaymentsModel({
    required this.id,
    required this.orderId,
    required this.method,
    required this.amount,
    required this.status,
    required this.transactionReference,
    this.changeGiven,
    required this.createdAt,
  });

  factory PaymentsModel.fromJson(Map<String, dynamic> json) {
    return PaymentsModel(
      id: json['id'] as String?,
      orderId: json['order_id'] as String,
      method: PaymentMethodEnum.values.firstWhere(
        (e) => e.name == json['method'],
        orElse: () => PaymentMethodEnum.cash,
      ),
      amount: (json['amount'] as num).toDouble(),
      status: PaymentStatusEnum.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PaymentStatusEnum.completed,
      ),
      transactionReference: json['transaction_reference'] as String?,
      changeGiven: json['change_given'] != null
          ? (json['change_given'] as num).toDouble()
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'method': method.name,
      'amount': amount,
      'status': status.name,
      'transaction_reference': transactionReference,
      'change_given': changeGiven,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PaymentsModel copyWith({
    String? id,
    String? orderId,
    PaymentMethodEnum? method,
    double? amount,
    PaymentStatusEnum? status,
    String? transactionReference,
    double? changeGiven,
    DateTime? createdAt,
  }) {
    return PaymentsModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      transactionReference: transactionReference ?? this.transactionReference,
      changeGiven: changeGiven ?? this.changeGiven,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
