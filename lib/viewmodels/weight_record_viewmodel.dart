import 'dart:io' show File;
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/weight_record.dart';

class WeightRecordState {
  final List<WeightRecord> records;
  final String? errorMessage;
  final bool isLoading;

  WeightRecordState({
    this.records = const [],
    this.errorMessage,
    this.isLoading = false,
  });

  WeightRecordState copyWith({
    List<WeightRecord>? records,
    String? errorMessage,
    bool? isLoading,
  }) => WeightRecordState(
    records: records ?? this.records,
    errorMessage: errorMessage ?? this.errorMessage,
    isLoading: isLoading ?? this.isLoading,
  );
}

class WeightRecordViewModel extends Notifier<WeightRecordState> {
  @override
  WeightRecordState build() {
    return WeightRecordState();
  }

  String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Nhập cân nặng";
    }

    double weight = double.parse(value);
    if (weight < 40 || weight > 200) {
      return "40-200";
    }

    return null;
  }

  WeightRecord? getRecord(int index) {
    if (index >= state.records.length || index < 0) {
      return null;
    }

    return state.records[index];
  }

  void addRecord(double weight, DateTime date, File? image) {
    final newRecord = WeightRecord(weight: weight, date: date, image: image);

    state = state.copyWith(records: [...state.records, newRecord]);
  }

  void removeRecord(int index) {
    if (state.records.isEmpty || index >= state.records.length) {
      return;
    }

    final updatedRecords = List.of(state.records)..removeAt(index);
    state = state.copyWith(records: updatedRecords);
  }

  void updateRecord(int index, double? weight, DateTime? date, File? image) {
    if (state.records.isEmpty || index >= state.records.length) {
      return;
    }

    final updatedRecords = List.of(state.records);
    updatedRecords[index] = updatedRecords[index].copyWith(
      weight: weight,
      date: date,
      image: image,
    );

    state = state.copyWith(records: updatedRecords);
  }

  List<WeightRecord> _getFilteredRecords(Period period) {
    final records = state.records;
    final now = DateTime.now();
    final sortedRecords = [...records]
      ..sort((a, b) => a.date.compareTo(b.date));

    switch (period) {
      case Period.week:
        final weekAgo = now.subtract(const Duration(days: 7));
        return sortedRecords
            .where((record) => record.date.isAfter(weekAgo))
            .toList();
      case Period.month:
        final monthAgo = DateTime(now.year, now.month - 1, now.day);
        return sortedRecords
            .where((record) => record.date.isAfter(monthAgo))
            .toList();
      case Period.threeMonths:
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return sortedRecords
            .where((record) => record.date.isAfter(threeMonthsAgo))
            .toList();
      case Period.sixMonths:
        final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
        return sortedRecords
            .where((record) => record.date.isAfter(sixMonthsAgo))
            .toList();
      case Period.year:
        final yearAgo = DateTime(now.year - 1, now.month, now.day);
        return sortedRecords
            .where((record) => record.date.isAfter(yearAgo))
            .toList();
      case Period.all:
        return sortedRecords;
    }
  }

  Map<String, dynamic> _getChartStatistics(Period period) {
    final filterdRecords = _getFilteredRecords(period);

    if (filterdRecords.length < 2) {
      return {
        "hasData": false,
        "weightChange": 0.0,
        "isGain": false,
        "firstWeight": 0.0,
        "lastWeight": 0.0,
      };
    }

    final firstRecord = filterdRecords.first;
    final lastRecord = filterdRecords.last;
    final weightChange = lastRecord.weight - firstRecord.weight;

    return {
      "hasData": true,
      "weightChange": weightChange,
      "isGain": weightChange > 0,
      "firstWeight": firstRecord.weight,
      "lastWeight": lastRecord.weight,
      "minWeight": filterdRecords.map((r) => r.weight).reduce(math.min),
      "maxWeight": filterdRecords.map((r) => r.weight).reduce(math.max),
    };
  }
}

final weightRecordViewModelProvider =
    NotifierProvider<WeightRecordViewModel, WeightRecordState>(
      () => WeightRecordViewModel(),
    );

final filteredWeightRecordsProvider =
    Provider.family<List<WeightRecord>, Period>((ref, period) {
      return ref
          .read(weightRecordViewModelProvider.notifier)
          ._getFilteredRecords(period);
    });

final weightChartStatsProvider = Provider.family<Map<String, dynamic>, Period>(
  (ref, period) => ref
      .read(weightRecordViewModelProvider.notifier)
      ._getChartStatistics(period),
);
