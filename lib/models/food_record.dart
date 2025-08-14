import 'package:flutter/material.dart';
import 'package:nutripal/models/food.dart';

class FoodRecord {
  final Food food;
  final double servingAmount;
  final Meal meal;
  final TimeOfDay consumedAt;

  const FoodRecord({
    required this.food,
    required this.servingAmount,
    required this.meal,
    required this.consumedAt,
  });

  FoodRecord copyWith({
    Food? food,
    double? servingAmount,
    Meal? meal,
    TimeOfDay? consumedAt,
  }) {
    return FoodRecord(
      food: food ?? this.food,
      servingAmount: servingAmount ?? this.servingAmount,
      meal: meal ?? this.meal,
      consumedAt: consumedAt ?? this.consumedAt,
    );
  }

  static FoodRecord placeholder() {
    return FoodRecord(
      food: Food.empty(),
      servingAmount: 0,
      meal: Meal.breakfast,
      consumedAt: TimeOfDay.now(),
    );
  }

  // Validation methods
  bool get isValid => servingAmount > 0;
  bool get isEmpty => servingAmount == 0;

  double get totalCalories => food.caloriesPerServing * servingAmount;
  double get totalCarbs => food.carb * servingAmount;
  double get totalFat => food.fat * servingAmount;
  double get totalProtein => food.protein * servingAmount;
}

enum Meal {
  breakfast(value: "breakfast", title: "Bữa sáng"),
  lunch(value: "lunch", title: "Bữa trưa"),
  dinner(value: "dinner", title: "Bữa tối"),
  snack(value: "snack", title: "Bữa phụ");

  final String value;
  final String title;

  const Meal({required this.value, required this.title});

  static Meal? fromValue(String value) {
    for (Meal meal in Meal.values) {
      if (meal.value == value) {
        return meal;
      }
    }
    return null;
  }

  static Meal? fromTitle(String title) {
    for (Meal meal in Meal.values) {
      if (meal.title == title) {
        return meal;
      }
    }
    return null;
  }
}
