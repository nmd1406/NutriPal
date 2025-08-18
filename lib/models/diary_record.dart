import 'package:nutripal/models/food_record.dart';
import 'package:nutripal/models/water_record.dart';

class DiaryRecord {
  final DateTime date;
  final Map<Meal, List<FoodRecord>> foodRecordsByMeal;
  final List<WaterRecord> waterRecords;

  const DiaryRecord({
    required this.date,
    required this.foodRecordsByMeal,
    required this.waterRecords,
  });

  DiaryRecord copyWith({
    DateTime? date,
    Map<Meal, List<FoodRecord>>? foodRecordsByMeal,
    List<WaterRecord>? waterRecords,
  }) {
    return DiaryRecord(
      date: date ?? this.date,
      foodRecordsByMeal: foodRecordsByMeal ?? this.foodRecordsByMeal,
      waterRecords: waterRecords ?? this.waterRecords,
    );
  }

  static DiaryRecord empty() => DiaryRecord(
    date: DateTime.now(),
    foodRecordsByMeal: {},
    waterRecords: [],
  );

  double get totalWaterAmount =>
      waterRecords.fold(0.0, (sum, record) => sum += record.amount);

  List<FoodRecord> getMealRecords(Meal meal) {
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

  List<FoodRecord> get breakfastRecords =>
      foodRecordsByMeal[Meal.breakfast] ?? [];
  List<FoodRecord> get lunchRecords => foodRecordsByMeal[Meal.lunch] ?? [];
  List<FoodRecord> get dinnerRecords => foodRecordsByMeal[Meal.dinner] ?? [];
  List<FoodRecord> get snackRecords => foodRecordsByMeal[Meal.snack] ?? [];

  double getTotalCaloriesByMeal(Meal meal) {
    final records = foodRecordsByMeal[meal] ?? [];
    return records.fold(0.0, (sum, record) => sum += record.totalCalories);
  }

  double get breakfastCalories => getTotalCaloriesByMeal(Meal.breakfast);
  double get lunchCalories => getTotalCaloriesByMeal(Meal.lunch);
  double get dinnerCalories => getTotalCaloriesByMeal(Meal.dinner);
  double get snackCalories => getTotalCaloriesByMeal(Meal.snack);

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

    for (List<FoodRecord> records in foodRecordsByMeal.values) {
      for (FoodRecord record in records) {
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

  bool get isMealRecordsEmpty => foodRecordsByMeal.isEmpty;
  bool get isWaterRecordsEmpty => waterRecords.isEmpty;
  bool get isEmpty => isMealRecordsEmpty || isWaterRecordsEmpty;

  Map<String, dynamic> toJson() {
    return {
      "date": date.toIso8601String(),
      "foodRecordsByMeal": foodRecordsByMeal.map(
        (meal, records) => MapEntry(
          meal.name,
          records.map((record) => record.toJson()).toList(),
        ),
      ),
      "waterRecords": waterRecords.map((record) => record.toJson()).toList(),
    };
  }

  factory DiaryRecord.fromJson(Map<String, dynamic> json) {
    return DiaryRecord(
      date: DateTime.parse(json["date"] as String),
      foodRecordsByMeal: (json["foodRecordsByMeal"] as Map<String, dynamic>)
          .map(
            (mealName, records) => MapEntry(
              Meal.fromTitle(mealName) ?? Meal.breakfast,
              (records as List)
                  .map(
                    (record) =>
                        FoodRecord.fromJson(record as Map<String, dynamic>),
                  )
                  .toList(),
            ),
          ),
      waterRecords: (json["waterRecords"] as List)
          .map((record) => WaterRecord.fromJson(record as Map<String, dynamic>))
          .toList(),
    );
  }
}
