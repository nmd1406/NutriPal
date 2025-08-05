import 'package:flutter/material.dart' show Color, Colors;

class Food {
  final int? id;
  final String name;
  final String category;
  final double servingSize;
  final String servingUnit;
  final double caloriesPerServing;
  final double protein;
  final double carb;
  final double fat;

  const Food({
    this.id,
    required this.name,
    required this.category,
    required this.servingSize,
    required this.servingUnit,
    required this.caloriesPerServing,
    required this.protein,
    required this.carb,
    required this.fat,
  });

  Food copyWith({
    int? id,
    String? name,
    String? category,
    double? servingSize,
    String? servingUnit,
    double? caloriesPerServing,
    double? protein,
    double? carb,
    double? fat,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      caloriesPerServing: caloriesPerServing ?? this.caloriesPerServing,
      protein: protein ?? this.protein,
      carb: carb ?? this.carb,
      fat: fat ?? this.fat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      "name": name,
      "category": category,
      "servingSize": servingSize,
      "servingUnit": servingUnit,
      "caloriesPerServing": caloriesPerServing,
      "protein": protein,
      "carb": carb,
      "fat": fat,
    };
  }

  Map<String, dynamic> toMapForInsert() {
    return {
      "name": name,
      "category": category,
      "servingSize": servingSize,
      "servingUnit": servingUnit,
      "caloriesPerServing": caloriesPerServing,
      "protein": protein,
      "carb": carb,
      "fat": fat,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map["id"] as int?,
      name: map["name"] as String,
      category: map["category"] as String,
      servingSize: map["servingSize"] as double,
      servingUnit: map["servingUnit"] as String,
      caloriesPerServing: map["caloriesPerServing"] as double,
      protein: map["protein"] as double,
      carb: map["carb"] as double,
      fat: map["fat"] as double,
    );
  }

  static Food empty() {
    return Food(
      name: "",
      category: "",
      servingSize: 0,
      servingUnit: "",
      caloriesPerServing: 0,
      protein: 0,
      carb: 0,
      fat: 0,
    );
  }

  Color get carbColor => Color.fromARGB(255, 44, 127, 47);
  Color get fatColor => Colors.deepPurple;
  Color get proteinColor => Colors.amber;

  double get _carbCalories => 4;
  double get _proteinCalories => 4;
  double get _fatCalories => 9;

  double get _totalMacroCalories =>
      carb * _carbCalories + protein * _proteinCalories + fat * _fatCalories;
  double get carbPercent => (carb * _carbCalories) / _totalMacroCalories;
  double get proteinPercent =>
      (protein * _proteinCalories) / _totalMacroCalories;
  double get fatPercent => (fat * _fatCalories) / _totalMacroCalories;
}
