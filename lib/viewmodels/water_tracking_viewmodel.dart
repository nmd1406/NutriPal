import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/water_record.dart';
import 'package:nutripal/viewmodels/diary_record_viewmodel.dart';

class WaterTrackingViewModel extends Notifier<void> {
  @override
  void build() {}

  Future<void> addWaterRecord({
    required double amount,
    required TimeOfDay consumedAt,
  }) async {
    final WaterRecord newRecord = WaterRecord(
      amount: amount,
      consumedAt: consumedAt,
    );

    final diaryNotifier = ref.read(diaryRecordViewModelProvider.notifier);
    diaryNotifier.addWaterRecord(newRecord);
  }

  Future<void> removeWaterRecord(int recordIndex) async {
    final diaryNotifier = ref.read(diaryRecordViewModelProvider.notifier);
    diaryNotifier.removeWaterRecord(recordIndex);
  }
}

final waterTrackingViewModelProvider =
    NotifierProvider<WaterTrackingViewModel, void>(WaterTrackingViewModel.new);
