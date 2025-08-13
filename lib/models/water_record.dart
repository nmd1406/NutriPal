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
}
