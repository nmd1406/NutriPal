import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/meal_record.dart';
import 'package:nutripal/models/food.dart';

class MealTrackingState {
  final Map<String, Map<Meal, List<MealRecord>>> mealRecords;
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
    Map<String, Map<Meal, List<MealRecord>>>? mealRecords,
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

  String get _dateKey => _formatDateKey(selectedDate);

  static String _formatDateKey(DateTime date) =>
      "${date.day}/${date.month}/${date.year}";

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

  Map<Meal, List<MealRecord>> get recordsByDate => mealRecords[_dateKey] ?? {};

  List<MealRecord> get breakfastRecords => recordsByDate[Meal.breakfast] ?? [];
  List<MealRecord> get lunchRecords => recordsByDate[Meal.lunch] ?? [];
  List<MealRecord> get dinnerRecords => recordsByDate[Meal.dinner] ?? [];
  List<MealRecord> get snackRecords => recordsByDate[Meal.snack] ?? [];

  // Calculated nutrition for each meal
  double getTotalCaloriesForMeal(Meal meal) {
    final records = recordsByDate[meal] ?? [];
    return records.fold(0.0, (sum, record) => sum + record.totalCalories);
  }

  double get breakfastCalories => getTotalCaloriesForMeal(Meal.breakfast);
  double get lunchCalories => getTotalCaloriesForMeal(Meal.lunch);
  double get dinnerCalories => getTotalCaloriesForMeal(Meal.dinner);
  double get snackCalories => getTotalCaloriesForMeal(Meal.snack);

  double get totalDailyCalories =>
      breakfastCalories + lunchCalories + dinnerCalories + snackCalories;

  double get breakfastPercentage => breakfastCalories / totalDailyCalories;
  double get lunchPercentage => lunchCalories / totalDailyCalories;
  double get dinnerPercentage => dinnerCalories / totalDailyCalories;
  double get snackPercentage => snackCalories / totalDailyCalories;

  Map<String, double> get _dailyMacros {
    double totalCarbs = 0;
    double totalFat = 0;
    double totalProtein = 0;

    for (List<MealRecord> records in recordsByDate.values) {
      for (MealRecord record in records) {
        totalCarbs += record.totalCarbs;
        totalFat += record.totalFat;
        totalProtein += record.totalProtein;
      }
    }

    return {"carbs": totalCarbs, "protein": totalProtein, "fat": totalFat};
  }

  double get totalDailyCarbs => _dailyMacros["carbs"] ?? 0;

  double get totalDailyFat => _dailyMacros["fat"] ?? 0;

  double get totalDailyProtein => _dailyMacros["protein"] ?? 0;

  double get totalDailyCarbsPercentage =>
      totalDailyCarbs * 4 / totalDailyCalories;
  double get totalDailyFatPercentage => totalDailyFat * 9 / totalDailyCalories;
  double get totalDailyProteinPercentage =>
      totalDailyProtein * 4 / totalDailyCalories;

  bool get isEmpty => recordsByDate.isEmpty;
}

class MealTrackingViewModel extends StateNotifier<MealTrackingState> {
  MealTrackingViewModel() : super(MealTrackingState());

  void changeSelectedDate(DateTime date) {
    if (!_isSameDay(date, state.selectedDate)) {
      state = state.copyWith(selectedDate: date);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void addFoodToMeal({
    required Food food,
    required Meal meal,
    required double servingAmount,
    required TimeOfDay consumedAt,
  }) {
    final newRecord = MealRecord(
      food: food,
      meal: meal,
      servingAmount: servingAmount,
      consumedAt: consumedAt,
    );

    final String dateKey = MealTrackingState._formatDateKey(state.selectedDate);

    final newMealRecords = Map<String, Map<Meal, List<MealRecord>>>.from(
      state.mealRecords,
    );

    if (newMealRecords.containsKey(dateKey)) {
      final dayRecords = Map<Meal, List<MealRecord>>.from(
        newMealRecords[dateKey]!,
      );
      final mealRecords = List<MealRecord>.from(dayRecords[meal] ?? []);
      mealRecords.add(newRecord);
      dayRecords[meal] = mealRecords;
      newMealRecords[dateKey] = dayRecords;
    } else {
      newMealRecords[dateKey] = {
        meal: [newRecord],
      };
    }

    state = state.copyWith(mealRecords: newMealRecords);
  }

  void removeRecordFromMeal(Meal meal, int recordIndex) {
    final dateKey = MealTrackingState._formatDateKey(state.selectedDate);

    final recordsByDate = state.mealRecords[dateKey];
    if (recordsByDate == null) {
      return;
    }

    final List<MealRecord>? recordsByMeal = recordsByDate[meal];
    if (recordsByMeal == null) {
      return;
    }

    final newMealRecords = Map<String, Map<Meal, List<MealRecord>>>.from(
      state.mealRecords,
    );
    final dayRecords = Map<Meal, List<MealRecord>>.from(
      newMealRecords[dateKey]!,
    );
    final mealRecords = List<MealRecord>.from(dayRecords[meal]!);

    mealRecords.removeAt(recordIndex);
    dayRecords[meal] = mealRecords;
    newMealRecords[dateKey] = dayRecords;

    state = state.copyWith(mealRecords: newMealRecords);
  }

  void clearAllMeals() {
    state = state.copyWith(mealRecords: {});
  }
}

final currentMealProvider = StateProvider<Meal>((ref) => Meal.breakfast);

final mealTrackingViewModelProvider =
    StateNotifierProvider<MealTrackingViewModel, MealTrackingState>(
      (ref) => MealTrackingViewModel(),
    );
