import 'dart:io' show File;
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutripal/models/weight_record.dart';
import 'package:nutripal/services/weight_tracking_firestore_service.dart';

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

  List<WeightRecord> get sortedRecords =>
      [...records]..sort((a, b) => b.date.compareTo(a.date));

  WeightRecordState clearError() => copyWith(errorMessage: null);
}

class WeightRecordViewModel extends Notifier<WeightRecordState> {
  final _firestore = WeightTrackingFirestoreService();

  @override
  WeightRecordState build() {
    Future.microtask(() => _loadWeightRecords());
    return WeightRecordState();
  }

  Future<void> _loadWeightRecords() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final records = await _firestore.weightRecords;
      state = state.copyWith(
        records: records ?? [],
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Failed to load data: ${e.toString()}",
      );
    }
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

  Future<File?> pickImageFromCamera() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    return picked != null ? File(picked.path) : null;
  }

  Future<File?> pickImageFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    return picked != null ? File(picked.path) : null;
  }

  void clearError() {
    state = state.clearError();
  }

  Future<void> refreshData() async {
    await _loadWeightRecords();
  }

  Future<void> addRecord(double weight, DateTime date, File? image) async {
    state = state.clearError();

    final oldState = state;

    try {
      final newRecord = WeightRecord(weight: weight, date: date, image: image);
      state = state.copyWith(records: [...state.records, newRecord]);

      await _firestore.saveWeightRecord(newRecord);
    } catch (e) {
      state = oldState.copyWith(
        errorMessage: "Failed to add record: ${e.toString()}",
      );
      await _loadWeightRecords();
    }
  }

  Future<void> removeRecord(int index) async {
    if (state.records.isEmpty || index >= state.records.length) {
      return;
    }

    state = state.clearError();

    final oldState = state;

    try {
      final record = state.records[index];
      final updatedRecords = List.of(state.records)..remove(record);
      state = state.copyWith(records: updatedRecords);

      await _firestore.removeWeightRecord(record.date);
    } catch (e) {
      state = oldState.copyWith(
        errorMessage: "Failed to remove record: ${e.toString()}",
      );
      await _loadWeightRecords();
    }
  }

  Future<void> updateRecord(
    int index,
    double? weight,
    DateTime? date,
    File? image,
  ) async {
    if (state.records.isEmpty || index >= state.records.length) {
      return;
    }

    state = state.clearError();

    final oldState = state;

    try {
      final updatedRecords = List.of(state.records);
      final oldDate = updatedRecords[index].date;

      updatedRecords[index] = updatedRecords[index].copyWith(
        weight: weight,
        date: date,
        image: image,
      );

      state = state.copyWith(records: updatedRecords);

      await _firestore.updateRecord(oldDate, updatedRecords[index]);
    } catch (e) {
      state = oldState.copyWith(
        errorMessage: "Failed to update record: ${e.toString()}",
      );
      await _loadWeightRecords();
    }
  }

  List<WeightRecord> _getFilteredRecords(Period period) {
    final records = state.records;
    final now = DateTime.now();
    final sortedRecords = [...records]
      ..sort((a, b) => a.date.compareTo(b.date));

    switch (period) {
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
    final filteredRecords = _getFilteredRecords(period);

    if (filteredRecords.isEmpty) {
      return {
        "hasData": false,
        "weightChange": 0.0,
        "isGain": false,
        "firstWeight": 0.0,
        "lastWeight": 0.0,
        "startDate": null,
        "endDate": null,
        "minWeight": 0.0,
        "maxWeight": 0.0,
      };
    }

    if (filteredRecords.length == 1) {
      final record = filteredRecords.first;
      return {
        "hasData": true,
        "weightChange": 0.0,
        "isGain": false,
        "firstWeight": record.weight,
        "lastWeight": record.weight,
        "startDate": record.date,
        "endDate": record.date,
        "minWeight": record.weight,
        "maxWeight": record.weight,
      };
    }

    final firstRecord = filteredRecords.first;
    final lastRecord = filteredRecords.last;
    final weightChange = lastRecord.weight - firstRecord.weight;

    return {
      "hasData": true,
      "weightChange": weightChange,
      "isGain": weightChange > 0,
      "firstWeight": firstRecord.weight,
      "lastWeight": lastRecord.weight,
      "startDate": firstRecord.date,
      "endDate": lastRecord.date,
      "minWeight": filteredRecords.map((r) => r.weight).reduce(math.min),
      "maxWeight": filteredRecords.map((r) => r.weight).reduce(math.max),
    };
  }
}

final weightRecordViewModelProvider =
    NotifierProvider<WeightRecordViewModel, WeightRecordState>(
      () => WeightRecordViewModel(),
    );

final filteredWeightRecordsProvider =
    Provider.family<List<WeightRecord>, Period>((ref, period) {
      ref.watch(weightRecordViewModelProvider);
      return ref
          .read(weightRecordViewModelProvider.notifier)
          ._getFilteredRecords(period);
    });

final weightChartStatsProvider = Provider.family<Map<String, dynamic>, Period>((
  ref,
  period,
) {
  ref.watch(weightRecordViewModelProvider);

  return ref
      .read(weightRecordViewModelProvider.notifier)
      ._getChartStatistics(period);
});
