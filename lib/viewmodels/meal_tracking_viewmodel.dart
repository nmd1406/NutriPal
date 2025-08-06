import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/meal_record.dart';
import 'package:nutripal/models/food.dart';

class MealTrackingState {
  final Map<Meal, List<MealRecord>> mealRecords;
  final DateTime selectedDate;
  final bool isLoading;
  final String? error;

  MealTrackingState({
    this.mealRecords = const {},
    DateTime? selectedDate,
    this.isLoading = false,
    this.error,
  }) : selectedDate = selectedDate ?? DateTime.now();

  MealTrackingState copyWith({
    Map<Meal, List<MealRecord>>? mealRecords,
    DateTime? selectedDate,
    bool? isLoading,
    String? error,
  }) {
    return MealTrackingState(
      mealRecords: mealRecords ?? this.mealRecords,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  List<MealRecord> getMealRecords(Meal meal) {
    switch (meal) {
      case Meal.breakfast:
        return breakfastRecords;
      case Meal.lunch:
        return lunchRecords;
      case Meal.dinner:
        return dinnerRecords;
      case Meal.snack:
        return snackRecords;
    }
  }

  List<MealRecord> get breakfastRecords => mealRecords[Meal.breakfast] ?? [];
  List<MealRecord> get lunchRecords => mealRecords[Meal.lunch] ?? [];
  List<MealRecord> get dinnerRecords => mealRecords[Meal.dinner] ?? [];
  List<MealRecord> get snackRecords => mealRecords[Meal.snack] ?? [];

  // Calculated nutrition for each meal
  double getTotalCaloriesForMeal(Meal meal) {
    final records = mealRecords[meal] ?? [];
    return records.fold(0.0, (sum, record) => sum + record.totalCalories);
  }

  double get breakfastCalories => getTotalCaloriesForMeal(Meal.breakfast);
  double get lunchCalories => getTotalCaloriesForMeal(Meal.lunch);
  double get dinnerCalories => getTotalCaloriesForMeal(Meal.dinner);
  double get snackCalories => getTotalCaloriesForMeal(Meal.snack);

  double get totalDailyCalories =>
      breakfastCalories + lunchCalories + dinnerCalories + snackCalories;

  double get totalDailyCarbs {
    return mealRecords.values
        .expand((records) => records)
        .fold(0.0, (sum, record) => sum + record.totalCarbs);
  }

  double get totalDailyFat {
    return mealRecords.values
        .expand((records) => records)
        .fold(0.0, (sum, record) => sum + record.totalFat);
  }

  double get totalDailyProtein {
    return mealRecords.values
        .expand((records) => records)
        .fold(0.0, (sum, record) => sum + record.totalProtein);
  }
}

class MealTrackingViewModel extends StateNotifier<MealTrackingState> {
  MealTrackingViewModel() : super(MealTrackingState());

  // 1. Add food to specific meal
  void addFoodToMeal({
    required Food food,
    required Meal meal,
    required double servingAmount,
    DateTime? consumedAt,
  }) {
    final newRecord = MealRecord(
      food: food,
      meal: meal,
      servingAmount: servingAmount,
      consumedAt: consumedAt ?? DateTime.now(),
    );

    final currentRecords = Map<Meal, List<MealRecord>>.from(state.mealRecords);
    final mealRecords = List<MealRecord>.from(currentRecords[meal] ?? []);
    mealRecords.add(newRecord);
    currentRecords[meal] = mealRecords;

    state = state.copyWith(mealRecords: currentRecords);
  }

  // 2. Remove record from meal
  void removeRecordFromMeal(Meal meal, int recordIndex) {
    final currentRecords = Map<Meal, List<MealRecord>>.from(state.mealRecords);
    final mealRecords = List<MealRecord>.from(currentRecords[meal] ?? []);

    if (recordIndex >= 0 && recordIndex < mealRecords.length) {
      mealRecords.removeAt(recordIndex);
      currentRecords[meal] = mealRecords;
      state = state.copyWith(mealRecords: currentRecords);
    }
  }

  // 3. Update serving amount
  void updateServingAmount(
    Meal meal,
    int recordIndex,
    double newServingAmount,
  ) {
    final currentRecords = Map<Meal, List<MealRecord>>.from(state.mealRecords);
    final mealRecords = List<MealRecord>.from(currentRecords[meal] ?? []);

    if (recordIndex >= 0 && recordIndex < mealRecords.length) {
      final updatedRecord = mealRecords[recordIndex].copyWith(
        servingAmount: newServingAmount,
      );
      mealRecords[recordIndex] = updatedRecord;
      currentRecords[meal] = mealRecords;
      state = state.copyWith(mealRecords: currentRecords);
    }
  }

  // 5. Clear specific meal
  void clearMeal(Meal meal) {
    final currentRecords = Map<Meal, List<MealRecord>>.from(state.mealRecords);
    currentRecords[meal] = [];
    state = state.copyWith(mealRecords: currentRecords);
  }

  // 6. Clear all meals for current day
  void clearAllMeals() {
    state = state.copyWith(mealRecords: {});
  }

  // 7. Get nutrition summary for specific meal
  Map<String, double> getMealNutritionSummary(Meal meal) {
    final records = state.mealRecords[meal] ?? [];
    return {
      'calories': records.fold(
        0.0,
        (sum, record) => sum + record.totalCalories,
      ),
      'carbs': records.fold(0.0, (sum, record) => sum + record.totalCarbs),
      'fat': records.fold(0.0, (sum, record) => sum + record.totalFat),
      'protein': records.fold(0.0, (sum, record) => sum + record.totalProtein),
    };
  }

  // 8. Get today's nutrition summary
  Map<String, double> getDailyNutritionSummary() {
    return {
      'calories': state.totalDailyCalories,
      'carbs': state.totalDailyCarbs,
      'fat': state.totalDailyFat,
      'protein': state.totalDailyProtein,
    };
  }

  // 9. Check if meal has any records
  bool mealHasRecords(Meal meal) {
    return (state.mealRecords[meal] ?? []).isNotEmpty;
  }

  // 10. Get total records count for today
  int get totalRecordsCount {
    return state.mealRecords.values.fold(
      0,
      (sum, records) => sum + records.length,
    );
  }
}

final currentMealProvider = StateProvider<Meal>((ref) => Meal.breakfast);

final mealTrackingViewModelProvider =
    StateNotifierProvider<MealTrackingViewModel, MealTrackingState>(
      (ref) => MealTrackingViewModel(),
    );
