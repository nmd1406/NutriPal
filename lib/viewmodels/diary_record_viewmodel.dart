import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/diary_record.dart';
import 'package:nutripal/models/food_record.dart';
import 'package:nutripal/models/water_record.dart';
import 'package:nutripal/services/diary_firestore_service.dart';

class DiaryRecordState {
  final DateTime selectedDate;
  final Map<DateTime, DiaryRecord> records;
  final bool isLoading;
  final String? errorMessage;

  DiaryRecordState({
    DateTime? selectedDate,
    this.records = const {},
    this.isLoading = false,
    this.errorMessage,
  }) : selectedDate = selectedDate ?? DateTime.now();

  DiaryRecordState copyWith({
    DateTime? selectedDate,
    Map<DateTime, DiaryRecord>? records,
    bool? isLoading,
    String? errorMessage,
  }) => DiaryRecordState(
    selectedDate: selectedDate ?? this.selectedDate,
    records: records ?? this.records,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage,
  );

  static DateTime _formatDateKey(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime get dateKey => _formatDateKey(selectedDate);

  DiaryRecord get recordsByDate => records[dateKey] ?? DiaryRecord.empty();

  List<WaterRecord> get waterRecords => recordsByDate.waterRecords;

  Map<Meal, List<FoodRecord>> get mealRecords =>
      recordsByDate.foodRecordsByMeal;

  DiaryRecordState clearError() => copyWith(errorMessage: null);
}

class DiaryRecordViewModel extends Notifier<DiaryRecordState> {
  final _firestore = DiaryFirestoreService();

  @override
  DiaryRecordState build() {
    final initialState = DiaryRecordState();
    Future.microtask(() => _loadDiaryRecord(initialState.selectedDate));
    return initialState;
  }

  Future<void> _loadDiaryRecord(DateTime date) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final record = await _firestore.getDiaryRecord(date);
      final dateKey = DiaryRecordState._formatDateKey(date);
      if (record != null) {
        state = state.copyWith(
          records: {...state.records, dateKey: record},
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          records: {...state.records, dateKey: DiaryRecord.empty()},
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: "Failed to load diary record: ${e.toString()}",
        isLoading: false,
      );
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> changeDate(DateTime date) async {
    if (!_isSameDay(date, state.selectedDate)) {
      state = state.copyWith(selectedDate: date);

      if (!state.records.containsKey(state.dateKey)) {
        await _loadDiaryRecord(date);
      }
    }
  }

  Future<void> _saveDiaryRecord(DiaryRecord diaryRecord) async {
    try {
      await _firestore.saveDiaryRecord(diaryRecord);
    } catch (e) {
      state = state.copyWith(
        errorMessage: "Failed to save diary record: ${e.toString()}",
      );
      rethrow;
    }
  }

  void clearError() {
    state = state.clearError();
  }

  Future<void> refreshData() async {
    await _loadDiaryRecord(state.selectedDate);
  }

  Future<void> addFoodRecord(Meal meal, FoodRecord newRecord) async {
    state = state.clearError();

    // Rollback nếu lưu lên Firestore bị lỗi
    final originalState = state;

    try {
      final currentDiaryRecord = state.recordsByDate;
      final currentFoodRecords =
          currentDiaryRecord.foodRecordsByMeal[meal] ?? [];

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

      await _saveDiaryRecord(updatedDiaryRecord);
    } catch (e) {
      state = originalState.copyWith(
        errorMessage: "Failed to add food record: ${e.toString()}",
      );
      await _loadDiaryRecord(state.selectedDate);
    }
  }

  Future<void> removeFoodRecord(Meal meal, int recordIndex) async {
    state = state.clearError();

    try {
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

      await _saveDiaryRecord(updatedDiaryRecord);
    } catch (e) {
      await _loadDiaryRecord(state.selectedDate);
    }
  }

  Future<void> addWaterRecord(WaterRecord newRecord) async {
    state = state.clearError();

    // Rollback
    final originalState = state;

    try {
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

      await _saveDiaryRecord(updatedDiaryRecord);
    } catch (e) {
      state = originalState.copyWith(
        errorMessage: "Failed to add water record: ${e.toString()}",
      );
      await _loadDiaryRecord(state.selectedDate);
    }
  }

  Future<void> removeWaterRecord(int recordIndex) async {
    state = state.clearError();

    try {
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
      await _saveDiaryRecord(updatedDairyRecord);
    } catch (e) {
      await _loadDiaryRecord(state.selectedDate);
    }
  }
}

final diaryRecordViewModelProvider =
    NotifierProvider<DiaryRecordViewModel, DiaryRecordState>(
      DiaryRecordViewModel.new,
    );
