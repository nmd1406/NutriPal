import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/diary_record.dart';
import 'package:nutripal/models/food_record.dart';
import 'package:nutripal/models/water_record.dart';

class DiaryRecordState {
  final DateTime selectedDate;
  final Map<DateTime, DiaryRecord> records;

  DiaryRecordState({DateTime? selectedDate, this.records = const {}})
    : selectedDate = selectedDate ?? DateTime.now();

  DiaryRecordState copyWith({
    DateTime? selectedDate,
    Map<DateTime, DiaryRecord>? records,
  }) => DiaryRecordState(
    selectedDate: selectedDate ?? this.selectedDate,
    records: records ?? this.records,
  );

  static DateTime _formatDateKey(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime get dateKey => _formatDateKey(selectedDate);

  DiaryRecord get recordsByDate => records[dateKey] ?? DiaryRecord.empty();

  List<WaterRecord> get waterRecords => recordsByDate.waterRecords;

  Map<Meal, List<FoodRecord>> get mealRecords =>
      recordsByDate.foodRecordsByMeal;
}

class DiaryRecordViewModel extends Notifier<DiaryRecordState> {
  @override
  DiaryRecordState build() {
    return DiaryRecordState();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void changeDate(DateTime date) {
    if (!_isSameDay(date, state.selectedDate)) {
      state = state.copyWith(selectedDate: date);
    }
  }

  void addFoodRecord(Meal meal, FoodRecord newRecord) {
    final currentDiaryRecord = state.recordsByDate;
    final currentFoodRecords = currentDiaryRecord.foodRecordsByMeal[meal] ?? [];

    final updatedFoodRecordsByMeal = {
      ...currentDiaryRecord.foodRecordsByMeal,
      meal: [...currentFoodRecords, newRecord],
    };

    final updatedDiaryRecord = currentDiaryRecord.copyWith(
      foodRecordsByMeal: updatedFoodRecordsByMeal,
    );

    state = state.copyWith(
      records: {...state.records, state.dateKey: updatedDiaryRecord},
    );
  }

  void removeFoodRecord(Meal meal, int recordIndex) {
    final currentDiaryRecord = state.recordsByDate;
    final currentFoodRecords = currentDiaryRecord.foodRecordsByMeal[meal];

    if (currentFoodRecords == null ||
        recordIndex >= currentFoodRecords.length) {
      return;
    }

    final updatedFoodRecords = List<FoodRecord>.from(currentFoodRecords)
      ..removeAt(recordIndex);

    final updatedFoodRecordsByMeal = {
      ...currentDiaryRecord.foodRecordsByMeal,
      meal: updatedFoodRecords,
    };

    final updatedDiaryRecord = currentDiaryRecord.copyWith(
      foodRecordsByMeal: updatedFoodRecordsByMeal,
    );

    state = state.copyWith(
      records: {...state.records, state.dateKey: updatedDiaryRecord},
    );
  }

  void addWaterRecord(WaterRecord newRecord) {
    final currentDiaryRecord = state.recordsByDate;
    final currentWaterRecords = currentDiaryRecord.waterRecords;

    final updatedWaterRecords = [...currentWaterRecords, newRecord];
    currentDiaryRecord.copyWith(waterRecords: updatedWaterRecords);
    final updatedDiaryRecord = currentDiaryRecord.copyWith(
      waterRecords: updatedWaterRecords,
    );

    state = state.copyWith(
      records: {...state.records, state.dateKey: updatedDiaryRecord},
    );
  }

  void removeWaterRecord(int recordIndex) {
    final currentDairyRecord = state.recordsByDate;
    final currentWaterRecords = currentDairyRecord.waterRecords;

    final updatedWaterRecords = List<WaterRecord>.from(currentWaterRecords)
      ..removeAt(recordIndex);

    final updatedDairyRecord = currentDairyRecord.copyWith(
      waterRecords: updatedWaterRecords,
    );

    state = state.copyWith(
      records: {...state.records, state.dateKey: updatedDairyRecord},
    );
  }
}

final diaryRecordViewModelProvider =
    NotifierProvider<DiaryRecordViewModel, DiaryRecordState>(
      DiaryRecordViewModel.new,
    );
