class WaterRecord {
  final double amount;
  final DateTime consumedAt;

  const WaterRecord({required this.amount, required this.consumedAt});

  WaterRecord copyWith({double? amount, DateTime? consumedAt}) {
    return WaterRecord(
      amount: amount ?? this.amount,
      consumedAt: consumedAt ?? this.consumedAt,
    );
  }
}
