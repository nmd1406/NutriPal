import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/water_record.dart';
import 'package:nutripal/viewmodels/diary_record_viewmodel.dart';

class WaterTrackingViewModel extends Notifier<void> {
  @override
  void build() {}

  void addWaterRecord({required double amount, required TimeOfDay consumedAt}) {
    final WaterRecord newRecord = WaterRecord(
      amount: amount,
      consumedAt: consumedAt,
    );

    final diaryNotifier = ref.read(diaryRecordViewModelProvider.notifier);
    diaryNotifier.addWaterRecord(newRecord);
  }

  void removeWaterRecord(int recordIndex) {
    final diaryNotifier = ref.read(diaryRecordViewModelProvider.notifier);
    diaryNotifier.removeWaterRecord(recordIndex);
  }
}

final waterTrackingViewModelProvider =
    NotifierProvider<WaterTrackingViewModel, void>(WaterTrackingViewModel.new);
