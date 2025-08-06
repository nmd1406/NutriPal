import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/water_record.dart';

class WaterTrackingState {
  final List<WaterRecord> records;

  const WaterTrackingState({this.records = const <WaterRecord>[]});
  WaterTrackingState copyWith({List<WaterRecord>? records}) {
    return WaterTrackingState(records: records ?? this.records);
  }

  double get totalAmount =>
      records.fold(0.0, (sum, record) => sum += record.amount);
}

class WaterTrackingViewModel extends StateNotifier<WaterTrackingState> {
  WaterTrackingViewModel() : super(WaterTrackingState());

  void addWaterRecord({required double amount, required DateTime consumedAt}) {
    final WaterRecord newRecord = WaterRecord(
      amount: amount,
      consumedAt: consumedAt,
    );

    state = state.copyWith(records: [...state.records, newRecord]);
  }

  void removeWaterRecord(int recordIndex) {
    final currentRecords = state.records;

    if (recordIndex >= 0 && recordIndex < currentRecords.length) {
      currentRecords.removeAt(recordIndex);
      state = state.copyWith(records: [...currentRecords]);
    }
  }

  void updateWaterRecord(int recordIndex, {required double amount}) {
    final currentRecords = state.records;
    final record = currentRecords[recordIndex];

    if (amount == record.amount) {
      return;
    }

    record.copyWith(amount: amount);
    currentRecords[recordIndex] = record;
    state = state.copyWith(records: [...currentRecords]);
  }
}

final waterTrackingViewModelProvider =
    StateNotifierProvider<WaterTrackingViewModel, WaterTrackingState>(
      (ref) => WaterTrackingViewModel(),
    );
