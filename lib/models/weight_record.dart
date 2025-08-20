import 'dart:async' show Completer;
import 'dart:io' show File;

import 'package:flutter/cupertino.dart';

class WeightRecord {
  final double weight;
  final DateTime date;
  final File? image;
  final String? imageUrl;

  const WeightRecord({
    required this.weight,
    required this.date,
    this.image,
    this.imageUrl,
  });

  static const _noChange = Object();

  WeightRecord copyWith({
    double? weight,
    DateTime? date,
    Object? image = _noChange,
    String? imageUrl,
  }) => WeightRecord(
    weight: weight ?? this.weight,
    date: date ?? this.date,
    image: image == _noChange ? this.image : image as File?,
    imageUrl: imageUrl ?? this.imageUrl,
  );

  String get formattedDate => "${date.day}/${date.month}/${date.year}";
  String get formattedWeight {
    if (weight == weight.roundToDouble()) {
      return weight.toStringAsFixed(0);
    }
    return weight.toStringAsFixed(1);
  }

  String formatDateForChart(Period period) {
    switch (period) {
      case Period.month:
      case Period.threeMonths:
      case Period.sixMonths:
        return '${date.day}/${date.month}';
      case Period.year:
      case Period.all:
        return '${date.month}/${date.year}';
    }
  }

  Map<String, dynamic> toJson() => {
    "weight": weight,
    "date": date.toIso8601String(),
    "imageUrl": imageUrl,
  };

  factory WeightRecord.fromJson(Map<String, dynamic> json) {
    return WeightRecord(
      weight: (json["weight"] as num).toDouble(),
      date: DateTime.parse(json["date"] as String),
      imageUrl: json["imageUrl"] as String?,
    );
  }

  static WeightRecord empty() {
    return WeightRecord(weight: 0.0, date: DateTime.now());
  }
}

enum Period {
  month("1 tháng"),
  threeMonths("3 tháng"),
  sixMonths("6 tháng"),
  year("Năm"),
  all("Tất cả");

  final String label;
  const Period(this.label);
}
