import 'dart:io' show File;

class WeightRecord {
  final double weight;
  final DateTime date;
  final File? image;

  const WeightRecord({required this.weight, required this.date, this.image});

  static const _noChange = Object();

  WeightRecord copyWith({
    double? weight,
    DateTime? date,
    Object? image = _noChange,
  }) => WeightRecord(
    weight: weight ?? this.weight,
    date: date ?? this.date,
    image: image == _noChange ? this.image : image as File?,
  );

  String get formattedDate => "${date.day}/${date.month}/${date.year}";
  String get formattedWeight {
    if (weight == weight.roundToDouble()) {
      return weight.toStringAsFixed(0);
    }
    return weight.toStringAsFixed(1);
  }
}

enum Period {
  week("Tuần"),
  month("1 tháng"),
  threeMonths("3 tháng"),
  sixMonths("6 tháng"),
  year("Năm"),
  all("Tất cả");

  final String label;
  const Period(this.label);
}
