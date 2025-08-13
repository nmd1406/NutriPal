import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/water_record.dart';

class WaterTrackingState {
  final Map<String, List<WaterRecord>> records;
  final DateTime selectedDate;

  WaterTrackingState({this.records = const {}, DateTime? selectedDate})
    : selectedDate = selectedDate ?? DateTime.now();

  WaterTrackingState copyWith({
    Map<String, List<WaterRecord>>? records,
    DateTime? selectedDate,
  }) {
    return WaterTrackingState(
      records: records ?? this.records,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  String get _dateKey => _formatDateKey(selectedDate);
  static String _formatDateKey(DateTime date) =>
      "${date.day}/${date.month}/${date.year}";

  double get totalAmount => (records[_dateKey] ?? []).fold(
    0.0,
    (sum, record) => sum += record.amount,
  );

  List<WaterRecord> get waterRecords => records[_dateKey] ?? [];

  bool get isEmpty => waterRecords.isEmpty;
}

class WaterTrackingViewModel extends StateNotifier<WaterTrackingState> {
  WaterTrackingViewModel() : super(WaterTrackingState());

  void changeSelectedDate(DateTime date) {
    if (!_isSameDay(date, state.selectedDate)) {
      state = state.copyWith(selectedDate: date);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void addWaterRecord({required double amount, required TimeOfDay consumedAt}) {
    final WaterRecord newRecord = WaterRecord(
      amount: amount,
      consumedAt: consumedAt,
    );

    final dateKey = WaterTrackingState._formatDateKey(state.selectedDate);
    final newRecords = Map<String, List<WaterRecord>>.from(state.records);

    if (newRecords.containsKey(dateKey)) {
      final dayRecords = List<WaterRecord>.from(newRecords[dateKey]!);
      dayRecords.add(newRecord);
      newRecords[dateKey] = dayRecords;
    } else {
      newRecords[dateKey] = [newRecord];
    }
    state = state.copyWith(records: newRecords);
  }

  void removeWaterRecord(int recordIndex) {
    final dateKey = WaterTrackingState._formatDateKey(state.selectedDate);

    List<WaterRecord>? dayRecords = state.records[dateKey];
    if (dayRecords == null || dayRecords.isEmpty) {
      return;
    }
    final newRecords = Map<String, List<WaterRecord>>.from(state.records);
    dayRecords = List<WaterRecord>.from(newRecords[dateKey]!);
    dayRecords.removeAt(recordIndex);
    newRecords[dateKey] = dayRecords;

    state = state.copyWith(records: newRecords);
  }

  // void updateWaterRecord(int recordIndex, {required double amount}) {
  //   final currentRecords = state.records;
  //   final record = currentRecords[recordIndex];

  //   if (amount == record.amount) {
  //     return;
  //   }

  //   record.copyWith(amount: amount);
  //   currentRecords[recordIndex] = record;
  //   state = state.copyWith(records: [...currentRecords]);
  // }
}

final waterTrackingViewModelProvider =
    StateNotifierProvider<WaterTrackingViewModel, WaterTrackingState>(
      (ref) => WaterTrackingViewModel(),
    );
