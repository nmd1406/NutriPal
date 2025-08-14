import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/food.dart';
import 'package:nutripal/models/food_record.dart';
import 'package:nutripal/viewmodels/diary_record_viewmodel.dart';

class MealTrackingViewModel extends Notifier<void> {
  @override
  void build() {}

  void addFoodToMeal({
    required Food food,
    required Meal meal,
    required double servingAmount,
    required TimeOfDay consumedAt,
  }) {
    final newRecord = FoodRecord(
      food: food,
      meal: meal,
      servingAmount: servingAmount,
      consumedAt: consumedAt,
    );

    final diaryNotifier = ref.read(diaryRecordViewModelProvider.notifier);
    diaryNotifier.addFoodRecord(meal, newRecord);
  }

  void removeRecordFromMeal(Meal meal, int recordIndex) {
    final diaryNotifier = ref.read(diaryRecordViewModelProvider.notifier);
    diaryNotifier.removeFoodRecord(meal, recordIndex);
  }
}

final currentMealProvider = StateProvider<Meal>((ref) => Meal.breakfast);

final mealTrackingViewModelProvider =
    NotifierProvider<MealTrackingViewModel, void>(MealTrackingViewModel.new);
