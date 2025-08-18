import 'package:flutter/material.dart';

class WaterRecord {
  final double amount;
  final TimeOfDay consumedAt;

  const WaterRecord({required this.amount, required this.consumedAt});

  WaterRecord copyWith({double? amount, TimeOfDay? consumedAt}) {
    return WaterRecord(
      amount: amount ?? this.amount,
      consumedAt: consumedAt ?? this.consumedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "consumedAt": {"hour": consumedAt.hour, "minute": consumedAt.minute},
    };
  }
  
  factory WaterRecord.fromJson(Map<String, dynamic> json) {
    return WaterRecord(amount: (json["amount"] as num).toDouble(), consumedAt: TimeOfDay(hour: json["consumedAt"]["hour"], minute: json["consumedAt"]["minute"]));
  }
}
